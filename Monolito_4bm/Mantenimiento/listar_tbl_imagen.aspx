<%@ Page Title="Gestión de Imágenes" Language="C#" 
    MasterPageFile="~/Mantenimiento/Principal.Master" 
    AutoEventWireup="true" 
    CodeBehind="listar_tbl_imagen.aspx.cs" 
    Inherits="Monolito_4bm.Mantenimiento.listar_tbl_imagen" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .img-card {
            background: white; border-radius: 18px; padding: 24px;
            box-shadow: 0 2px 12px rgba(124,92,191,0.08); margin-bottom: 20px;
        }
        .section-title {
            font-size: 13px; font-weight: 700; color: #9b8ec4;
            text-transform: uppercase; letter-spacing: 1px;
            margin-bottom: 14px; padding-bottom: 8px;
            border-bottom: 2px solid #f0eaf8;
        }
        /* Grid de miniaturas estilo MercadoLibre */
        .img-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
            gap: 14px;
        }
        .img-item {
            position: relative; border-radius: 12px;
            overflow: hidden; border: 2px solid #e4daf5;
            background: #faf8ff; aspect-ratio: 1;
        }
        .img-item img {
            width: 100%; height: 100%; object-fit: cover;
            display: block;
        }
        .img-item .img-overlay {
            position: absolute; inset: 0;
            background: rgba(44,34,80,0.55);
            opacity: 0; transition: opacity .2s;
            display: flex; align-items: center; justify-content: center; gap: 8px;
        }
        .img-item:hover .img-overlay { opacity: 1; }
        .btn-overlay {
            background: white; border: none; border-radius: 8px;
            padding: 6px 10px; font-size: 12px; font-weight: 700;
            cursor: pointer; color: #2d2250;
        }
        .btn-overlay.del { color: #ef4444; }
        .img-placeholder-box {
            width: 100%; height: 100%; display: flex;
            align-items: center; justify-content: center; font-size: 36px;
        }
        .img-meta {
            font-size: 11px; color: #9b8ec4; text-align: center;
            padding: 4px 6px; background: white;
            border-top: 1px solid #e4daf5;
        }
        /* Upload zone */
        .upload-zone {
            border: 2px dashed #a78bda; border-radius: 14px;
            padding: 28px; text-align: center; background: #faf8ff;
            cursor: pointer; transition: background .2s;
        }
        .upload-zone:hover { background: #f0eaf8; }
        .upload-zone input[type=file] { display: none; }
        .upload-icon { font-size: 40px; color: #a78bda; margin-bottom: 8px; }
        .btn-purple {
            background: linear-gradient(135deg, #7c5cbf, #a78bda);
            color: white; padding: 10px 22px; border-radius: 10px;
            border: none; font-weight: 600; cursor: pointer; font-size: 13px;
        }
        .btn-outline {
            background: transparent; color: #7c5cbf;
            border: 1.5px solid #a78bda; padding: 10px 20px;
            border-radius: 10px; font-weight: 600; cursor: pointer; font-size: 13px;
        }
        .select-prod {
            padding: 10px 14px; border: 1px solid #e4daf5;
            border-radius: 10px; font-size: 14px; color: #2d2250;
            background: #faf8ff; font-weight: 600; width: 100%;
            margin-bottom: 16px;
        }
        .badge-count {
            background: #f0eaf8; color: #7c5cbf;
            padding: 3px 10px; border-radius: 20px;
            font-size: 12px; font-weight: 700; margin-left: 8px;
        }
        .empty-state {
            text-align: center; padding: 40px;
            color: #9b8ec4; font-size: 14px;
        }
        .empty-state .emoji { font-size: 48px; margin-bottom: 12px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph_contenido" runat="server">

    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
        <h2 style="font-weight:800; color:#2d2250; font-size:22px;">
            <i class="fas fa-images" style="color:#7c5cbf;"></i>
            Gestión de Imágenes
            <asp:Label ID="lbl_count" runat="server" CssClass="badge-count" Text="0" />
        </h2>
        <a href="listar_tbl_producto.aspx">
            <button type="button" class="btn-outline">← Volver a productos</button>
        </a>
    </div>

    <%-- SELECTOR DE PRODUCTO --%>
    <div class="img-card">
        <div class="section-title">
            <i class="fas fa-box"></i> Selecciona un producto
        </div>
        <asp:DropDownList ID="ddl_producto" runat="server"
            CssClass="select-prod"
            AutoPostBack="true"
            OnSelectedIndexChanged="ddl_producto_SelectedIndexChanged" />
    </div>

    <%-- SUBIR IMÁGENES --%>
    <asp:Panel ID="pnl_subir" runat="server" Visible="false">
        <div class="img-card">
            <div class="section-title">
                <i class="fas fa-upload"></i> Subir imágenes
            </div>
            
            <%-- FileUpload múltiple --%>
            <div class="upload-zone" onclick="document.getElementById('<%= fu_imagenes.ClientID %>').click();">
                <div style="margin-top:14px;">
    <asp:Button ID="btn_subir" runat="server"
        Text="📤 Subir imágenes seleccionadas"
        CssClass="btn-purple"
        OnClick="btn_subir_Click"
        CausesValidation="false" />
    
    <asp:Label ID="Label1" runat="server" 
        Visible="false"
        style="display:block; margin-top:10px; padding:10px; border-radius:8px;">
    </asp:Label>
</div>
    <div class="upload-icon">📸</div>
    <div style="font-weight:700; color:#2d2250; margin-bottom:4px;">
        Haz clic para seleccionar imágenes
    </div>
    <div style="font-size:12px; color:#9b8ec4;">
        JPG, PNG, WEBP — Máx. 5 MB por imagen
    </div>
    <%-- FileUpload múltiple oculto --%>
    <asp:FileUpload ID="fu_imagenes" runat="server"
        AllowMultiple="true"
        accept="image/*"
        style="display:none;" />
</div>
            <asp:Label ID="lbl_msg_subir" runat="server" Visible="false"
                style="display:block; margin-top:10px;" />
        </div>
    </asp:Panel>

    <%-- GRID DE IMÁGENES ESTILO MERCADOLIBRE --%>
    <asp:Panel ID="pnl_imagenes" runat="server" Visible="false">
        <div class="img-card">
            <div class="section-title">
                <i class="fas fa-th"></i> Imágenes del producto
            </div>

            <%-- Repeater = el "carrusel/grid" que pidió el profe --%>
            <asp:Repeater ID="rpt_imgs" runat="server"
                OnItemCommand="rpt_imgs_ItemCommand">
                <HeaderTemplate>
                    <div class="img-grid">
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="img-item">
                        <%-- Muestra la imagen por ruta o por BLOB --%>
                        <img src='<%# GetSrc(Eval("img_datos"), Eval("img_tipo"), Eval("img_ruta")) %>'
                             alt="Imagen" />
                        <div class="img-overlay">
                            <%-- Botón eliminar con CommandArgument = img_id --%>
                            <asp:LinkButton runat="server"
                                CommandName="Eliminar"
                                CommandArgument='<%# Eval("img_id") %>'
                                CssClass="btn-overlay del"
                                OnClientClick="return confirm('¿Eliminar esta imagen?');">
                                🗑 Eliminar
                            </asp:LinkButton>
                        </div>
                        <div class="img-meta">
                            ID: <%# Eval("img_id") %> —
                            <%# Eval("img_fecha", "{0:dd/MM/yy}") %>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                </FooterTemplate>
                
            </asp:Repeater>
            

<asp:Label ID="lbl_sin_imgs" runat="server" Visible="false">
    <div class="empty-state">
        <div class="emoji">📦</div>
        <div>Este producto no tiene imágenes todavía.</div>
    </div>
</asp:Label>

        </div>
    </asp:Panel>

</asp:Content>