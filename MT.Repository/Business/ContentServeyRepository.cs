using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region ContentServeyRepository
    /// <summary>
    /// This object represents the properties and methods of a ContentServeyRepository.
    /// </summary>
    public class ContentServeyRepository : BaseRepository<ContentServey>, IContentServeyRepository
    {
        #region"Contructor"
        public ContentServeyRepository()
        {
        }
        public ContentServeyRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
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
        public List<ProjectSurvey_AttachDetail> GetListIDByMasterID(Guid? masterID)
        {
            return this.ExecuteReader<ProjectSurvey_AttachDetail>("dbo.Proc_SelectListIDProjectSurvey_AttachDetailByMasterID", masterID);
        }

        /// <summary>
        /// Xóa file đính kèm
        /// Create By: manh:01.04.18
        /// </summary>
        /// <param name="masterID"></param>
        /// <returns></returns>
        public bool DeleteByMasterID(Guid? masterID)
        {
            return this.ExecuteNoneQuery("dbo.Proc_DeleteProjectSurvey_AttachDetailByMasterID", masterID);
        }
        #endregion
    }
    #endregion
}

