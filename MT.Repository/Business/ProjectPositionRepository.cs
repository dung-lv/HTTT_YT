using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region ProjectPositionRepository
    /// <summary>
    /// This object represents the properties and methods of a ProjectPositionRepository.
    /// </summary>
    public class ProjectPositionRepository : BaseRepository<ProjectPosition>, IProjectPositionRepository
    {
        #region"Contructor"
        public ProjectPositionRepository()
        {
        }
        public ProjectPositionRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Check trùng mã 
        /// CreateBy: truongnm 04-03-2018
        /// </summary>
        /// <param name="master"></param>
        /// <returns></returns>
        public ResultData ValidateBeforeSave(ProjectPosition master)
        {
            ResultData resultData = new ResultData();
            bool exist = Convert.ToBoolean(this.ExecuteScalar("Proc_CheckExitsProjectPositionCode",
                master.ProjectPositionID, master.ProjectPositionCode, master.EditMode));
            if (exist)
            {
                resultData.Success = false;
                resultData.ErrorMessage = "Trùng mã vai trò đề tài";
            }
            return resultData;
        }
        #endregion
    }
    #endregion
}

