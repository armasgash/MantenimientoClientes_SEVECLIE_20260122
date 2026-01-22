using System;
using System.Text;
using WebApplication1.AccesoDatos;

namespace WebApplication1.Paginas
{
    public partial class Impresion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Recuperamos el filtro que viene de la pantalla principal
            string filtro = Request.QueryString["f"] ?? "";
            CargarDatos(filtro);
        }

        private void CargarDatos(string filtro)
        {
            ClienteDAL dal = new ClienteDAL();
            var lista = dal.ConsultarClientes(filtro);

            StringBuilder sb = new StringBuilder();
            foreach (var cli in lista)
            {
                sb.Append("<tr>");
                sb.Append($"<td>{cli.cedula}</td>");
                sb.Append($"<td>{cli.nombre}</td>");
                sb.Append($"<td>{(cli.genero == "M" ? "Masculino" : "Femenino")}</td>");
                sb.Append($"<td>{cli.estado_civil}</td>");
                sb.Append($"<td>{cli.fecha_nac}</td>");
                sb.Append("</tr>");
            }
            tablaReporte.InnerHtml = sb.ToString();
        }
    }
}