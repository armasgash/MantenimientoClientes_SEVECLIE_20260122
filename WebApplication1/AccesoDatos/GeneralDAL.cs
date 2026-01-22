using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using WebApplication1.Entidades;

namespace WebApplication1.AccesoDatos
{
    public class GeneralDAL
    {
        public List<EstadoCivilCls> ListarEstadosCiviles()
        {
            List<EstadoCivilCls> lista = new List<EstadoCivilCls>();
            using (SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["CadenaSEVECLIE"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand("sp_ConsultarEstadosCiviles", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        lista.Add(new EstadoCivilCls
                        {
                            id_estado = (int)dr["id_estado"],
                            descripcion = dr["descripcion"].ToString()
                        });
                    }
                }
            }
            return lista;
        }
    }
}