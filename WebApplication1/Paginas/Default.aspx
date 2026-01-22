<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication1.Paginas.Default" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <title>Mantenimiento de Clientes</title>
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <div class="container mt-5">

        <%--Aca esta es la barra de navegación--%>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
            <div class="container-fluid">
                <a class="navbar-brand d-flex align-items-center" href="#">
                    <i class="bi bi-person-badge me-2"></i> SEVECLIE
                </a>

                <div class="d-flex align-items-center">
                    <span class="navbar-text me-3 text-white d-none d-sm-inline">
                        Usuario: <strong><%= Request.Cookies["SesionUsuario"]?.Value %></strong>
                    </span>
                    <button type="button" id="btnLogout" class="btn btn-outline-danger">
                         Cerrar Sesión
                    </button>
                </div>
            </div>
        </nav>

        <h2 class="mb-4">Registro de Clientes</h2>

        <div class="card card-body mb-4">
            <div class="row g-3">
                <div class="col-md-4">
                    <label>Cédula:</label>
                    <input type="text" id="txtCedula" class="form-control" title="Ingrese la identificación oficial" />
                </div>
                <div class="col-md-8">
                    <label>Nombre Completo:</label>
                    <input type="text" id="txtNombre" class="form-control" title="Nombre y apellidos" />
                </div>
                <div class="col-md-4">
                    <label>Género:</label>
                    <select id="ddlGenero" class="form-control">
                        <option value="M">Masculino</option>
                        <option value="F">Femenino</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label>Fecha Nacimiento:</label>
                    <input type="text" id="txtFechaNac" class="form-control" title="Seleccione su fecha en el calendario" />
                </div>
                <div class="col-md-4">
                    <label>Estado Civil:</label>
                    <select id="ddlEstadoCivil" class="form-control" title="Seleccione su estado civil actual"></select>
                </div>
            </div>
            <div class="mt-3">
                <button type="button" id="btnGuardar" class="btn btn-primary">Guardar Registro</button>
                <button type="button" class="btn btn-outline-dark" onclick="abrirReporte()">Generar Reporte</button>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <input type="text" id="txtFiltro" class="form-control" placeholder="Filtrar por nombre o identificación..." />
            </div>
        </div>

        <table class="table table-hover bg-white" id="tablaClientes">
            <thead class="table-dark">
                <tr>
                    <th>Cédula</th>
                    <th>Nombre</th>
                    <th>Género</th>
                    <th>Estado Civil</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                </tbody>
        </table>
    </div>

    <style>
    body { font-family: 'Segoe UI', sans-serif; }
    /* Estilo igual al Login para Requisito 8 */
    .ui-tooltip {
        padding: 8px;
        position: absolute;
        z-index: 9999;
        max-width: 300px;
        background: #333;
        color: white;
        border-radius: 5px;
        font-size: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        border: none;
    }
    .ui-helper-hidden-accessible { display: none !important; }

    .logout-container {
        position: fixed;
        bottom: 20px;
        left: 20px;
        z-index: 1000;
    }
    #btnLogout {
        padding: 10px 20px;
    }
