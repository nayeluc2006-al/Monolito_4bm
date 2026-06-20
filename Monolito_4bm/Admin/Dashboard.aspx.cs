using System;
using System.Linq;
using System.Web.UI;
using Capa_Negocio;

namespace Monolito_4bm.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Seguridad: Asegurar que quien entre sea estrictamente Admin
            if ((int)Session["PerfilID"] != 1)
            {
                Response.Redirect("~/Seguridad/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarContenidoAdmin();
                CargarDatosTabla();
            }
        }

        private void CargarContenidoAdmin()
        {
            int id = (int)Session["UsuarioID"];
            var user = CN_tbl_usuario.traerUsuarioPorId(id);
            if (user == null) return;

            lbl_nombre_full.Text = user.usu_nombres + " " + user.usu_apellidos;

            if (user.usu_foto != null && user.usu_foto.Length > 0)
            {
                string src = "data:image/jpeg;base64," + Convert.ToBase64String(user.usu_foto.ToArray());
                img_foto.ImageUrl = src;
                img_foto.Visible = true;
                pnl_icon.Visible = false;
            }
            else
            {
                img_foto.Visible = false;
                pnl_icon.Visible = true;
            }
        }

        private void CargarDatosTabla()
        {
            var todos = CN_tbl_usuario.traerTodosLosUsuarios();
            var bloqueados = todos.Where(u => u.usu_intentos >= 3 || u.usu_estado == 'I').ToList();
            var activos = todos.Where(u => u.usu_estado == 'A' && u.usu_intentos < 3).ToList();

            lbl_total.Text = todos.Count.ToString();
            lbl_bloqueados.Text = bloqueados.Count.ToString();
            lbl_activos.Text = activos.Count.ToString();

            if (bloqueados.Count > 0)
            {
                rpt_bloqueados.DataSource = bloqueados;
                rpt_bloqueados.DataBind();
                pnl_sin_bloqueados.Visible = false;
            }
            else
            {
                rpt_bloqueados.DataSource = null;
                rpt_bloqueados.DataBind();
                pnl_sin_bloqueados.Visible = true;
            }
        }

        protected void rpt_bloqueados_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Desbloquear")
            {
                int id = int.Parse(e.CommandArgument.ToString());
                var user = CN_tbl_usuario.traerUsuarioPorId(id);
                if (user != null)
                {
                    user.usu_intentos = 0;
                    user.usu_estado = 'A';
                    CN_tbl_usuario.ActualizarEstadoIntentos(user);

                    ScriptManager.RegisterStartupScript(this, GetType(), "swal",
                        "Swal.fire('¡Desbloqueado!','Usuario desbloqueado correctamente.','success');",
                        true);
                }
                CargarDatosTabla();
            }
        }

        protected void btn_refresh_Click(object sender, EventArgs e) => CargarDatosTabla();
    }
}