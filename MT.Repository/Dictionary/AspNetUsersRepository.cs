using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
namespace MT.Repository
{
    #region AspNetUsersRepository
    /// <summary>
    /// This object represents the properties and methods of a AspNetRolesRepository.
    /// </summary>
    public class AspNetUsersRepository : BaseRepository<AspNetUsers>, IAspNetUsersRepository
    {
        #region"Contructor"
        public AspNetUsersRepository()
        {
        }
        public AspNetUsersRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Lấy về danh sách dữ liệu phần trang
        /// </summary>
        /// <param name="sort">Sắp xếp</param>
        /// <param name="page">Trang hiện tại</param>
        /// <param name="limit">Số bản ghi trên 1 trang</param>
        /// <param name="where">Điều kiện where</param>
        /// <param name="columns">Cột</param>
        /// <param name="arrParams">Danh sách tham số mở rộng</param>
        /// <returns>Danh sách dữ liệu</returns>
        /// Create by: dvthang:11.01.2018
        public ResultData GetAspNetUsersDataPaging(string sort, int page, int limit, string where, string columns = "*", params object[] arrParams)
        {
            ResultData oResultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            try
            {

                string storeName = string.Format(MT.Library.Commonkey.mscSelectPaging, "dbo", typeof(AspNetUsers).Name);
                oResultData = this.GetAspNetUsersDataPaging(storeName, sort, page, limit, where, columns, arrParams);

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


        /// <summary>
        /// Lấy về danh sách dữ liệu phần trang
        /// </summary>
        /// <param name="storeName">Tên store</param>
        /// <param name="sort">Sắp xếp</param>
        /// <param name="page">Trang hiện tại</param>
        /// <param name="limit">Số bản ghi trên 1 trang</param>
        /// <param name="where">Điều kiện where</param>
        /// <param name="columns">Cột</param>
        /// <param name="arrParams">Danh sách tham số mở rộng</param>
        /// <returns>Danh sách dữ liệu</returns>
        /// Create by: dvthang:11.01.2018
        public ResultData GetAspNetUsersDataPaging(string storeName, string sort, int page, int limit, string where, string columns = "*", params object[] arrParams)
        {
            ResultData oResultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            try
            {
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

                        List<AspNetUsers> lstAspNetUsers = new List<AspNetUsers>();
                        List<AspNetUsers> temp = new List<AspNetUsers>();
                        temp = rd.FillCollection<AspNetUsers>(false);
                        int num = 1;
                        if (temp != null)
                        {
                            foreach (var item in temp.OrderBy(x=>x.AspNetUsersID).ToList())
                            {
                                lstAspNetUsers.Add(new AspNetUsers
                                {
                                    Id=item.Id,
                                    AspNetUsersID=item.AspNetUsersID,
                                    CompanyName=item.CompanyName,
                                    FullName=item.FullName,
                                    UserID=item.UserID,
                                    AspNetRolesName=item.AspNetRolesName,
                                    CompanyParentName=item.CompanyParentName,
                                    UserName=item.UserName,
                                    PhoneNumber=item.PhoneNumber,
                                    Email=item.Email,
                                    Address = item.Address,
                                    GroupID = item.GroupID
                                });
                                num++;
                            }
                            oResultData.Data = lstAspNetUsers;
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
        public List<AspNetUsers> GetAspNetUsersbyPermissionInfor(int editMode)
        {
            List<AspNetUsers> GetAspNetUsersbyPermissionInfor = this.ExecuteReader<AspNetUsers>("dbo.Proc_GetAspNetUsersbyPermissionInfor", editMode);
            return GetAspNetUsersbyPermissionInfor;
        }
        public List<AspNetUsers> GetAspNetUsersbyPermissionInforTempStore(int editMode)
        {
            List<AspNetUsers> GetAspNetUsersbyPermissionInforTempStore = this.ExecuteReader<AspNetUsers>("dbo.Proc_GetAspNetUsersbyPermissionInforTempStorer", editMode);
            return GetAspNetUsersbyPermissionInforTempStore;
        }
        #endregion
        /// <summary>
        /// Check trùng mã học vị
        /// </summary>
        /// <param name="master"></param>
        /// <returns></returns>
        public ResultData ValidateBeforeSave(AspNetUsers master)
        {
            ResultData resultData = new ResultData();
            bool exist = Convert.ToBoolean(this.ExecuteScalar("Proc_CheckExitsUserName",
                master.UserName, master.Id, master.EditMode));
            if (exist)
            {
                resultData.Success = false;
                resultData.ErrorMessage = "Tài khoản đã tồn tại";
            }
            return resultData;
        }
    }
    #endregion
}

