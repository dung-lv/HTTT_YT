using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
	#region ProjectCloseRepository
	/// <summary>
	/// This object represents the properties and methods of a ProjectCloseRepository.
	/// </summary>
	public class ProjectCloseRepository : BaseRepository<ProjectClose>, IProjectCloseRepository
    {
        #region"Contructor"
		public ProjectCloseRepository()
		{
		}	
		public ProjectCloseRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Lấy danh sách kế hoạch thực hiện của đề tài
        /// </summary>
        /// <param name="masterID">ID của đề tài</param>
        /// <returns>Danh sách kế hoạch thực hiện của đề tài</returns>
        /// Create by: truonngnm:11.02.2018
        /// Modified by: laipv:11.02.2018
        public List<ProjectClose> GetProjectCloseByMasterID(Guid? masterID)
        {
            return this.ExecuteReader<ProjectClose>("dbo.Proc_GetListProjectCloseByMasterID", masterID);
        }

        #endregion
    }
	#endregion
}

