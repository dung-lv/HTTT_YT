using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
	#region ProjectAcceptanceBasic_AttachDetailRepository
	/// <summary>
	/// This object represents the properties and methods of a ProjectAcceptanceBasic_AttachDetailRepository.
	/// </summary>
	public class ProjectAcceptanceBasic_AttachDetailRepository : BaseRepository<ProjectAcceptanceBasic_AttachDetail>, IProjectAcceptanceBasic_AttachDetailRepository
    {
        #region"Contructor"
		public ProjectAcceptanceBasic_AttachDetailRepository()
		{
		}	
		public ProjectAcceptanceBasic_AttachDetailRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
		#endregion
	    #region"Sub/Func"

        #endregion
	}
	#endregion
}

