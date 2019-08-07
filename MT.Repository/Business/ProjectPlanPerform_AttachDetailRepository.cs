using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region ProjectPlanPerform_AttachDetailRepository
    /// <summary>
    /// This object represents the properties and methods of a ProjectPlanPerform_AttachDetailRepository.
    /// </summary>
    public class ProjectPlanPerform_AttachDetailRepository: BaseRepository<ProjectPlanPerform_AttachDetail>, IProjectPlanPerform_AttachDetailRepository
    {
        #region"Contructor"
        public ProjectPlanPerform_AttachDetailRepository()
        {
        }
        public ProjectPlanPerform_AttachDetailRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"

        #endregion
    }
    #endregion
}

