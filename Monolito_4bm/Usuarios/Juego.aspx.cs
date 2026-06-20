using System;
using System.Web.UI;

namespace Monolito_4bm.Usuarios
{
    public partial class Juego : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                IniciarNuevoJuego();
            }
        }

        private void IniciarNuevoJuego()
        {
            Random rnd = new Random();
            Session["NumeroSecreto"] = rnd.Next(1, 101); // Genera entre 1 y 100
            Session["IntentosContador"] = 0;
            lbl_intentos.Text = "0";
            lbl_pista.Text = "¡Suerte! Comienza el juego.";
            lbl_pista.ForeColor = System.Drawing.Color.SlateGray;
            btn_reiniciar.Visible = false;
            btn_probar.Enabled = true;
            txt_numero.Text = "";
        }

        protected void btn_probar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txt_numero.Text)) return;

            int intentoUsuario = int.Parse(txt_numero.Text);
            int numeroSecreto = (int)Session["NumeroSecreto"];
            int contador = (int)Session["IntentosContador"] + 1;

            Session["IntentosContador"] = contador;
            lbl_intentos.Text = contador.ToString();

            if (intentoUsuario == numeroSecreto)
            {
                lbl_pista.Text = "🎉 ¡BRUTAL! ¡Lo adivinaste!";
                lbl_pista.ForeColor = System.Drawing.Color.Green;
                btn_probar.Enabled = false;
                btn_reiniciar.Visible = true;
                ScriptManager.RegisterStartupScript(this, GetType(), "win", "Swal.fire('¡Ganaste!', 'Lo lograste en " + contador + " intentos', 'success');", true);
            }
            else if (intentoUsuario < numeroSecreto)
            {
                lbl_pista.Text = "❌ Muy bajo... ¡Sube más!";
                lbl_pista.ForeColor = System.Drawing.Color.OrangeRed;
            }
            else
            {
                lbl_pista.Text = "❌ Muy alto... ¡Bájale un poco!";
                lbl_pista.ForeColor = System.Drawing.Color.OrangeRed;
            }
            txt_numero.Text = "";
            txt_numero.Focus();
        }

        protected void btn_reiniciar_Click(object sender, EventArgs e)
        {
            IniciarNuevoJuego();
        }

        
        protected void btn_logout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Seguridad/Login.aspx");
        }
    }
}