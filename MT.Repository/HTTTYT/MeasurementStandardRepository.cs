using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region MeasurementStandardRepository
    /// <summary>
    /// This object represents the properties and methods of a MeasurementStandardRepository.
    /// </summary>
    public class MeasurementStandardRepository : BaseRepository<MeasurementStandard>, IMeasurementStandardRepository
    {
        #region"Contructor"
        public MeasurementStandardRepository()
        {
        }
        public MeasurementStandardRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"

        #endregion
    }
    #endregion
}

