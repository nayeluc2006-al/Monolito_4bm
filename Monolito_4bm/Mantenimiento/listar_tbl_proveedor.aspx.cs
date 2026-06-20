using System;
using System.Web.UI.WebControls;
using Capa_Negocio;

namespace Monolito_4bm.Mantenimiento
{
    public partial class listar_tbl_proveedor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                CargarGrid();
        }

        private void CargarGrid()

        {
            gvProveedores.DataSource = CN_tbl_proveedor.ListarProveedor();
            gvProveedores.DataBind();
        }

        protected void gvProveedores_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProveedores.PageIndex = e.NewPageIndex;
            CargarGrid();
        }

        protected void gvProveedores_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "Editar")
            {
                Response.Redirect("nuevo_tbl_proveedor.aspx?id=" + id);
            }
            else if (e.CommandName == "Eliminar")
            {
                try
                {
                    // Usamos tu método original de eliminación lógica
                    CN_tbl_proveedor.eliminar(id);

                    lblMensaje.Visible = true;
                    lblMensaje.Text = "✅ Proveedor eliminado con éxito.";
                    lblMensaje.CssClass = "alert alert-success d-block";
                }
                catch (Exception)
                {
                    lblMensaje.Visible = true;
                    lblMensaje.Text = "❌ No se pudo eliminar el proveedor.";
                    lblMensaje.CssClass = "alert alert-danger d-block";
                }

                CargarGrid(); // Recargamos la tabla para ver los cambios
            }
        }
    }
}