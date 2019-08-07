using APIBE.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using MT.Library;
using MT.Model;
using MT.Repository;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Net.Http;
using System.Web.Http;

namespace APIBE.Controllers
{
    #region AspNetUsersController:BaseController<AspNetUsers>
    /// <summary>
    /// This object represents the properties and methods of a AspNetRolesController:BaseController<AspNetRoles>.
    /// </summary>
    public class AspNetUsersController : BaseController<AspNetUsers>
    {
        #region"Declare"
        private ApplicationUserManager _userManager;
        public ApplicationUserManager UserManager
        {
            get
            {
                return _userManager ?? Request.GetOwinContext().GetUserManager<ApplicationUserManager>();
            }
            private set
            {
                _userManager = value;
            }
        }
        private readonly IAspNetUsersRepository repAspNetUsers;
        #endregion
        #region"Contructor"
        public AspNetUsersController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
            this.repAspNetUsers = this.Rep as IAspNetUsersRepository;
        }
        #endregion
        #region"Sub/Func"

        #endregion
        /// <summary>
        /// Action phân trang dữ liệu
        /// </summary>
        /// <param name="page">Trang hiện tại</param>
        /// <param name="limit">Số bản ghi trên 1 trang</param>
        /// <param name="sort">Sắp xếp</param>
        /// <param name="sWhere">ĐIều kiện tìm kiếm</param>
        /// <returns>Danh sách dữ liệu phân trang</returns>
        /// create by: dvthang:19.01.2018
        [HttpGet]
        public override ResultData Get(int page, int start, int limit, string sort = "", string filter = "")
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            try
            {
                string sWhere = string.Empty;
                if (!string.IsNullOrEmpty(filter))
                {
                    sWhere = MTGrid.BuildWhere(CommonFunction.DeserializeObject<List<Filtering>>(filter));
                }
                resultData = this.repAspNetUsers.GetAspNetUsersDataPaging(sort, page, limit, sWhere);
            }
            catch (Exception ex)
            {
                resultData.SetError(ex);
            }
            return resultData;
        }
        
        protected override void PreSaveData(AspNetUsers master, IList<EntityBase> details)
        {
            master.CreatedDate = DateTime.Now;
            master.LockoutEndDateUtc = DateTime.Now;
        }
        protected override ResultData ValidateBeforeSave(AspNetUsers master, IList<EntityBase> details)
        {
            ResultData resultData = base.ValidateBeforeSave(master, details);
            if (resultData.Success)
            {
                resultData = this.repAspNetUsers.ValidateBeforeSave(master);
            }
            return resultData;
        }
    }
    #endregion
}

