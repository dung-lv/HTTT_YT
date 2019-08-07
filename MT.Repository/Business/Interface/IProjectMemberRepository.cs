using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region IProjectMemberRepository:IBaseRepository<ProjectMember>
    /// <summary>
    /// This object represents the properties and methods of a IProjectMemberRepository:IBaseRepository<ProjectMember>.
    /// </summary>
    public interface IProjectMemberRepository : IBaseRepository<ProjectMember>
    {

        #region"Sub/Func"
        /// <summary>
        /// Check trùng mã thành viên thao gia đề tài
        /// CreateBy: truongnm 03-03-2018
        /// </summary>
        /// <param name="master"></param>
        /// <returns></returns>
        ResultData ValidateBeforeSave(ProjectMember master);
        #endregion
    }
    #endregion
}

