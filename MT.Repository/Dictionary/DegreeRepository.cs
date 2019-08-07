using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
	#region DegreeRepository
	/// <summary>
	/// This object represents the properties and methods of a DegreeRepository.
	/// </summary>
	public class DegreeRepository : BaseRepository<Degree>, IDegreeRepository
    {
        #region"Contructor"
		public DegreeRepository()
		{
		}	
		public DegreeRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
        #endregion
        #region"Sub/Func"

        #endregion
        /// <summary>
        /// Check trùng mã học vị
        /// </summary>
        /// <param name="master"></param>
        /// <returns></returns>
        public  ResultData ValidateBeforeSave(Degree master)
        {
            ResultData resultData = new ResultData();
            bool exist = Convert.ToBoolean(this.ExecuteScalar("Proc_CheckExitsDegreeCode",
                master.DegreeID, master.DegreeCode, master.EditMode));
            if(exist)
            {
                resultData.Success = false;
                resultData.ErrorMessage = "Trùng mã học vị";
            }
            return resultData;
        }

    }
	#endregion
}

