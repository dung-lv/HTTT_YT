using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
	#region IProjectCloseRepository:IBaseRepository<ProjectClose>
	/// <summary>
	/// This object represents the properties and methods of a IProjectCloseRepository:IBaseRepository<ProjectClose>.
	/// </summary>
	public interface IProjectCloseRepository:IBaseRepository<ProjectClose>
	{

        #region"Sub/Func"

        /// <summary>
        /// Lấy danh sách đóng đề tài theo projectId
        /// </summary>
        /// <param name="masterID"></param>
        /// <returns></returns>
        List<ProjectClose> GetProjectCloseByMasterID(Guid? masterID);
        #endregion
    }
	#endregion
}

