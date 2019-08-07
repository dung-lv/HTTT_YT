using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region ProjectProgressReportRepository
    /// <summary>
    /// This object represents the properties and methods of a ProjectProgressReportRepository.
    /// Create by: truongnm:31.01.2018
    /// </summary>
    public class ProjectProgressReportRepository : BaseRepository<ProjectProgressReport>, IProjectProgressReportRepository
    {
        #region"Contructor"
        public ProjectProgressReportRepository()
        {
        }
        public ProjectProgressReportRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Lấy về danh sách ID file đính kèm của Báo cáo tiến độ
        /// Create By: manh:01.04.18
        /// </summary>
        /// <param name="masterID"></param>
        /// <returns></returns>
        public List<ProjectProgressReport_AttachDetail> GetListIDByMasterID(Guid? masterID)
        {
            return this.ExecuteReader<ProjectProgressReport_AttachDetail>("dbo.Proc_SelectListIDProjectProgressReport_AttachDetailByMasterID", masterID);
        }

        /// <summary>
        /// Xóa file đính kèm
        /// Create By: manh:01.04.18
        /// </summary>
        /// <param name="masterID"></param>
        /// <returns></returns>
        public bool DeleteByMasterID(Guid? masterID)
        {
            return this.ExecuteNoneQuery("dbo.Proc_DeleteProjectProgressReport_AttachDetailByMasterID", masterID);
        }

        #endregion
    }
    #endregion
}

