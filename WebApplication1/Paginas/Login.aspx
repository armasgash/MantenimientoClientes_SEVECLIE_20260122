<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApplication1.Paginas.Login" %>

<head runat="server">
    <title>Login - SEVECLIE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; }
        .login-container { margin-top: 10%; }
        .card { border: none; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        .card-header { background: #007bff; color: white; border-radius: 15px 15px 0 0 !important; text-align: center; font-weight: bold; }
    </style>
</head>

<body class="bg-light">
    <div class="container login-container">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header py-3">
                        <h4>Control de Acceso</h4>
                    </div>
                    <div class="card-body p-4">
                        <div class="mb-3">
                            <label class="form-label">Usuario</label>
                            <input type="text" id="txtUser" class="form-control" title="Ingrese su nombre de usuario asignado" placeholder="Ej: admin" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Contraseña</label>
                            <input type="password" id="txtPass" class="form-control" title="Ingrese su clave de seguridad" placeholder="••••••••" />
                        </div>
                        <button type="button" id="btnLogin" class="btn btn-primary w-100 py-2">Ingresar al Sistema</button>
                    </div>
                </div>
                <p class="text-center mt-3 text-muted">&copy; 2026 Sistema SEVECLIE</p>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>

</body>

<style>
    /* Estilo para el Requisito 8 (Tooltips) */
    .ui-helper-hidden-accessible {
    display: none !important;
    visibility: hidden !important;
}

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
    border: 1px solid #555;
    display: none;                  /* Evita parpadeos al cargar */
    position: absolute !important;  /* Esto asegura que no flote al final del documento */
}
</style>


    <script>
        $(document).ready(function () {
            // Requisito 8: Limpieza total de tooltips nativos
            $(document).tooltip({
                items: "[title]",
                position: {
                    my: "left top+10",
                    at: "left bottom",
                    collision: "flipfit"
                },
                show: { effect: "fadeIn", duration: 200 },
                hide: { effect: "fadeOut", duration: 200 },
                open: function (event, ui) {
                    // Guardamos el título y lo borramos del elemento original para que el navegador no lo pinte en la orilla.
                    var title = $(this).attr("title");
                    $(this).data("temp-title", title).removeAttr("title");
                },
                close: function (event, ui) {
                    // Cuando el mouse sale, le devolvemos su título
                    var title = $(this).data("temp-title");
                    $(this).attr("title", title);
                }
            });

            $("#btnLogin").click(function () {
                // Aca lee los datos y los manda al servidor
                var user = $("#txtUser").val();
                var pass = $("#txtPass").val();

                if (user === "" || pass === "") {
                    alert("Por favor, llene todos los campos");
                    return;
                }

                $.ajax({
                    type: "POST",
                    url: "Login.aspx/ValidarUsuario",                       // Volvamos a poner el .aspx ya que no tienes FriendlyUrls
                    data: JSON.stringify({ usuario: user, clave: pass }),   // 'usuario' y 'clave' deben ser iguales en el .cs
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "OK") {
                            window.location.href = "Default.aspx";
                        } else {
                            alert("Credenciales incorrectas");
                        }
                    },
                    error: function (xhr) {
                        // Esto es vital: si falla lo indica para que el usuario sepa que hubo un error crítico
                        var err = JSON.parse(xhr.responseText);
                        alert("Error crítico: " + err.Message);
                    }
                });
            });
        });
    </script>