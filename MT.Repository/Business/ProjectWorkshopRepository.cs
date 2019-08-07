using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region ProjectWorkshopRepository
    /// <summary>
    /// This object represents the properties and methods of a ProjectWorkshopRepository.
    /// </summary>
    public class ProjectWorkshopRepository : BaseRepository<ProjectWorkshop>, IProjectWorkshopRepository
    {
        #region"Contructor"
        public ProjectWorkshopRepository()
        {
        }
        public ProjectWorkshopRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
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
        public List<ProjectWorkshop_AttachDetail> GetListIDByMasterID(Guid? masterID)
        {
            return this.ExecuteReader<ProjectWorkshop_AttachDetail>("dbo.Proc_SelectListIDProjectWorkshop_AttachDetailByMasterID", masterID);
        }

        /// <summary>
        /// Xóa file đính kèm
        /// Create By: manh:01.04.18
        /// </summary>
        /// <param name="masterID"></param>
        /// <returns></returns>
        public bool DeleteByMasterID(Guid? masterID)
        {
            return this.ExecuteNoneQuery("dbo.Proc_DeleteProjectWorkshop_AttachDetailByMasterID", masterID);
        }
        #endregion
    }
    #endregion
}

