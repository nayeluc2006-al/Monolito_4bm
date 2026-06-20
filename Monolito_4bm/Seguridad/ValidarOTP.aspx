<%@ Page Language="C#" AutoEventWireup="true" 
    CodeBehind="ValidarOTP.aspx.cs" 
    Inherits="Monolito_4bm.Seguridad.ValidarOTP" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verificación OTP - Lotus Security</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root { --primary: #10b981; --primary-dark: #059669; }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; }
        body { min-height: 100vh; background: linear-gradient(135deg, #064e3b, #10b981);
               display: flex; align-items: center; justify-content: center; padding: 20px; }
        .card { background: white; border-radius: 20px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.2);
                max-width: 420px; width: 100%; padding: 40px; text-align: center; }
        .icon-top { width: 70px; height: 70px; border-radius: 50%;
                    background: linear-gradient(135deg, #10b981, #059669);
                    display: flex; align-items: center; justify-content: center;
                    margin: 0 auto 20px; font-size: 28px; color: white; }
        h1 { font-size: 22px; color: #1e293b; margin-bottom: 6px; }
        .sub { font-size: 13px; color: #64748b; margin-bottom: 28px; line-height: 1.6; }
        .otp-input { width: 100%; padding: 16px; text-align: center;
                     font-size: 28px; font-weight: 700; letter-spacing: 12px;
                     border: 2px solid #e2e8f0; border-radius: 12px;
                     outline: none; color: #1e293b; transition: 0.2s;
                     margin-bottom: 20px; }
        .otp-input:focus { border-color: var(--primary);
                           box-shadow: 0 0 0 3px rgba(16,185,129,0.12); }
        .btn-validar { width: 100%; padding: 14px; border: none; border-radius: 12px;
                       background: linear-gradient(135deg, var(--primary), var(--primary-dark));
                       color: white; font-size: 15px; font-weight: 700;
                       cursor: pointer; transition: 0.2s;
                       box-shadow: 0 4px 15px rgba(16,185,129,0.3); }
        .btn-validar:hover { transform: translateY(-2px);
                             box-shadow: 0 8px 20px rgba(16,185,129,0.4); }
        .hint { font-size: 11px; color: #94a3b8; margin-top: 16px; }
        .intentos { font-size: 12px; color: #ef4444; margin-top: 12px; 
                    font-weight: 600; }
    </style>
</head>
<body>
<form id="form1" runat="server">
<div class="card">

    <div class="icon-top"><i class="fas fa-mobile-alt"></i></div>
    <h1>Verificación en dos pasos</h1>
    <p class="sub">
        Abre <b>Google Authenticator</b> en tu celular e ingresa<br>
        el código de <b>6 dígitos</b> que aparece ahora.
    </p>

    <%-- Campo OTP — solo números, máximo 6 dígitos --%>
    <asp:TextBox ID="txt_otp" runat="server"
        CssClass="otp-input"
        MaxLength="6"
        placeholder="000000"
        TextMode="Number" />

    <asp:Button ID="btn_validar" runat="server"
        Text="Verificar Código"
        OnClick="btn_validar_Click"
        CssClass="btn-validar"
        CausesValidation="false" />

    <asp:Label ID="lbl_intentos" runat="server"
        CssClass="intentos" Visible="false" />

    <p class="hint">
        <i class="fas fa-sync-alt"></i> 
        El código cambia cada 30 segundos — úsalo antes de que expire
    </p>

</div>
</form>
</body>
</html>