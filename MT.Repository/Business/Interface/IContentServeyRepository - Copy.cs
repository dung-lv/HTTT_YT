using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region IContentServeyRepository:IBaseRepository<ProjectSurvey>
    /// <summary>
    /// This object represents the properties and methods of a IContentServeyRepository:IBaseRepository<ProjectSurvey>.
    /// </summary>
    public interface IContentServeyRepository : IBaseRepository<ContentServey>
    {

        #region"Sub/Func"
        /// <summary>
        /// Lấy về danh sách ID file đính kèm của Thông tin khảo sát
        /// Create By: manh:01.04.18
        /// </summary>
        /// <param name="masterID"></param>
        /// <returns></returns>
        List<ProjectSurvey_AttachDetail> GetListIDByMasterID(Guid? masterID);

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

