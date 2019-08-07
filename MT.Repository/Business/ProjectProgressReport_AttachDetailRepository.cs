using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region ProjectProgressReport_AttachDetailRepository
    /// <summary>
    /// This object represents the properties and methods of a ProjectProgressReport_AttachDetailRepository.
    /// Create by: truongnm:31.01.2018
    /// </summary>
    public class ProjectProgressReport_AttachDetailRepository : BaseRepository<ProjectProgressReport_AttachDetail>, IProjectProgressReport_AttachDetailRepository
    {
        #region"Contructor"
        public ProjectProgressReport_AttachDetailRepository()
        {
        }
        public ProjectProgressReport_AttachDetailRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"

        #endregion
    }
    #endregion
}

