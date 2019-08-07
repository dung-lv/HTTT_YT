using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region MedicalRecordRepository
    /// <summary>
    /// This object represents the properties and methods of a MedicalRecordRepository.
    /// </summary>
    public class MedicalRecordRepository : BaseRepository<MedicalRecord>, IMedicalRecordRepository
    {
        #region"Contructor"
        public MedicalRecordRepository()
        {
        }
        public MedicalRecordRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"
        public ResultData GetDataPaging(string sort, int page, int limit, string where, string columns = "*", params object[] arrParams)
        {
            ResultData oResultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            try
            {
                where = where.Replace("CustomerID", "cus.CustomerID");
                string storeName = string.Format(MT.Library.Commonkey.mscSelectPaging, "dbo", typeof(MedicalRecord).Name);
                oResultData = this.GetDataPaging(storeName, sort, page, limit, where, columns, arrParams);
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                oResultData.SetError(ex);
                throw ex;
            }
            catch (Exception ex)
            {
                oResultData.SetError(ex);
                throw ex;
            }
            return oResultData;
        }

        public ResultData GetDataPaging(string storeName, string sort, int page, int limit, string where, string columns = "*", params object[] arrParams)
        {
            ResultData oResultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            try
            {
                where = where.Replace("CustomerID", "cus.CustomerID");
                DbParameter pOutput = null;
                using (DbCommand command = this.DB.GetStoredProcCommand(storeName))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    this.DB.DiscoverParameters(command);
                    if (command.Parameters.Count > 0)
                    {
                        command.Parameters.RemoveAt(0);
                        int paramIndex = 0;

                        for (int i = 0; i <= command.Parameters.Count - 1; i++)
                        {
                            DbParameter dbParam = command.Parameters[i];
                            string paramName = dbParam.ParameterName.Replace("@", "").ToLower();

                            switch (paramName)
                            {
                                case "sort":
                                    if (!string.IsNullOrEmpty(sort))
                                    {
                                        dbParam.Value = sort;
                                    }
                                    else
                                    {
                                        dbParam.Value = DBNull.Value;
                                    }
                                    break;
                                case "page":
                                    dbParam.Value = page;
                                    break;
                                case "limit":
                                    dbParam.Value = limit;
                                    break;
                                case "where":
                                    dbParam.Value = where;
                                    break;
                                case "columns":
                                    if (!string.IsNullOrEmpty(columns))
                                    {
                                        dbParam.Value = columns;
                                    }
                                    else
                                    {
                                        dbParam.Value = "*";
                                    }
                                    break;
                                case "totalcount":
                                    pOutput = command.Parameters[i];
                                    pOutput.Value = 0;
                                    break;
                                default:
                                    if (arrParams != null)
                                    {
                                        if (arrParams[paramIndex] != null)
                                        {
                                            dbParam.Value = arrParams[paramIndex];
                                        }
                                        else
                                        {
                                            dbParam.Value = DBNull.Value;
                                        }
                                        paramIndex++;
                                    }
                                    break;
                            }

                        }
                    }

                    using (IDataReader rd = this.DB.ExecuteReader(command))
                    {
                        oResultData.Data = rd.FillCollection<MedicalRecord>(false);
                        if (rd.NextResult())
                        {
                            Dictionary<string, object> dicSummary = new Dictionary<string, object>();
                            while (rd.Read())
                            {
                                for (int i = 0; i < rd.FieldCount; i++)
                                {
                                    dicSummary.Add(rd.GetName(i), rd[i]);
                                }
                            }
                            oResultData.SummaryData = dicSummary;
                        };
                    }
                    if (pOutput != null)
                    {
                        oResultData.Total = pOutput.Value as int? ?? default(int);
                    }
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                oResultData.SetError(ex);
                throw ex;
            }
            catch (Exception ex)
            {
                oResultData.SetError(ex);
                throw ex;
            }
            return oResultData;
        }
        #endregion
    }
    #endregion
}

