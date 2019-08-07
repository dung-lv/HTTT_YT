using MT.Library;
using MT.Model;
using MT.Repository;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
namespace APIBE.Controllers
{
    #region CustomerController:BaseController<Customer>
    /// <summary>
    /// This object represents the properties and methods of a CustomerController:BaseController<Customer>.
    /// </summary>
    [Authorize]
    [RoutePrefix("api/Customer")]
    public class CustomerController : BaseController<Customer>
    {
        #region"Declare"
        private readonly ICustomerRepository repCustomer;
        #endregion
        #region"Contructor"
        public CustomerController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
            this.repCustomer = this.Rep as ICustomerRepository;
        }
        #endregion
        #region"Sub/Func"

        #endregion
    }
    #endregion
}

