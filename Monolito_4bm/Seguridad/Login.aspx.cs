using System;
using System.Web.UI;
using Capa_Negocio;
using Capa_Datos;
using Capa_Negocio.SimpleCryptoShim;

namespace Monolito_4bm.Seguridad
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                Session.Clear();
        }

        protected void btn_inicio_Click1(object sender, EventArgs e)
        {
            string entrada = txt_ced.Text.Trim();
            string passIngresada = txt_pass.Text;

            if (string.IsNullOrEmpty(entrada) || string.IsNullOrEmpty(passIngresada))
            {
                Alerta("Campos Vacíos", "Completa tus credenciales.", "warning");
                return;
            }

            try
            {
                // ✅ Busca por cédula primero, si no encuentra busca por nick
                var user = CN_tbl_usuario.traerUsuarioPorCedula(entrada)
                        ?? CN_tbl_usuario.traerUsuarioPorNick(entrada);

                if (user == null)
                {
                    Alerta("No Encontrado", "El usuario o cédula no está registrado.", "error");
                    return;
                }

                // ✅ Bloqueado por proceso de registro incompleto
                if (user.usu_estado == 'P')
                {
                    Alerta(
                        "Cuenta Pendiente",
                        "Tu cuenta no está activada. Completa el proceso de registro.",
                        "warning"
                    );
                    return;
                }

                // Bloqueado por intentos o por admin
                if (user.usu_estado == 'I' || user.usu_intentos >= 3)
                {
                    Alerta(
                        "Cuenta Bloqueada",
                        "Has superado el límite de intentos. Contacta al administrador.",
                        "error"
                    );
                    return;
                }

                if (user.usu_contraseña == null)
                {
                    Alerta("Error", "El usuario no tiene contraseña asignada.", "error");
                    return;
                }

                byte[] contrasenaBytes = user.usu_contraseña.ToArray();
                string hashEnBD = System.Text.Encoding.UTF8
                                        .GetString(contrasenaBytes)
                                        .Trim('\0').Trim();

                if (!hashEnBD.Contains("."))
                {
                    Alerta(
                        "Incompatibilidad",
                        "Formato de clave no reconocido. Solicita restablecer tu contraseña.",
                        "warning"
                    );
                    return;
                }

                // Validar que la parte 'salt' sea Base64 válida antes de computar
                var partes = hashEnBD.Split(new[] { '.' }, 2);
                try
                {
                    Convert.FromBase64String(partes[0]);
                }
                catch (FormatException)
                {
                    Alerta(
                        "Error Crítico",
                        "La clave almacenada tiene un formato inválido. Solicita restablecer tu contraseña o contacta al administrador.",
                        "error"
                    );
                    return;
                }
                ICryptoService cryptoService = new PBKDF2();

                if (cryptoService.Compute(passIngresada, hashEnBD) == hashEnBD)
                {
                    Session["OTP_UsuarioID"] = user.usu_id;
                    Session["OTP_PerfilID"] = user.tusu_id;
                    Session["OTP_Nombre"] = user.usu_nombres;
                    Session["OTP_EsTemporal"] = user.usu_clave_es_temporal == true;
                    Session["OTP_Intentos"] = 0;

                    user.usu_intentos = 0;
                    user.usu_fecha_ultimo_intento = DateTime.Now;
                    CN_tbl_usuario.ActualizarEstadoIntentos(user);

                    Response.Redirect("~/Seguridad/ValidarOTP.aspx");
                }
                else
                {
                    user.usu_intentos += 1;
                    user.usu_fecha_ultimo_intento = DateTime.Now;

                    if (user.usu_intentos >= 3)
                    {
                        user.usu_estado = 'I';
                        Alerta("Bloqueado", "Usuario bloqueado tras 3 intentos fallidos.", "error");
                    }
                    else
                    {
                        Alerta("Error", $"Contraseña incorrecta. Intento {user.usu_intentos} de 3.", "error");
                    }

                    CN_tbl_usuario.ActualizarEstadoIntentos(user);
                }
            }
            catch (Exception ex)
            {
                Alerta("Error Crítico", "Fallo en la validación: " + ex.Message, "error");
            }
        }

        private void Alerta(string titulo, string texto, string tipo)
        {
            texto = texto.Replace("'", "\\'");
            string script = $"Swal.fire('{titulo}', '{texto}', '{tipo}');";
            ScriptManager.RegisterStartupScript(this, GetType(), "swal", script, true);
        }

        protected void lnk_registra_Click(object sender, EventArgs e)
        {
            Response.Redirect("Registrar.aspx");
        }
    }
}