using System;
using System.Collections.Generic;
using System.Data.Linq;
using System.Web.UI;
using Capa_Negocio;
using Capa_Datos;

namespace Monolito_4bm.Seguridad
{
    public partial class Registrar : System.Web.UI.Page
    {
        [Serializable]
        public class InfoFoto
        {
            public byte[] Bytes { get; set; }
            public string Mime { get; set; }
            public string Nombre { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                cargar_perfil();
            else
                RestaurarPreview();
        }

        private void RestaurarPreview()
        {
            var lista = ViewState["ListaFotos"] as List<InfoFoto>;
            if (lista != null && lista.Count > 0)
            {
                var ultima = lista[lista.Count - 1];
                img_previa.ImageUrl = $"data:{ultima.Mime};base64,{Convert.ToBase64String(ultima.Bytes)}";
                img_previa.Visible = true;
                ico_placeholder.Visible = false;
                lbl_nombre_foto.Text =
                    $"<i class='fas fa-check-circle' style='color:#10b981'></i> " +
                    $"{ultima.Nombre} — <b>{lista.Count} foto(s) cargada(s)</b>";
            }
        }

        protected void cargar_perfil()
        {
            try
            {
                var listu = CN_tbl_tipo_usuario.traer_tipos_usuario();
                listu.Insert(0, new tbl_tipo_usuario()
                {
                    tusu_nombre = "-- SELECCIONE --",
                    tusu_id = 0
                });
                ddl_perfil.DataSource = listu;
                ddl_perfil.DataTextField = "tusu_nombre";
                ddl_perfil.DataValueField = "tusu_id";
                ddl_perfil.DataBind();
            }
            catch (Exception ex) { Alerta("Error", ex.Message, "error"); }
        }

        protected void GenerarDatosUsuario_TextChanged(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(txt_nombres.Text) ||
                    string.IsNullOrEmpty(txt_apellidos.Text)) return;

                string[] nom = txt_nombres.Text.Trim().Split(' ');
                string[] ape = txt_apellidos.Text.Trim().Split(' ');

                txt_correo.Text = nom[0].ToLower() + "." + ape[0].ToLower() + "@cordillera.edu.ec";

                string chars2 = "ABCDEFGHJKLMNOPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz0123456789!@#";
                Random rnd = new Random();
                char[] ch = new char[8];
                for (int i = 0; i < 8; i++) ch[i] = chars2[rnd.Next(chars2.Length)];
                txt_pass.Text = new string(ch);

                string cedula = txt_cedula.Text.Trim();
                string iniciales = nom[0].Substring(0, 1).ToUpper();
                if (nom.Length > 1) iniciales += nom[1].Substring(0, 1).ToLower();
                string digitos = cedula.Length >= 2 ? cedula.Substring(cedula.Length - 2) : "00";
                txt_nick.Text = iniciales + rnd.Next(100, 1000) + "@" + digitos;
            }
            catch (Exception ex) { Alerta("Error", ex.Message, "error"); }
        }

        protected void btn_cargar_Click(object sender, EventArgs e)
        {
            if (!fu_foto.HasFile)
            {
                if (ViewState["ListaFotos"] == null)
                    Alerta("Atención", "Selecciona un archivo de imagen primero.", "warning");
                return;
            }

            string mime = fu_foto.PostedFile.ContentType;
            if (!mime.StartsWith("image/"))
            {
                Alerta("Archivo inválido", "Solo se permiten imágenes (JPG, PNG, GIF).", "warning");
                return;
            }
            if (fu_foto.PostedFile.ContentLength > 5 * 1024 * 1024)
            {
                Alerta("Archivo muy grande", "La imagen no debe superar 5MB.", "warning");
                return;
            }

            var lista = ViewState["ListaFotos"] as List<InfoFoto> ?? new List<InfoFoto>();
            var nueva = new InfoFoto
            {
                Bytes = fu_foto.FileBytes,
                Mime = mime,
                Nombre = System.IO.Path.GetFileName(fu_foto.PostedFile.FileName)
            };
            lista.Add(nueva);
            ViewState["ListaFotos"] = lista;

            img_previa.ImageUrl = $"data:{nueva.Mime};base64,{Convert.ToBase64String(nueva.Bytes)}";
            img_previa.Visible = true;
            ico_placeholder.Visible = false;
            lbl_nombre_foto.Text =
                $"<i class='fas fa-check-circle' style='color:#10b981'></i> " +
                $"{nueva.Nombre} — <b>{lista.Count} foto(s) cargada(s)</b>";
        }

