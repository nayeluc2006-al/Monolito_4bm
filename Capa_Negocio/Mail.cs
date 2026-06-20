using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;


namespace Capa_Negocio
{
    public class Mail
    {
        MailMessage m = new MailMessage();
        SmtpClient smtp = new SmtpClient();
        string from = "nayeluc2006@gmail.com";
        string pass = "vkozqbxipshdvwsx";

        public bool envia_correo(string to, string msj)
        {
            try
            {
                m.From= new MailAddress(from);
                m.To.Add(new MailAddress(to));
                m.Body = msj;
                m.Subject = "Recuperación de contraseña";
                m.IsBodyHtml = true;

                smtp.Host = "smtp.gmail.com";
                smtp.Port = 587;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new NetworkCredential(from, pass);
                smtp.EnableSsl = true;
                smtp.Send(m);
                smtp.Dispose();
                return true;




            }
            catch(Exception ex) 
            {
                Console.WriteLine(ex.Message);
                return false;
                throw;
            }
        }

    }

}
