using System;
using System.Linq;
using Capa_Datos;
using Capa_Negocio;

namespace Monolito_4bm.Mantenimiento
{
    public partial class detalle_producto : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] == null)
                {
                    Response.Redirect("listar_tbl_producto.aspx");
                    return;
                }
                int id = Convert.ToInt32(Request.QueryString["id"]);
                CargarDetalle(id);
                CargarCharts();
            }
        }

        private void CargarDetalle(int id)
        {
            var p = CN_tbl_producto.traerproductoxid(id);
            if (p == null)
            {
                Response.Redirect("listar_tbl_producto.aspx");
                return;
            }

            lit_titulo.Text = p.pro_nombre;
            lit_nombre.Text = p.pro_nombre;
            lit_precio.Text = (p.pro_precio ?? 0).ToString("N2");
            lit_cantidad.Text = (p.pro_cantidad ?? 0).ToString();
            lit_proveedor.Text = p.tbl_proveedor?.prov_nombre ?? "Sin proveedor";

            string est = p.pro_estado?.ToString() ?? "I";
            lit_estado.Text = est == "A"
                ? "<span class='badge-A'>Activo</span>"
                : "<span class='badge-I'>Inactivo</span>";

            var imagenes = CN_tbl_producto_imagen.ListarImagenesPorProducto(id);
            rpt_imagenes.DataSource = imagenes;
            rpt_imagenes.DataBind();
        }

        private void CargarCharts()
        {
            using (var dc = new DataClasses1DataContext())
            {
                var todos = dc.tbl_producto
                              .Where(p => p.pro_estado == 'A')
                              .ToList();

                // Top 5 mayor precio
                var topPrecio = todos
                    .OrderByDescending(p => p.pro_precio ?? 0)
                    .Take(5).ToList();
                hf_precio.Value = SimpleJson(
                    topPrecio.Select(p => p.pro_nombre ?? "?").ToArray(),
                    topPrecio.Select(p => (double)(p.pro_precio ?? 0)).ToArray());

                // Top 5 mayor stock
                var topStock = todos
                    .OrderByDescending(p => p.pro_cantidad ?? 0)
                    .Take(5).ToList();
                hf_stock.Value = SimpleJson(
                    topStock.Select(p => p.pro_nombre ?? "?").ToArray(),
                    topStock.Select(p => (double)(p.pro_cantidad ?? 0)).ToArray());

                // Productos por proveedor
                var porProv = todos
                    .GroupBy(p => p.tbl_proveedor?.prov_nombre ?? "Sin proveedor")
                    .Select(g => new { nombre = g.Key, total = g.Count() })
                    .OrderByDescending(x => x.total)
                    .Take(5).ToList();
                hf_proveedor.Value = SimpleJson(
                    porProv.Select(x => x.nombre).ToArray(),
                    porProv.Select(x => (double)x.total).ToArray());
            }
        }

        private string SimpleJson(string[] labels, double[] data)
        {
            string lbls = string.Join(",", Array.ConvertAll(labels,
                l => "\"" + l.Replace("\"", "") + "\""));
            string vals = string.Join(",", Array.ConvertAll(data,
                d => d.ToString(System.Globalization.CultureInfo.InvariantCulture)));
            return "{\"labels\":[" + lbls + "],\"data\":[" + vals + "]}";
        }

        public string ObtenerUrl(object datos, object tipo, object ruta)
        {
            string rutaStr = ruta?.ToString();
            if (!string.IsNullOrEmpty(rutaStr))
                return ResolveUrl(rutaStr);

            var bytes = datos as System.Data.Linq.Binary;
            if (bytes != null && bytes.Length > 0)
                return "data:" + (tipo?.ToString() ?? "image/png") + ";base64,"
                       + Convert.ToBase64String(bytes.ToArray());

            return "";
        }
    }
}