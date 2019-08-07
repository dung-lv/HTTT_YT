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
    #region EmployeeRepository
    /// <summary>
    /// This object represents the properties and methods of a EmployeeRepository.
    /// </summary>
    public class EmployeeRepository : BaseRepository<Employee>, IEmployeeRepository
    {
        #region"Contructor"
        public EmployeeRepository()
        {
        }
        public EmployeeRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Lấy về thông tin của nhân viên theo username
        /// </summary>
        /// <param name="userName">Tên userName</param>
        /// <returns>Thông tin nhân viên</returns>
        /// Create by: dvthang:21.02.2018
        public Employee GetEmpByUserName(string userName)
        {
            return this.ExecuteReader<Employee>("Proc_GetEmpByUserName", userName).FirstOrDefault();
        }
        #endregion
        /// <summary>
        /// Check trùng mã nhân viên
        /// </summary>
        /// <param name="master"></param>
        /// <returns></returns>
        public ResultData ValidateBeforeSave(Employee master)
        {
            ResultData resultData = new ResultData();
            bool existEmployeeCode = Convert.ToBoolean(this.ExecuteScalar("Proc_CheckExitsEmployeeCode",
                master.EmployeeID, master.EmployeeCode, master.EditMode));
            bool existFullName_CompanyID = Convert.ToBoolean(this.ExecuteScalar("Proc_CheckExitsFullName_CompanyID",
                master.EmployeeID, master.FullName, master.CompanyID, master.EditMode));
            if (existEmployeeCode)
            {
                resultData.Success = false;
                resultData.ErrorMessage = "Trùng mã nhân viên";
            }
            else if (existFullName_CompanyID)
            {
                resultData.Success = false;
                resultData.ErrorMessage = "Trùng họ tên và đơn vị";
            }

            return resultData;
        }

        /// <summary>
        /// Lấy dữ liệu đưa vào combo trong ProjectTaskMember
        /// CreateBy: manh:11.03.18
        /// </summary>
        /// <param name="ProjectID"></param>
        /// <returns></returns>
        public List<Employee> GetEmployeeByMasterID(Guid? ProjectID)
        {
            return this.ExecuteReader<Employee>("[dbo].[Proc_SelectEmployeeByMasterID]", ProjectID);
        }
    }
    #endregion
}

