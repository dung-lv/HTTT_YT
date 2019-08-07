using APIBE.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using MT.Library;
using MT.Model;
using MT.Repository;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;

namespace APIBE.Controllers
{
    #region ForgotController
    [RoutePrefix("~/api/Forgot")]
    /// <summary>
    /// Lấy lại mật khẩu
    /// </summary>
    public class ForgotController : ApiController
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
        #endregion
        #region"Contructor"

        #endregion
        #region"Sub/Func"        
        /// <summary>
        /// Lấy lại password
        /// </summary>
        /// <returns>Đường dẫn link kích hoạt</returns>
        /// Create by: dvthang:22.02.2018
        [Route("~/api/Forgot/SendLinkActive")]
        [HttpPost]
        public ResultData SendLinkActive([FromUri]string userName, [FromUri]string capcha, [FromUri]string emailConfirm)
        {
            ResultData oResultData = new ResultData();
            try
            {
                if (!string.IsNullOrWhiteSpace(userName) && !string.IsNullOrWhiteSpace(capcha))
                {
                    //Kiểm tra user có tồn tại không
                    ApplicationUser user = UserManager.FindByName<ApplicationUser, string>(userName);
                    if (user != null)
                    {

                        //Kiểm tra capcha có hợp lệ không
                        object objCapcha = MemoryCacheHelper.GetValue(Commonkey.Capcha);
                        if (objCapcha == null && !string.IsNullOrWhiteSpace(capcha))
                        {
                            oResultData.Success = false;
                            oResultData.ErrorMessage = MT.Resources.GlobalResource.WarnCodeExpried;
                        }
                        if (!objCapcha.ToString().Equals(capcha,StringComparison.OrdinalIgnoreCase))
                        {
                            oResultData.Success = false;
                            oResultData.ErrorMessage = MT.Resources.GlobalResource.WarnCodeInValid;
                        }
                        else
                        {
                            MemoryCacheHelper.Delete(Commonkey.Capcha);
                        }
                        if (user.Email == emailConfirm)
                        {
                            Guid token = Guid.NewGuid();

                            MemoryCacheHelper.Add(token.ToString(), userName, DateTimeOffset.Now.AddDays(1));

                            string hostName = MT.Library.CommonFunction.GetDomainBEcore();

                            string pathEmail = MT.Library.CommonFunction.GetMapPathEmail();

                            //var destinationPath = Path.Combine(pathEmail, "ConfirmPassword.html");
                            var destinationPath = Path.Combine(pathEmail, "SetNewPassword.html");

                            string strBody = MT.Library.CommonFunction.ReadData(destinationPath);

                            strBody = strBody.Replace("#Link#", hostName);

                            strBody = strBody.Replace("#Token#", token.ToString());
                            //Gửi mail kích hoạt tài khoản
                            EmailUltility.SendMail(user.Email, "", MT.Resources.GlobalResource.Title_ActiveLink, strBody, null);
                            oResultData.Success = true;
                            oResultData.Data = user.Email;
                        }
                        else
                        {
                            oResultData.Success = false;
                            oResultData.ErrorMessage = MT.Resources.GlobalResource.InvalidEmailConfirm;
                        }
                    }
                    else
                    {
                        oResultData.Success = false;
                        oResultData.ErrorMessage = MT.Resources.GlobalResource.UserNameInValid;
                    }

                }
                else
                {
                    oResultData.Success = false;
                    oResultData.ErrorMessage = MT.Resources.GlobalResource.WarnUserNameOrCodeBlank;
                }

            }
            catch (Exception ex)
            {
                oResultData.SetError(ex);
            }
            return oResultData;
        }

