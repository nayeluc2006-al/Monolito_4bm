using System;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;
using Capa_Datos;
using Capa_Negocio;

namespace Monolito_4bm.Mantenimiento
{
    public partial class listar_tbl_imagen : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarComboProductos();
            }
        }

        private void CargarComboProductos()
        {
            var productos = CN_tbl_producto.ListarProductos();
            ddl_producto.DataSource = productos;
            ddl_producto.DataValueField = "pro_id";
            ddl_producto.DataTextField = "pro_nombre";
            ddl_producto.DataBind();
            ddl_producto.Items.Insert(0,
                new ListItem("-- Selecciona un producto --", "0"));
        }

        protected void ddl_producto_SelectedIndexChanged(object sender, EventArgs e)
        {
            int id = int.Parse(ddl_producto.SelectedValue);
            if (id == 0)
            {
                pnl_subir.Visible = false;
                pnl_imagenes.Visible = false;
                return;
            }

            pnl_subir.Visible = true;
            pnl_imagenes.Visible = true;
            CargarImagenes(id);
        }

        private void CargarImagenes(int proId)
        {
            var imgs = CN_tbl_producto_imagen.ListarImagenesPorProducto(proId);
            rpt_imgs.DataSource = imgs;
            rpt_imgs.DataBind();
            lbl_count.Text = imgs.Count + " imagen(es)";
            lbl_sin_imgs.Visible = imgs.Count == 0; // ✅ muestra si está vacío
        }

        // Subir múltiples imágenes
        protected void btn_subir_Click(object sender, EventArgs e)
        {
            int proId = int.Parse(ddl_producto.SelectedValue);
            if (proId == 0)
            {
                Mensaje("Selecciona un producto primero.", false);
                return;
            }

            if (!fu_imagenes.HasFiles)
            {
                Mensaje("Selecciona al menos una imagen.", false);
                return;
            }

            string carpeta = Server.MapPath("~/Uploads/Productos/");
            if (!Directory.Exists(carpeta))
                Directory.CreateDirectory(carpeta);

            int subidas = 0;
            foreach (var archivo in fu_imagenes.PostedFiles)
            {
                // Validar tipo
                if (!archivo.ContentType.StartsWith("image/")) continue;

                // Validar peso — máx 5 MB
                if (archivo.ContentLength > 5 * 1024 * 1024) continue;

                string ext = Path.GetExtension(archivo.FileName);
                string nombreArchivo = "prod_" + proId + "_" +
                                       DateTime.Now.Ticks + "_" + subidas + ext;
                string rutaFisica = Path.Combine(carpeta, nombreArchivo);
                string rutaBD = "~/Uploads/Productos/" + nombreArchivo;

                archivo.SaveAs(rutaFisica);

                CN_tbl_producto_imagen.InsertarImagen(proId, null,
                    archivo.ContentType, rutaBD);
                subidas++;
            }

            CargarImagenes(proId);
            Mensaje("✅ " + subidas + " imagen(es) guardada(s).", true);
        }

        // Eliminar imagen desde el Repeater
        protected void rpt_imgs_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "Eliminar") return;

            int imgId = int.Parse(e.CommandArgument.ToString());
            CN_tbl_producto_imagen.EliminarImagen(imgId);

            int proId = int.Parse(ddl_producto.SelectedValue);
            CargarImagenes(proId);

            // SweetAlert de confirmación
            string script = @"Swal.fire({
                title: 'Imagen eliminada',
                icon: 'success',
                timer: 1500,
                showConfirmButton: false,
                confirmButtonColor: '#7c5cbf'
            });";
            System.Web.UI.ScriptManager.RegisterStartupScript(
                this, GetType(), "swalDel", script, true);
        }

        // Resuelve la URL — path tiene prioridad sobre BLOB
        protected string GetSrc(object datos, object tipo, object ruta)
        {
            string rutaStr = ruta?.ToString();
            if (!string.IsNullOrEmpty(rutaStr))
                return ResolveUrl(rutaStr);

            var bytes = datos as System.Data.Linq.Binary;
            if (bytes != null && bytes.Length > 0)
                return "data:" + (tipo?.ToString() ?? "image/png")
                       + ";base64," + Convert.ToBase64String(bytes.ToArray());

            return "";
        }

        private void Mensaje(string msg, bool ok)
        {
            lbl_msg_subir.Visible = true;
            lbl_msg_subir.Text = msg;
            lbl_msg_subir.CssClass = ok
                ? "alert alert-success d-block"
                : "alert alert-danger d-block";
        }
    }
}