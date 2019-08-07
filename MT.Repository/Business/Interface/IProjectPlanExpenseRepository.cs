using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region IProjectPlanExpenseRepository:IBaseRepository<ProjectPlanExpense>
    /// <summary>
    /// This object represents the properties and methods of a IProjectPlanExpenseRepository:IBaseRepository<ProjectPlanExpense>.
    /// </summary>
    public interface IProjectPlanExpenseRepository : IBaseRepository<ProjectPlanExpense>
    {
        #region"Sub/Func"
        /// <summary>
        /// Lấy danh sách kế hoạch k.phí của đề tài
        /// </summary>
        /// <param name="masterID">ID của đề tài</param>
        /// <returns>Danh sách kế hoạch k.phí của đề tài</returns>
        /// Create by: truonngnm:11.02.2018
        List<ProjectPlanExpense> GetListProjectPlanExpenseByMasterID(Guid? masterID);
        #endregion
    }
    #endregion
}

