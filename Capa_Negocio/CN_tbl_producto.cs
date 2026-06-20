using Capa_Datos;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Capa_Negocio
{
    public class CN_tbl_producto
    {
        // ✅ Sin DataContext estático — cada método crea el suyo
        // El DC estático causa errores de concurrencia y datos desactualizados

        public static List<tbl_producto> ListarProductos()
        {
            using (var dc = new DataClasses1DataContext())
            {
                var opciones = new System.Data.Linq.DataLoadOptions();
                opciones.LoadWith<tbl_producto>(p => p.tbl_proveedor);
                dc.LoadOptions = opciones;

                return dc.tbl_producto
                         .Where(p => p.pro_estado == 'A')
                         .OrderByDescending(p => p.pro_id)
                         .ToList();
            } 
        }  

        public static tbl_producto traerproductoxid(int id)
        {
            using (var dc = new DataClasses1DataContext())
            {
                var opciones = new System.Data.Linq.DataLoadOptions();
                opciones.LoadWith<tbl_producto>(p => p.tbl_proveedor);
                dc.LoadOptions = opciones;

                return dc.tbl_producto
                         .FirstOrDefault(p => p.pro_id == id);
            }
        }

        public static void modificar(tbl_producto registro)
        {
            using (var dc = new DataClasses1DataContext())
            {
                var p = dc.tbl_producto
                          .FirstOrDefault(x => x.pro_id == registro.pro_id);
                if (p == null) return;

                p.pro_nombre = registro.pro_nombre;
                p.pro_cantidad = registro.pro_cantidad;
                p.pro_precio = registro.pro_precio;
                p.prov_id = registro.prov_id;

                dc.SubmitChanges();
            }
        }

        // Eliminación lógica
        public static void eliminar(int id)
        {
            using (var dc = new DataClasses1DataContext())
            {
                var p = dc.tbl_producto.FirstOrDefault(x => x.pro_id == id);
                if (p == null) return;
                p.pro_estado = 'I';
                dc.SubmitChanges();
            }
        }

        // ✅ Para la carga masiva Excel — borra todo y reinicia IDENTITY
        // El profe dijo: sin esto los IDs quedan 43, 90, 150...
        public static void EliminarTodosYReiniciarIdentity()
        {
            using (var dc = new DataClasses1DataContext())
            {
                // Primero borramos las imágenes (tabla hija)
                dc.ExecuteCommand("DELETE FROM tbl_producto_imagen");
                // Luego borramos productos excepto el "Sin Proveedor" de referencia
                dc.ExecuteCommand("DELETE FROM tbl_producto");
                // Reiniciamos el contador de IDs desde 0
                dc.ExecuteCommand("DBCC CHECKIDENT('tbl_producto', RESEED, 0)");
            }
        }

        // ✅ Inserta un producto desde el Excel usando SP del proveedor
        public static void CargarProveedorDesdeExcel(string nombre)
        {
            using (var dc = new DataClasses1DataContext())
            {
                dc.ExecuteCommand(
                    "EXEC sp_CargaMasivaProveedores @prov_nombre={0}",
                    nombre
                );
            }
        }

        // ✅ Insertar producto directamente (para carga masiva)
        public static bool InsertarParaCargaMasiva(
    string nombre, int cantidad, decimal precio, int provId)
        {
            try
            {
                using (var dc = new DataClasses1DataContext())
                {
                    // ✅ Verificar que el proveedor existe antes de insertar
                    bool existeProv = dc.tbl_proveedor
                                        .Any(p => p.prov_id == provId && p.prov_estado == 'A');

                    var prod = new tbl_producto
                    {
                        pro_nombre = nombre,
                        pro_cantidad = cantidad,
                        pro_precio = precio,
                        // Si no existe el proveedor → asigna 0 (Sin Proveedor)
                        prov_id = existeProv ? provId : 0,
                        pro_estado = 'A'
                    };
                    dc.tbl_producto.InsertOnSubmit(prod);
                    dc.SubmitChanges();
                    return true;
                }
            }
            catch { return false; }
        }
    }
}