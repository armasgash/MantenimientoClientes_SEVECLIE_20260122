using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication1.AccesoDatos;
using WebApplication1.Entidades;

namespace WebApplication1.Paginas
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //ACA QUE VERIFIQUE LA COOKIE
            if (Request.Cookies["SesionUsuario"] == null)
            {
                // Si no hay cookie, redirigir al login
                Response.Redirect("Login.aspx");
            }
        }

        //Aca traemos los estados civiles
        [System.Web.Services.WebMethod]
        public static List<EstadoCivilCls> GetEstadosCiviles()
        {
            AccesoDatos.GeneralDAL dal = new AccesoDatos.GeneralDAL();
            return dal.ListarEstadosCiviles();
        }

        //Aca traemos los clientes
        [System.Web.Services.WebMethod]
        public static List<Cliente> GetClientes(string filtro)
        {
            // Usamos la capa de datos (DAL) que creamos antes
            ClienteDAL dal = new ClienteDAL();
            return dal.ConsultarClientes(filtro);
        }

        //Aca guardamos los clientes
        [System.Web.Services.WebMethod]
        public static bool GuardarCliente(Cliente entidad)
        {
            ClienteDAL dal = new ClienteDAL();
            return dal.GuardarCliente(entidad);
        }

        //Aca obtenemos el cliente por id
        [System.Web.Services.WebMethod]
        public static Cliente ObtenerClientePorId(int id)
        {
            ClienteDAL dal = new ClienteDAL();
            return dal.ConsultarPorId(id);
        }

        //Aca eliminamos el cliente
        [System.Web.Services.WebMethod]
        public static bool EliminarCliente(int id)
        {
            return new ClienteDAL().EliminarCliente(id);
        }
    }
}