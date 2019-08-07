using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region ContentExperimentRepository
    /// <summary>
    /// This object represents the properties and methods of a ContentExperimentRepository.
    /// </summary>
    public class ContentExperimentRepository : BaseRepository<ContentExperiment>, IContentExperimentRepository
    {
        #region"Contructor"
        public ContentExperimentRepository()
        {
        }
        public ContentExperimentRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
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
        public List<ProjectExperiment_AttachDetail> GetListIDByMasterID(Guid? masterID)
        {
            return this.ExecuteReader<ProjectExperiment_AttachDetail>("dbo.Proc_SelectListIDProjectExperiment_AttachDetailByMasterID", masterID);
        }

        /// <summary>
        /// Xóa file đính kèm
        /// Create By: manh:01.04.18
        /// </summary>
        /// <param name="masterID"></param>
        /// <returns></returns>
        public bool DeleteByMasterID(Guid? masterID)
        {
            return this.ExecuteNoneQuery("dbo.Proc_DeleteProjectExperiment_AttachDetailByMasterID", masterID);
        }
        #endregion
    }
    #endregion
}