        /// <summary>
        /// Kích hoạt tài khoản sau khi reset
        /// </summary>
        /// <returns>Gửi mật khẩu truy cập vào ứng dụng vào mail</returns>
        /// Create by: dvthang:22.02.2018
        [Route("~/api/Forgot/Active")]
        [HttpPost]
        public async Task<ResultData> Active([FromUri]string token)
        {
            ResultData oResultData = new ResultData();
            try
            {
                //Kiểm tra key có tồn tại và đã hết thời gian kích hoạt chưa
                if (!string.IsNullOrWhiteSpace(token) && MemoryCacheHelper.HasExitsKey(token))
                {
                    string userName = Convert.ToString(MemoryCacheHelper.GetValue(token));
                    ApplicationUser user = UserManager.FindByName<ApplicationUser, string>(userName);
                    if (user != null)
                    {
                        string code = await UserManager.GeneratePasswordResetTokenAsync(user.Id);
                        string passWordGenerate = MT.Library.CommonFunction.RandomPassword();

                        var result = await UserManager.ResetPasswordAsync(user.Id, code, passWordGenerate);
                        if (result.Succeeded)
                        {
                            MemoryCacheHelper.Delete(token);
                            string hostName = MT.Library.CommonFunction.GetDomainBEcore();

                            string pathEmail = MT.Library.CommonFunction.GetMapPathEmail();
                            var destinationPath = Path.Combine(pathEmail, "ActivePassword.html");
                            string strBody = MT.Library.CommonFunction.ReadData(destinationPath);

                            strBody = strBody.Replace("#Link#", hostName);

                            strBody = strBody.Replace("#PassWord#", passWordGenerate);

                            //Gửi mail kích hoạt tài khoản
                            EmailUltility.SendMail(user.Email, "", MT.Resources.GlobalResource.Title_SendLinkActive, strBody, null);

                            oResultData.Success = true;
                        }
                        else
                        {
                            oResultData.Success = false;
                        }
                    }
                }
                else
                {
                    oResultData.Success = false;
                    oResultData.ErrorMessage = MT.Resources.GlobalResource.ErrorExpriedActiveLink;
                }
            }
            catch (Exception ex)
            {
                oResultData.SetError(ex);
            }
            return oResultData;
        }


        [Route("~/api/Forgot/CheckToken")]
        [HttpPost]
        public async Task<ResultData> CheckToken([FromUri]string token)
        {
            ResultData oResultData = new ResultData();
            try
            {
                //Kiểm tra key có tồn tại và đã hết thời gian kích hoạt chưa
                if (!string.IsNullOrWhiteSpace(token) && MemoryCacheHelper.HasExitsKey(token))
                {
                    string userName = Convert.ToString(MemoryCacheHelper.GetValue(token));
                    ApplicationUser user = UserManager.FindByName<ApplicationUser, string>(userName);
                    if (user != null)
                    {
                        oResultData.Success = true;  
                    }
                    else
                    {
                        oResultData.Success = false;
                    }
                }
                else
                {
                    oResultData.Success = false;
                    oResultData.ErrorMessage = MT.Resources.GlobalResource.ErrorExpriedActiveLink;
                }
            }
            catch (Exception ex)
            {
                oResultData.SetError(ex);
            }
            return oResultData;
        }

        [Route("~/api/Forgot/SetNewPassword")]
        [HttpPost]
        public async Task<ResultData> SetNewPassword([FromUri]string token, [FromUri]string Password)
        {
            ResultData oResultData = new ResultData();
            try
            {
                //Kiểm tra key có tồn tại và đã hết thời gian kích hoạt chưa
                if (!string.IsNullOrWhiteSpace(token) && MemoryCacheHelper.HasExitsKey(token))
                {
                    string userName = Convert.ToString(MemoryCacheHelper.GetValue(token));
                    ApplicationUser user = UserManager.FindByName<ApplicationUser, string>(userName);
                    if (user != null)
                    {
                        string code = await UserManager.GeneratePasswordResetTokenAsync(user.Id);

                        var result = await UserManager.ResetPasswordAsync(user.Id, code, Password);
                        if (result.Succeeded)
                        {
                            MemoryCacheHelper.Delete(token);
                            //string hostName = MT.Library.CommonFunction.GetDomainBEcore();

                            //string pathEmail = MT.Library.CommonFunction.GetMapPathEmail();
                            //var destinationPath = Path.Combine(pathEmail, "ActivePassword.html");
                            //string strBody = MT.Library.CommonFunction.ReadData(destinationPath);

                            //strBody = strBody.Replace("#Link#", hostName);

                            //strBody = strBody.Replace("#PassWord#", passWordGenerate);

                            ////Gửi mail kích hoạt tài khoản
                            //EmailUltility.SendMail(user.Email, "", MT.Resources.GlobalResource.Title_SendLinkActive, strBody, null);

                            oResultData.Success = true;
                        }
                        else
                        {
                            oResultData.Success = false;
                        }
                    }
                }
                else
                {
                    oResultData.Success = false;
                    oResultData.ErrorMessage = MT.Resources.GlobalResource.ErrorExpriedActiveLink;
                }
            }
            catch (Exception ex)
            {
                oResultData.SetError(ex);
            }
            return oResultData;
        }
        #endregion
    }
    #endregion
}

