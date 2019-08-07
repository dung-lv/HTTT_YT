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
    /// <summary>
    /// Lấy về danh sách số ngày còn để chấm công
    /// </summary>
    /// Create by: manh:10.06.18
    public class DaysLeftRepository : BaseRepository<DaysLeft>, IDaysLeftRepository
    {
        #region"Contructor"
        public DaysLeftRepository()
        {

        }
        public DaysLeftRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Function"
        /// <summary>
        /// Lấy về danh sách số ngày còn để chấm công
        /// </summary>
        /// <param name="projectID">mã đề tài</param>
        /// <param name="companyID">mã đơn vị</param>
        /// <param name="employeeID">mã nhân viên</param>
        /// <param name="year">năm</param>
        /// <returns></returns>
        public List<DaysLeft> GetListDaysLeft(Guid? companyID, Guid? employeeID, Guid? projectID, int year)
        {
            return this.ExecuteReader<DaysLeft>("[dbo].[Proc_GetListDaysLeftByCompanyIDAndEmployeeIDAndProjectIDAndYear]", companyID, employeeID, projectID, year);
        }
        #endregion
    }
}
