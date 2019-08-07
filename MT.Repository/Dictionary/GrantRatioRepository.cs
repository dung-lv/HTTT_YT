using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region GrantRatioRepository
    /// <summary>
    /// This object represents the properties and methods of a GrantRatioRepository.
    /// </summary>
    public class GrantRatioRepository :BaseRepository<GrantRatio>, IGrantRatioRepository
    {
        #region"Contructor"
        public GrantRatioRepository()
        {
        }
        public GrantRatioRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"

        #endregion
        /// <summary>
        /// Check trùng mã học hàm
        /// </summary>
        /// <param name="master"></param>
        /// <returns></returns>
        public ResultData ValidateBeforeSave(GrantRatio master)
        {
            ResultData resultData = new ResultData();
            bool exist = Convert.ToBoolean(this.ExecuteScalar("Proc_CheckExitsGrantRatioCode",
                master.GrantRatioID, master.GrantRatioCode, master.EditMode));
            if(exist)
            {
                resultData.Success = false;
                resultData.ErrorMessage = "Trùng mã học hàm";
            }

            return resultData;
        }

    }
    #endregion
}

