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
    /// Danh mục cấp bậc
    /// </summary>
    /// Create by: dvthang:08.01.2018
    public class RankRepository : BaseRepository<Rank>, IRankRepository
    {
        #region"Contructor"
        public RankRepository()
        {

        }

        public RankRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
        #endregion
        /// <summary>
        /// Check trùng mã chức vụ
        /// </summary>
        /// <param name="master"></param>
        /// <returns></returns>
        public ResultData ValidateBeforeSave(Rank master)
        {
            ResultData resultData = new ResultData();

            bool bexist = Convert.ToBoolean(this.ExecuteScalar("Proc_CheckExitsRankCode",
                master.RankID, master.RankCode, master.EditMode));
            if(bexist)
            {
                resultData.Success = false;
                resultData.ErrorMessage = "Trùng mã chức vụ";
            }

            return resultData;
        }



    }
}
