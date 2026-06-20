<%@ Page Language="C#" MasterPageFile="~/Mantenimiento/Principal.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Monolito_4bm.Admin.Dashboard" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <!-- Vinculación limpia al CSS externo sin ensuciar la página -->
    <link href="../Content/custom-layouts.css" rel="stylesheet" type="text/css" />
</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="cph_contenido" runat="server">
    <div class="welcome-card">
        <asp:Image ID="img_foto" runat="server" CssClass="welcome-foto" Visible="false" />
        <asp:Panel ID="pnl_icon" runat="server" CssClass="welcome-icon">
            <i class="fas fa-user-shield"></i>
        </asp:Panel>
        <div class="welcome-info">
            <h2><asp:Label ID="lbl_nombre_full" runat="server" /></h2>
            <p><i class="fas fa-shield-alt"></i> Panel de administración del sistema Lotus</p>
        </div>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon purple"><i class="fas fa-users"></i></div>
            <div>
                <div class="stat-num"><asp:Label ID="lbl_total" runat="server" Text="0"/></div>
                <div class="stat-lbl">Total usuarios</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon red"><i class="fas fa-user-lock"></i></div>
            <div>
                <div class="stat-num"><asp:Label ID="lbl_bloqueados" runat="server" Text="0"/></div>
                <div class="stat-lbl">Bloqueados</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green"><i class="fas fa-user-check"></i></div>
            <div>
                <div class="stat-num"><asp:Label ID="lbl_activos" runat="server" Text="0"/></div>
                <div class="stat-lbl">Activos</div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <div class="card-title">
                <i class="fas fa-user-lock" style="color:#ef4444"></i>
                Usuarios Bloqueados
            </div>
            <asp:Button ID="btn_refresh" runat="server" Text="↻ Actualizar"
                CssClass="btn-refresh" CausesValidation="false" OnClick="btn_refresh_Click" />
        </div>

        <asp:Repeater ID="rpt_bloqueados" runat="server" OnItemCommand="rpt_bloqueados_ItemCommand">
            <HeaderTemplate>
                <table>
                    <tr>
                        <th>Cédula</th><th>Nombre</th><th>Nick</th>
                        <th>Intentos</th><th>Último intento</th>
                        <th>Estado</th><th>Acción</th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%# Eval("usu_cedula") %></td>
                    <td><%# Eval("usu_nombres") %> <%# Eval("usu_apellidos") %></td>
                    <td><%# Eval("usu_nick") %></td>
                    <td><b style="color:#ef4444"><%# Eval("usu_intentos") %></b></td>
                    <td><%# Eval("usu_fecha_ultimo_intento") != null ?
                        ((DateTime)Eval("usu_fecha_ultimo_intento")).ToString("dd/MM/yyyy HH:mm") : "—" %></td>
                    <td><span class="badge-bloq">Bloqueado</span></td>
                    <td>
                        <asp:Button runat="server" Text="✓ Desbloquear"
                            CssClass="btn-desbloquear" CommandName="Desbloquear"
                            CommandArgument='<%# Eval("usu_id") %>' CausesValidation="false" />
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate></table></FooterTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnl_sin_bloqueados" runat="server" Visible="false">
            <div class="no-data">
                <i class="fas fa-shield-check"></i>
                ¡Todo en orden! No hay usuarios bloqueados.
            </div>
        </asp:Panel>
    </div>
</asp:Content>