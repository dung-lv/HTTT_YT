using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    /// <summary>
    /// File đính kèm đề tài
    /// </summary>
    /// Create by: dvthang:26.01.2018
    public class Project_AttachDetailRepository : BaseRepository<Project_AttachDetail>, IProject_AttachDetailRepository
    {
        #region"Contructor"
        public Project_AttachDetailRepository()
        {

        }

        public Project_AttachDetailRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
        #endregion
    }
}
