using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    public interface IProjectPlanPerformRepository : IBaseRepository<ProjectPlanPerform>
    {
        #region"Sub/Func"
        /// <summary>
        /// Lấy danh sách kế hoạch thực hiện của đề tài
        /// </summary>
        /// <param name="masterID">ID của đề tài</param>
        /// <returns>Danh sách kế hoạch thực hiện của đề tài</returns>
        /// Create by: truonngnm:11.02.2018
        /// Modified by: laipv:11.02.2018
        List<ProjectPlanPerform> GetProjectPlanPerformByMasterID(Guid? masterID);
        #endregion
    }
}

