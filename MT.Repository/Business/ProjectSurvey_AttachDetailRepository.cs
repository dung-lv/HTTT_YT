using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region ProjectSurvey_AttachDetailRepository
    /// <summary>
    /// This object represents the properties and methods of a ProjectSurvey_AttachDetailRepository.
    /// </summary>
    public class ProjectSurvey_AttachDetailRepository : BaseRepository<ProjectSurvey_AttachDetail>, IProjectSurvey_AttachDetailRepository
    {
        #region"Contructor"
        public ProjectSurvey_AttachDetailRepository()
        {
        }
        public ProjectSurvey_AttachDetailRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"

        #endregion
    }
    #endregion
}