</style>

    <script>
        $(document).ready(function () {
            // Requisito 2: Calendario jQuery UI
            $("#txtFechaNac").datepicker({ dateFormat: 'yy-mm-dd' });

            // Requisito 8: Activar Tooltips de jQuery UI
            $(document).tooltip();

        });

        // Requisito 8: Tooltips iguales al Login (Sin duplicados)
        $(document).tooltip({
            items: "[title]",
            position: { my: "left top+10", at: "left bottom", collision: "flipfit" },
            open: function (event, ui) {
                var title = $(this).attr("title");
                $(this).data("temp-title", title).removeAttr("title");
            },
            close: function (event, ui) {
                var title = $(this).data("temp-title");
                $(this).attr("title", title);
            }
        });

        // Cierra cualquier tooltip abierto al hacer clic en cualquier parte o perder foco
        $("input").on("blur", function () {
            $(".ui-tooltip").remove();
        });

        // Requisito 4: ACA Cargar Combo de Estado Civil desde el servidor
        function cargarComboEstadoCivil() {
            $.ajax({
                type: "POST",
                url: "Default.aspx/GetEstadosCiviles",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var ddl = $("#ddlEstadoCivil");
                    ddl.empty();
                    $.each(response.d, function (index, item) {
                        ddl.append($('<option>', {
                            value: item.id_estado,
                            text: item.descripcion
                        }));
                    });
                }
            });
        }

        // Abrimos la nueva página enviando el filtro por la URL
        function abrirReporte() {
            var filtro = $("#txtFiltro").val();
            window.open("Impresion.aspx?f=" + encodeURIComponent(filtro), "_blank");
        }

        // Para borrar una cookie, simplemente le pedimos al servidor que la expire en el pasado.
        $("#btnLogout").click(function () {
            document.cookie = "SesionUsuario=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
            window.location.href = "Login.aspx";
        });

        // EVENTO GUARDAR (Requisito 10)
        $("#btnGuardar").click(function () {
            // Si no hay ID guardado, usamos 0 (Indica nuevo registro)
            var idActual = $(this).data("id_clie") || 0;

            var cliente = {
                id_clie: idActual,
                cedula: $("#txtCedula").val(),
                nombre: $("#txtNombre").val(),
                genero: $("#ddlGenero").val(),
                fecha_nac: $("#txtFechaNac").val(),
                estado_civil: $("#ddlEstadoCivil").val()
            };

            if (cliente.cedula === "" || cliente.nombre === "") {
                alert("Cédula y Nombre son obligatorios");
                return;
            }

            $.ajax({
                type: "POST",
                url: "Default.aspx/GuardarCliente",
                data: JSON.stringify({ entidad: cliente }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d) {
                        alert("Operación realizada con éxito");
                        // Resetear el formulario y el botón
                        $("#txtCedula, #txtNombre, #txtFechaNac").val("");
                        $("#btnGuardar").text("Guardar Registro")
                            .removeClass("btn-success")
                            .addClass("btn-primary")
                            .data("id_clie", 0);

                        cargarTablaClientes(""); // Refrescar tabla
                    }
                }
            });
        });

        //Aca van las funciones editar y eliminar
        function editar(id) {
            $.ajax({
                type: "POST",
                url: "Default.aspx/ObtenerClientePorId",
                data: JSON.stringify({ id: id }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var cli = response.d;
                    if (cli) {
                        $("#txtCedula").val(cli.cedula);
                        $("#txtNombre").val(cli.nombre);
                        $("#ddlGenero").val(cli.genero);
                        $("#txtFechaNac").val(cli.fecha_nac);
                        $("#ddlEstadoCivil").val(cli.estado_civil);

                        // Si aun así no cambia, fuerza el evento change
                        $("#ddlEstadoCivil").trigger("change");

                        $("#btnGuardar").data("id_clie", cli.id_clie);
                        $("#btnGuardar").text("Actualizar Registro").addClass("btn-success");
                    }
                }
            });
        }

        // Requisito 6: Eliminar con confirmación
        function eliminar(id) {
            if (confirm("¿Está seguro de que desea eliminar este registro? Esta acción no se puede deshacer.")) {
                $.ajax({
                    type: "POST",
                    url: "Default.aspx/EliminarCliente",
                    data: JSON.stringify({ id: id }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d) {
                            alert("Registro eliminado correctamente");
                            cargarTablaClientes($("#txtFiltro").val()); // Refrescamos la tabla
                        } else {
                            alert("No se pudo eliminar el registro. Verifique si tiene dependencias.");
                        }
                    },
                    error: function (xhr) {
                        alert("Error en el servidor al intentar eliminar.");
                    }
                });
            }
        }

        function limpiarFormulario() {
            $("#txtCedula").val("");
            $("#txtNombre").val("");
            $("#txtFechaNac").val("");
            $("#ddlGenero").val("M");
        }

        // Llamada inicial de todo al cargar la página
        $(document).ready(function () {
            cargarTablaClientes("");
            cargarComboEstadoCivil();
        });

        function cargarTablaClientes(filtroTexto) {
            $.ajax({
                type: "POST",
                url: "Default.aspx/GetClientes",
                data: JSON.stringify({ filtro: filtroTexto }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var tabla = $("#tablaClientes tbody");
                    tabla.empty();
                    $.each(response.d, function (i, cli) {
                        // Traducción de Género
                        var generoTexto = (cli.genero === "M") ? "Masculino" : "Femenino";
                        var fila = `<tr>
                    <td>${cli.cedula}</td>
                    <td>${cli.nombre}</td>
                    <td>${generoTexto}</td>
                    <td>${cli.estado_civil}</td> 
                    <td>
                        <button class='btn btn-sm btn btn-success' onclick='editar(${cli.id_clie})'>Editar</button>
                        <button class='btn btn-sm btn-danger' onclick='eliminar(${cli.id_clie})'>Eliminar</button>
                    </td>
                </tr>`;
                        tabla.append(fila);
                    });
                }
            });
        }

        // Requisito 3: Filtrar mientras se escribe
        $("#txtFiltro").on("keyup", function () {
            var valor = $(this).val();
            cargarTablaClientes(valor);
        });

    </script>
</body>
</html>