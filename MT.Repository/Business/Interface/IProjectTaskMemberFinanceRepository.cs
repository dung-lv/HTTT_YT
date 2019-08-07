using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    public interface IProjectTaskMemberFinanceRepository : IBaseRepository<ProjectTaskMemberFinance>
    {
        /// <summary>
        /// Hàm lấy về danh sách chấm công tháng theo: Các tham số
        /// </summary>
        /// <param name="projectID">Mã đề tài</param>
        /// <param name="projectTaskID">Mã nội dung</param>
        /// <param name="employeeID">Mã nhân viên</param>
        /// <param name="Year">Năm</param>
        /// <param name="Month">Tháng</param>
        /// CreatedBy:laipv.03.03.2018
        List<ProjectTaskMemberFinance> GetListProjectTaskMemberFinances(Guid? projectID, Guid? projectTaskID, Guid? employeeID, int Year, int Month);
    }
}
