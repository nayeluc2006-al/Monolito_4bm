<%@ Page Title="Carga Masiva" Language="C#" 
    MasterPageFile="~/Mantenimiento/Principal.Master" 
    AutoEventWireup="true" 
    CodeBehind="subir_excel_producto.aspx.cs" 
    Inherits="Monolito_4bm.Mantenimiento.subir_excel_producto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .upload-card {
            background: white; border-radius: 18px; padding: 32px;
            box-shadow: 0 2px 12px rgba(124,92,191,0.08); margin-bottom: 20px;
        }
        .upload-zone {
            border: 2px dashed #a78bda; border-radius: 14px;
            padding: 32px; text-align: center; background: #faf8ff;
            margin-bottom: 20px;
        }
        .upload-icon { font-size: 48px; color: #a78bda; margin-bottom: 12px; }
        .upload-title { font-size: 16px; font-weight: 700; color: #2d2250; margin-bottom: 6px; }
        .upload-sub { font-size: 12px; color: #9b8ec4; margin-bottom: 16px; }
        .btn-purple {
            background: linear-gradient(135deg, #7c5cbf, #a78bda);
            color: white; padding: 11px 24px; border-radius: 10px;
            border: none; font-weight: 600; cursor: pointer; font-size: 13px;
        }
        .btn-outline {
            background: transparent; color: #7c5cbf;
            border: 1.5px solid #a78bda; padding: 11px 24px;
            border-radius: 10px; font-weight: 600; cursor: pointer;
            font-size: 13px; margin-right: 10px;
        }
        .btn-danger {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white; padding: 11px 24px; border-radius: 10px;
            border: none; font-weight: 600; cursor: pointer; font-size: 13px;
        }
        .section-title {
            font-size: 13px; font-weight: 700; color: #9b8ec4;
            text-transform: uppercase; letter-spacing: 1px;
            margin-bottom: 14px; padding-bottom: 8px;
            border-bottom: 2px solid #f0eaf8;
        }
        .preview-table { width: 100%; border-collapse: collapse; font-size: 13px; }
        .preview-table th {
            background: #f0eaf8; padding: 10px 14px; text-align: left;
            font-size: 11px; font-weight: 700; color: #9b8ec4;
            text-transform: uppercase;
        }
        .preview-table td {
            padding: 10px 14px; border-bottom: 1px solid #e4daf5; color: #2d2250;
        }
        .preview-table tr:hover td { background: #faf8ff; }
        .badge-new {
            background: #d1fae5; color: #065f46;
            padding: 3px 8px; border-radius: 20px;
            font-size: 11px; font-weight: 700;
        }
        .alert-info {
            background: #eff6ff; border-left: 4px solid #3b82f6;
            padding: 12px 16px; border-radius: 8px;
            font-size: 13px; color: #1e40af; margin-bottom: 16px;
        }
        .alert-warning {
            background: #fefce8; border-left: 4px solid #f59e0b;
            padding: 12px 16px; border-radius: 8px;
            font-size: 13px; color: #92400e; margin-bottom: 16px;
        }
        .alert-success {
            background: #d1fae5; border-left: 4px solid #10b981;
            padding: 12px 16px; border-radius: 8px;
            font-size: 13px; color: #065f46; margin-bottom: 16px;
        }
        .alert-danger {
            background: #fee2e2; border-left: 4px solid #ef4444;
            padding: 12px 16px; border-radius: 8px;
            font-size: 13px; color: #991b1b; margin-bottom: 16px;
        }
        .counter-box {
            display: inline-flex; align-items: center; gap: 8px;
            background: #f0eaf8; border-radius: 10px; padding: 8px 16px;
            font-size: 13px; font-weight: 600; color: #7c5cbf; margin-bottom: 16px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph_contenido" runat="server">

    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
        <h2 style="font-weight:800; color:#2d2250; font-size:22px;">
            <i class="fas fa-file-excel" style="color:#10b981"></i>
            Carga Masiva de Productos
        </h2>
        <a href="listar_tbl_producto.aspx" style="text-decoration:none;">
            <button class="btn-outline">← Volver al listado</button>
        </a>
    </div>

    <%-- PASO 1: DESCARGAR FORMATO --%>
    <div class="upload-card">
        <div class="section-title">
            <i class="fas fa-download"></i> Paso 1 — Descarga el formato
        </div>
        <div class="alert-info">
            <i class="fas fa-info-circle"></i>
            Descarga el formato con tus productos actuales, agrégale los nuevos y súbelo aquí.
        </div>
        <asp:Button ID="btn_descargar_formato" runat="server"
            Text="⬇ Descargar productos actuales"
            CssClass="btn-outline"
            OnClick="btn_descargar_formato_Click"
            CausesValidation="false" />
    </div>

    <%-- PASO 2: SUBIR ARCHIVO --%>
    <div class="upload-card">
        <div class="section-title">
            <i class="fas fa-upload"></i> Paso 2 — Sube tu archivo
        </div>
        <div class="upload-zone">
            <div class="upload-icon"><i class="fas fa-file-excel"></i></div>
            <div class="upload-title">Selecciona tu archivo Excel</div>
            <div class="upload-sub">Formato: .xlsx</div>
            <asp:FileUpload ID="fu_excel" runat="server" />
        </div>
        <asp:Button ID="btn_previsualizar" runat="server"
            Text="👁 Previsualizar datos"
            CssClass="btn-outline"
            OnClick="btn_previsualizar_Click"
            CausesValidation="false" />
    </div>

    <%-- Resultado fuera del panel para que el .cs lo encuentre siempre --%>
    <asp:Label ID="lbl_resultado" runat="server" Visible="false"
        style="display:block; margin-top:10px;" />

    <%-- PASO 3: PREVISUALIZACIÓN --%>
    <asp:Panel ID="pnl_preview" runat="server" Visible="false">
        <div class="upload-card">
            <div class="section-title">
                <i class="fas fa-table"></i> Paso 3 — Previsualización
            </div>
            <div class="alert-warning">
                <i class="fas fa-exclamation-triangle"></i>
                <b>Atención:</b> Al confirmar se borrarán los productos actuales,
                se reiniciará el ID y se cargarán los nuevos datos.
                Esta acción no se puede deshacer.
            </div>
            <div class="counter-box">
                <i class="fas fa-boxes"></i>
                <asp:Label ID="lbl_contador" runat="server" Text="0 productos" />
            </div>
            <div style="overflow-x:auto;">
                <asp:GridView ID="gv_preview" runat="server"
                    CssClass="preview-table"
                    AutoGenerateColumns="false"
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="pro_nombre"   HeaderText="Nombre" />
                        <asp:BoundField DataField="pro_cantidad" HeaderText="Cantidad" />
                        <asp:BoundField DataField="pro_precio"   HeaderText="Precio"
                            DataFormatString="{0:C}" />
                        <asp:BoundField DataField="prov_id"      HeaderText="ID Proveedor" />
                        <asp:TemplateField HeaderText="Estado">
                            <ItemTemplate>
                                <%# (bool)Eval("es_nuevo")
                                    ? "<span class='badge-new'>NUEVO</span>"
                                    : "<span style='background:#dbeafe;color:#1e40af;padding:3px 8px;border-radius:20px;font-size:11px;font-weight:700;'>EXISTENTE</span>" %>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <div style="margin-top:16px; display:flex; gap:10px;">

    <%-- Botón oculto que hace el postback real --%>
    <asp:Button ID="btn_confirmar_carga" runat="server"
        Text="Confirmar"
        CssClass="btn-purple"
        OnClick="btn_confirmar_carga_Click"
        CausesValidation="false"
        style="display:none;" />

    <%-- Botón visible que dispara el SweetAlert --%>
    <button type="button" class="btn-purple" onclick="interceptarConfirmar();">
        🚀 Confirmar y cargar a la BD
    </button>

    <asp:Button ID="btn_cancelar" runat="server"
        Text="✖ Cancelar"
        CssClass="btn-danger"
        OnClick="btn_cancelar_Click"
        CausesValidation="false" />

</div>  <%-- ← cierre del div de botones --%>

</div>  <%-- ← cierre del upload-card --%>

</asp:Panel>
    <script>
        function interceptarConfirmar() {
            Swal.fire({
                title: '¿Estás seguro?',
                html: 'Se <b>borrarán todos los productos actuales</b> y se cargarán los del Excel.<br><br>Esta acción <b>no se puede deshacer</b>.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: '✅ Sí, cargar',
                cancelButtonText: '❌ Cancelar',
                confirmButtonColor: '#7c5cbf',
                cancelButtonColor: '#ef4444'
            }).then((result) => {
                if (result.isConfirmed) {
                    // ✅ Llama directo al botón ASP.NET oculto
                    document.getElementById('<%= btn_confirmar_carga.ClientID %>').click();
        }
    });
        }
    </script>

</asp:Content>