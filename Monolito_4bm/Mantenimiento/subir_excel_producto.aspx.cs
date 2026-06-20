using System;
using System.Collections.Generic;
using System.IO;
using System.Web.UI;
using Capa_Datos;
using Capa_Negocio;
using OfficeOpenXml;
using OfficeOpenXml.Style;

namespace Monolito_4bm.Mantenimiento
{
    public partial class subir_excel_producto : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        // ── Descargar formato con productos actuales ──────────────────────
        protected void btn_descargar_formato_Click(object sender, EventArgs e)
        {
            using (var paquete = new ExcelPackage())
            {
                var hoja = paquete.Workbook.Worksheets.Add("Productos");

                // Encabezados
                hoja.Cells[1, 1].Value = "pro_nombre";
                hoja.Cells[1, 2].Value = "pro_cantidad";
                hoja.Cells[1, 3].Value = "pro_precio";
                hoja.Cells[1, 4].Value = "prov_id";

                using (var rango = hoja.Cells[1, 1, 1, 4])
                {
                    rango.Style.Font.Bold = true;
                    rango.Style.Fill.PatternType = ExcelFillStyle.Solid;
                    rango.Style.Fill.BackgroundColor.SetColor(
                        System.Drawing.Color.FromArgb(124, 92, 191));
                    rango.Style.Font.Color.SetColor(System.Drawing.Color.White);
                }

                // Datos actuales
                var productos = CN_tbl_producto.ListarProductos();
                int fila = 2;
                foreach (var p in productos)
                {
                    hoja.Cells[fila, 1].Value = p.pro_nombre;
                    hoja.Cells[fila, 2].Value = p.pro_cantidad;
                    hoja.Cells[fila, 3].Value = (double)(p.pro_precio ?? 0);
                    hoja.Cells[fila, 4].Value = p.prov_id;
                    fila++;
                }

                // Si no hay productos, poner ejemplo
                if (productos.Count == 0)
                {
                    hoja.Cells[2, 1].Value = "Producto Ejemplo";
                    hoja.Cells[2, 2].Value = 10;
                    hoja.Cells[2, 3].Value = 5.99;
                    hoja.Cells[2, 4].Value = 1;
                }

                hoja.Cells.AutoFitColumns();

                byte[] bytes = paquete.GetAsByteArray();
                Response.Clear();
                Response.ContentType =
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("Content-Disposition",
                    "attachment; filename=productos_actuales.xlsx");
                Response.BinaryWrite(bytes);
                Response.End();
            }
        }

