<%@ Page Title="Proveedor" Language="C#" 
    MasterPageFile="~/Mantenimiento/Principal.Master" 
    AutoEventWireup="true" 
    CodeBehind="nuevo_tbl_proveedor.aspx.cs" 
    Inherits="Monolito_4bm.Mantenimiento.nuevo_tbl_proveedor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .form-card {
            background: white; border-radius: 18px; padding: 32px;
            box-shadow: 0 2px 12px rgba(124,92,191,0.08);
        }
        .form-info {
            background: #f0eaf8; border-left: 4px solid #7c5cbf;
            padding: 12px 16px; border-radius: 8px;
            margin-bottom: 24px; font-size: 13px; color: #2d2250;
        }
        .form-group { margin-bottom: 20px; }
        .form-label {
            display: block; font-size: 13px; font-weight: 600;
            color: #2d2250; margin-bottom: 8px;
        }
        .form-label span { color: #ef4444; }
        .form-input {
            width: 100%; padding: 12px 14px;
            border: 1px solid #e4daf5; border-radius: 10px;
            font-size: 14px; box-sizing: border-box;
        }
        .form-input:focus { outline: none; border-color: #7c5cbf; }
        .btn-group { display: flex; gap: 12px; margin-bottom: 24px; }
        .btn { padding: 10px 20px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; border: none; }
        .btn-primary { background: linear-gradient(135deg,#7c5cbf,#a78bda); color: white; }
        .btn-secondary { background: #f0eaf8; color: #7c5cbf; }
        .btn-regresar {
            background: transparent; color: #9b8ec4;
            border: 1px solid #e4daf5; padding: 12px 24px;
            border-radius: 10px; font-size: 14px; cursor: pointer; margin-top: 24px;
        }
        .alert { padding: 12px 16px; border-radius: 10px; margin-bottom: 20px; font-size: 13px; }
        .alert-success { background: #d1fae5; color: #065f46; }
        .alert-danger  { background: #fee2e2; color: #991b1b; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph_contenido" runat="server">

    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:24px;">
        <div style="font-size:24px; font-weight:800; color:#2d2250;"
             id="lblTitulo" runat="server">Nuevo Proveedor</div>
        <a href="listar_tbl_proveedor.aspx"
           style="background:linear-gradient(135deg,#7c5cbf,#a78bda);color:white;
                  padding:12px 24px;border-radius:10px;font-size:14px;
                  font-weight:600;text-decoration:none;">
            LISTADO
        </a>
    </div>

    <div class="form-card">
        <div class="form-info">
            <i class="fas fa-info-circle"></i>
            Completa los campos para registrar o editar un proveedor.
        </div>

        <asp:HiddenField ID="hf_id" runat="server" Value="0" />

        <div class="btn-group">
            <asp:Button ID="btn_nuevo" runat="server" Text="+ Nuevo Proveedor"
                CssClass="btn btn-secondary" OnClick="btn_nuevo_Click"
                CausesValidation="false" />
            <asp:Button ID="btn_guardar" runat="server" Text="💾 Guardar"
                CssClass="btn btn-primary" OnClick="btn_guardar_Click"
                CausesValidation="false" />
        </div>

        <asp:Label ID="lbl_mensaje" runat="server" CssClass="alert" Visible="false" />

        <div class="form-group">
            <label class="form-label">Nombre del Proveedor <span>*</span></label>
            <asp:TextBox ID="txt_nombre" runat="server" CssClass="form-input"
                placeholder="Ej: PRONACA, La Favorita..." />
        </div>

        <div class="form-group">
            <label class="form-label">Estado</label>
            <asp:DropDownList ID="ddl_estado" runat="server" CssClass="form-input">
                <asp:ListItem Text="Activo"   Value="A" />
                <asp:ListItem Text="Inactivo" Value="I" />
            </asp:DropDownList>
        </div>

        <asp:Button ID="btn_regresar" runat="server" Text="← Regresar"
            CssClass="btn-regresar" OnClick="btn_regresar_Click"
            CausesValidation="false" />
    </div>

</asp:Content>