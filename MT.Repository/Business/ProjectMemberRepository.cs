using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region ProjectMemberRepository
    /// <summary>
    /// This object represents the properties and methods of a ProjectMemberRepository.
    /// </summary>
    public class ProjectMemberRepository : BaseRepository<ProjectMember>, IProjectMemberRepository
    {
        #region"Contructor"
        public ProjectMemberRepository()
        {
        }
        public ProjectMemberRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Check trùng mã thành viên thao gia đề tài
        /// CreateBy: truongnm 03-03-2018
        /// </summary>
        /// <param name="master"></param>
        /// <returns></returns>
        public ResultData ValidateBeforeSave(ProjectMember master)
        {
            ResultData resultData = new ResultData();
            bool exist = Convert.ToBoolean(this.ExecuteScalar("Proc_CheckExitsProjectMemberCode",
                master.ProjectMemberID, master.ProjectID, master.EmployeeID, master.EditMode));

            if (exist)
            {
                resultData.Success = false;
                resultData.ErrorMessage = "Trùng mã nhân viên";
            }

            return resultData;
        }
        #endregion
    }
    #endregion
}

