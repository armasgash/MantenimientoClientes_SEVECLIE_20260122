using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApplication1.Entidades
{
    public class Cliente
    {
        public int id_clie { get; set; }
        public string cedula { get; set; }
        public string nombre { get; set; }
        public string genero { get; set; }
        public string fecha_nac { get; set; } // Aca manejo como string para el HTML date mas adelante lo parseo
        public string estado_civil { get; set; }
    }
}