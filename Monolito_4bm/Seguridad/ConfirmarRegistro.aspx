    <%@ Page Language="C#" AutoEventWireup="true" 
        CodeBehind="ConfirmarRegistro.aspx.cs" 
        Inherits="Monolito_4bm.Seguridad.ConfirmarRegistro" %>
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Confirmar Registro - Lotus Security</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
            :root {
                --primary: #10b981; --primary-dark: #059669;
                --bg: #f1f5f9; --text: #1e293b;
                --muted: #64748b; --border: #e2e8f0;
            }
            * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; }
            body { min-height: 100vh; background: var(--bg);
                   display: flex; align-items: flex-start; 
                   justify-content: center; padding: 30px; }
            .card { background: white; border-radius: 20px;
                    box-shadow: 0 10px 40px rgba(0,0,0,0.1);
                    max-width: 580px; width: 100%; padding: 40px; }
            .icon-top { width: 70px; height: 70px; border-radius: 50%;
                        background: linear-gradient(135deg,#10b981,#059669);
                        display: flex; align-items: center; justify-content: center;
                        margin: 0 auto 20px; font-size: 30px; color: white; }
            h1 { font-size: 22px; color: var(--text); text-align:center; margin-bottom: 6px; }
            .sub { font-size: 13px; color: var(--muted); text-align:center;
                   margin-bottom: 28px; line-height: 1.6; }

            /* Info del usuario */
            .info-box { background: #f8fafc; border: 1.5px solid var(--border);
                        border-radius: 12px; padding: 16px; margin-bottom: 24px; }
            .info-row { display: flex; justify-content: space-between;
                        align-items: center; padding: 7px 0;
                        border-bottom: 1px solid var(--border); font-size: 13px; }
            .info-row:last-child { border-bottom: none; }
            .info-row .lbl { color: var(--muted); font-weight: 600; }
            .info-row .val { color: var(--text); font-weight: 700; }

            /* Pasos */
            .steps { background: #eff6ff; border: 1.5px solid #bfdbfe;
                     border-radius: 12px; padding: 16px; margin-bottom: 24px; }
            .steps-title { font-size: 12px; font-weight: 700; 
                           color: #1e40af; margin-bottom: 10px; }
            .step-item { display: flex; gap: 10px; margin-bottom: 8px; 
                         font-size: 12px; color: #374151; align-items: flex-start; }
            .step-num { width: 20px; height: 20px; background: #3b82f6; color: white;
                        border-radius: 50%; display: flex; align-items: center;
                        justify-content: center; font-size: 10px; 
                        font-weight: 700; flex-shrink: 0; margin-top: 1px; }

            /* QR */
            .qr-section { text-align: center; margin-bottom: 24px; }
            .qr-section .qr-hint { font-size: 12px; color: var(--muted); margin-bottom: 14px; }
            .qr-img { width: 200px; height: 200px; border: 4px solid white;
                      border-radius: 12px; box-shadow: 0 4px 16px rgba(0,0,0,0.12);
                      display: block; margin: 0 auto 16px; }
            .secreto-box { font-family: monospace; font-size: 12px; font-weight: 700;
                           color: #059669; letter-spacing: 2px; background: #d1fae5;
                           padding: 8px 14px; border-radius: 8px; 
                           display: inline-block; margin-bottom: 4px; }
            .secreto-hint { font-size: 11px; color: var(--muted); display: block; }

            /* CallMeBot */
            .callmebot-box { background: #fefce8; border: 1.5px solid #fde68a;
                             border-radius: 12px; padding: 16px; margin-bottom: 24px; }
            .callmebot-title { font-size: 12px; font-weight: 700; 
                               color: #92400e; margin-bottom: 10px; }
            .callmebot-msg { background: #fff7ed; border: 1px solid #fed7aa;
                             border-radius: 8px; padding: 8px 12px;
                             font-family: monospace; font-size: 12px;
                             color: #c2410c; margin: 8px 0; text-align: center; }
            .apikey-row { display: flex; gap: 8px; margin-top: 10px; }
            .apikey-row input { flex: 1; padding: 9px 12px; border: 1.5px solid var(--border);
                                border-radius: 8px; font-size: 13px; outline: none; }
            .apikey-row input:focus { border-color: var(--primary); }

            /* Botones */
            .btn-save-key { background: #f59e0b; color: white; border: none;
                            padding: 9px 18px; border-radius: 8px; font-weight: 700;
                            font-size: 13px; cursor: pointer; transition: 0.2s; white-space: nowrap; }
            .btn-save-key:hover { background: #d97706; }
            .btn-login { display: flex; align-items: center; justify-content: center; gap: 10px;
                         background: linear-gradient(135deg,var(--primary),var(--primary-dark));
                         color: white; text-decoration: none; padding: 14px 28px;
                         border-radius: 12px; font-weight: 700; font-size: 15px;
                         transition: 0.2s; width: 100%; border: none; cursor: pointer; }
            .btn-login:hover { transform: translateY(-1px); 
                               box-shadow: 0 6px 20px rgba(16,185,129,0.3); }
            .section-title { font-size: 11px; font-weight: 700; color: #6366f1;
                             text-transform: uppercase; letter-spacing: 1px;
                             margin-bottom: 12px; padding-bottom: 6px;
                             border-bottom: 2px solid #ede9fe;
                             display: flex; align-items: center; gap: 8px; }
        </style>
    </head>
    <body>
    <form id="form1" runat="server">
    <div class="card">

        <div class="icon-top"><i class="fas fa-check"></i></div>
        <h1>¡Registro Exitoso!</h1>
        <p class="sub">
            Guarda estos datos — los necesitarás para iniciar sesión.<br>
            <b>No cierres esta página</b> hasta haber escaneado el QR.
        </p>

        <%-- Datos del usuario --%>
        <div class="section-title"><i class="fas fa-user"></i> Tus datos de acceso</div>
        <div class="info-box">
            <div class="info-row">
                <span class="lbl"><i class="fas fa-at"></i> Usuario (Nick)</span>
                <span class="val"><asp:Label ID="lbl_nick" runat="server" /></span>
            </div>
            <div class="info-row">
                <span class="lbl"><i class="fas fa-key"></i> Clave temporal</span>
                <span class="val"><asp:Label ID="lbl_clave" runat="server" /></span>
            </div>
            <div class="info-row">
                <span class="lbl"><i class="fas fa-envelope"></i> Correo</span>
                <span class="val"><asp:Label ID="lbl_correo" runat="server" /></span>
            </div>
        </div>

        <%-- QR Google Authenticator --%>
        <div class="section-title"><i class="fas fa-shield-alt"></i> Google Authenticator</div>
        <div class="steps">
            <div class="steps-title">
                <i class="fas fa-mobile-alt"></i> Configura el doble factor ahora:
            </div>
            <div class="step-item">
                <div class="step-num">1</div>
                <span>Descarga <b>Google Authenticator</b> en tu celular desde la tienda de apps</span>
            </div>
            <div class="step-item">
                <div class="step-num">2</div>
                <span>Abre la app y toca el botón <b>"+"</b> para agregar una cuenta</span>
            </div>
            <div class="step-item">
                <div class="step-num">3</div>
                <span>Selecciona <b>"Escanear código QR"</b> y apunta al código de abajo</span>
            </div>
            <div class="step-item">
                <div class="step-num">4</div>
                <span>En cada login necesitarás el <b>código de 6 dígitos</b> que aparece en la app</span>
            </div>
        </div>

        <div class="qr-section">
            <p class="qr-hint">
                <i class="fas fa-qrcode"></i> Escanea con Google Authenticator:
            </p>
            <asp:Image ID="img_qr" runat="server" CssClass="qr-img" />
            <br />
            <p style="font-size:11px;color:#6b7280;margin-bottom:8px;">
                ¿No puedes escanear? Ingresa este código manualmente en la app:
            </p>
            <div class="secreto-box">
                <asp:Label ID="lbl_secreto" runat="server" />
            </div>
            <span class="secreto-hint">Guarda este código en un lugar seguro</span>
        </div>

        <%-- CallMeBot --%>
        <div class="section-title">
            <i class="fab fa-whatsapp"></i> Activar notificaciones por WhatsApp
        </div>
        <div class="callmebot-box">
            <div class="callmebot-title">
                <i class="fas fa-info-circle"></i> 
                Activa WhatsApp para recibir tu clave si olvidas tu contraseña
            </div>
           <div class="step-item" style="margin-bottom:6px;">
        <div class="step-num">1</div>
        <span>Toca el botón para abrir WhatsApp con el mensaje listo — solo presiona enviar:</span>
    </div>

    <asp:HyperLink ID="lnk_whatsapp_callmebot" runat="server"
        Target="_blank"
        style="display:inline-flex; align-items:center; gap:8px;
               background:#25D366; color:white; padding:10px 20px;
               border-radius:10px; font-weight:700; font-size:13px;
               text-decoration:none; margin:10px 0;">
        <i class="fab fa-whatsapp"></i> Abrir WhatsApp y activar CallMeBot
    </asp:HyperLink>

            <div class="step-item" style="margin-bottom:6px;">
                <div class="step-num">2</div>
                <span>CallMeBot te responderá con tu <b>API Key</b> personal (ej: 1234567)</span>
            </div>
            <div class="step-item" style="margin-bottom:10px;">
                <div class="step-num">3</div>
                <span>Ingresa esa API Key aquí y guárdala:</span>
            </div>
            <div class="apikey-row">
                <asp:TextBox ID="txt_apikey" runat="server" 
                    placeholder="Ej: 1234567" MaxLength="20" />
                <asp:Button ID="btn_guardar_apikey" runat="server" 
                    Text="Guardar" CssClass="btn-save-key"
                    CausesValidation="false"
                    OnClick="btn_guardar_apikey_Click" />
            </div>
            <asp:Label ID="lbl_apikey_estado" runat="server" 
                style="font-size:12px; margin-top:8px; display:block;" />
        </div>

        <%-- Ir al Login --%>
          <asp:Button ID="btn_ir_login" runat="server"
        Text="Ir al Login"
        OnClick="btn_ir_login_Click"
        CssClass="btn-login"
        CausesValidation="false" />
 

    </div>
    </form>
    </body>
    </html>