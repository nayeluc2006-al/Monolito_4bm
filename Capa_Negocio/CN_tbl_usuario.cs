using System;
using System.Collections.Generic;
using System.Linq;
using Capa_Datos;
using System.Data.Linq;
using Capa_Negocio.SimpleCryptoShim;

namespace Capa_Negocio
{
    public class CN_tbl_usuario
    {
        // ✅ DataContext estático — estilo que pide el profe
        private static DataClasses1DataContext dc = new DataClasses1DataContext();

        // 1. Listar solo usuarios activos
        public static List<tbl_usuario> ListarUsuario()
        {
            return dc.tbl_usuario.Where(u => u.usu_estado == 'A').ToList();
        }

        // 2. Verificar si la cédula existe y está activa
        public static bool autentixced(string cedula)
        {
            return dc.tbl_usuario.Any(u => u.usu_cedula == cedula && u.usu_estado == 'A');
        }

        // 3. Traer usuario por cédula
        public static tbl_usuario traerUsuarioPorCedula(string cedula)
        {
            return dc.tbl_usuario.FirstOrDefault(u => u.usu_cedula == cedula);
        }

        // 4. Traer usuario por ID
        public static tbl_usuario traerUsuarioPorId(int usuId)
        {
            return dc.tbl_usuario.FirstOrDefault(u => u.usu_id == usuId);
        }

        // 5. Traer usuario por correo
        public static tbl_usuario traerUsuarioPorCorreo(string correo)
        {
            return dc.tbl_usuario.FirstOrDefault(u => u.usu_correo == correo);
        }

        // 6. Traer usuario por nick
        public static tbl_usuario traerUsuarioPorNick(string nick)
        {
            return dc.tbl_usuario.FirstOrDefault(u => u.usu_nick == nick);
        }

        // 7. Traer TODOS los usuarios
        public static List<tbl_usuario> traerTodosLosUsuarios()
        {
            return dc.tbl_usuario.ToList();
        }

        // 8. Registrar Usuario simple
        public static bool RegistrarUsuario(tbl_usuario usuario)
        {
            try
            {
                usuario.usu_fecha_creacion = DateTime.Now;
                usuario.usu_estado = 'A';
                usuario.usu_intentos = 0;
                dc.tbl_usuario.InsertOnSubmit(usuario);
                dc.SubmitChanges();
                return true;
            }
            catch { return false; }
        }

        // 9. Registrar Usuario con clave PBKDF2 + secreto OTP
        public static int RegistrarUsuarioConClaveNativa(
            tbl_usuario usuario, string clavePlana, string secretoOtp)
        {
            try
            {
                usuario.usu_fecha_creacion = DateTime.Now;
                usuario.usu_estado = 'A';
                usuario.usu_intentos = 0;
                usuario.usu_otp_secreto = secretoOtp;
                usuario.usu_clave_es_temporal = true;

                // Genera salt → hash en formato "salt.hash" que el Login espera
                ICryptoService crypto = new PBKDF2();
                string salt = crypto.GenerateSalt();
                string hashGenerado = crypto.Compute(clavePlana, salt);
                usuario.usu_contraseña = new Binary(
                    System.Text.Encoding.UTF8.GetBytes(hashGenerado)
                );

                dc.tbl_usuario.InsertOnSubmit(usuario);
                dc.SubmitChanges();
                return usuario.usu_id;
            }
            catch { return 0; }
        }

        // 10. Activar usuario tras completar QR
        public static bool ActivarUsuario(int usuId)
        {
            try
            {
                var u = dc.tbl_usuario.FirstOrDefault(x => x.usu_id == usuId);
                if (u != null) { u.usu_estado = 'A'; dc.SubmitChanges(); return true; }
                return false;
            }
            catch { return false; }
        }

        // 11. Actualizar intentos y estado
        public static bool ActualizarEstadoIntentos(tbl_usuario user)
        {
            try
            {
                var u = dc.tbl_usuario.FirstOrDefault(x => x.usu_id == user.usu_id);
                if (u != null)
                {
                    u.usu_intentos = user.usu_intentos;
                    u.usu_estado = user.usu_estado;
                    u.usu_fecha_ultimo_intento = DateTime.Now;
                    dc.SubmitChanges();
                    return true;
                }
                return false;
            }
            catch { return false; }
        }

        // 12. Reiniciar intentos tras login exitoso
        public static void ReiniciarIntentos(int idUsuario)
        {
            try
            {
                var u = dc.tbl_usuario.FirstOrDefault(x => x.usu_id == idUsuario);
                if (u != null) { u.usu_intentos = 0; u.usu_estado = 'A'; dc.SubmitChanges(); }
            }
            catch { }
        }

        // 13. Listar usuarios bloqueados
        public static List<tbl_usuario> ListarBloqueados()
        {
            return dc.tbl_usuario
                     .Where(u => u.usu_intentos >= 3 || u.usu_estado == 'I')
                     .ToList();
        }

        // 14. Verificar si ya existe una cédula
        public static bool ExisteCedula(string cedula)
        {
            return dc.tbl_usuario.Any(u => u.usu_cedula == cedula);
        }

        // 15. Actualizar contraseña + limpiar OTP
        public static bool ActualizarPassword(string correo, byte[] nuevaPass)
        {
            try
            {
                var u = dc.tbl_usuario.FirstOrDefault(x => x.usu_correo == correo);
                if (u != null)
                {
                    u.usu_contraseña = nuevaPass;
                    u.usu_codigo_OTP = null;
                    u.usu_intentos = 0;
                    u.usu_estado = 'A';
                    u.usu_clave_es_temporal = false;
                    dc.SubmitChanges();
                    return true;
                }
                return false;
            }
            catch { return false; }
        }

        // 16. Guardar OTP temporal en BD
        public static bool GuardarOTP(string correo, string otp)
        {
            try
            {
                var u = dc.tbl_usuario.FirstOrDefault(x => x.usu_correo == correo);
                if (u != null) { u.usu_codigo_OTP = otp; dc.SubmitChanges(); return true; }
                return false;
            }
            catch { return false; }
        }

        // 17. Guardar foto en tbl_usuario_fotos
        public static bool GuardarFotoUsuario(int usuId, byte[] fotoBytes, string mimeType)
        {
            try
            {
                var foto = new tbl_usuario_fotos
                {
                    usu_id = usuId,
                    foto_imagen = new Binary(fotoBytes),
                    foto_tipo = mimeType,
                    foto_fecha = DateTime.Now
                };
                dc.tbl_usuario_fotos.InsertOnSubmit(foto);
                dc.SubmitChanges();
                return true;
            }
            catch { return false; }
        }

        // 18. Marcar clave como definitiva
        public static bool MarcarClaveDefinitiva(int idUsuario)
        {
            try
            {
                var u = dc.tbl_usuario.FirstOrDefault(x => x.usu_id == idUsuario);
                if (u != null) { u.usu_clave_es_temporal = false; dc.SubmitChanges(); return true; }
                return false;
            }
            catch { return false; }
        }

        // 19. Guardar API Key de CallMeBot
        public static bool GuardarCallMeBotApiKey(string correo, string apiKey)
        {
            try
            {
                var u = dc.tbl_usuario.FirstOrDefault(x => x.usu_correo == correo);
                if (u != null) { u.usu_callmebot_apikey = apiKey; dc.SubmitChanges(); return true; }
                return false;
            }
            catch { return false; }
        }
    }
}