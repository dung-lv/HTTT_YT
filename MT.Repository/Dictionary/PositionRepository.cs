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
    /// Danh mục Cấp bậc
    /// </summary>
    /// Create by: laipv:13.01.2018
    public class PositionRepository : BaseRepository<Position>, IPositionRepository
    {
        #region"Contructor"
        public PositionRepository()
        {

        }

        public PositionRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
        #endregion
    }
}
