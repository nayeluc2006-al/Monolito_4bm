using Capa_Datos;
using System.Collections.Generic;
using System.Linq;

namespace Capa_Negocio
{
    public class CN_tbl_proveedor
    {
        private static DataClasses1DataContext dc = new DataClasses1DataContext();

        // ── Para llenar dropdowns u otros formularios ────────────────────
        public static List<tbl_proveedor> traerproveedores()
        {
            return dc.tbl_proveedor
                     .Where(p => p.prov_estado == 'A')
                     .ToList();
        }

        // ── Para el grid del listar ────────────────────────────────────────
        public static List<tbl_proveedor> ListarProveedor()
        {
            return dc.tbl_proveedor
                     .Where(p => p.prov_estado == 'A')
                     .ToList();
        }

        // ── Buscar uno por ID (para cargar formulario edición) ─────────────
        public static tbl_proveedor traerproveedorxid(int id)
        {
            return dc.tbl_proveedor
                     .Where(p => p.prov_id == id)
                     .FirstOrDefault();
        }

        // ── Insertar ───────────────────────────────────────────────────────
        public static void agregar(tbl_proveedor nuevo)
        {
            dc.tbl_proveedor.InsertOnSubmit(nuevo);
            dc.SubmitChanges();
        }

        // ── Actualizar ─────────────────────────────────────────────────────
        public static void modificar(tbl_proveedor registro)
        {
            // Como el registro ya se buscó y modificó en el .aspx.cs, 
            // solo confirmamos los cambios en el contexto de LINQ
            dc.SubmitChanges();
        }

        // ── Eliminar lógico ────────────────────────────────────────────────
        public static void eliminar(int id)
        {
            var registro = dc.tbl_proveedor
                             .Where(p => p.prov_id == id)
                             .FirstOrDefault();
            if (registro == null) return;

            registro.prov_estado = 'I';
            dc.SubmitChanges();
        }

        // ── Verificar que no exista ya ese nombre ──────────────────────────
        public static bool verificarproveedorunico(string nombre)
        {
            return dc.tbl_proveedor
                     .Where(p => p.prov_nombre == nombre && p.prov_estado == 'A')
                     .Any();
        }
    }
}