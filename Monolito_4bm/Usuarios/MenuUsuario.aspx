<%@ Page Language="C#" MasterPageFile="~/Mantenimiento/Principal.Master" AutoEventWireup="true" CodeBehind="MenuUsuario.aspx.cs" Inherits="Monolito_4bm.Usuarios.MenuUsuario" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Reutiliza el mismo CSS de forma rápida y eficiente -->
    <link href="../Content/custom-layouts.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph_contenido" runat="server">
    <div class="welcome-card">
        <asp:Image ID="img_foto" runat="server" CssClass="welcome-foto" Visible="false" />
        <asp:Panel ID="pnl_icon" runat="server" CssClass="welcome-icon">
            <i class="fas fa-user"></i>
        </asp:Panel>
        <div class="welcome-info">
            <h2><asp:Label ID="lbl_nombre" runat="server" /></h2>
            <p><i class="fas fa-at"></i> <asp:Label ID="lbl_nick2" runat="server" /></p>
            <small><i class="fas fa-envelope"></i> <asp:Label ID="lbl_correo" runat="server" /></small>
        </div>
    </div>

    <div class="cards-grid">
        <asp:LinkButton ID="btn_juego" runat="server" CssClass="card" OnClick="btn_juego_Click">
            <div class="card-icon green"><i class="fas fa-gamepad"></i></div>
            <div class="card-title">Zona de Juegos</div>
            <div class="card-sub">Adivina el número secreto entre 1 y 100</div>
            <div class="card-arrow">Jugar ahora →</div>
        </asp:LinkButton>

        <div class="card">
            <div class="card-icon purple"><i class="fas fa-user-circle"></i></div>
            <div class="card-title">Mi Perfil</div>
            <div class="card-sub">Consulta tus datos registrados en el sistema</div>
            <div class="card-arrow">Ver perfil →</div>
        </div>

        <div class="card">
            <div class="card-icon purple"><i class="fas fa-shield-alt"></i></div>
            <div class="card-title">Seguridad</div>
            <div class="card-sub">Google Authenticator y configuración de acceso</div>
            <div class="card-arrow">Ver →</div>
        </div>

        <div class="card">
            <div class="card-icon green"><i class="fas fa-clock"></i></div>
            <div class="card-title">Último acceso</div>
            <div class="card-sub">
                <asp:Label ID="lbl_ultimo_acceso" runat="server" />
            </div>
            <div class="card-arrow"> </div>
        </div>
    </div>
</asp:Content>