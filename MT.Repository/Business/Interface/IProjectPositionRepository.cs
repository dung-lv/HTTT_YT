using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region IProjectPositionRepository:IBaseRepository<ProjectPosition>
    /// <summary>
    /// This object represents the properties and methods of a IProjectPositionRepository:IBaseRepository<ProjectPosition>.
    /// Create by: truongnm:31.01.2018
    /// </summary>
    public interface IProjectPositionRepository : IBaseRepository<ProjectPosition>
    {

        #region"Sub/Func"
        /// <summary>
        /// Check trùng mã 
        /// CreateBy: truongnm 04-03-2018
        /// </summary>
        /// <param name="master"></param>
        /// <returns></returns>
        ResultData ValidateBeforeSave(ProjectPosition master);
        #endregion
    }
    #endregion
}

