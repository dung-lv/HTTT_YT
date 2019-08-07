using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region ProjectWorkshop_AttachDetailRepository
    /// <summary>
    /// This object represents the properties and methods of a ProjectWorkshop_AttachDetailRepository.
    /// </summary>
    public class ProjectWorkshop_AttachDetailRepository : BaseRepository<ProjectWorkshop_AttachDetail>, IProjectWorkshop_AttachDetailRepository
    {
        #region"Contructor"
        public ProjectWorkshop_AttachDetailRepository()
        {
        }
        public ProjectWorkshop_AttachDetailRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"

        #endregion
    }
    #endregion
}

