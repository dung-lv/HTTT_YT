using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
	#region ProjectTaskMemberRepository
	/// <summary>
	/// This object represents the properties and methods of a ProjectTaskMemberRepository.
	/// </summary>
	public class ProjectTaskMemberRepository : BaseRepository<ProjectTaskMember>, IProjectTaskMemberRepository
    {
        #region"Contructor"
		public ProjectTaskMemberRepository()
		{
		}	
		public ProjectTaskMemberRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
		#endregion
	    #region"Sub/Func"
        
        #endregion
    }
	#endregion
}

