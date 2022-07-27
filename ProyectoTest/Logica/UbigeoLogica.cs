using ProyectoTest.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ProyectoTest.Logica
{
    public class UbigeoLogica
    {
        
        private static UbigeoLogica _instancia = null;

        public UbigeoLogica()
        {

        }

        public static UbigeoLogica Instancia
        {
            get {
                if (_instancia == null) {
                    _instancia = new UbigeoLogica();
                }
                return _instancia;
            }
        }



        public List<Departamento> ObtenerDepartamento() {
            List<Departamento> lst = new List<Departamento>();
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("select * from departamento", oConexion);
                    cmd.CommandType = CommandType.Text;
                    oConexion.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lst.Add(new Departamento()
                            {
                                IdDepartamento = dr["IdDepartamento"].ToString(),
                                Descripcion = dr["Descripcion"].ToString()
                            });
                        }
                    }

                }
                catch (Exception ex)
                {
                    lst = new List<Departamento>();
                }
            }
            return lst;
        }

        public List<Ciudad> ObtenerCiudad(string _iddepartamento)
        {
            List<Ciudad> lst = new List<Ciudad>();
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("select * from ciudad where IdDepartamento = @iddepartamento", oConexion);
                    cmd.Parameters.AddWithValue("@iddepartamento", _iddepartamento);
                    cmd.CommandType = CommandType.Text;
                    oConexion.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lst.Add(new Ciudad()
                            {
                                IdCiudad = dr["IdCiudad"].ToString(),
                                Descripcion = dr["Descripcion"].ToString(),
                                IdDepartamento = dr["IdDepartamento"].ToString()
                            });
                        }
                    }

                }
                catch (Exception ex)
                {
                    lst = new List<Ciudad>();
                }
            }
            return lst;
        }

        public List<Barrio> ObtenerBarrio(string _idciudad, string _iddepartamento)
        {
            List<Barrio> lst = new List<Barrio>();
            using (SqlConnection oConexion = new SqlConnection(Conexion.CN))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("select * from DISTRITO where IdCiudad = @idciudad and IdDepartamento = @iddepartamento", oConexion);
                    cmd.Parameters.AddWithValue("@idciudad", _idciudad);
                    cmd.Parameters.AddWithValue("@iddepartamento", _iddepartamento);
                    cmd.CommandType = CommandType.Text;
                    oConexion.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lst.Add(new Barrio()
                            {
                                IdBarrio = dr["IdBarrio"].ToString(),
                                Descripcion = dr["Descripcion"].ToString(),
                                IdCiudad = dr["IdCiudad"].ToString(),
                                IdDepartamento = dr["IdDepartamento"].ToString()
                            });
                        }
                    }

                }
                catch (Exception ex)
                {
                    lst = new List<Barrio>();
                }
            }
            return lst;
        }

    }
}