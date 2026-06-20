using System;
using System.Web.UI;
using Capa_Negocio;

namespace Monolito_4bm.Usuarios
{
    public partial class MenuUsuario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirección si un Admin intenta colarse aquí de forma manual en la URL
            if ((int)Session["PerfilID"] == 1)
            {
                Response.Redirect("~/Admin/Dashboard.aspx");
                return;
            }

            if (!IsPostBack)
                CargarContenidoUsuario();
        }

        private void CargarContenidoUsuario()
        {
            int idUsuario = (int)Session["UsuarioID"];
            var user = CN_tbl_usuario.traerUsuarioPorId(idUsuario);
            if (user == null) return;

            lbl_nombre.Text = user.usu_nombres + " " + user.usu_apellidos;
            lbl_nick2.Text = user.usu_nick;
            lbl_correo.Text = user.usu_correo;
            lbl_ultimo_acceso.Text = user.usu_fecha_ultimo_intento.HasValue
                ? user.usu_fecha_ultimo_intento.Value.ToString("dd/MM/yyyy HH:mm")
                : "Primer acceso";

            if (user.usu_foto != null && user.usu_foto.Length > 0)
            {
                string base64 = Convert.ToBase64String(user.usu_foto.ToArray());
                img_foto.ImageUrl = "data:image/jpeg;base64," + base64;
                img_foto.Visible = true;
                pnl_icon.Visible = false;
            }
            else
            {
                img_foto.Visible = false;
                pnl_icon.Visible = true;
            }
        }

        protected void btn_juego_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Usuarios/Juego.aspx");
        }
    }
}