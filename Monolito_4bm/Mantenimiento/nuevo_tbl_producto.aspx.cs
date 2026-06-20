using System;
using System.Web.UI.WebControls;
using Capa_Datos;
using Capa_Negocio; // Para heredar de CN_tbl_producto y CN_tbl_proveeder

namespace Monolito_4bm.Mantenimiento
{
    public partial class nuevo_tbl_producto : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (Form != null)
            {
                Form.Enctype = "multipart/form-data";
            }

            // El IsPostBack evita que los controles se reinicien al presionar un botón
            if (!IsPostBack)
            {
                CargarComboProveedores();

                // Si la URL tiene un parámetro ?id=... significa que el usuario quiere EDITAR
                if (Request.QueryString["id"] != null)
                {
                    int id = Convert.ToInt32(Request.QueryString["id"]);
                    CargarProductoParaEditar(id);
                }
            }
        }

        // 🧠 APRENDAMOS: Este método llena el DropDownList dinámicamente desde la base de datos
        private void CargarComboProveedores()
        {
            ddl_proveedor.DataSource = CN_tbl_proveedor.ListarProveedor();
            ddl_proveedor.DataValueField = "prov_id";     // Lo que se guarda (la llave foránea)
            ddl_proveedor.DataTextField = "prov_nombre";  // Lo que el usuario lee en pantalla
            ddl_proveedor.DataBind();

            // Añadimos una opción neutra al inicio del combo
            ddl_proveedor.Items.Insert(0, new ListItem("-- Selecciona un Proveedor --", "0"));
        }

        // Recupera el producto seleccionado usando LINQ y llena los campos de texto
        private void CargarProductoParaEditar(int id)
        {
            var p = CN_tbl_producto.traerproductoxid(id);
            if (p != null)
            {
                hf_id.Value = p.pro_id.ToString(); // Guardamos el ID oculto para saber que es una edición
                txt_nombre.Text = p.pro_nombre;
                txt_cantidad.Text = p.pro_cantidad.ToString();
                txt_precio.Text = p.pro_precio.ToString();

                if (p.prov_id != null && ddl_proveedor.Items.FindByValue(p.prov_id.ToString()) != null)
                {
                    ddl_proveedor.SelectedValue = p.prov_id.ToString();
                }

                lblTitulo.InnerText = "Editar Producto"; // Cambia el encabezado dinámicamente
            }
        }

        // Evento principal del botón Guardar (Detecta si inserta o actualiza)
        protected void btn_guardar_Click(object sender, EventArgs e)
        {
            try
            {
                // Validaciones básicas de seguridad en el servidor
                if (string.IsNullOrEmpty(txt_nombre.Text.Trim()))
                {
                    Mensaje("El nombre del producto es obligatorio.", false);
                    return;
                }
                if (ddl_proveedor.SelectedValue == "0")
                {
                    Mensaje("Por favor, selecciona un proveedor.", false);
                    return;
                }

                int id = 0;
                if (!string.IsNullOrEmpty(hf_id.Value))
                {
                    id = Convert.ToInt32(hf_id.Value);
                }

                if (id == 0)
                {
                    // ── MODO INSERTAR NUEVO ──
                    tbl_producto nuevo = new tbl_producto();
                    nuevo.pro_nombre = txt_nombre.Text.Trim();
                    nuevo.pro_cantidad = Convert.ToInt32(txt_cantidad.Text.Trim());
                    nuevo.pro_precio = ConvertirPrecioSeguro(txt_precio.Text);
                    nuevo.prov_id = Convert.ToInt32(ddl_proveedor.SelectedValue);
                    nuevo.pro_estado = 'A'; // Activo

                    // Usar el método existente InsertarParaCargaMasiva en vez de un método inexistente 'agregar'
                    bool creado = CN_tbl_producto.InsertarParaCargaMasiva(
                        nuevo.pro_nombre,
                        nuevo.pro_cantidad ?? 0,
                        nuevo.pro_precio ?? 0m,
                        nuevo.prov_id ?? 0
                    );

                    if (creado)
                    {
                        Mensaje("¡Producto registrado con éxito!", true);
                        Limpiar();
                    }
                    else
                    {
                        Mensaje("No se pudo registrar el producto.", false);
                    }
                }
                else
                {
                    // ── MODO EDITAR EXISTENTE ──
                    var p = CN_tbl_producto.traerproductoxid(id);
                    if (p != null)
                    {
                        p.pro_nombre = txt_nombre.Text.Trim();
                        p.pro_cantidad = Convert.ToInt32(txt_cantidad.Text.Trim());

                        p.pro_precio = ConvertirPrecioSeguro(txt_precio.Text);
                        p.prov_id = Convert.ToInt32(ddl_proveedor.SelectedValue);

                        CN_tbl_producto.modificar(p);
                        Mensaje("¡Producto actualizado correctamente!", true);
                    }
                }
            }
            catch (Exception ex)
            {
                Mensaje("Ocurrió un error: " + ex.Message, false);
            }
        }

        protected void btn_nuevo_Click(object sender, EventArgs e)
        {
            Limpiar();
            lblTitulo.InnerText = "Nuevo Producto";
            lbl_mensaje.Visible = false;
        }

        protected void btn_regresar_Click(object sender, EventArgs e)
        {
            Response.Redirect("listar_tbl_producto.aspx");
        }

        private void Limpiar()
        {
            hf_id.Value = "0";
            txt_nombre.Text = "";
            txt_cantidad.Text = "0";
            txt_precio.Text = "0.00";
            if (ddl_proveedor.Items.Count > 0) ddl_proveedor.SelectedIndex = 0;
        }

        private void Mensaje(string msg, bool ok)
        {
            lbl_mensaje.Visible = true;
            lbl_mensaje.Text = msg;
            // Evaluamos la alerta usando las clases CSS lavandas que pusiste en tu diseño .aspx
            lbl_mensaje.CssClass = ok ? "alert alert-success d-block" : "alert alert-danger d-block";
        }

        private decimal ConvertirPrecioSeguro(string textoPrecio)
        {
            // 1. Limpiamos espacios en blanco
            string limpio = textoPrecio.Trim();

            if (string.IsNullOrEmpty(limpio)) return 0.00m;

            // 2. Si el usuario usó ambos (ejemplo: 1,250.50 o 1.250,50), removemos el separador de miles
            if ((limpio.Contains(",") && limpio.Contains(".")))
            {
                // Si el punto está después de la coma, la coma es de miles (1,250.50)
                if (limpio.IndexOf(",") < limpio.IndexOf("."))
                {
                    limpio = limpio.Replace(",", ""); // Quitamos la coma de miles
                }
                else // Si la coma está después del punto, el punto es de miles (1.250,50)
                {
                    limpio = limpio.Replace(".", "").Replace(",", "."); // Quitamos punto y pasamos coma a punto
                }
            }
            else
            {
                // 3. Si solo usó un separador (ejemplo: 50,25 o 50.25), lo pasamos al formato estándar de punto
                limpio = limpio.Replace(",", ".");
            }

            // 4. Convertimos usando la cultura invariante de forma segura
            return Convert.ToDecimal(limpio, System.Globalization.CultureInfo.InvariantCulture);
        }

        protected void btn_subir_imagen_Click(object sender, EventArgs e)
        {
            try
            {
                // 1. Recuperar el ID de forma segura desde la QueryString si el HiddenField falla
                int idProducto = 0;
                if (!string.IsNullOrEmpty(hf_id.Value) && hf_id.Value != "0")
                {
                    idProducto = Convert.ToInt32(hf_id.Value);
                }
                else if (Request.QueryString["id"] != null)
                {
                    idProducto = Convert.ToInt32(Request.QueryString["id"]);
                    hf_id.Value = idProducto.ToString(); // Lo reasignamos por seguridad
                }

                if (idProducto == 0)
                {
                    Mensaje("Primero guarda el producto antes de adjuntarle imágenes.", false);
                    return;
                }

                // 2. Verificar que el control FileUpload tenga el archivo retenido
                if (fu_imagen.HasFile)
                {
                    string tipo = fu_imagen.PostedFile.ContentType;
                    if (!tipo.StartsWith("image/"))
                    {
                        Mensaje("Solo se permiten imágenes.", false);
                        return;
                    }

                    // Límite de peso: 5 MB
                    if (fu_imagen.PostedFile.ContentLength > 5 * 1024 * 1024)
                    {
                        Mensaje("La imagen no puede superar 5 MB.", false);
                        return;
                    }

                    // 3. Crear la ruta física de forma limpia
                    string carpeta = Server.MapPath("~/Uploads/Productos/");
                    if (!System.IO.Directory.Exists(carpeta))
                    {
                        System.IO.Directory.CreateDirectory(carpeta);
                    }

                    // Nombre único usando Ticks de tiempo
                    string ext = System.IO.Path.GetExtension(fu_imagen.FileName);
                    string nombreArchivo = "prod_" + idProducto + "_" + DateTime.Now.Ticks + ext;
                    string rutaCompleta = System.IO.Path.Combine(carpeta, nombreArchivo);

                    // 4. Guardar físicamente el archivo en el disco del servidor
                    fu_imagen.SaveAs(rutaCompleta);

                    // Ruta relativa exacta para guardar en BD (compatible con local y hosting)
                    string rutaBD = "~/Uploads/Productos/" + nombreArchivo;

                    // 5. Inserción en la capa de negocio
                    // Pasamos null al parámetro varbinary (img_datos) ya que usas rutas por carpetas
                    bool exito = CN_tbl_producto_imagen.InsertarImagen(idProducto, null, tipo, rutaBD);

                    if (exito)
                    {
                        Mensaje("✅ Imagen guardada correctamente.", true);

                        // Opcional: Si quieres que se limpie el input al terminar
                        // fu_imagen.Attributes.Clear(); 
                    }
                    else
                    {
                        // Si entra aquí, el fallo es 100% de la Base de Datos (Clave foránea rota o procedimiento erróneo)
                        Mensaje("No se pudo guardar el registro de la imagen en la Base de Datos. Verifica que el ID del producto exista.", false);
                    }
                }
                else
                {
                    Mensaje("Selecciona una imagen antes de hacer clic en Adjuntar.", false);
                }
            }
            catch (Exception ex)
            {
                Mensaje("Error crítico al subir la imagen: " + ex.Message, false);
            }
        }
    }
    }
