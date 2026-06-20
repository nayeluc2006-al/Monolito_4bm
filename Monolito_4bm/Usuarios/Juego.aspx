<%@ Page Language="C#" AutoEventWireup="true" 
    CodeBehind="Juego.aspx.cs" 
    Inherits="Monolito_4bm.Usuarios.Juego" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Adivina el Número - Lotus</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root { --primary: #10b981; --primary-dark: #059669; }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; }
        body { min-height: 100vh; background: linear-gradient(135deg, #064e3b, #10b981, #6366f1);
               display: flex; flex-direction: column; align-items: center; 
               justify-content: center; padding: 20px; }

        .navbar {
            position: fixed; top: 0; left: 0; right: 0;
            background: rgba(0,0,0,0.2); backdrop-filter: blur(10px);
            padding: 0 24px; height: 56px;
            display: flex; align-items: center; justify-content: space-between;
            color: white;
        }
        .navbar-brand { font-weight: 700; font-size: 16px; }
        .btn-logout {
            background: rgba(255,255,255,0.15); color: white;
            border: 1px solid rgba(255,255,255,0.3);
            padding: 6px 14px; border-radius: 8px; font-size: 12px;
            font-weight: 600; cursor: pointer; text-decoration: none;
            display: flex; align-items: center; gap: 6px;
        }

        .card {
            background: rgba(255,255,255,0.95); border-radius: 24px;
            padding: 40px; max-width: 440px; width: 100%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
            text-align: center; margin-top: 56px;
        }
        .game-icon { font-size: 56px; margin-bottom: 12px; 
                     animation: bounce 2s infinite; display: block; }
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }
        h1 { font-size: 24px; font-weight: 800; color: #1e293b; margin-bottom: 4px; }
        .sub { font-size: 13px; color: #64748b; margin-bottom: 28px; }

        /* Barra de progreso de intentos — solo JavaScript para animar */
        .intentos-bar { margin-bottom: 20px; }
        .intentos-label { font-size: 12px; color: #64748b; 
                          margin-bottom: 6px; text-align: left; }
        .bar-bg { background: #e2e8f0; border-radius: 20px; height: 8px; overflow: hidden; }
        .bar-fill { height: 8px; border-radius: 20px; width: 0%;
                    background: linear-gradient(90deg, #10b981, #6366f1);
                    transition: width 0.4s ease; }

        .input-group { display: flex; gap: 10px; margin-bottom: 16px; }
        .input-numero {
            flex: 1; padding: 14px; font-size: 22px; font-weight: 700;
            text-align: center; border: 2px solid #e2e8f0; border-radius: 12px;
            outline: none; color: #1e293b; transition: 0.2s;
        }
        .input-numero:focus { border-color: var(--primary);
                              box-shadow: 0 0 0 3px rgba(16,185,129,0.12); }
        .btn-probar {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white; border: none; padding: 14px 20px; border-radius: 12px;
            font-size: 15px; font-weight: 700; cursor: pointer; transition: 0.2s;
            white-space: nowrap;
        }
        .btn-probar:hover { transform: translateY(-2px);
                            box-shadow: 0 6px 16px rgba(16,185,129,0.35); }
        .btn-probar:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }

        .pista-box {
            background: #f8fafc; border: 2px solid #e2e8f0;
            border-radius: 12px; padding: 14px; margin-bottom: 16px;
            font-size: 16px; font-weight: 600; min-height: 52px;
            display: flex; align-items: center; justify-content: center;
            transition: 0.3s;
        }

        .stats-row { display: flex; gap: 10px; margin-bottom: 16px; }
        .stat-box { flex: 1; background: #f0fdf4; border-radius: 10px; padding: 12px; }
        .stat-box .num { font-size: 22px; font-weight: 800; color: var(--primary); }
        .stat-box .lbl { font-size: 11px; color: #64748b; }

        .btn-reiniciar {
            width: 100%; padding: 13px; border: none; border-radius: 12px;
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            color: white; font-size: 14px; font-weight: 700;
            cursor: pointer; transition: 0.2s; display: none;
        }
        .btn-reiniciar:hover { transform: translateY(-1px); }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <nav class="navbar">
        <div class="navbar-brand">
            <i class="fas fa-spa"></i> Lotus — Zona de Juegos
        </div>
        <asp:LinkButton ID="btn_logout" runat="server"
            CssClass="btn-logout" OnClick="btn_logout_Click">
            <i class="fas fa-sign-out-alt"></i> Salir
        </asp:LinkButton>
    </nav>

    <div class="card">
        <span class="game-icon">🎯</span>
        <h1>Adivina el Número</h1>
        <p class="sub">Tengo un número entre <b>1 y 100</b> en mente.<br>¿Puedes adivinarlo?</p>

        <%-- Stats --%>
        <div class="stats-row">
            <div class="stat-box">
                <div class="num"><asp:Label ID="lbl_intentos" runat="server" Text="0" /></div>
                <div class="lbl">Intentos</div>
            </div>
            <div class="stat-box" style="background:#eff6ff">
                <div class="num" style="color:#6366f1">1-100</div>
                <div class="lbl">Rango</div>
            </div>
        </div>

        <%-- Barra de intentos — JS solo anima, C# da el valor --%>
        <div class="intentos-bar">
            <div class="intentos-label">Progreso de intentos</div>
            <div class="bar-bg">
                <div class="bar-fill" id="barFill"></div>
            </div>
        </div>

        <%-- Pista generada en C# --%>
        <div class="pista-box">
            <asp:Label ID="lbl_pista" runat="server" Text="¡Suerte! Comienza el juego." />
        </div>

        <%-- Input + botón --%>
        <div class="input-group">
            <asp:TextBox ID="txt_numero" runat="server"
                CssClass="input-numero" TextMode="Number"
                placeholder="?" />
            <asp:Button ID="btn_probar" runat="server"
                Text="Probar" CssClass="btn-probar"
                OnClick="btn_probar_Click"
                CausesValidation="false" />
        </div>

        <%-- Botón reiniciar --%>
        <asp:Button ID="btn_reiniciar" runat="server"
            Text="🔄 Nuevo Juego" CssClass="btn-reiniciar"
            OnClick="btn_reiniciar_Click"
            CausesValidation="false" />
    </div>

</form>

<%-- JavaScript SOLO para animar la barra y efectos visuales --%>
<%-- Toda la lógica del juego está en C# (Juego.aspx.cs) --%>
<script>
    // Anima la barra de progreso según el número de intentos que C# puso en el label
    function animarBarra() {
        var intentos = parseInt(document.getElementById('<%= lbl_intentos.ClientID %>').innerText) || 0;
        var porcentaje = Math.min((intentos / 20) * 100, 100); // máx visual = 20 intentos
        document.getElementById('barFill').style.width = porcentaje + '%';
    }

    // Muestra el botón reiniciar si C# lo activó
    function sincronizarBotones() {
        var btnReiniciar = document.querySelector('.btn-reiniciar');
        var aspReiniciar = document.getElementById('<%= btn_reiniciar.ClientID %>');
        if (aspReiniciar && aspReiniciar.style.display !== 'none') {
            btnReiniciar.style.display = 'block';
        }
    }

    // Ejecutar al cargar la página
    window.onload = function () {
        animarBarra();
        sincronizarBotones();
    };
</script>

</body>
</html>