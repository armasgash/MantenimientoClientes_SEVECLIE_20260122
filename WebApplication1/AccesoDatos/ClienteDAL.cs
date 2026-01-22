using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebApplication1.Entidades;

namespace WebApplication1.AccesoDatos
{
    public class ClienteDAL
    {
        string connStr = ConfigurationManager.ConnectionStrings["CadenaSEVECLIE"].ConnectionString;

        public bool GuardarCliente(Cliente obj)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_MantenimientoCliente", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id_clie", obj.id_clie);
                cmd.Parameters.AddWithValue("@cedula", obj.cedula);
                cmd.Parameters.AddWithValue("@nombre", obj.nombre);
                cmd.Parameters.AddWithValue("@genero", obj.genero);
                cmd.Parameters.AddWithValue("@fecha_nac", obj.fecha_nac);
                cmd.Parameters.AddWithValue("@estado_civil", obj.estado_civil);
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public List<Cliente> ConsultarClientes(string filtro)
        {
            List<Cliente> lista = new List<Cliente>();
            using (SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["CadenaSEVECLIE"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand("sp_ConsultarClientesFiltrado", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Filtro", filtro ?? "");
                cn.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        lista.Add(new Cliente
                        {
                            id_clie = (int)dr["id_clie"],
                            cedula = dr["cedula"].ToString(),
                            nombre = dr["nombre"].ToString(),
                            genero = dr["genero"].ToString(),
                            fecha_nac = Convert.ToDateTime(dr["fecha_nac"]).ToString("yyyy-MM-dd"),
                            estado_civil = dr["estado_civil"].ToString()
                        });
                    }
                }
            }
            return lista;
        }

        public bool EliminarCliente(int id)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_EliminarCliente", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@id_clie", id);
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public Cliente ConsultarPorId(int id)
        {
            Cliente cli = null;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                // Usamos el ID para traer la fila específica
                string query = "SELECT id_clie, cedula, nombre, genero, fecha_nac, estado_civil FROM Clientes WHERE id_clie = @id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", id);
                con.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        cli = new Cliente
                        {
                            id_clie = Convert.ToInt32(dr["id_clie"]),
                            cedula = dr["cedula"].ToString(),
                            nombre = dr["nombre"].ToString(),
                            genero = dr["genero"].ToString(),
                            fecha_nac = Convert.ToDateTime(dr["fecha_nac"]).ToString("yyyy-MM-dd"),
                            estado_civil = dr["estado_civil"].ToString() // Este es el ID (1, 2, etc.)
                        };
                    }
                }
            }
            return cli;
        }
    }
}