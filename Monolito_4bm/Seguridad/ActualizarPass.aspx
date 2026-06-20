<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ActualizarPass.aspx.cs" Inherits="Monolito_4bm.Seguridad.ActualizarPass" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <title>Nueva Contraseña - Seguridad</title>

    <%-- ✅ AGREGADO: SweetAlert2 para reemplazar el alert() nativo --%>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body { background-color: #6a3de8; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background-color: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 30px; padding: 40px; width: 400px; text-align: center; color: white; backdrop-filter: blur(10px); }
        .logo-circle { background-color: white; width: 80px; height: 80px; border-radius: 50%; margin: 0 auto 20px; display: flex; justify-content: center; align-items: center; }
        h2 { font-size: 24px; margin-bottom: 5px; font-weight: bold; }
        .subtitle { font-size: 13px; opacity: 0.8; margin-bottom: 25px; }
        .input-container { background: rgba(255, 255, 255, 0.2); border: 1px solid rgba(255, 255, 255, 0.3); border-radius: 12px; margin-bottom: 15px; padding: 10px; text-align: left; }
        .input-field { background: transparent; border: none; color: white; width: 90%; padding: 8px; outline: none; }
        .input-field::placeholder { color: rgba(255, 255, 255, 0.6); }
        .btn-save { background-color: white; color: #6a3de8; border: none; border-radius: 12px; padding: 15px; width: 100%; font-weight: bold; cursor: pointer; font-size: 16px; transition: 0.3s; margin-top: 10px; }
        .btn-save:hover { background-color: #f0f0f0; transform: translateY(-2px); }
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

            <h2>Nueva Contraseña</h2>
            <p class="subtitle">Crea una clave segura para tu cuenta</p>

            <div class="input-container">
                <asp:TextBox ID="txt_pass1" runat="server" CssClass="input-field" TextMode="Password" placeholder="Nueva contraseña"></asp:TextBox>
            </div>

            <div class="input-container">
                <asp:TextBox ID="txt_pass2" runat="server" CssClass="input-field" TextMode="Password" placeholder="Confirmar contraseña"></asp:TextBox>
            </div>

            <asp:Button ID="btn_Actualizar" runat="server" Text="Guardar Cambios" OnClick="btn_Actualizar_Click" CssClass="btn-save" />

            <asp:Label ID="lbl_error" runat="server" style="display:block; margin-top:15px; color:#ffb3b3; font-size:12px;"></asp:Label>
        </div>
    </form>
</body>
</html>
