using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
	#region ProjectAcceptanceBasicRepository
	/// <summary>
	/// This object represents the properties and methods of a ProjectAcceptanceBasicRepository.
	/// </summary>
	public class ProjectAcceptanceBasicRepository : BaseRepository<ProjectAcceptanceBasic>, IProjectAcceptanceBasicRepository
    {
        #region"Contructor"
		public ProjectAcceptanceBasicRepository()
		{
		}	
		public ProjectAcceptanceBasicRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
        #endregion
        #region"Sub/Func"

        /// <summary>
        ///  Lấy danh sách nghiệm thu cơ sở theo projectId
        /// </summary>
        /// <param name="ProjectID"></param>
        /// <returns></returns>
        public List<ProjectAcceptanceBasic> GetByProjectID(Guid? ProjectID)
        {
            List<ProjectAcceptanceBasic> projectAcceptanceBasics = this.ExecuteReader<ProjectAcceptanceBasic>("dbo.Proc_SelectProjectAcceptanceBasicByProjectID", ProjectID);
            return projectAcceptanceBasics;
        }

        #endregion
	}
	#endregion
}

