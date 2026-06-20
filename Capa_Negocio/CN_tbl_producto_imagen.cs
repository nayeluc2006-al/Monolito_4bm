using Capa_Datos;
using System;
using System.Collections.Generic;
using System.Data.Linq;
using System.Linq;

namespace Capa_Negocio
{
    public class CN_tbl_producto_imagen
    {
        // ✅ DataContext estático — estilo que pide el profe
        private static DataClasses1DataContext dc = new DataClasses1DataContext();

        // Listar todas las imágenes de un producto
        public static List<tbl_producto_imagen> ListarImagenesPorProducto(int proId)
        {
            return dc.tbl_producto_imagen
                     .Where(img => img.pro_id == proId)
                     .ToList();
        }

        // Traer la primera imagen — para miniatura en el grid
        public static tbl_producto_imagen TraerPrimeraImagen(int proId)
        {
            return dc.tbl_producto_imagen
                     .Where(img => img.pro_id == proId)
                     .OrderBy(img => img.img_fecha)
                     .FirstOrDefault();
        }

        // Traer imagen por ID — para mostrar en detalle
        public static tbl_producto_imagen TraerImagenPorId(int imgId)
        {
            return dc.tbl_producto_imagen
                     .FirstOrDefault(img => img.img_id == imgId);
        }

        // Contar imágenes de un producto
        public static int ContarImagenes(int proId)
        {
            return dc.tbl_producto_imagen
                     .Count(img => img.pro_id == proId);
        }

        // Insertar imagen — guarda bytes en BD
        // ✅ Acepta bytes null — cuando se guarda por path no hay bytes
        public static bool InsertarImagen(int proId, byte[] datos, string tipo, string ruta)
        {
            try
            {
                var nueva = new tbl_producto_imagen
                {
                    pro_id = proId,
                    // ✅ Solo guarda bytes si vienen — si es null los omite
                    img_datos = datos != null ? new System.Data.Linq.Binary(datos) : null,
                    img_tipo = tipo,
                    img_ruta = ruta,
                    img_fecha = DateTime.Now
                };
                dc.tbl_producto_imagen.InsertOnSubmit(nueva);
                dc.SubmitChanges();
                return true;
            }
            catch { return false; }
        }

        // Eliminar imagen por ID
        public static bool EliminarImagen(int imgId)
        {
            try
            {
                var reg = dc.tbl_producto_imagen
                            .FirstOrDefault(img => img.img_id == imgId);
                if (reg == null) return false;
                dc.tbl_producto_imagen.DeleteOnSubmit(reg);
                dc.SubmitChanges();
                return true;
            }
            catch { return false; }
        }

        // Eliminar TODAS las imágenes de un producto
        // Se llama antes de eliminar el producto para no dejar huérfanos
        public static void EliminarImagenesPorProducto(int proId)
        {
            try
            {
                var imgs = dc.tbl_producto_imagen
                             .Where(img => img.pro_id == proId)
                             .ToList();
                dc.tbl_producto_imagen.DeleteAllOnSubmit(imgs);
                dc.SubmitChanges();
            }
            catch { }
        }

    }
}