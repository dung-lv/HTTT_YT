using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
	#region ProjectAcceptanceManageRepository
	/// <summary>
	/// This object represents the properties and methods of a ProjectAcceptanceManageRepository.
	/// </summary>
	public class ProjectAcceptanceManageRepository : BaseRepository<ProjectAcceptanceManage>, IProjectAcceptanceManageRepository
    {
        #region"Contructor"
		public ProjectAcceptanceManageRepository()
		{
		}	
		public ProjectAcceptanceManageRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
        #endregion

        #region"Sub/Func"
        /// <summary>
        ///  Lấy danh sách nghiệm thu cấp quản lý theo projectId
        /// </summary>
        /// <param name="projectID"></param>
        /// <returns></returns>
        public List<ProjectAcceptanceManage> GetByProjectID(Guid? projectID)
        {
            List<ProjectAcceptanceManage> projectAcceptanceManages = this.ExecuteReader<ProjectAcceptanceManage>("dbo.Proc_SelectProjectAcceptanceManageByProjectID", projectID);
            return projectAcceptanceManages;
        }

        #endregion
    }
	#endregion
}

