    <%@ Page Title="Gestión de Productos" Language="C#" MasterPageFile="~/Mantenimiento/Principal.Master" 
        AutoEventWireup="true" CodeBehind="listar_tbl_producto.aspx.cs" 
        Inherits="Monolito_4bm.Mantenimiento.listar_tbl_producto" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <!-- CDN de SweetAlert2 para las alertas flotantes estilo premium -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <style>
            .fb-layout {
                display: flex;
                gap: 20px;
                margin-top: 15px;
                align-items: flex-start;
            }

            /* Menú Lateral Fiel a Facebook */
            .fb-sidebar-filters {
                width: 280px;
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 2px 12px rgba(124,92,191,0.06);
                flex-shrink: 0;
            }
            .filter-section-title {
                font-size: 18px;
                font-weight: 800;
                color: #2d2250;
                margin-bottom: 15px;
                border-bottom: 2px solid #f0eaf8;
                padding-bottom: 8px;
            }
            .filter-group-title {
                font-size: 11px;
                font-weight: 700;
                color: #9b8ec4;
                text-transform: uppercase;
                margin-top: 15px;
                margin-bottom: 6px;
                letter-spacing: 0.5px;
            }

            /* Enlaces Interactivos */
            .filter-link {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 9px 12px;
                color: #4b5563;
                text-decoration: none;
                font-size: 13.5px;
                font-weight: 500;
                border-radius: 8px;
                transition: all 0.2s;
                margin-bottom: 3px;
            }
            .filter-link:hover {
                background-color: #faf8ff;
                color: #7c5cbf;
            }
            .filter-link.active {
                background-color: #f0eaf8;
                color: #7c5cbf;
                font-weight: 700;
            }

            /* Zona de Contenido */
            .fb-main-content {
                flex-grow: 1;
            }
            .grid-container {
                background: white;
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 2px 12px rgba(124,92,191,0.08);
            }

            /* Buscador Superior Combinado */
            .search-top-box {
                background: white;
                padding: 15px 20px;
                border-radius: 12px;
                box-shadow: 0 2px 12px rgba(124,92,191,0.06);
                margin-bottom: 15px;
                display: flex;
                gap: 12px;
                align-items: center;
            }
            .form-select {
                padding: 10px;
                border: 1px solid #e4daf5;
                border-radius: 8px;
                font-size: 14px;
                background-color: #faf8ff;
                color: #2d2250;
                font-weight: 600;
            }
            .form-input-search {
                flex-grow: 1;
                padding: 10px;
                border: 1px solid #e4daf5;
                border-radius: 8px;
                font-size: 14px;
            }
            .btn-purple {
                background: linear-gradient(135deg, #7c5cbf, #a78bda);
                color: white;
                padding: 10px 20px;
                border-radius: 8px;
                border: none;
                font-weight: 600;
                cursor: pointer;
            }

            /* Estilos del Gridview */
            .table th { background: #f0eaf8; padding: 12px 16px; text-align:left; font-size: 11px; font-weight: 700; color: #9b8ec4; text-transform: uppercase; }
            .table td { padding: 13px 16px; font-size: 13px; border-bottom: 1px solid #e4daf5; }
            .table tr:hover td { background: #faf8ff; }
            .img-thumb { width: 45px; height: 45px; border-radius: 8px; object-fit: cover; border: 2px solid #e4daf5; }
            .img-placeholder { width: 45px; height: 45px; border-radius: 8px; background: #ede9f6; display: inline-flex; align-items: center; justify-content: center; font-size: 18px; color: #a78bda; }
         
            /* Personalización de SweetAlert2 acorde al tema lavanda */
            .swal2-popup-lavanda {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
                border-radius: 16px !important;
            }
            .swal2-confirm-lavanda {
                background: linear-gradient(135deg, #7c5cbf, #a78bda) !important;
                color: white !important;
                font-weight: 600 !important;
                border-radius: 8px !important;
                padding: 10px 24px !important;
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="cph_contenido" runat="server">

        <div class="page-header" style="display:flex; justify-content:space-between; margin-bottom:15px;">
            <h2 style="font-weight:800; color:#2d2250;">Resultados de la búsqueda</h2>
            <a href="nuevo_tbl_producto.aspx" class="btn-purple" style="text-decoration:none; padding:10px 20px;">
                + NUEVO PRODUCTO
            </a>
        </div>

        <div class="fb-layout">
         
            <!-- BARRA LATERAL ESTILO FACEBOOK CON SECCIONES CRONOLÓGICAS Y DE ACTIVIDAD -->
            <div class="fb-sidebar-filters">
                <div class="filter-section-title">Filtros</div>
             
                <div class="filter-group-title">General</div>
                <asp:LinkButton ID="lnk_todo" runat="server" CssClass="filter-link active" OnClick="FiltrarLateral_Click" CommandArgument="TODO">
                    🌐 Todo el inventario
                </asp:LinkButton>

                <div class="filter-group-title">Tu Actividad</div>
                <asp:LinkButton ID="lnk_recientes" runat="server" CssClass="filter-link" OnClick="FiltrarLateral_Click" CommandArgument="RECIENTES">
                    🆕 Agregados hoy
                </asp:LinkButton>
                <asp:LinkButton ID="lnk_modificados" runat="server" CssClass="filter-link" OnClick="FiltrarLateral_Click" CommandArgument="MODIFICADOS">
                    ✏️ Modificados recientemente
                </asp:LinkButton>

                <div class="filter-group-title">Disponibilidad (Marketplace)</div>
                <asp:LinkButton ID="lnk_populares" runat="server" CssClass="filter-link" OnClick="FiltrarLateral_Click" CommandArgument="POPULARES">
                    🔥 Más vendidos / Populares
                </asp:LinkButton>
                <asp:LinkButton ID="lnk_stock_bajo" runat="server" CssClass="filter-link" OnClick="FiltrarLateral_Click" CommandArgument="STOCK_CRITICO">
                    ⚠️ Agotándose (Stock Mínimo)
                </asp:LinkButton>

                <div class="filter-group-title">Fecha de Ingreso</div>
                <asp:LinkButton ID="lnk_mes_actual" runat="server" CssClass="filter-link" OnClick="FiltrarLateral_Click" CommandArgument="MES_ACTUAL">
                    📅 Lote de este mes
                </asp:LinkButton>
                <asp:LinkButton ID="lnk_historicos" runat="server" CssClass="filter-link" OnClick="FiltrarLateral_Click" CommandArgument="HISTORICOS">
                    📦 Históricos / Antiguos
                </asp:LinkButton>

                <div class="filter-group-title">Criterio de Valor</div>
                <asp:LinkButton ID="lnk_ofertas" runat="server" CssClass="filter-link" OnClick="FiltrarLateral_Click" CommandArgument="OFERTAS">
                    ⚡ Ofertas del día (Económicos)
                </asp:LinkButton>
                <asp:LinkButton ID="lnk_alta_gama" runat="server" CssClass="filter-link" OnClick="FiltrarLateral_Click" CommandArgument="ALTA_GAMA">
                    💎 Alta gama (Costosos)
                </asp:LinkButton>
            </div>

            <!-- CONTENIDO PRINCIPAL: Barra superior combinada + Grid -->
            <div class="fb-main-content">
             
                <div class="search-top-box">
                    <label style="font-weight:700; color:#2d2250; font-size:13px;">Filtrar por:</label>
                    <asp:DropDownList ID="ddl_buscar_por" runat="server" CssClass="form-select">
                        <asp:ListItem Text="Nombre" Value="Nombre"></asp:ListItem>
                        <asp:ListItem Text="Precio" Value="Precio"></asp:ListItem>
                        <asp:ListItem Text="Proveedor" Value="Proveedor"></asp:ListItem>
                        <asp:ListItem Text="Cantidad" Value="Cantidad"></asp:ListItem>
                        <asp:ListItem Text="Fecha de Registro" Value="Fecha"></asp:ListItem>
                    </asp:DropDownList>

                    <asp:TextBox ID="txt_buscar" runat="server" CssClass="form-input-search" 
                        placeholder="Escribe para buscar dentro del filtro seleccionado..." 
                        AutoPostBack="true" OnTextChanged="btn_buscar_Click"></asp:TextBox>
                    <asp:Button ID="btn_buscar" runat="server" Text="Buscar" CssClass="btn-purple" OnClick="btn_buscar_Click" />
                </div>

                <div class="grid-container">
                    <asp:GridView ID="gvProductos" runat="server" AutoGenerateColumns="False"
                        AllowPaging="True" PageSize="5" OnPageIndexChanging="gvProductos_PageIndexChanging"
                        OnRowCommand="gvProductos_RowCommand" CssClass="table" Width="100%" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="pro_id" HeaderText="ID" />
                            <asp:BoundField DataField="pro_nombre" HeaderText="Nombre" />
                            <asp:BoundField DataField="pro_cantidad" HeaderText="Cantidad" />
                            <asp:BoundField DataField="pro_precio" HeaderText="Precio" DataFormatString="{0:C}" />
                         
                            <asp:TemplateField HeaderText="Proveedor">
                                <ItemTemplate>
                                    <%# Eval("tbl_proveedor.prov_nombre") %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Foto">
                                <ItemTemplate>
                                    <%# ObtenerMiniatura(Convert.ToInt32(Eval("pro_id"))) %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEditar" runat="server" CommandName="Editar" CommandArgument='<%# Eval("pro_id") %>' Text="✏️ Editar" style="margin-right:10px; text-decoration:none; font-weight:600; color:#7c5cbf;" />
                                    <asp:LinkButton ID="btnEliminar" runat="server" CommandName="Eliminar" CommandArgument='<%# Eval("pro_id") %>' Text="❌ Eliminar" style="color:#ef4444; text-decoration:none; font-weight:600;" OnClientClick="return confirm('¿Seguro que deseas dar de baja este producto?');" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="">
                         <ItemTemplate>
                            <a href='detalle_producto.aspx?id=<%# Eval("pro_id") %>'>
                            <button type="button" style="background:#f0eaf8;color:#7c5cbf;
                             border:none;border-radius:8px;padding:5px 10px;
                            font-size:12px;cursor:pointer;font-weight:600;">
                            <i class="fas fa-eye"></i> Ver
                     </button>
            </a>
        </ItemTemplate>
    </asp:TemplateField>
                        </Columns>
                        <PagerStyle HorizontalAlign="Center" BackColor="#F0EAF8" ForeColor="#7c5cbf" Font-Bold="true" Height="40px" />
                    </asp:GridView>
                </div>

            </div>
        </div>

        <!-- Script de control dinámico para transformar la entrada de texto en Calendario nativo HTML5 -->
        <script type="text/javascript">
            function configurarBuscadorDinamico() {
                var ddl = document.getElementById('<%= ddl_buscar_por.ClientID %>');
                var txt = document.getElementById('<%= txt_buscar.ClientID %>');
            
                if (ddl && txt) {
                    if (ddl.value === "Fecha") {
                        txt.type = "date"; // Transforma la caja de texto en un calendario gráfico completo
                        txt.placeholder = "";
                    } else {
                        txt.type = "text"; // Restaura a texto normal para los demás campos
                        if (ddl.value === "Precio") {
                            txt.placeholder = "Ejemplo: 3.50";
                        } else if (ddl.value === "Cantidad") {
                            txt.placeholder = "Ejemplo: 6";
                        } else {
                            txt.placeholder = "Escribe para buscar dentro del filtro seleccionado...";
                        }
                    }
                }
            }

            // Registrar los eventos en la carga inicial y tras los refrescos del servidor (AutoPostBack)
            window.onload = function() {
                configurarBuscadorDinamico();
                var ddl = document.getElementById('<%= ddl_buscar_por.ClientID %>');
                if (ddl) ddl.addEventListener("change", configurarBuscadorDinamico);
            };

            var prm = Sys.Web.Forms.PageRequestManager.getInstance();
            if (prm) {
                prm.add_endRequest(function() {
                    configurarBuscadorDinamico();
                    var ddl = document.getElementById('<%= ddl_buscar_por.ClientID %>');
                    if (ddl) ddl.addEventListener("change", configurarBuscadorDinamico);
                });
            }
        </script>
    </asp:Content>