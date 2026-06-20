<%@ Page Title="Productos" Language="C#" MasterPageFile="~/Mantenimiento/Principal.Master" 
    AutoEventWireup="true" CodeBehind="nuevo_tbl_producto.aspx.cs" 
    Inherits="Monolito_4bm.Mantenimiento.nuevo_tbl_producto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        .page-title {
            font-size: 24px;
            font-weight: 800;
            color: var(--text);
        }
        .btn-header {
            background: linear-gradient(135deg, #7c5cbf, #a78bda);
            color: white;
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            text-decoration: none;
        }
        .form-card {
            background: white;
            border-radius: 18px;
            padding: 32px;
            box-shadow: 0 2px 12px rgba(124,92,191,0.08);
        }
        .form-info {
            background: #f0eaf8;
            border-left: 4px solid #7c5cbf;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 13px;
            color: #2d2250;
        }
        .btn-group-top {
            display: flex;
            gap: 12px;
            margin-bottom: 24px;
        }
        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: 0.2s;
        }
        .btn-primary {
            background: linear-gradient(135deg, #7c5cbf, #a78bda);
            color: white;
        }
        .btn-secondary {
            background: #f0eaf8;
            color: #7c5cbf;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #2d2250;
            margin-bottom: 8px;
        }
        .form-label span {
            color: #ef4444;
        }
        .form-input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #e4daf5;
            border-radius: 10px;
            font-size: 14px;
            box-sizing: border-box;
            transition: 0.2s;
        }
        .form-input:focus {
            outline: none;
            border-color: #7c5cbf;
            box-shadow: 0 0 0 3px rgba(124,92,191,0.1);
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .btn-regresar {
            background: transparent;
            color: #9b8ec4;
            border: 1px solid #e4daf5;
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 14px;
            cursor: pointer;
            margin-top: 24px;
        }
        .alert {
            padding: 12px 16px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 13px;
        }
        .alert-success {
            background: #d1fae5;
            color: #065f46;
        }
        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph_contenido" runat="server">
    
    <div class="page-header">
        <div class="page-title" id="lblTitulo" runat="server">Nuevo Producto</div>
        <a href="listar_tbl_producto.aspx" class="btn-header">LISTADO</a>
    </div>

    <div class="form-card">
        <div class="form-info">
            <i class="fas fa-info-circle"></i> Completa los campos requeridos para registrar un nuevo producto en el sistema.
        </div>

        <div class="btn-group-top">
            <asp:Button ID="btn_nuevo" runat="server" Text="+ Nuevo Producto" 
                CssClass="btn btn-secondary" OnClick="btn_nuevo_Click" />
            <asp:Button ID="btn_guardar" runat="server" Text="Guardar" 
                CssClass="btn btn-primary" OnClick="btn_guardar_Click" />
        </div>

        <asp:Label ID="lbl_mensaje" runat="server" CssClass="alert" Visible="false"></asp:Label>
        <asp:HiddenField ID="hf_id" runat="server" Value="0" />

        <div class="form-group">
            <label class="form-label">Nombre del Producto <span>*</span></label>
            <asp:TextBox ID="txt_nombre" runat="server" CssClass="form-input" 
                placeholder="Ingresa el nombre del producto"></asp:TextBox>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label class="form-label">Cantidad <span>*</span></label>
                <asp:TextBox ID="txt_cantidad" runat="server" CssClass="form-input" 
                    TextMode="Number" Text="0"></asp:TextBox>
            </div>
            <div class="form-group">
                <label class="form-label">Precio <span>*</span></label>
                <asp:TextBox ID="txt_precio" runat="server" CssClass="form-input" 
                    Text="0.00"></asp:TextBox>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">Proveedor <span>*</span></label>
            <asp:DropDownList ID="ddl_proveedor" runat="server" CssClass="form-input">
            </asp:DropDownList>
        </div>

        <div class="form-group" style="margin-top:20px; border-top:1px solid #e4daf5; padding-top:20px;">
    <label class="form-label">Subir Imagen del Producto</label>
    <div style="display:flex; gap:10px; align-items:center;">
        <asp:FileUpload ID="fu_imagen" runat="server" CssClass="form-input" />
        <asp:Button ID="btn_subir_imagen" runat="server" Text="📸 Adjuntar Foto" 
            CssClass="btn btn-secondary" OnClick="btn_subir_imagen_Click" style="white-space:nowrap;" />
    </div>
    <asp:Label ID="lbl_imagen_msg" runat="server" ForeColor="Green" Visible="false" style="font-size:12px; display:block; margin-top:5px;"></asp:Label>
</div>

        <asp:Button ID="btn_regresar" runat="server" Text="Regresar" 
            CssClass="btn-regresar" OnClick="btn_regresar_Click" />
    </div>
</asp:Content>