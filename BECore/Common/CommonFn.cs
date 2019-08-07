using MT.Library;
using MT.Model;
using MT.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BECore
{
    public class CommonFn
    {
        #region"Declare"
        private readonly ITokensRepository tokenRep;
        private readonly IUnitOfWork unitOfWork;
        #endregion
        #region"Contructor"
        public CommonFn()
        {
            unitOfWork = new UnitOfWork();
            tokenRep = unitOfWork.GetRepByName("Tokens") as ITokensRepository;
        }
        #endregion
        /// <summary>
        /// Luu thong tin login
        /// </summary>
        /// <returns>true: thanh cong, nguoc lai thats bai</returns>
        /// Create by: dvthang:12.1.2018
        public bool SaveInfoLogin(Token oToken)
        {
            string msgRespone = MT.Library.CommonFunction.SerializeObject(oToken);
            //MTLog.Trace("Start  SaveInfoLogin {0}", msgRespone);
            bool isSucces = false;
            MT.Model.Tokens tokens = new Tokens
            {
                TokenId = Guid.NewGuid(),
                UserName = oToken.UserName,
                Token = msgRespone,
                IssuedOn = DateTime.Now,
                ExpiresOn = DateTime.Now.AddDays(1),
            };
            isSucces = tokenRep.Insert(tokens) > 0;
            if (isSucces)
            {
                //MTLog.Trace.Trace("Finish  SaveInfoLogin {0}", tokens.TokenId);
                SetCookie(MT.Library.Commonkey.TokenLogin, tokens.TokenId.ToString());
            }
            return isSucces;
        }

        /// <summary>
        /// Lấy về thông tin đăng nhập của user
        /// </summary>
        /// <param name="tokenId">ID tự sinh</param>
        /// <returns>Thông tin của token</returns>
        /// Create by: dvthang:221.01.2018
        public Tokens GetTokensByTokenId(string tokenId)
        {
            return tokenRep.GetDataByID(Guid.Parse(tokenId));
        }

        /// <summary>
        /// Kiem tra thong  tin dang nhap nhap con hieu luc khong
        /// </summary>
        /// <param name="tokenId">Token da luu</param>
        /// <returns>true: thanh cong, nguoc lai thats bai</returns>
        /// Create by: dvthang:12.1.2018
        public bool ValidateToken(string tokenId, ref Token oToken)
        {
            return tokenRep.ValidateToken(tokenId, ref oToken);
        }

        /// <summary>
        /// Doc token luu trong cookie
        /// </summary>
        /// <returns>Chuoi Token</returns>
        /// Create by: dvthang:12.1.2018
        public string GetToken()
        {
            string tokenId = string.Empty;
            if (HttpContext.Current != null && HttpContext.Current.Request != null && HttpContext.Current.Request.Cookies.Count > 0)
            {
                HttpCookie cookie = HttpContext.Current.Request.Cookies[MT.Library.Commonkey.TokenLogin];
                if (cookie != null)
                {
                    tokenId = cookie.Value;
                }
            }
            return tokenId;
        }

        /// <summary>
        /// Doc token luu trong cookie
        /// </summary>
        /// <returns>Chuoi Token</returns>
        /// Create by: dvthang:12.1.2018
        public void SetCookie(string key, string value)
        {
            HttpCookie cookie = new HttpCookie(key);
            cookie.Value = value;
            cookie.Expires = DateTime.Now.AddDays(1);
           
            if (HttpContext.Current?.Response?.Cookies != null)
            {
                if (HttpContext.Current.Response.Cookies.AllKeys.Contains(key))
                {
                    HttpContext.Current.Response.Cookies.Remove(key);
                }
                cookie.Domain = HttpContext.Current.Request.Url.Host;
                HttpContext.Current.Response.Cookies.Add(cookie);
            }
        }

        /// <summary>
        /// Thực hiện xóa cookie
        /// </summary>
        /// <param name="key">Tên key cần xóa</param>
        /// Create by: dvthang:12.01.2018
        public void RemoveCookie(string key)
        {
            if (HttpContext.Current?.Request?.Cookies != null)
            {
                string[] myCookies = HttpContext.Current.Request.Cookies.AllKeys;
                foreach (string cookieName in myCookies)
                {
                    if (cookieName.Equals(key, StringComparison.OrdinalIgnoreCase))
                    {
                        HttpCookie myCookie = HttpContext.Current.Request.Cookies.Get(cookieName);
                        myCookie.Expires = DateTime.Now.AddMonths(-1);
                        myCookie.Value = null;
                        myCookie.Domain = HttpContext.Current.Request.Url.Host;
                        HttpContext.Current.Request.Cookies.Remove(cookieName);
                        HttpContext.Current.Request.Cookies.Add(myCookie);
                    }
                }
            }
        }

        /// <summary>
        /// Thực hiện xóa cookie
        /// </summary>
        /// Create by: dvthang:12.01.2018
        public void ClearAllCookie()
        {
            if (HttpContext.Current?.Request?.Cookies != null)
            {
                string[] myCookies = HttpContext.Current.Request.Cookies.AllKeys;
                foreach (string cookieName in myCookies)
                {
                    HttpCookie myCookie = new HttpCookie(cookieName);
                    myCookie.Expires = DateTime.Now.AddMonths(-1);
                    myCookie.Value = null;
                    myCookie.Domain = HttpContext.Current.Request.Url.Host;
                    HttpContext.Current.Request.Cookies.Remove(cookieName);
                    HttpContext.Current.Request.Cookies.Add(myCookie);
                    HttpContext.Current.Response.Cookies.Remove(cookieName);
                    HttpContext.Current.Response.Cookies.Add(myCookie);
                }
            }
        }
    }
}