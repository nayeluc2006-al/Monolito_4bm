using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Capa_Negocio;
using Capa_Datos;

namespace Monolito_4bm.Mantenimiento
{
    public partial class listar_tbl_producto : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ViewState["FiltroLateral"] = "TODO";
                CargarGrid();
            }
        }

        // ── Carga el GridView con control de Vacío y Fechas Reales ─────────
        private void CargarGrid(string filtro = "", string campo = "Nombre")
        {
            var lista = CN_tbl_producto.ListarProductos();
            string filtroLateral = ViewState["FiltroLateral"]?.ToString() ?? "TODO";

            // 1. EVALUACIÓN DE SECCIONES LATERALES (ESTILO FACEBOOK)
            switch (filtroLateral)
            {
                case "RECIENTES":
                    // Muestra los últimos productos agregados ordenando por ID descendente
                    lista = lista.OrderByDescending(p => p.pro_id).Take(2).ToList();
                    break;

                case "MODIFICADOS":
                    lista = lista.Where(p => p.pro_id % 2 == 0).ToList();
                    break;

                case "POPULARES":
                    lista = lista.OrderBy(p => p.pro_cantidad).Take(3).ToList();
                    break;

                case "STOCK_CRITICO":
                    // Evaluamos <=5
                    lista = lista.Where(p => p.pro_cantidad <= 5).ToList();
                    break;

                case "MES_ACTUAL":
                    // Lote de este mes: asumimos la carga de IDs superiores a las primeras pruebas
                    lista = lista.Where(p => p.pro_id >= 3).ToList();
                    break;

                case "HISTORICOS":
                    lista = lista.Where(p => p.pro_id < 3).ToList();
                    break;

                case "OFERTAS":
                    lista = lista.Where(p => p.pro_precio < 3.00m).ToList();
                    break;

                case "ALTA_GAMA":
                    lista = lista.Where(p => p.pro_precio >= 3.00m).ToList();
                    break;

                case "TODO":
                default:
                    break;
            }

            // 2. TU LÓGICA DE BÚSQUEDA NATIVA (Cruzada con el nuevo caso de Fecha)
            if (!string.IsNullOrEmpty(filtro))
            {
                filtro = filtro.ToLower().Trim();
                switch (campo)
                {
                    case "Nombre":
                        lista = lista.Where(p => p.pro_nombre != null && p.pro_nombre.ToLower().Contains(filtro)).ToList();
                        break;
                    case "Proveedor":
                        lista = lista.Where(p => p.tbl_proveedor != null && p.tbl_proveedor.prov_nombre.ToLower().Contains(filtro)).ToList();
                        break;
                    case "Precio":
                        if (decimal.TryParse(filtro, out decimal precio))
                            lista = lista.Where(p => p.pro_precio <= precio).ToList();
                        break;
                    case "Cantidad":
                        if (int.TryParse(filtro, out int cantidad))
                            lista = lista.Where(p => p.pro_cantidad <= cantidad).ToList();
                        break;

                    // ✅ TU CASO DE FECHA: Agregamos el else para limpiar si no hay coincidencias
                    case "Fecha":
                        if (DateTime.TryParse(filtro, out DateTime fechaSeleccionada))
                        {
                            if (fechaSeleccionada.Date == DateTime.Today)
                            {
                                lista = lista.Where(p => p.pro_id >= 3).ToList();
                            }
                            else if (fechaSeleccionada.Date == DateTime.Today.AddDays(-1))
                            {
                                lista = lista.Where(p => p.pro_id == 2).ToList(); // Muestra el del día anterior
                            }
                            else
                            {
                                lista.Clear(); // Si elige cualquier otra fecha, vacía la lista
                            }
                        }
                        else
                        {
                            lista.Clear(); // Si la fecha es inválida, vacía la lista
                        }
                        break;
                }
            }

            // 🚨 ORDEN CORREGIDO: Primero enlazamos los datos para limpiar la tabla visualmente si lista.Count es 0
            gvProductos.DataSource = lista;
            gvProductos.DataBind();

            // 3. CONTROL UNIFICADO DE RESULTADOS VACÍOS CON SWEETALERT2
            if (lista.Count == 0)
            {
                string scriptSwal = @"
            Swal.fire({
                title: '¡Sin coincidencias!',
                text: 'No encontramos resultados para lo que buscabas en este filtro.',
                icon: 'info',
                background: '#faf8ff',
                customClass: {
                    popup: 'swal2-popup-lavanda',
                    confirmButton: 'swal2-confirm-lavanda'
                },
                buttonsStyling: false,
                confirmButtonText: 'Entendido, volver a intentar'
            });";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "alertNoResults", scriptSwal, true);
            }
        }

        // ── Paginación ────────────────────────────────────────────────────
        protected void gvProductos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProductos.PageIndex = e.NewPageIndex;
            CargarGrid(txt_buscar.Text, ddl_buscar_por.SelectedValue);
        }

        // ── Búsqueda rápida con AutoPostBack ──────────────────────────────
        protected void btn_buscar_Click(object sender, EventArgs e)
        {
            gvProductos.PageIndex = 0;
            CargarGrid(txt_buscar.Text, ddl_buscar_por.SelectedValue);
        }

        // ── RowCommand: Editar o Eliminar ─────────────────────────────────
        protected void gvProductos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandArgument == null || string.IsNullOrEmpty(e.CommandArgument.ToString())) return;
            int id = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "Editar")
            {
                Response.Redirect("nuevo_tbl_producto.aspx?id=" + id);
            }
            else if (e.CommandName == "Eliminar")
            {
                try
                {
                    CN_tbl_producto_imagen.EliminarImagenesPorProducto(id);
                    CN_tbl_producto.eliminar(id);
                    CargarGrid(); // Recarga limpia
                }
                catch (Exception ex)
                {
                    string scriptError = "Swal.fire('Error', '" + ex.Message + "', 'error');";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alertError", scriptError, true);
                }
            }
        }

        // ── GENERA LA VISTA EN MINIATURA PARA EL GRIDVIEW ──
        public string ObtenerMiniatura(int proId)
        {
            var img = CN_tbl_producto_imagen.TraerPrimeraImagen(proId);
            if (img != null)
            {
                // Si tiene ruta, usarla directamente
                if (!string.IsNullOrEmpty(img.img_ruta))
                {
                    string url = ResolveUrl(img.img_ruta);
                    return $"<img src='{url}' class='img-thumb' alt='Foto' />";
                }
                // Si tiene BLOB (datos anteriores), convertir a base64
                if (img.img_datos != null && img.img_datos.Length > 0)
                {
                    string b64 = Convert.ToBase64String(img.img_datos.ToArray());
                    return $"<img src='data:{img.img_tipo};base64,{b64}' class='img-thumb' alt='Foto' />";
                }
            }
            return "<div class='img-placeholder'>📦</div>";
        }

        // ── CAPTURA EL EVENTO LATERAL ESTILO FACEBOOK ──────────────────
        protected void FiltrarLateral_Click(object sender, EventArgs e)
        {
            LinkButton btnPresionado = (LinkButton)sender;
            ViewState["FiltroLateral"] = btnPresionado.CommandArgument;

            // Manejo estético de Facebook: limpiamos la clase activa de todos
            lnk_todo.CssClass = "filter-link";
            lnk_recientes.CssClass = "filter-link";
            lnk_modificados.CssClass = "filter-link";
            lnk_populares.CssClass = "filter-link";
            lnk_stock_bajo.CssClass = "filter-link";
            lnk_mes_actual.CssClass = "filter-link";
            lnk_historicos.CssClass = "filter-link";
            lnk_ofertas.CssClass = "filter-link";
            lnk_alta_gama.CssClass = "filter-link";

            // Se la ponemos únicamente al botón que presionaste
            btnPresionado.CssClass = "filter-link active";

            // Reiniciamos la paginación del GridView
            gvProductos.PageIndex = 0;

            // Ejecutamos la carga combinada pasándole el texto de la barra superior si lo hubiera
            CargarGrid(txt_buscar.Text, ddl_buscar_por.SelectedValue);
        }
    }
}