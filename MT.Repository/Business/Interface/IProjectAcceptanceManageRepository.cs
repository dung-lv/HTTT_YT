using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
	#region IProjectAcceptanceManageRepository:IBaseRepository<ProjectAcceptanceManage>
	/// <summary>
	/// This object represents the properties and methods of a IProjectAcceptanceManageRepository:IBaseRepository<ProjectAcceptanceManage>.
	/// </summary>
	public interface IProjectAcceptanceManageRepository:IBaseRepository<ProjectAcceptanceManage>
	{

        #region"Sub/Func"
        
        /// <summary>
        /// Lấy danh sách nghiệm thu cơ sở theo projectId
        /// </summary>
        /// <param name="projectID"></param>
        /// <returns></returns>
        List<ProjectAcceptanceManage> GetByProjectID(Guid? projectID);

        #endregion
    }
	#endregion
}

