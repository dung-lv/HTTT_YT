using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region IProjectWorkshopRepository:IBaseRepository<ProjectWorkshop>
    /// <summary>
    /// This object represents the properties and methods of a IProjectWorkshopRepository:IBaseRepository<ProjectWorkshop>.
    /// </summary>
    public interface IProjectWorkshopRepository : IBaseRepository<ProjectWorkshop>
    {

        #region"Sub/Func"
        /// <summary>
        /// Lấy về danh sách ID file đính kèm của Hội thảo
        /// Create By: manh:01.04.18
        /// </summary>
        /// <param name="masterID"></param>
        /// <returns></returns>
        List<ProjectWorkshop_AttachDetail> GetListIDByMasterID(Guid? masterID);

        /// <summary>
        /// Xóa file đính kèm
        /// Create By: manh:01.04.18
        /// </summary>
        /// <param name="masterID"></param>
        /// <returns></returns>
        bool DeleteByMasterID(Guid? masterID);
        #endregion
    }
    #endregion
}

