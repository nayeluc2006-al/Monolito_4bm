using System;
using System.Web.UI;
using Capa_Negocio;

namespace Monolito_4bm
{
    public partial class Principal : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Control de seguridad global estricto
            if (Session["UsuarioID"] == null || Session["PerfilID"] == null)
            {
                // ResolveUrl asegura que la redirección funcione sin importar qué tan profunda sea la carpeta de la página hija
                Response.Redirect(ResolveUrl("~/Seguridad/Login.aspx"));
                return;
            }

            if (!IsPostBack)
            {
                ConfigurarMenuPorRol();
                CargarDatosUsuarioMaster();
            }
        }

        private void ConfigurarMenuPorRol()
        {
            int perfilId = (int)Session["PerfilID"];

            if (perfilId == 1) // Administrador
            {
                pnl_menu_admin.Visible = true;
                pnl_menu_usuario.Visible = false;
                lbl_rol_sidebar.Text = "Administrador";
                lbl_badge_rol.Text = "— Admin";
                icon_perfil_rol.Attributes["class"] = "fas fa-user-shield";
            }
            else // Usuario regular u otros roles
            {
                pnl_menu_admin.Visible = false;
                pnl_menu_usuario.Visible = true;
                lbl_rol_sidebar.Text = "Usuario";
                lbl_badge_rol.Text = "";
                icon_perfil_rol.Attributes["class"] = "fas fa-user";
            }
        }

        private void CargarDatosUsuarioMaster()
        {
            int idUsuario = (int)Session["UsuarioID"];
            var user = CN_tbl_usuario.traerUsuarioPorId(idUsuario);

            if (user == null) return;

            // Extrae de forma segura el primer nombre para el saludo en el Topbar
            if (!string.IsNullOrEmpty(user.usu_nombres))
            {
                lbl_primer_nombre.Text = user.usu_nombres.Split(' ')[0];
            }

            lbl_nick_sidebar.Text = user.usu_nick;

            // Conversión y procesamiento seguro de la imagen en formato binario SQL (varbinary)
            if (user.usu_foto != null && user.usu_foto.Length > 0)
            {
                string base64 = Convert.ToBase64String(user.usu_foto.ToArray());
                string src = "data:image/jpeg;base64," + base64;

                img_sidebar.ImageUrl = src;
                img_sidebar.Visible = true;
                pnl_sidebar_icon.Visible = false;
            }
            else
            {
                img_sidebar.Visible = false;
                pnl_sidebar_icon.Visible = true;
            }
        }

        protected void btn_logout_Click(object sender, EventArgs e)
        {
            // Limpia por completo la memoria de variables de sesión y abandona la sesión actual
            Session.Clear();
            Session.Abandon();

            Response.Redirect(ResolveUrl("~/Seguridad/Login.aspx"));
        }
    }
}