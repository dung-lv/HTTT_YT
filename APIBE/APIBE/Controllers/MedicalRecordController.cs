using MT.Library;
using MT.Model;
using MT.Repository;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
namespace APIBE.Controllers
{
    #region MedicalRecordController:BaseController<MedicalRecord>
    /// <summary>
    /// This object represents the properties and methods of a MedicalRecordController:BaseController<MedicalRecord>.
    /// </summary>
    [Authorize]
    [RoutePrefix("api/MedicalRecord")]
    public class MedicalRecordController : BaseController<MedicalRecord>
    {
        #region"Declare"
        private readonly IMedicalRecordRepository repMedicalRecord;
        #endregion
        #region"Contructor"
        public MedicalRecordController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
            this.repMedicalRecord = this.Rep as IMedicalRecordRepository;
        }
        #endregion
        #region"Sub/Func"

        #endregion
    }
    #endregion
}

