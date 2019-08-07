using MT.Library;
using MT.Model;
using MT.Repository;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
namespace APIBE.Controllers
{
    #region MeasurementStandardController:BaseController<MeasurementStandard>
    /// <summary>
    /// This object represents the properties and methods of a MeasurementStandardController:BaseController<MeasurementStandard>.
    /// </summary>
    [Authorize]
    [RoutePrefix("api/MeasurementStandard")]
    public class MeasurementStandardController : BaseController<MeasurementStandard>
    {
        #region"Declare"
        private readonly IMeasurementStandardRepository repMeasurementStandard;
        #endregion
        #region"Contructor"
        public MeasurementStandardController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
            this.repMeasurementStandard = this.Rep as IMeasurementStandardRepository;
        }
        #endregion
        #region"Sub/Func"

        #endregion
    }
    #endregion
}

