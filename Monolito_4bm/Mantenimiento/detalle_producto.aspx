<%@ Page Title="Detalle Producto" Language="C#" 
    MasterPageFile="~/Mantenimiento/Principal.Master" 
    AutoEventWireup="true" 
    CodeBehind="detalle_producto.aspx.cs" 
    Inherits="Monolito_4bm.Mantenimiento.detalle_producto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .detalle-card {
            background: white; border-radius: 18px; padding: 28px;
            box-shadow: 0 2px 12px rgba(124,92,191,0.08); margin-bottom: 20px;
        }
        .section-title {
            font-size: 13px; font-weight: 700; color: #9b8ec4;
            text-transform: uppercase; letter-spacing: 1px;
            margin-bottom: 14px; padding-bottom: 8px;
            border-bottom: 2px solid #f0eaf8;
        }
        .carousel-wrap {
            position: relative; overflow: hidden;
            border-radius: 14px; background: #f0eaf8; height: 280px;
        }
        .carousel-track {
            display: flex; transition: transform .4s ease; height: 100%;
        }
        .carousel-track img {
            min-width: 100%; width: 100%; object-fit: cover; flex-shrink: 0;
        }
        .no-img {
            width: 100%; height: 280px; display: flex;
            align-items: center; justify-content: center; font-size: 60px;
        }
        .carousel-btn {
            position: absolute; top: 50%; transform: translateY(-50%);
            background: rgba(124,92,191,0.75); color: white;
            border: none; border-radius: 50%;
            width: 38px; height: 38px; font-size: 20px;
            cursor: pointer; z-index: 10; line-height: 1;
        }
        .carousel-btn.prev { left: 10px; }
        .carousel-btn.next { right: 10px; }
        .carousel-dots { text-align: center; margin-top: 8px; }
        .carousel-dots span {
            display: inline-block; width: 8px; height: 8px;
            border-radius: 50%; background: #c4b5e8;
            margin: 0 3px; cursor: pointer;
        }
        .carousel-dots span.active { background: #7c5cbf; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .info-box { background: #faf8ff; border-radius: 10px; padding: 14px; }
        .info-label { font-size: 11px; font-weight: 700; color: #9b8ec4;
            text-transform: uppercase; letter-spacing: 1px; margin-bottom: 4px; }
        .info-val { font-size: 20px; font-weight: 700; color: #2d2250; }
        .badge-A { background:#d1fae5; color:#065f46; padding:4px 12px;
            border-radius:20px; font-size:12px; font-weight:700; }
        .badge-I { background:#fee2e2; color:#991b1b; padding:4px 12px;
            border-radius:20px; font-size:12px; font-weight:700; }
        .charts-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; }
        .chart-label { text-align:center; font-size:12px; color:#9b8ec4;
            margin-top:8px; font-weight:600; }
        .btn-outline {
            background: transparent; color: #7c5cbf;
            border: 1.5px solid #a78bda; padding: 10px 20px;
            border-radius: 10px; font-weight: 600; cursor: pointer; font-size: 13px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="cph_contenido" runat="server">

    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
        <h2 style="font-weight:800; color:#2d2250; font-size:22px;">
            <i class="fas fa-box" style="color:#7c5cbf;"></i>
            <asp:Literal ID="lit_titulo" runat="server" Text="Detalle del Producto" />
        </h2>
        <a href="listar_tbl_producto.aspx">
            <button class="btn-outline" type="button">← Volver al listado</button>
        </a>
    </div>

    <div style="display:grid; grid-template-columns:1fr 1fr; gap:20px; margin-bottom:20px;">

        <%-- CARRUSEL --%>
        <div class="detalle-card">
            <div class="section-title"><i class="fas fa-images"></i> Imágenes</div>
            <div class="carousel-wrap">
                <div class="carousel-track" id="carouselTrack">
                    <asp:Repeater ID="rpt_imagenes" runat="server">
                        <ItemTemplate>
                            <img src='<%# ObtenerUrl(Eval("img_datos"), Eval("img_tipo"), Eval("img_ruta")) %>'
                                 alt="Imagen producto" />
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <button class="carousel-btn prev" type="button" onclick="mover(-1)">&#8249;</button>
                <button class="carousel-btn next" type="button" onclick="mover(1)">&#8250;</button>
            </div>
            <div class="carousel-dots" id="carouselDots"></div>
        </div>

        <%-- INFO --%>
        <div class="detalle-card">
            <div class="section-title"><i class="fas fa-info-circle"></i> Información</div>
            <div class="info-grid">
                <div class="info-box">
                    <div class="info-label">Nombre</div>
                    <div class="info-val">
                        <asp:Literal ID="lit_nombre" runat="server" />
                    </div>
                </div>
                <div class="info-box">
                    <div class="info-label">Proveedor</div>
                    <div class="info-val">
                        <asp:Literal ID="lit_proveedor" runat="server" />
                    </div>
                </div>
                <div class="info-box">
                    <div class="info-label">Precio</div>
                    <div class="info-val" style="color:#7c5cbf;">
                        $<asp:Literal ID="lit_precio" runat="server" />
                    </div>
                </div>
                <div class="info-box">
                    <div class="info-label">Stock</div>
                    <div class="info-val">
                        <asp:Literal ID="lit_cantidad" runat="server" />
                    </div>
                </div>
                <div class="info-box" style="grid-column:span 2;">
                    <div class="info-label">Estado</div>
                    <asp:Literal ID="lit_estado" runat="server" />
                </div>
            </div>
        </div>

    </div>

    <%-- CHARTS --%>
    <div class="detalle-card">
        <div class="section-title"><i class="fas fa-chart-bar"></i> Estadísticas del catálogo</div>
        <div class="charts-grid">
            <div>
                <canvas id="chartPrecio"></canvas>
                <div class="chart-label">Top 5 — Mayor precio</div>
            </div>
            <div>
                <canvas id="chartStock"></canvas>
                <div class="chart-label">Top 5 — Mayor stock</div>
            </div>
            <div>
                <canvas id="chartProveedor"></canvas>
                <div class="chart-label">Productos por proveedor</div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hf_precio"    runat="server" />
    <asp:HiddenField ID="hf_stock"     runat="server" />
    <asp:HiddenField ID="hf_proveedor" runat="server" />

    <script>
        // ══ CARRUSEL ══════════════════════════════════════
        var idx = 0;
        var track = document.getElementById('carouselTrack');
        var dotsEl = document.getElementById('carouselDots');
        var slides = track ? Array.from(track.querySelectorAll('img')) : [];

        function initDots() {
            slides.forEach(function (_, i) {
                var d = document.createElement('span');
                if (i === 0) d.className = 'active';
                d.onclick = function () { irA(i); };
                dotsEl.appendChild(d);
            });
        }
        function mover(dir) {
            if (slides.length === 0) return;
            idx = (idx + dir + slides.length) % slides.length;
            irA(idx);
        }
        function irA(n) {
            idx = n;
            track.style.transform = 'translateX(-' + (100 * idx) + '%)';
            var ds = dotsEl.querySelectorAll('span');
            ds.forEach(function (d, i) { d.className = i === idx ? 'active' : ''; });
        }
        if (slides.length > 0) initDots();

        // ══ CHARTS ════════════════════════════════════════
        var purple = ['#7c5cbf', '#a78bda', '#c4b5e8', '#5a3d9b', '#e4d9f5'];

        function parseJSON(id) {
            try { return JSON.parse(document.getElementById(id).value); }
            catch (e) { return null; }
        }

        var dp = parseJSON('<%= hf_precio.ClientID %>');
    var ds    = parseJSON('<%= hf_stock.ClientID %>');
    var dprov = parseJSON('<%= hf_proveedor.ClientID %>');

        if (dp) new Chart(document.getElementById('chartPrecio'), {
            type: 'bar',
            data: {
                labels: dp.labels,
                datasets: [{
                    label: 'Precio $', data: dp.data,
                    backgroundColor: 'rgba(124,92,191,0.85)', borderRadius: 6
                }]
            },
            options: { plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } }
        });

        if (ds) new Chart(document.getElementById('chartStock'), {
            type: 'bar',
            data: {
                labels: ds.labels,
                datasets: [{
                    label: 'Stock', data: ds.data,
                    backgroundColor: 'rgba(167,139,218,0.7)', borderRadius: 6
                }]
            },
            options: { plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } }
        });

        if (dprov) new Chart(document.getElementById('chartProveedor'), {
            type: 'doughnut',
            data: {
                labels: dprov.labels,
                datasets: [{ data: dprov.data, backgroundColor: purple }]
            },
            options: { plugins: { legend: { position: 'bottom' } } }
        });
    </script>

</asp:Content>