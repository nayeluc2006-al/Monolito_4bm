using System;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web.UI;
using Capa_Negocio;

namespace Monolito_4bm.Seguridad
{
    public partial class RecuperarClave : System.Web.UI.Page
    {
        protected void btn_Generar_Click(object sender, EventArgs e)
        {
            string correoDestino = txt_correo.Text.Trim();

            if (string.IsNullOrEmpty(correoDestino))
            {
                lbl_mensaje.Text = "Ingresa tu correo.";
                return;
            }

            // 1. Verificar que el correo existe en la BD
            var user = CN_tbl_usuario.traerUsuarioPorCorreo(correoDestino);
            if (user == null)
            {
                lbl_mensaje.Text = "No existe una cuenta con ese correo.";
                return;
            }

            // 2. Generar OTP de 6 caracteres
            string otp = GenerarPassword(6);

            try
            {
                // 3. Guardar OTP en la BD (más seguro que solo en Session)
                CN_tbl_usuario.GuardarOTP(correoDestino, otp);

                // 4. Guardar en Session con UNA SOLA clave consistente
                Session["OTP_Generado"] = otp;
                Session["CorreoRecuperacion"] = correoDestino;

                // 5. Link de WhatsApp usando el celular del usuario registrado
                string celular = user.usu_celular ?? "";
                // Quitamos el 0 inicial y ponemos código Ecuador +593
                if (celular.StartsWith("0"))
                    celular = "593" + celular.Substring(1);

                string msgWA = $"Hola {user.usu_nombres}, tu código de seguridad temporal es: {otp}";
                string urlWa = "https://api.whatsapp.com/send?phone=" + celular
                                + "&text=" + Server.UrlEncode(msgWA);

                Session["LinkWA"] = urlWa;

                // 6. Enviar correo con el OTP
                MailMessage mail = new MailMessage();
                mail.To.Add(correoDestino);
                mail.From = new MailAddress("nayeluc2006@gmail.com", "Lotus Security");
                mail.Subject = "Código de Recuperación OTP";
                mail.Body =
                    $"Hola {user.usu_nombres},\n\n" +
                    $"Tu código temporal es: {otp}\n\n" +
                    $"Ingresa este código en la pantalla de verificación.\n" +
                    $"Si no solicitaste esto, ignora este mensaje.";

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.Credentials = new NetworkCredential("nayeluc2006@gmail.com", "vkozqbxipshdvwsx");
                smtp.EnableSsl = true;
                smtp.Send(mail);

                // 7. Redirigir a validar OTP
                Response.Redirect("ValidarOTP.aspx");
            }
            catch (Exception ex)
            {
                lbl_mensaje.Text = "Error: " + ex.Message;
            }
        }

        private string GenerarPassword(int length)
        {
            const string valid = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // sin caracteres confusos
            StringBuilder res = new StringBuilder();
            Random rnd = new Random();
            while (0 < length--)
                res.Append(valid[rnd.Next(valid.Length)]);
            return res.ToString();
        }
    }
}