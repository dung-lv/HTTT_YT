using MT.Library;
using MT.Model;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace BECore.Controllers
{
    public class AccountController : Controller
    {
        #region"Declare"
        private readonly string requestUriLogin;
        private readonly CommonFn commonFn;
        #endregion
        #region"Contructor"
        public AccountController()
        {
            commonFn = new CommonFn();
            requestUriLogin = UtilityExtensions.GetKeyAppSetting(MT.Library.Commonkey.mscUriLogin);
        }
        #endregion
        // GET: Account
        public ActionResult Login()
        {
            string token = commonFn.GetToken();
            if (!string.IsNullOrEmpty(token))
            {
                return RedirectToAction("Index", "Home");
            }
            return View();
        }

        /// <summary>
        /// Thực logout khởi ứng dụng
        /// </summary>
        /// <returns></returns>
        /// Create by: dvthang:12.01.2018
        public ActionResult Logout()
        {
            string token = commonFn.GetToken();
            if (!string.IsNullOrEmpty(token))
            {
                commonFn.ClearAllCookie();
            }
            return RedirectToAction("Login", "Account");
        }


        [HttpPost]
        public async Task<ActionResult> Login(MT.Model.User oUser)
        {
            ResultData oResultData = new ResultData { Success = true};
            if (ModelState.IsValid)
            {
                try
                {
                    Token oToken = null;
                    string userName = oUser.UserName;
                    //MTLog.Trace.Trace("Start Login: UserName {0}", userName);
                    if (string.IsNullOrEmpty(userName) || userName.Trim().Length == 0)
                    {
                        oResultData.ErrorMessage = "Tên đăng nhập không được bỏ trống.";
                        oResultData.Success = false;
                        return Json(oResultData);
                    }
                    string password = oUser.Password;

                    if (string.IsNullOrEmpty(password) || password.Trim().Length == 0)
                    {
                        oResultData.ErrorMessage = "Mật khẩu không được bỏ trống.";
                        oResultData.Success = false;
                        return Json(oResultData);
                    }
                    Dictionary<string, string> dicUser = new Dictionary<string, string>()
                {
                    {"username",oUser.UserName},
                    {"password",oUser.Password},
                    {"grant_type","password"}
                };
                    var content = new FormUrlEncodedContent(dicUser);
                    using (HttpClient client = new HttpClient())
                    {
                        //MTLog.Trace.Trace("Link API Login {0}, password {1}", requestUriLogin, oUser.Password);
                        client.DefaultRequestHeaders.Accept.Add(new System.Net.Http.Headers.MediaTypeWithQualityHeaderValue("application/x-www-form-urlencoded"));
                        HttpResponseMessage result = await client.PostAsync(requestUriLogin, content);
                        if (result.IsSuccessStatusCode)
                        {
                            string reponse = await result.Content.ReadAsStringAsync();

                            //MTLog.Trace.Trace("Respone Login {0}", reponse);

                            oToken = CommonFunction.DeserializeObject<Token>(reponse);
                        }
                        else if (result.StatusCode == System.Net.HttpStatusCode.BadRequest)
                        {
                            string reponse = await result.Content.ReadAsStringAsync();

                            //MTLog.Trace.Trace("Respone Login {0}", reponse);

                            oToken = CommonFunction.DeserializeObject<Token>(reponse);
                        }
                    }
                    if (oToken == null)
                    {
                        oResultData.ErrorMessage = "Bạn không có quyền vào ứng dụng.";
                        oResultData.Success = false;
                        return Json(oResultData);
                    }
                    else if (oToken.Error == Commonkey.mscInvalid_grant)
                    {
                        oResultData.ErrorMessage = "Tên đăng nhập hoặc mật khẩu không chính xác.";
                        oResultData.Success = false;
                        return Json(oResultData);
                    }
                    else if (oToken.Error == Commonkey.mscUnsupported_grant_type )
                    {
                        oResultData.ErrorMessage = "Bạn không có quyền vào ứng dụng.";
                        oResultData.Success = false;
                        return Json(oResultData);
                    }
                    TempData[Commonkey.mscResponeLogin] = oToken;
                    commonFn.SaveInfoLogin(oToken);
                }
                catch (System.Exception ex)
                {
                    //MTLog.Trace.Trace("Error Login {0}", ex.Message);
                }
            }
            return Json(oResultData);
        }

        /// <summary>
        /// Ghi lỗi vào ModelState
        /// </summary>
        /// <param name="key">Key lỗi</param>
        /// <param name="errorMessage">Tên lỗi</param>
        private void AddError(string key, string errorMessage)
        {
            ModelState.Clear();
            ModelState.AddModelError(key, errorMessage);
        }

    }
}