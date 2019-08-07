using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region IProjectProgressReportRepository:IBaseRepository<ProjectProgressReport>
    /// <summary>
    /// This object represents the properties and methods of a IProjectProgressReportRepository:IBaseRepository<ProjectProgressReport>.
    /// Create by: truongnm:31.01.2018
    /// </summary>
    public interface IProjectProgressReportRepository : IBaseRepository<ProjectProgressReport>
    {

        #region"Sub/Func"
        /// <summary>
        /// Lấy về danh sách ID file đính kèm của Báo cáo tiến độ
        /// Create By: manh:01.04.18
        /// </summary>
        /// <param name="masterID"></param>
        /// <returns></returns>
        List<ProjectProgressReport_AttachDetail> GetListIDByMasterID(Guid? masterID);

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

