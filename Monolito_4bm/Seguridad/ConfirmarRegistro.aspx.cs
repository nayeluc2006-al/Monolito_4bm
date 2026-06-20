    using Capa_Negocio;
    using System;
    using System.Web.UI;


namespace Monolito_4bm.Seguridad
    {
        public partial class ConfirmarRegistro : System.Web.UI.Page
        {
            protected void Page_Load(object sender, EventArgs e)
            {
                if (!IsPostBack)
                {
                    // ✅ Si alguien entra directo sin registrarse — lo botamos al login
                    if (Session["reg_idUsuario"] == null)
                    {
                        Response.Redirect("~/Seguridad/Login.aspx");
                        return;
                    }
                    CargarDatos();
                    // Genera el link de WhatsApp con número y mensaje pre-escrito
                    string mensajeWA = "I allow callmebot to send me messages";
                    string numeroWA = "34644945867"; // número de CallMeBot sin + ni espacios
                    string urlWhatsApp = $"https://wa.me/{numeroWA}?text={Uri.EscapeDataString(mensajeWA)}";

                    lnk_whatsapp_callmebot.NavigateUrl = urlWhatsApp;
                }
            }

            private void CargarDatos()
            {
                // ✅ Leer datos que Registrar.aspx dejó en Session
                string nick = Session["reg_nick"].ToString();
                string clave = Session["reg_clave"].ToString();
                string correo = Session["reg_correo"].ToString();
                string secretoOtp = Session["reg_otpSecreto"].ToString();

                // Llenar etiquetas
                lbl_nick.Text = nick;
                lbl_clave.Text = clave;
                lbl_correo.Text = correo;

                // ✅ Generar QR en C# puro — sin JavaScript
                // otpauth://totp/ es el formato estándar que entiende Google Authenticator
                string otpUrl = $"otpauth://totp/LotusSystem:{correo}" +
                                $"?secret={secretoOtp}&issuer=LotusSystem";

                using (var gen = new QRCoder.QRCodeGenerator())
                using (var data = gen.CreateQrCode(otpUrl, QRCoder.QRCodeGenerator.ECCLevel.Q))
                using (var png = new QRCoder.PngByteQRCode(data))
                {
                    byte[] qrBytes = png.GetGraphic(10);
                    img_qr.ImageUrl = "data:image/png;base64," +
                                       Convert.ToBase64String(qrBytes);
                }

                lbl_secreto.Text = secretoOtp;

                // ✅ Limpiar Session — ya no la necesitamos después de cargar
                // IMPORTANTE: guardamos el ID para el botón de guardar API Key
                Session["reg_correo"] = correo; // lo necesita btn_guardar_apikey_Click
            }

            protected void btn_guardar_apikey_Click(object sender, EventArgs e)
            {
                string apiKey = txt_apikey.Text.Trim();

                if (string.IsNullOrEmpty(apiKey))
                {
                    lbl_apikey_estado.Text =
                        "<i class='fas fa-exclamation-circle' style='color:#ef4444'></i> " +
                        "Ingresa tu API Key de CallMeBot.";
                    return;
                }

                // ✅ Guardar API Key en BD usando el correo que quedó en Session
                string correo = Session["reg_correo"]?.ToString();
                if (string.IsNullOrEmpty(correo))
                {
                    lbl_apikey_estado.Text =
                        "<i class='fas fa-times-circle' style='color:#ef4444'></i> " +
                        "Sesión expirada. Ve al login.";
                    return;
                }

                bool ok = CN_tbl_usuario.GuardarCallMeBotApiKey(correo, apiKey);

                if (ok)
                {
                    lbl_apikey_estado.Text =
                        "<i class='fas fa-check-circle' style='color:#10b981'></i> " +
                        "<b>¡API Key guardada!</b> Recibirás mensajes automáticos por WhatsApp.";
                    txt_apikey.Enabled = false;
                    btn_guardar_apikey.Enabled = false;

                    // Limpiar el resto de la Session
                    Session.Remove("reg_idUsuario");
                    Session.Remove("reg_nick");
                    Session.Remove("reg_clave");
                    Session.Remove("reg_correo");
                    Session.Remove("reg_otpSecreto");
                }
                else
                {
                    lbl_apikey_estado.Text =
                        "<i class='fas fa-times-circle' style='color:#ef4444'></i> " +
                        "No se pudo guardar. Intenta de nuevo.";
                }
            }

        protected void btn_ir_login_Click(object sender, EventArgs e)
        {
            try
            {
                if (Session["reg_idUsuario"] == null)
                {
                    Response.Redirect("~/Seguridad/Login.aspx");
                    return;
                }

                int idUsuario = (int)Session["reg_idUsuario"];

                // ✅ ISO 27001 — Activar usuario: cambia estado 'P' → 'A'
                bool activado = CN_tbl_usuario.ActivarUsuario(idUsuario);

                if (activado)
                {
                    Session.Remove("reg_idUsuario");
                    Session.Remove("reg_nick");
                    Session.Remove("reg_clave");
                    Session.Remove("reg_correo");
                    Session.Remove("reg_celular");
                    Session.Remove("reg_otpSecreto");

                    Response.Redirect("~/Seguridad/Login.aspx");
                }
                else
                {
                    ScriptManager.RegisterStartupScript(
                        this, GetType(), "swal",
                        "Swal.fire('Error','No se pudo activar la cuenta.','error');",
                        true
                    );
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "swal",
                    $"Swal.fire('Error','{ex.Message.Replace("'", "\\'")}','error');",
                    true
                );
            }
        }


    }
    }