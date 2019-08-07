using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region ProjectSurveyRepository
    /// <summary>
    /// This object represents the properties and methods of a ProjectSurveyRepository.
    /// </summary>
    public class ProjectSurveyRepository : BaseRepository<ProjectSurvey>, IProjectSurveyRepository
    {
        #region"Contructor"
        public ProjectSurveyRepository()
        {
        }
        public ProjectSurveyRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"

        #endregion
    }
    #endregion
}

