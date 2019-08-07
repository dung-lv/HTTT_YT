using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region ProjectExperimentRepository
    /// <summary>
    /// This object represents the properties and methods of a ProjectExperimentRepository.
    /// </summary>
    public class ProjectExperimentRepository : BaseRepository<ProjectExperiment>, IProjectExperimentRepository
    {
        #region"Contructor"
        public ProjectExperimentRepository()
        {
        }
        public ProjectExperimentRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"

        #endregion
    }
    #endregion
}

