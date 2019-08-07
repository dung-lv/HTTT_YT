using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    /// <summary>
    /// Danh mục cấp quản lý đề tài
    /// </summary>
    /// Create by: laipv:13.01.2018
    public class LevelRepository : BaseRepository<Level>, ILevelRepository
    {
        #region"Contructor"
        public LevelRepository()
        {

        }
        public LevelRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
        #endregion
        #region ovverides
        /// <summary>
        /// Check trùng mã cấp QLDT
        /// </summary>
        /// <param name="master"></param>
        /// <returns></returns>
        public ResultData ValidateBeforeSave(Level master)
        {
            ResultData resultData = new ResultData();
            //
            bool bexist = Convert.ToBoolean(this.ExecuteScalar("Proc_CheckExitsLevelCode",
                master.LevelID, master.LevelCode, master.EditMode));
            if(bexist)
            {
                resultData.Success = false;
                resultData.ErrorMessage = "Trùng mã cấp thực hiện";
            }
            //
            return resultData;
        }
        #endregion

    }
}
