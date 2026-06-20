        <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Monolito_4bm.Seguridad.Login" %>

    <!DOCTYPE html>
    <html lang="es">
    <head runat="server">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Acceso al Sistema - Seguridad</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@300;400;600&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
            * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Public Sans', sans-serif; }
            body {
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                background: linear-gradient(135deg, #8e2de2, #4a00e0);
            }
            .login-card {
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 25px;
                padding: 50px 40px;
                width: 400px;
                box-shadow: 0 15px 35px rgba(0,0,0,0.2);
                text-align: center;
                color: white;
            }
            .logo-circle {
                width: 80px; height: 80px;
                background: white;
                border-radius: 50%;
                margin: 0 auto 25px;
                display: flex; align-items: center; justify-content: center;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }
            .logo-circle i { font-size: 40px; color: #4a00e0; }
            h1 { font-size: 28px; margin-bottom: 10px; font-weight: 600; }
            p { font-size: 14px; margin-bottom: 30px; opacity: 0.8; }
            .input-group { margin-bottom: 20px; position: relative; text-align: left; }
            .input-group i {
                position: absolute; left: 15px; top: 40px; color: rgba(255,255,255,0.7);
            }
            .input-group label { display: block; font-size: 13px; margin-bottom: 8px; opacity: 0.9; }
            .input-group input {
                width: 100%;
                padding: 12px 15px 12px 45px;
                background: rgba(255, 255, 255, 0.15);
                border: 1px solid rgba(255, 255, 255, 0.3);
                border-radius: 12px;
                color: white; outline: none; transition: 0.3s;
            }
            .input-group input:focus { background: rgba(255, 255, 255, 0.25); border-color: white; }
            .btn-login {
                width: 100%;
                padding: 14px;
                background: white;
                color: #4a00e0;
                border: none;
                border-radius: 12px;
                font-size: 16px; font-weight: 700;
                cursor: pointer; transition: 0.3s;
                margin-top: 10px;
            }
            .btn-login:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0,0,0,0.2); }
            .links { margin-top: 25px; font-size: 13px; }
            .links a { color: white; text-decoration: none; opacity: 0.8; transition: 0.3s; }
            .links a:hover { opacity: 1; text-decoration: underline; }
        </style>
    </head>
    <body>
        <form id="form1" runat="server">
            <div class="login-card">
                <div class="logo-circle">
                    <i class="fas fa-mountain"></i>
                </div>
                <h1>Bienvenido</h1>
                <p>Ingresa tus credenciales para continuar</p>

                <div class="input-group">
                    <label>Nick o Cédula</label>
                    <i class="fas fa-id-card"></i>
                  <asp:TextBox ID="txt_ced" runat="server" placeholder="Ingresa tu nick o cédula"></asp:TextBox>                

                </div>

                <div class="input-group">
                    <label>Contraseña</label>
                    <i class="fas fa-lock"></i>
                    <asp:TextBox ID="txt_pass" runat="server" TextMode="Password" placeholder="Ingresa tu contraseña"></asp:TextBox>
                </div>

                <asp:Button ID="btn_inicio" runat="server" Text="Iniciar Sesión" CssClass="btn-login" OnClick="btn_inicio_Click1" />

                <div class="links">
                    <asp:LinkButton ID="lnk_registra" runat="server" OnClick="lnk_registra_Click">¿No tienes cuenta? Regístrate</asp:LinkButton>
                    <br /><br />
                    <a href="RecuperarClave.aspx">¿Olvidaste tu contraseña?</a>
                </div>
            </div>
        </form>
    </body>
    </html>