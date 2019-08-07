using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
	#region ProjectPlanExpenseRepository
	/// <summary>
	/// This object represents the properties and methods of a ProjectPlanExpenseRepository.
	/// </summary>
	public class ProjectPlanExpenseRepository : BaseRepository<ProjectPlanExpense>, IProjectPlanExpenseRepository
    {
        #region"Contructor"
		public ProjectPlanExpenseRepository()
		{
		}	
		public ProjectPlanExpenseRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Lấy danh sách kế hoạch k.phí của đề tài
        /// </summary>
        /// <param name="masterID">ID của đề tài</param>
        /// <returns>Danh sách kế hoạch k.phí của đề tài</returns>
        /// Create by: truonngnm:11.02.2018
        public List<ProjectPlanExpense> GetListProjectPlanExpenseByMasterID(Guid? masterID)
        {
            return this.ExecuteReader<ProjectPlanExpense>("dbo.Proc_GetListProjectPlanExpenseByMasterID", masterID);
        }
        #endregion
    }
	#endregion
}

