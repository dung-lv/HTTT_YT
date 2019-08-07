using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
	#region ProjectAcceptanceManage_AttachDetailRepository
	/// <summary>
	/// This object represents the properties and methods of a ProjectAcceptanceManage_AttachDetailRepository.
	/// </summary>
	public class ProjectAcceptanceManage_AttachDetailRepository : BaseRepository<ProjectAcceptanceManage_AttachDetail>, IProjectAcceptanceManage_AttachDetailRepository
    {
        #region"Contructor"
		public ProjectAcceptanceManage_AttachDetailRepository()
		{
		}	
		public ProjectAcceptanceManage_AttachDetailRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
		#endregion
	    #region"Sub/Func"

        #endregion
	}
	#endregion
}

