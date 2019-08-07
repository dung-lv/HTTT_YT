using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
	#region IProjectAcceptanceBasicRepository:IBaseRepository<ProjectAcceptanceBasic>
	/// <summary>
	/// This object represents the properties and methods of a IProjectAcceptanceBasicRepository:IBaseRepository<ProjectAcceptanceBasic>.
	/// </summary>
	public interface IProjectAcceptanceBasicRepository:IBaseRepository<ProjectAcceptanceBasic>
	{

        #region"Sub/Func"

        #endregion
        /// <summary>
        /// Lấy danh sách nghiệm thu cơ sở theo projectId
        /// </summary>
        /// <param name="projectID"></param>
        /// <returns></returns>
        List<ProjectAcceptanceBasic> GetByProjectID(Guid? ProjectID);
    }
    
    #endregion
}

