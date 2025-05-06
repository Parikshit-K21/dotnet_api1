using System;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace SPARSH_MOB.DataAccess
{
    public class DatabaseHelper : DbContext
    //(DbContextOptions<DatabaseHelper> options) : DbContext(options)
    {
        private readonly string _bwliveConnectionString;
        private readonly string _itKhariaConnectionString;
        private readonly string _imageDataConnectionString;

        public DatabaseHelper(
            string bwliveConnectionString,
            string itKhariaConnectionString,
            string imageDataConnectionString
        )
        {
            _bwliveConnectionString = bwliveConnectionString;
            _itKhariaConnectionString = itKhariaConnectionString;
            _imageDataConnectionString = imageDataConnectionString;
        }

        // General method to execute SELECT queries for any connection string
        private List<Dictionary<string, object>> ExecuteSelectQuery(
            string connectionString,
            string query,
            Dictionary<string, object> parameters
        )
        {
            var resultList = new List<Dictionary<string, object>>();
            using (var conn = new SqlConnection(connectionString))
            using (var cmd = new SqlCommand(query, conn))
            {
                foreach (var param in parameters)
                {
                    cmd.Parameters.AddWithValue(param.Key, param.Value);
                }
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var row = new Dictionary<string, object>();
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            row[reader.GetName(i)] = reader[i];
                        }
                        resultList.Add(row);
                    }
                }
            }
            return resultList;
        }

        // General method to execute INSERT, UPDATE, or DELETE queries for any
        private int ExecuteCommand(
            string connectionString,
            string query,
            Dictionary<string, object> parameters
        )
        {
            using (var conn = new SqlConnection(connectionString))
            using (var cmd = new SqlCommand(query, conn))
            {
                foreach (var param in parameters)
                {
                    cmd.Parameters.AddWithValue(param.Key, param.Value);
                }
                conn.Open();
                return cmd.ExecuteNonQuery(); // Returns the number of rows affected
            }
        }

        private int ExecuteCommandInternal(
            string connectionString,
            string query,
            Dictionary<string, object> parameters
        )
        {
            using (var conn = new SqlConnection(connectionString))
            {
                var cmd = new SqlCommand(query, conn);
                foreach (var param in parameters)
                {
                    cmd.Parameters.AddWithValue(param.Key, param.Value);
                }
                conn.Open();
                return cmd.ExecuteNonQuery();
            }
        }

        public int WebExecute(string query, Dictionary<string, object> parameters)
        {
            return ExecuteCommandInternal(_bwliveConnectionString, query, parameters);
        }

        public int KkrExecute(string query, Dictionary<string, object> parameters)
        {
            return ExecuteCommandInternal(_itKhariaConnectionString, query, parameters);
        }

        public int ImgExecute(string query, Dictionary<string, object> parameters)
        {
            return ExecuteCommandInternal(_imageDataConnectionString, query, parameters);
        }

        // Function to handle queries for bwlive database (WebSessBean)
        public List<Dictionary<string, object>> WebSessBean(
            string query,
            Dictionary<string, object> parameters
        )
        {
            return ExecuteSelectQuery(_bwliveConnectionString, query, parameters);
        }

        // Function to handle queries for itKharia database (KkrSessBean)
        public List<Dictionary<string, object>> KkrSessBean(
            string query,
            Dictionary<string, object> parameters
        )
        {
            return ExecuteSelectQuery(_itKhariaConnectionString, query, parameters);
        }

        // Function to handle queries for imageData database (ImgSessBean)
        public List<Dictionary<string, object>> ImgSessBean(
            string query,
            Dictionary<string, object> parameters
        )
        {
            return ExecuteSelectQuery(_imageDataConnectionString, query, parameters);
        }

        // Retrieve SecretKey for a given PartnerID from the RegisteredUsers table (itKharia)
        public string GetSecretKey(string userID)
        {
            var query =
                "SELECT appRegId FROM wcmUserCred WHERE loginIdM = @loginIdm and isActive = 'Y'";
            var parameters = new Dictionary<string, object>
            {
                { "@loginIdm", userID }, // Matches query
            };
            var result = KkrSessBean(query, parameters);
            if (result.Count > 0)
            {
                return result[0]["appRegId"]?.ToString();
            }
            throw new Exception("appRegId not found for the given UserID.");
        }

        // Log API requests into the comApiLogs table (itKharia)
        public void InsertIntoLog(string partnerId, string endpoint, string responseStatus)
        {
            // Check if the PartnerID exists
            var checkQuery = "SELECT COUNT(*) AS Count FROM prmApiPrtnr WHERE partnrId = @loginIdm";
            var checkParams = new Dictionary<string, object>
            {
                { "@loginIdm", partnerId }, // This now matches your query
            };
            var exists = KkrSessBean(checkQuery, checkParams);
            if (exists.Count == 0 || Convert.ToInt32(exists[0]["Count"]) == 0)
            {
                Console.WriteLine(
                    $"Warning: PartnerID '{partnerId}' does not exist in RegisteredUsers. Log insertion skipped."
                );
                return;
            }

            // Insert log into comApiLogs
            var insertQuery =
                @"INSERT INTO comApiLogs (PartnerID, Endpoint, 
ResponseStatus)
 VALUES (@loginIdm, @Endpoint, @ResponseStatus)";
            var insertParams = new Dictionary<string, object>
            {
                { "@loginIdm", partnerId }, // Must match placeholder in SQL
                { "@Endpoint", endpoint },
                { "@ResponseStatus", responseStatus },
            };
            ExecuteCommand(_itKhariaConnectionString, insertQuery, insertParams);
        }
    }
}
