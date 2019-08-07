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
    /// Bảng chấm công (kinh phí) thực hiện đề tài
    /// </summary>
    /// Create by: laipv:03.03.2018
    public class ProjectTaskMemberFinanceRepository : BaseRepository<ProjectTaskMemberFinance>, IProjectTaskMemberFinanceRepository
    {
        #region"Contructor"
        public ProjectTaskMemberFinanceRepository()
        {

        }
        public ProjectTaskMemberFinanceRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Function"
        /// <summary>
        /// Hàm lấy về danh sách chấm công tháng theo: Các tham số
        /// </summary>
        /// <param name="projectID">Mã đề tài</param>
        /// <param name="projectTaskID">Mã nội dung</param>
        /// <param name="employeeID">Mã nhân viên</param>
        /// <param name="Year">Năm</param>
        /// <param name="Month">Tháng</param>
        /// CreatedBy:laipv.03.03.2018
        public List<ProjectTaskMemberFinance> GetListProjectTaskMemberFinances(Guid? projectID, Guid? projectTaskID, Guid? employeeID, int Year, int Month)
        {
            return this.ExecuteReader<ProjectTaskMemberFinance>("[dbo].[Proc_GetListProjectTaskMemberFinances]", projectID, projectTaskID, employeeID,Year,Month);
        }
        #endregion
    }
}
