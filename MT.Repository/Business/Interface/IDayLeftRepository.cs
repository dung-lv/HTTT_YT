using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    public interface IDaysLeftRepository : IBaseRepository<DaysLeft>
    {
        /// <summary>
        /// Lấy về danh sách số ngày còn để chấm công
        /// </summary>
        /// <param name="projectID">mã đề tài</param>
        /// <param name="companyID">mã đơn vị</param>
        /// <param name="employeeID">mã nhân viên</param>
        /// <param name="year">năm</param>
        /// <returns></returns>
        List<DaysLeft> GetListDaysLeft(Guid? companyID, Guid? employeeID, Guid? projectID, int year);
    }
}
