using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
namespace MT.Repository
{
    #region ProjectPlanPerformRepository
    /// <summary>
    /// This object represents the properties and methods of a ProjectPlanPerformRepository.
    /// </summary>
    public class ProjectPlanPerformRepository : BaseRepository<ProjectPlanPerform>, IProjectPlanPerformRepository
    {
        #region"Contructor"
        public ProjectPlanPerformRepository()
        {
        }
        public ProjectPlanPerformRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Lấy danh sách kế hoạch thực hiện của đề tài
        /// </summary>
        /// <param name="masterID">ID của đề tài</param>
        /// <returns>Danh sách kế hoạch thực hiện của đề tài</returns>
        /// Create by: truonngnm:11.02.2018
        /// Modified by: laipv:11.02.2018
        public List<ProjectPlanPerform> GetProjectPlanPerformByMasterID(Guid? masterID)
        {
            return  this.ExecuteReader<ProjectPlanPerform>("dbo.Proc_GetListProjectPlanPerformByMasterID", masterID);
        }
        #endregion
    }
    #endregion
}

