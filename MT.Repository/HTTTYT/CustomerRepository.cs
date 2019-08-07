using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region CustomerRepository
    /// <summary>
    /// This object represents the properties and methods of a CustomerRepository.
    /// </summary>
    public class CustomerRepository : BaseRepository<Customer>, ICustomerRepository
    {
        #region"Contructor"
        public CustomerRepository()
        {
        }
        public CustomerRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"

        #endregion
    }
    #endregion
}

