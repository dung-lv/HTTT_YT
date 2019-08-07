using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
	#region ProjectPresentProtectedRepository
	/// <summary>
	/// This object represents the properties and methods of a ProjectPresentProtectedRepository.
	/// </summary>
	public class ProjectPresentProtectedRepository : BaseRepository<ProjectPresentProtected>, IProjectPresentProtectedRepository
    {
        #region"Contructor"
		public ProjectPresentProtectedRepository()
		{
		}	
		public ProjectPresentProtectedRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
		#endregion
	    #region"Sub/Func"

        #endregion
	}
	#endregion
}

