using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region ProjectPlanExpense_AttachDetailRepository
    /// <summary>
    /// This object represents the properties and methods of a ProjectPlanExpense_AttachDetailRepository.
    /// </summary>
    public class ProjectPlanExpense_AttachDetailRepository : BaseRepository<ProjectPlanExpense_AttachDetail>, IProjectPlanExpense_AttachDetailRepository
    {
        #region"Contructor"
        public ProjectPlanExpense_AttachDetailRepository()
        {
        }
        public ProjectPlanExpense_AttachDetailRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"

        #endregion
    }
    #endregion
}

