using System;
using System.Web;
using System.Web.Services;

namespace WebApplication1.Paginas
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Aca Verificamos si existe la cookie que creamos al loguearnos
            if (Request.Cookies["SesionUsuario"] != null)
            {
                Response.Redirect("Default.aspx");
            }
        }

        [WebMethod(EnableSession = true)] // Aca agrego EnableSession por si acaso
        public static string ValidarUsuario(string usuario, string clave)
        {
            if (usuario == "admin" && clave == "1234")
            {
                //Aca se crea la cookie y configuramos su tiempo de expiracion
                HttpCookie cookie = new HttpCookie("SesionUsuario", usuario);
                cookie.Expires = DateTime.Now.AddHours(2);
                HttpContext.Current.Response.Cookies.Add(cookie);
                return "OK";
            }
            return "FAIL";
        }
    }
}