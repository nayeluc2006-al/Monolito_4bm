using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Capa_Negocio;
using Capa_Negocio.SimpleCryptoShim;

namespace Monolito_4bm.Seguridad
{
    public partial class ActualizarPass : System.Web.UI.Page
    {
        // Declaración agregada para el control lbl_error
        protected Label lbl_error;

        // Declaraciones añadidas para los TextBox referenciados en el code-behind
        protected TextBox txt_pass1;
        protected TextBox txt_pass2;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["OTP_Generado"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btn_Actualizar_Click(object sender, EventArgs e)
        {
            string p1 = txt_pass1.Text.Trim();
            string p2 = txt_pass2.Text.Trim();

            if (p1 == "" || p2 == "")
            {
                lbl_error.Text = "Completa ambos campos.";
                return;
            }

            if (p1 != p2)
            {
                lbl_error.Text = "Las contraseñas no coinciden.";
                return;
            }

            try
            {
                ICryptoService cryptoService = new PBKDF2();
                string salt = cryptoService.GenerateSalt();
                string hashFormato = cryptoService.Compute(p1, salt);
                byte[] passEncript = System.Text.Encoding.UTF8.GetBytes(hashFormato);

                if (Session["CorreoRecuperacion"] == null)
                {
                    lbl_error.Text = "La sesión expiró. Vuelve a recuperar la contraseña.";
                    return;
                }

                bool exito = CN_tbl_usuario.ActualizarPassword(
                    Session["CorreoRecuperacion"].ToString(),
                    passEncript
                );

                if (exito)
                {
                    var user = CN_tbl_usuario.traerUsuarioPorCorreo(
                        Session["CorreoRecuperacion"].ToString()
                    );
                    if (user != null)
                        CN_tbl_usuario.MarcarClaveDefinitiva(user.usu_id);

                    Session.Remove("OTP_Generado");
                    Session.Remove("CorreoRecuperacion");
                    Session.Remove("LinkWA");

                    string script =
                        "Swal.fire('¡Listo!','Contraseña actualizada con éxito.','success')" +
                        ".then(function(){ window.location='Login.aspx'; });";

                    ScriptManager.RegisterStartupScript(
                        this, GetType(), "exito", script, true
                    );
                }
                else
                {
                    lbl_error.Text = "No se pudo actualizar la contraseña.";
                }
            }
            catch (Exception ex)
            {
                lbl_error.Text = "Error: " + ex.Message;
            }
        }
    }
}