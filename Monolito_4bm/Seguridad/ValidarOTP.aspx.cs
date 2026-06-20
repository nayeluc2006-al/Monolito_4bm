using System;
using System.Web.UI;
using Capa_Negocio;

namespace Monolito_4bm.Seguridad
{
    public partial class ValidarOTP : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // ✅ Si no hay usuario en sesión — redirige al login
            // Esto evita que alguien entre directo a esta URL sin haber hecho login
            if (Session["OTP_UsuarioID"] == null)
                Response.Redirect("~/Seguridad/Login.aspx");
        }

        protected void btn_validar_Click(object sender, EventArgs e)
        {
            string codigoIngresado = txt_otp.Text.Trim();

            if (string.IsNullOrEmpty(codigoIngresado) || codigoIngresado.Length != 6)
            {
                MostrarError("Ingresa el código de 6 dígitos de Google Authenticator.");
                return;
            }

            int idUsuario = (int)Session["OTP_UsuarioID"];

            // ✅ Traer el secreto OTP guardado en BD al momento del registro
            var user = CN_tbl_usuario.traerUsuarioPorId(idUsuario);
            if (user == null || string.IsNullOrEmpty(user.usu_otp_secreto))
            {
                MostrarError("No se encontró la configuración OTP. Contacta al administrador.");
                return;
            }

            // ✅ Validar el código con OtpNet
            // OtpNet toma el secreto Base32, genera el código actual de 30 seg
            // y lo compara con lo que ingresó el usuario
            byte[] secretoBytes = OtpNet.Base32Encoding.ToBytes(user.usu_otp_secreto);
            var totp = new OtpNet.Totp(secretoBytes);
            bool otpValido = totp.VerifyTotp(
                codigoIngresado,
                out long _,
                OtpNet.VerificationWindow.RfcSpecifiedNetworkDelay
            // VerificationWindow acepta ±1 ventana de 30 seg
            // para compensar diferencia de reloj entre celular y servidor
            );

            if (otpValido)
            {
                // ✅ OTP correcto — pasar los datos de sesión al siguiente paso
                Session["UsuarioID"] = idUsuario;
                Session["PerfilID"] = Session["OTP_PerfilID"];
                Session["NombreUsuario"] = Session["OTP_Nombre"];
                bool esTemporal = (bool)Session["OTP_EsTemporal"];

                // Limpiar las variables temporales de OTP
                Session.Remove("OTP_UsuarioID");
                Session.Remove("OTP_PerfilID");
                Session.Remove("OTP_Nombre");
                Session.Remove("OTP_EsTemporal");

                if (esTemporal)
                {
                    // Clave temporal → obligar a cambiarla
                    Session["CorreoRecuperacion"] = user.usu_correo;
                    Session["OTP_Generado"] = "ok"; // ActualizarPass lo requiere

                    Alerta(
                        "¡OTP Correcto!",
                        "Tu clave es temporal. Debes cambiarla ahora.",
                        "info",
                        "ActualizarPass.aspx"
                    );
                }
                else
                {
                    // Clave normal → redirige según perfil
                    int perfilId = (int)Session["PerfilID"];
                    string destino = perfilId == 1
                        ? "../Admin/Dashboard.aspx"
                        : "../Usuarios/MenuUsuario.aspx";

                    Alerta("¡Bienvenido!", "Identidad verificada correctamente.", "success", destino);
                }
            }
            else
            {
                // ✅ OTP incorrecto — mostrar error con intentos restantes
                int intentos = Session["OTP_Intentos"] != null
                    ? (int)Session["OTP_Intentos"] : 0;
                intentos++;
                Session["OTP_Intentos"] = intentos;

                if (intentos >= 3)
                {
                    // 3 intentos fallidos → volver al login
                    Session.Clear();
                    Alerta(
                        "Demasiados intentos",
                        "Vuelve a iniciar sesión.",
                        "error",
                        "Login.aspx"
                    );
                }
                else
                {
                    lbl_intentos.Text = $"Código incorrecto. Intento {intentos} de 3.";
                    lbl_intentos.Visible = true;
                }
            }
        }

        private void Alerta(string titulo, string texto, string tipo, string redirige)
        {
            texto = texto.Replace("'", "\\'");
            string script =
                $"Swal.fire('{titulo}','{texto}','{tipo}')" +
                $".then(()=>{{ window.location='{redirige}'; }});";
            ScriptManager.RegisterStartupScript(this, GetType(), "swal", script, true);
        }

        private void MostrarError(string mensaje)
        {
            lbl_intentos.Text = mensaje;
            lbl_intentos.Visible = true;
        }
    }
}