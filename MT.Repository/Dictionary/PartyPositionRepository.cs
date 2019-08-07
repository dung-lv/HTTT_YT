using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model.Dictionary;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;

namespace MT.Repository
{
    /// <summary>
    /// Danh mục Cấp bậc trong Đảng
    /// </summary>
    /// Create by: laipv:13.01.2018
    public class PartyPositionRepository : BaseRepository<PartyPosition>, IPartyPositionRepository
    {
        #region"Contructor"
        public PartyPositionRepository()
        {

        }

        public PartyPositionRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
    }
}