        // ── Previsualizar Excel antes de cargar ───────────────────────────
        protected void btn_previsualizar_Click(object sender, EventArgs e)
        {
            if (!fu_excel.HasFile)
            {
                MensajeSwal("Archivo requerido",
                    "Selecciona un archivo Excel primero.", "warning");
                return;
            }

            string ext = Path.GetExtension(fu_excel.FileName).ToLower();
            if (ext != ".xlsx")
            {
                MensajeSwal("Formato inválido",
                    "Solo se permiten archivos .xlsx", "error");
                return;
            }

            try
            {
                // Nombres existentes para marcar NUEVO vs EXISTENTE
                var nombresExistentes = new HashSet<string>(
                    StringComparer.OrdinalIgnoreCase);
                foreach (var p in CN_tbl_producto.ListarProductos())
                    nombresExistentes.Add(p.pro_nombre ?? "");

                var productos = LeerExcel(fu_excel.FileBytes, nombresExistentes);

                if (productos.Count == 0)
                {
                    MensajeSwal("Sin datos",
                        "El archivo está vacío o no tiene datos válidos.", "warning");
                    return;
                }

                // Guardamos en ViewState para el botón Confirmar
                ViewState["ProductosExcel"] = productos;

                gv_preview.DataSource = productos;
                gv_preview.DataBind();

                int nuevos = 0, existentes = 0;
                foreach (var p in productos)
                {
                    if (p.es_nuevo) nuevos++;
                    else existentes++;
                }

                lbl_contador.Text = $"{productos.Count} producto(s): " +
                                    $"{nuevos} nuevos, {existentes} existentes";
                pnl_preview.Visible = true;
                lbl_resultado.Visible = false;

                string script = $@"
                Swal.fire({{
                    title: '¡Previsualización lista!',
                    html: '<b>{productos.Count}</b> producto(s) detectados:<br>" +
                    $@"<span style=""color:#10b981"">● {nuevos} nuevos</span>&nbsp;&nbsp;" +
                    $@"<span style=""color:#3b82f6"">● {existentes} existentes</span>',
                    icon: 'info',
                    confirmButtonText: 'Ver y confirmar',
                    confirmButtonColor: '#7c5cbf'
                }});";
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "swalPreview", script, true);
            }
            catch (Exception ex)
            {
                MensajeSwal("Error", "Error al leer el archivo: " + ex.Message, "error");
            }
        }

        // ── Confirmar y cargar a la BD ────────────────────────────────────
        protected void btn_confirmar_carga_Click(object sender, EventArgs e)
        {
            var productos = ViewState["ProductosExcel"] as List<ProductoExcelDto>;

            if (productos == null || productos.Count == 0)
            {
                MensajeSwal("Sin datos", "No hay datos. Previsualiza primero.", "warning");
                return;
            }

            try
            {
                // Paso 1 — Borrar y reiniciar
                CN_tbl_producto.EliminarTodosYReiniciarIdentity();

                // Paso 2 — Insertar uno por uno
                int insertados = 0;
                string errores = "";

                foreach (var dto in productos)
                {
                    bool ok = CN_tbl_producto.InsertarParaCargaMasiva(
                        dto.pro_nombre,
                        dto.pro_cantidad,
                        dto.pro_precio,
                        dto.prov_id
                    );
                    if (ok) insertados++;
                    else errores += $"Falló: {dto.pro_nombre} | ";
                }

                // Guardar log para depuración
                string logPath = Server.MapPath("~/App_Data/log_carga.txt");
                System.IO.File.AppendAllText(logPath,
                    $"{DateTime.Now} — Insertados: {insertados}/{productos.Count} | {errores}\n"
                );

                ViewState["ProductosExcel"] = null;
                pnl_preview.Visible = false;

                MensajeSwal(
                    "Carga completada",
                    $"{insertados} de {productos.Count} producto(s) insertados." +
                    (errores != "" ? " Errores: " + errores : ""),
                    insertados > 0 ? "success" : "error"
                );
            }
            catch (Exception ex)
            {
                // Log completo del error
                string logPath = Server.MapPath("~/App_Data/log_carga.txt");
                System.IO.File.AppendAllText(logPath,
                    $"{DateTime.Now} — EXCEPCIÓN: {ex.Message}\n{ex.StackTrace}\n"
                );

                MensajeSwal("Error crítico", ex.Message, "error");
            }
        }

        // ── Cancelar previsualización ─────────────────────────────────────
        protected void btn_cancelar_Click(object sender, EventArgs e)
        {
            ViewState["ProductosExcel"] = null;
            pnl_preview.Visible = false;
            lbl_resultado.Visible = false;
        }

        // ── Leer Excel con EPPlus ─────────────────────────────────────────
        private List<ProductoExcelDto> LeerExcel(
            byte[] bytes, HashSet<string> existentes)
        {
            var lista = new List<ProductoExcelDto>();

            using (var stream = new MemoryStream(bytes))
            using (var paquete = new ExcelPackage(stream))
            {
                if (paquete.Workbook.Worksheets.Count == 0)
                    throw new Exception("El archivo no tiene hojas.");

                var hoja = paquete.Workbook.Worksheets[1]; // primera hoja

                if (hoja.Dimension == null)
                    throw new Exception("La hoja está vacía.");

                int filas = hoja.Dimension.Rows;

                for (int i = 2; i <= filas; i++) // fila 1 = encabezados
                {
                    string nombre = hoja.Cells[i, 1].Text.Trim();
                    if (string.IsNullOrEmpty(nombre)) continue;

                    lista.Add(new ProductoExcelDto
                    {
                        pro_nombre = nombre,
                        pro_cantidad = int.TryParse(
                            hoja.Cells[i, 2].Text.Trim(),
                            out int cant) ? cant : 0,
                        pro_precio = decimal.TryParse(
                            hoja.Cells[i, 3].Text.Trim().Replace(",", "."),
                            System.Globalization.NumberStyles.Any,
                            System.Globalization.CultureInfo.InvariantCulture,
                            out decimal precio) ? precio : 0,
                        prov_id = int.TryParse(
                            hoja.Cells[i, 4].Text.Trim(),
                            out int prov) ? prov : 0,
                        es_nuevo = !existentes.Contains(nombre)
                    });
                }
            }

            return lista;
        }

        // ── SweetAlert desde servidor ─────────────────────────────────────
        private void MensajeSwal(string titulo, string mensaje, string icono)
        {
            string script = $@"
            Swal.fire({{
                title: '{titulo}',
                text: '{mensaje.Replace("'", "\\'")}',
                icon: '{icono}',
                confirmButtonColor: '#7c5cbf'
            }});";
            ScriptManager.RegisterStartupScript(
                this, GetType(), "swal_" + icono, script, true);
        }

        // ── DTO para transferir datos del Excel al ViewState ──────────────
        [Serializable]
        public class ProductoExcelDto
        {
            public string pro_nombre { get; set; }
            public int pro_cantidad { get; set; }
            public decimal pro_precio { get; set; }
            public int prov_id { get; set; }
            public bool es_nuevo { get; set; }
        }
    }
}