<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Impresion.aspx.cs" Inherits="WebApplication1.Paginas.Impresion" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Reporte de Clientes - SEVECLIE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        @media print {
            .no-print { display: none; }
            body { background-color: white !important; }
        }
        .header-report { border-bottom: 2px solid #000; margin-bottom: 20px; padding-bottom: 10px; }
    </style>
</head>
<body class="bg-white">
    <div class="container mt-5">
        <div class="no-print mb-4">
            <button onclick="window.print();" class="btn btn-primary">Imprimir ahora</button>
            <button onclick="window.close();" class="btn btn-secondary">Cerrar</button>
        </div>

        <div class="header-report text-center">
            <h1>SISTEMA SEVECLIE</h1>
            <h3>Reporte General de Clientes</h3>
            <p>Fecha de generación: <%= DateTime.Now.ToString("dd/MM/yyyy HH:mm") %></p>
        </div>

        <table class="table table-bordered">
            <thead class="table-light">
                <tr>
                    <th>Cédula</th>
                    <th>Nombre Completo</th>
                    <th>Género</th>
                    <th>Estado Civil</th>
                    <th>Fecha Nac.</th>
                </tr>
            </thead>
            <tbody id="tablaReporte" runat="server">
                </tbody>
        </table>
    </div>
</body>
</html>