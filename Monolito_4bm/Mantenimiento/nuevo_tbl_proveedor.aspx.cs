using System;
using Capa_Datos;
using Capa_Negocio;

namespace Monolito_4bm.Mantenimiento
{
    public partial class nuevo_tbl_proveedor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Si viene con ?id= es edición
                if (Request.QueryString["id"] != null)
                {
                    int id = Convert.ToInt32(Request.QueryString["id"]);
                    CargarParaEditar(id);
                }
            }
        }

        private void CargarParaEditar(int id)
        {
            var p = CN_tbl_proveedor.traerproveedorxid(id);
            if (p == null) return;

            hf_id.Value = p.prov_id.ToString();
            txt_nombre.Text = p.prov_nombre;
            ddl_estado.SelectedValue = p.prov_estado.ToString();
            lblTitulo.InnerText = "Editar Proveedor";
        }

        protected void btn_guardar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txt_nombre.Text))
            {
                Mensaje("El nombre es obligatorio.", false);
                return;
            }

            int id = Convert.ToInt32(hf_id.Value);

            try
            {
                if (id == 0)
                {
                    // ── INSERTAR ──────────────────────────────────
                    var nuevo = new tbl_proveedor
                    {
                        prov_nombre = txt_nombre.Text.Trim(),
                        prov_estado = ddl_estado.SelectedValue[0]
                    };
                    CN_tbl_proveedor.agregar(nuevo);
                    Mensaje("¡Proveedor registrado con éxito!", true);
                    Limpiar();
                }
                else
                {
                    // ── ACTUALIZAR ────────────────────────────────
                    var p = CN_tbl_proveedor.traerproveedorxid(id);
                    if (p != null)
                    {
                        p.prov_nombre = txt_nombre.Text.Trim();
                        p.prov_estado = ddl_estado.SelectedValue[0];
                        CN_tbl_proveedor.modificar(p);
                        Mensaje("¡Proveedor actualizado correctamente!", true);
                    }
                }
            }
            catch (Exception ex)
            {
                Mensaje("Error: " + ex.Message, false);
            }
        }

        protected void btn_nuevo_Click(object sender, EventArgs e)
        {
            Limpiar();
            lblTitulo.InnerText = "Nuevo Proveedor";
        }

        protected void btn_regresar_Click(object sender, EventArgs e)
        {
            Response.Redirect("listar_tbl_proveedor.aspx");
        }

        private void Limpiar()
        {
            hf_id.Value = "0";
            txt_nombre.Text = "";
            ddl_estado.SelectedValue = "A";
            lbl_mensaje.Visible = false;
        }

        private void Mensaje(string msg, bool ok)
        {
            lbl_mensaje.Visible = true;
            lbl_mensaje.Text = msg;
            lbl_mensaje.CssClass = ok ? "alert alert-success d-block"
                                      : "alert alert-danger d-block";
        }
    }
}