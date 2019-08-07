using MT.Library;
using MT.Model;
using MT.Repository;
using System.Web.Mvc;

namespace BECore.Controllers
{
    public class HomeController : Controller
    {

        #region"Declare"
        private readonly CommonFn commonFn;      
        #endregion
        #region"Contructor"
        public HomeController()
        {
            commonFn = new CommonFn();
        }
        #endregion
        // GET: Home
        public ActionResult Index()
        {
            Token oToken = TempData[Commonkey.mscResponeLogin] as Token;
            string token = commonFn.GetToken();
            if (oToken == null)
            {
                if (string.IsNullOrEmpty(token) || !commonFn.ValidateToken(token,ref oToken))
                {
                    return RedirectToAction("Logout", "Account");
                }
            }
            ViewBag.TokenId = token;
            ViewBag.Token = oToken;
            return View();
        }

        /// <summary>
        /// Hiển thị form lấy lại mật khẩu
        /// </summary>
        /// <returns>Hiển thị form lấy lại mật khẩu</returns>
        /// Create by: dvthang:22.02.2018
        public ActionResult ResetPassword()
        {
            return View();
        }

        public ActionResult SetNewPassword()
        {
            return View();
        }
    }
}