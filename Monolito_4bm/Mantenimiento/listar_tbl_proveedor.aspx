<%@ Page Title="Listado de Proveedores" Language="C#" MasterPageFile="~/Mantenimiento/Principal.Master" AutoEventWireup="true" CodeBehind="listar_tbl_proveedor.aspx.cs" Inherits="Monolito_4bm.Mantenimiento.listar_tbl_proveedor" %>

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
            color: #2d2250;
        }
        .btn-purple {
            background: linear-gradient(135deg, #7c5cbf, #a78bda);
            color: white;
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 14px;
            font-size: 14px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            text-decoration: none;
            transition: 0.2s;
        }
        .grid-card {
            background: white;
            border-radius: 18px;
            padding: 32px;
            box-shadow: 0 2px 12px rgba(124,92,191,0.08);
        }
        .table-custom {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        .alert-info-box {
            background: #f0eaf8;
            border-left: 4px solid #7c5cbf;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 13px;
            color: #2d2250;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph_contenido" runat="server">
    
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
    <h2 style="font-weight:800; color:#2d2250; font-size:22px;">
        <i class="fas fa-truck" style="color:#7c5cbf;"></i> Proveedores
    </h2>
    <a href="nuevo_tbl_proveedor.aspx"
       style="background:linear-gradient(135deg,#7c5cbf,#a78bda);color:white;
              padding:10px 20px;border-radius:10px;font-size:13px;
              font-weight:600;text-decoration:none;">
        + NUEVO PROVEEDOR
    </a>
</div>

    <div class="grid-card">
        <div class="alert-info-box">
            <i class="fas fa-list"></i> A continuación se muestran los proveedores activos en el sistema distribuidor.
        </div>

        <asp:Label ID="lblMensaje" runat="server" Visible="false" style="padding:10px; display:block; margin-bottom:15px; border-radius:8px; font-size:13px;"></asp:Label>

        <asp:GridView ID="gvProveedores" runat="server" AutoGenerateColumns="False" 
            AllowPaging="True" PageSize="5" OnPageIndexChanging="gvProveedores_PageIndexChanging" 
            OnRowCommand="gvProveedores_RowCommand" CssClass="table-custom" GridLines="None" Width="100%">
            
           <Columns>
    <%-- Columna del ID Real --%>
    <asp:BoundField DataField="prov_id" HeaderText="ID Proveedor" HeaderStyle-ForeColor="#7c5cbf">
        <ItemStyle HorizontalAlign="Center" Width="100px" />
    </asp:BoundField>
    
    <%-- Columna del Nombre Real --%>
    <asp:BoundField DataField="prov_nombre" HeaderText="Nombre de la Empresa" HeaderStyle-ForeColor="#7c5cbf">
        <ItemStyle HorizontalAlign="Left" />
    </asp:BoundField>
    
    <%-- Botones de Acción para interactuar con la Capa de Negocio --%>
    <asp:TemplateField HeaderText="Acciones Disponibles" HeaderStyle-ForeColor="#7c5cbf">
        <ItemTemplate>
            <asp:LinkButton ID="btnEditar" runat="server" CommandName="Editar" 
                CommandArgument='<%# Eval("prov_id") %>' Text="✏️ Editar" style="margin-right:15px; text-decoration:none; font-weight:600; color:#7c5cbf;" />
            
            <asp:LinkButton ID="btnEliminar" runat="server" CommandName="Eliminar" 
                CommandArgument='<%# Eval("prov_id") %>' Text="❌ Eliminar" style="color:#ef4444; text-decoration:none; font-weight:600;" 
                OnClientClick="return confirm('¿Estás seguro de que deseas dar de baja a este proveedor de forma lógica?');" />
        </ItemTemplate>
    </asp:TemplateField>
</Columns>

            
<PagerStyle HorizontalAlign="Center" BackColor="#F0EAF8" ForeColor="#7c5cbf" Font-Bold="true" Height="40px" />
        </asp:GridView>
    </div>

</asp:Content>