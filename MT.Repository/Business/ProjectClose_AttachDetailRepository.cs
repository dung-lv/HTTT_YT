using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
	#region ProjectClose_AttachDetailRepository
	/// <summary>
	/// This object represents the properties and methods of a ProjectClose_AttachDetailRepository.
	/// </summary>
	public class ProjectClose_AttachDetailRepository : BaseRepository<ProjectClose_AttachDetail>, IProjectClose_AttachDetailRepository
    {
        #region"Contructor"
		public ProjectClose_AttachDetailRepository()
		{
		}	
		public ProjectClose_AttachDetailRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
		#endregion
	    #region"Sub/Func"

        #endregion
	}
	#endregion
}