        protected void btn_registrar_Click(object sender, EventArgs e)
        {
            string cedula = txt_cedula.Text.Trim();

            if (int.Parse(ddl_perfil.SelectedValue) == 0)
            { Alerta("Campo requerido", "Selecciona un perfil de acceso.", "warning"); return; }

            if (string.IsNullOrEmpty(txt_nombres.Text) || string.IsNullOrEmpty(txt_apellidos.Text))
            { Alerta("Campos vacíos", "Completa nombres y apellidos.", "warning"); return; }

            if (string.IsNullOrEmpty(txt_fecha_nac.Text))
            { Alerta("Campo requerido", "La fecha de cumpleaños es obligatoria.", "warning"); return; }

            if (CN_tbl_usuario.ExisteCedula(cedula))
            { Alerta("Ya existe", "Esta cédula ya está registrada.", "warning"); return; }

            try
            {
                tbl_usuario obj = new tbl_usuario();
                obj.usu_cedula = cedula;
                obj.usu_nombres = txt_nombres.Text.Trim().ToUpper();
                obj.usu_apellidos = txt_apellidos.Text.Trim().ToUpper();
                obj.usu_correo = txt_correo.Text.Trim();
                obj.usu_nick = txt_nick.Text.Trim();
                obj.usu_celular = txt_celular.Text.Trim();
                obj.usu_direccion = txt_direccion.Text.Trim();
                obj.tusu_id = int.Parse(ddl_perfil.SelectedValue);
                obj.usu_intentos = 0;
                obj.usu_fecha_creacion = DateTime.Now;
                obj.usu_fecha_cumple = DateTime.Parse(txt_fecha_nac.Text);

                // ✅ ISO 27001 — Estado PENDIENTE hasta completar QR + WhatsApp
                obj.usu_estado = 'P';

                // Foto principal
                var lista = ViewState["ListaFotos"] as List<InfoFoto>;
                if (lista != null && lista.Count > 0)
                    obj.usu_foto = new Binary(lista[0].Bytes);

                // Generar secreto OTP para Google Authenticator
                byte[] secretoBytes = OtpNet.KeyGeneration.GenerateRandomKey(20);
                string secretoOtp = OtpNet.Base32Encoding.ToString(secretoBytes);

                string clavePlana = txt_pass.Text;

                // ✅ Guardar en BD con estado 'P' (Pendiente)
                int idGenerado = CN_tbl_usuario.RegistrarUsuarioConClaveNativa(
                    obj, clavePlana, secretoOtp
                );

                if (idGenerado > 0)
                {
                    // Guardar todas las fotos en tbl_usuario_fotos
                    if (lista != null)
                        foreach (var foto in lista)
                            CN_tbl_usuario.GuardarFotoUsuario(idGenerado, foto.Bytes, foto.Mime);

                    // Pasar datos a ConfirmarRegistro por Session
                    Session["reg_idUsuario"] = idGenerado;
                    Session["reg_nick"] = obj.usu_nick;
                    Session["reg_clave"] = clavePlana;
                    Session["reg_correo"] = obj.usu_correo;
                    Session["reg_celular"] = obj.usu_celular;
                    Session["reg_otpSecreto"] = secretoOtp;

                    // Limpiar controles
                    ViewState["ListaFotos"] = null;
                    img_previa.Visible = false;
                    ico_placeholder.Visible = true;
                    lbl_nombre_foto.Text = "Ningún archivo seleccionado";

                    Response.Redirect("~/Seguridad/ConfirmarRegistro.aspx");
                }
                else
                    Alerta("Error", "No se pudo registrar. Intenta de nuevo.", "error");
            }
            catch (Exception ex) { Alerta("Error", ex.Message, "error"); }
        }

        private void Alerta(string t, string m, string tipo)
        {
            m = m.Replace("'", "\\'");
            ScriptManager.RegisterStartupScript(
                this, GetType(), "swal",
                $"Swal.fire('{t}', '{m}', '{tipo}');", true
            );
        }
    }
}