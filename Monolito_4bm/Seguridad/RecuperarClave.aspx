<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RecuperarClave.aspx.cs" Inherits="Monolito_4bm.Seguridad.RecuperarClave" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <title>Recuperar Contraseña</title>
    <style>
        body { background-color: #6a3de8; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background-color: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 30px; padding: 40px; width: 400px; text-align: center; color: white; backdrop-filter: blur(10px); }
        .logo-circle { background-color: white; width: 80px; height: 80px; border-radius: 50%; margin: 0 auto 20px; display: flex; justify-content: center; align-items: center; }
        .logo-mountain { width: 40px; height: 40px; background-color: #6a3de8; clip-path: polygon(50% 0%, 0% 100%, 100% 100%); position: relative; }
        h2 { font-size: 28px; margin-bottom: 10px; font-weight: bold; }
        .subtitle { font-size: 14px; opacity: 0.8; margin-bottom: 30px; }
        .input-container { background: rgba(255, 255, 255, 0.2); border: 1px solid rgba(255, 255, 255, 0.3); border-radius: 12px; margin-bottom: 20px; padding: 10px; display: flex; align-items: center; }
        .input-field { background: transparent; border: none; color: white; width: 100%; padding: 8px; outline: none; }
        .input-field::placeholder { color: rgba(255, 255, 255, 0.6); }
        .btn-recover { background-color: white; color: #6a3de8; border: none; border-radius: 12px; padding: 15px; width: 100%; font-weight: bold; cursor: pointer; font-size: 16px; transition: 0.3s; }
        .btn-recover:hover { background-color: #f0f0f0; transform: translateY(-2px); }
        .footer-link { color: white; text-decoration: none; font-size: 13px; display: block; margin-top: 20px; opacity: 0.9; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="card">
            <div class="logo-circle">
                <div style="width: 0; height: 0; border-left: 15px solid transparent; border-right: 15px solid transparent; border-bottom: 25px solid #6a3de8; position: relative;">
                    <div style="width: 0; height: 0; border-left: 8px solid transparent; border-right: 8px solid transparent; border-bottom: 12px solid white; position: absolute; top: 13px; left: -8px;"></div>
                </div>
            </div>
            
            <h2>Recuperar</h2>
            <p class="subtitle">Ingresa tu correo para generar una clave temporal</p>

            <div class="input-container">
                <asp:TextBox ID="txt_correo" runat="server" CssClass="input-field" placeholder="Correo electrónico"></asp:TextBox>
            </div>

            <asp:Button ID="btn_Generar" runat="server" Text="Generar Clave" OnClick="btn_Generar_Click" CssClass="btn-recover" />

            <asp:Label ID="lbl_mensaje" runat="server" style="display:block; margin-top:15px; font-size:13px;"></asp:Label>

            <a href="Login.aspx" class="footer-link">¿Recordaste tu contraseña? Inicia Sesión</a>
        </div>
    </form>
</body>
</html>