using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region ProjectExperiment_AttachDetailRepository
    /// <summary>
    /// This object represents the properties and methods of a ProjectExperiment_AttachDetailRepository.
    /// </summary>
    public class ProjectExperiment_AttachDetailRepository : BaseRepository<ProjectExperiment_AttachDetail>, IProjectExperiment_AttachDetailRepository
    {
        #region"Contructor"
        public ProjectExperiment_AttachDetailRepository()
        {
        }
        public ProjectExperiment_AttachDetailRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion 
        #region"Sub/Func"

        #endregion
    }
    #endregion
}

