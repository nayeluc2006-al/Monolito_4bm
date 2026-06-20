<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Registrar.aspx.cs" Inherits="Monolito_4bm.Seguridad.Registrar" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - Lotus Security</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --primary: #10b981;
            --primary-dark: #059669;
            --accent: #6366f1;
            --bg: #f1f5f9;
            --text: #1e293b;
            --muted: #64748b;
            --border: #e2e8f0;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; }
        body { min-height: 100vh; display: flex; background-color: var(--bg); }

        .side-banner {
            width: 300px; min-width: 300px;
            background: linear-gradient(160deg, #064e3b 0%, #10b981 60%, #6366f1 100%);
            display: flex; flex-direction: column; align-items: center;
            justify-content: center; color: white; padding: 40px;
            text-align: center; position: sticky; top: 0; height: 100vh;
        }
        .icon-circle {
            width: 90px; height: 90px; background: rgba(255,255,255,0.15);
            border: 2px solid rgba(255,255,255,0.3); border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 20px; font-size: 40px;
        }
        .side-banner h1 { font-size: 24px; margin-bottom: 10px; }
        .side-banner p  { font-size: 13px; opacity: 0.8; line-height: 1.6; }
        .side-steps { margin-top: 28px; text-align: left; width: 100%; }
        .step { display: flex; align-items: center; gap: 12px; margin-bottom: 14px; font-size: 13px; opacity: 0.85; }
        .step-num {
            width: 26px; height: 26px; border-radius: 50%;
            background: rgba(255,255,255,0.2); display: flex;
            align-items: center; justify-content: center;
            font-size: 11px; font-weight: 700; flex-shrink: 0;
        }

        .main-content { flex: 1; padding: 40px 50px; overflow-y: auto; background: white; }
        .page-title { font-size: 24px; font-weight: 700; color: var(--text); margin-bottom: 4px; }
        .page-sub   { font-size: 13px; color: var(--muted); margin-bottom: 24px; }

        .section-title {
            font-size: 11px; font-weight: 700; color: var(--accent);
            text-transform: uppercase; letter-spacing: 1px;
            margin: 22px 0 12px; padding-bottom: 6px;
            border-bottom: 2px solid #ede9fe;
            display: flex; align-items: center; gap: 8px;
        }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .full { grid-column: span 2; }
        .field-group { display: flex; flex-direction: column; }
        .field-group label {
            font-size: 11px; font-weight: 700; color: var(--muted);
            margin-bottom: 5px; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .input-wrapper { position: relative; display: flex; align-items: center; }
        .input-wrapper i { position: absolute; left: 12px; color: var(--primary); font-size: 14px; z-index: 1; }
        .input-wrapper input,
        .input-wrapper select {
            width: 100%; padding: 11px 12px 11px 36px;
            border: 1.5px solid var(--border); border-radius: 10px;
            outline: none; transition: 0.25s; font-size: 14px; color: var(--text); background: white;
        }
        .input-wrapper input:focus,
        .input-wrapper select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(16,185,129,0.12);
        }
        /* ReadOnly solo para nick y contraseña */
        .input-wrapper input[readonly] {
            background: #f8fafc; color: var(--accent); font-weight: 600;
        }
        /* Correo: editable pero con fondo suave para indicar que fue autogenerado */
        .input-correo input {
            background: #f0fdf9 !important;
            border-color: #a7f3d0 !important;
        }
        .correo-hint {
            font-size: 11px; color: var(--primary); margin-top: 4px;
            display: flex; align-items: center; gap: 4px;
        }

        /* FOTO */
        .foto-area {
            border: 2px dashed var(--border); border-radius: 14px;
            padding: 20px; background: #fafafa; transition: 0.2s;
        }
        .foto-area:hover { border-color: var(--primary); background: #f0fdf4; }
        .foto-row { display: flex; align-items: center; gap: 20px; flex-wrap: wrap; }
        .preview-circle {
            width: 90px; height: 90px; border-radius: 50%;
            border: 3px solid var(--border); overflow: hidden;
            display: flex; align-items: center; justify-content: center;
            background: #f1f5f9; flex-shrink: 0;
        }
        .preview-circle i { font-size: 32px; color: #cbd5e1; }
        .foto-controls { flex: 1; }
        .foto-label  { font-size: 13px; font-weight: 600; color: var(--text); margin-bottom: 4px; display: block; }
        .foto-hint2  { font-size: 11px; color: var(--muted); margin-bottom: 10px; }
        .btn-preview {
            background: white; color: var(--primary);
            border: 1.5px solid var(--primary);
            padding: 8px 18px; border-radius: 8px; font-size: 12px;
            font-weight: 600; cursor: pointer; transition: 0.2s;
            display: inline-flex; align-items: center; gap: 6px;
        }
        .btn-preview:hover { background: var(--primary); color: white; }
        .file-name-label { font-size: 11px; color: var(--muted); margin-top: 8px; display: block; }

        .btn-main {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white; border: none; padding: 15px; border-radius: 12px;
            font-weight: 700; font-size: 15px; cursor: pointer; transition: 0.3s;
            width: 100%; margin-top: 24px;
            display: flex; align-items: center; justify-content: center; gap: 10px;
            box-shadow: 0 4px 15px rgba(16,185,129,0.3);
        }
        .btn-main:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(16,185,129,0.4); }

        @media (max-width: 768px) {
            body { flex-direction: column; }
            .side-banner { width: 100%; min-width: unset; height: auto; padding: 24px; position: relative; }
            .side-steps { display: none; }
            .main-content { padding: 24px 16px; }
            .form-grid { grid-template-columns: 1fr; }
            .full { grid-column: span 1; }
        }
    </style>
</head>
<body>
    <div class="side-banner">
        <div class="icon-circle"><i class="fas fa-spa"></i></div>
        <h1>Lotus System</h1>
        <p>Registro seguro con encriptación avanzada</p>
        <div class="side-steps">
            <div class="step"><div class="step-num">1</div><span>Completa tus datos personales</span></div>
            <div class="step"><div class="step-num">2</div><span>Sube tu foto de perfil</span></div>
            <div class="step"><div class="step-num">3</div><span>Guarda tu clave temporal</span></div>
            <div class="step"><div class="step-num">4</div><span>Inicia sesión y cambia tu clave</span></div>
        </div>
    </div>

    <div class="main-content">
        <form id="form1" runat="server">

            <div class="page-title">Registro de Usuario</div>
            <div class="page-sub">Completa todos los campos para crear tu cuenta.</div>

            <%-- SECCIÓN 1: DATOS PERSONALES --%>
            <div class="section-title"><i class="fas fa-user-circle"></i> Datos Personales</div>
            <div class="form-grid">

                <div class="field-group full">
                    <label>Número de Cédula</label>
                    <div class="input-wrapper">
                        <i class="fas fa-id-card"></i>
                        <asp:TextBox ID="txt_cedula" runat="server" placeholder="1728737758"></asp:TextBox>
                    </div>
                </div>

                <div class="field-group">
                    <label>Nombres</label>
                    <div class="input-wrapper">
                        <i class="fas fa-user"></i>
                        <asp:TextBox ID="txt_nombres" runat="server" placeholder="Juan Alberto"
                            AutoPostBack="true" OnTextChanged="GenerarDatosUsuario_TextChanged"></asp:TextBox>
                    </div>
                </div>

                <div class="field-group">
                    <label>Apellidos</label>
                    <div class="input-wrapper">
                        <i class="fas fa-user-tag"></i>
                        <asp:TextBox ID="txt_apellidos" runat="server" placeholder="Pérez Castro"
                            AutoPostBack="true" OnTextChanged="GenerarDatosUsuario_TextChanged"></asp:TextBox>
                    </div>
                </div>

                <div class="field-group full">
                    <label>Dirección</label>
                    <div class="input-wrapper">
                        <i class="fas fa-map-marker-alt"></i>
                        <asp:TextBox ID="txt_direccion" runat="server" placeholder="Av. Principal y Calle Secundaria"></asp:TextBox>
                    </div>
                </div>

                <div class="field-group">
                    <label>Celular (WhatsApp)</label>
                    <div class="input-wrapper">
                        <i class="fas fa-phone"></i>
                        <asp:TextBox ID="txt_celular" runat="server" placeholder="09XXXXXXXX"></asp:TextBox>
                    </div>
                </div>

                <div class="field-group">
                    <label>Fecha de Cumpleaños</label>
                    <div class="input-wrapper">
                        <i class="fas fa-calendar-day"></i>
                        <asp:TextBox ID="txt_fecha_nac" runat="server" TextMode="Date"></asp:TextBox>
                    </div>
                </div>

            </div>

            <%-- SECCIÓN 2: ACCESO AL SISTEMA --%>
            <div class="section-title"><i class="fas fa-shield-alt"></i> Acceso al Sistema</div>
            <div class="form-grid">

                <div class="field-group full">
                    <label>Correo Institucional</label>
                    <%-- ✅ NO tiene ReadOnly — se autogenera pero el usuario puede editarlo --%>
                    <div class="input-wrapper input-correo">
                        <i class="fas fa-envelope"></i>
                        <asp:TextBox ID="txt_correo" runat="server" placeholder="se genera automáticamente"></asp:TextBox>
                    </div>
                    <span class="correo-hint">
                        <i class="fas fa-info-circle"></i>
                        Se genera automáticamente, pero puedes modificarlo si lo necesitas.
                    </span>
                </div>

                <div class="field-group">
                    <label>Nick / Usuario (Generado)</label>
                    <div class="input-wrapper">
                        <i class="fas fa-at"></i>
                        <%-- Nick sí es ReadOnly --%>
                          <asp:TextBox ID="txt_nick" runat="server" placeholder="se genera automáticamente"></asp:TextBox>
                    </div>
                </div>
                 <span class="correo-hint">
            <i class="fas fa-info-circle"></i>
             Se genera automáticamente — puedes modificarlo si lo necesitas.
             </span>
                <div class="field-group">
                    <label>Contraseña Temporal (Generada)</label>
                    <div class="input-wrapper">
                        <i class="fas fa-key"></i>
                        <%-- Contraseña también ReadOnly --%>
                        <asp:TextBox ID="txt_pass" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <div class="field-group full">
                    <label>Perfil de Acceso</label>
                    <div class="input-wrapper">
                        <i class="fas fa-user-shield"></i>
                        <asp:DropDownList ID="ddl_perfil" runat="server"></asp:DropDownList>
                    </div>
                </div>

            </div>

            <%-- SECCIÓN 3: FOTO DE PERFIL --%>
            <div class="section-title"><i class="fas fa-camera"></i> Foto de Perfil</div>

            <div class="foto-area">
                <div class="foto-row">

                    <%-- Preview circular — se llena desde C# --%>
                    <div class="preview-circle">
                        <asp:Image ID="img_previa" runat="server" Visible="false"
                            style="width:100%; height:100%; object-fit:cover;" />
                        <i class="fas fa-user-circle" runat="server" id="ico_placeholder"></i>
                    </div>

                    <div class="foto-controls">
                        <span class="foto-label">Selecciona tu foto de perfil</span>
                        <span class="foto-hint2">JPG, PNG o GIF — Máximo 5MB</span>

                        <%-- FileUpload visible --%>
                        <asp:FileUpload ID="fu_foto" runat="server" />

                        <br />
                        <%-- Botón previsualizar — postback a C#, sin JS --%>
                       <asp:Button ID="btn_previa" runat="server"
                            Text="Previsualizar"
                            OnClick="btn_cargar_Click"
                            CssClass="btn-preview"
                           CausesValidation="false"
                           UseSubmitBehavior="false"
                            style="margin-top:8px;" />
                        <%-- Nombre del archivo persiste tras postback (lo escribe C#) --%>
                        <asp:Label ID="lbl_nombre_foto" runat="server"
                            CssClass="file-name-label"
                            Text="Ningún archivo seleccionado">
                        </asp:Label>
                    </div>

                </div>
            </div>

            <asp:Button ID="btn_registrar" runat="server"
                Text="REGISTRAR USUARIO"
                OnClick="btn_registrar_Click"
                CssClass="btn-main" />

        </form>
    </div>
</body>
</html>
