using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
namespace MT.Library
{
    public class SessionData
    {
        public static Guid CompanyID
        {
            get
            {
                Guid gCompanyID = Guid.Empty;
                if ((bool)HttpContext.Current?.Request?.Headers?.AllKeys.Contains(Commonkey.CompanyID))
                {
                    string value = HttpContext.Current.Request.Headers[Commonkey.CompanyID];
                    Guid.TryParse(value, out gCompanyID);
                }
                return gCompanyID;
            }
        }

        public static Guid PositionID
        {
            get
            {
                Guid gPositionID = Guid.Empty;
                if ((bool)HttpContext.Current?.Request?.Headers?.AllKeys.Contains(Commonkey.PositionID))
                {
                    string value = HttpContext.Current.Request.Headers[Commonkey.PositionID];
                    Guid.TryParse(value, out gPositionID);
                }
                return gPositionID;
            }
        }

        public static Guid EmployeeID
        {
            get
            {
                Guid gEmployeeID = Guid.Empty;
                if ((bool)HttpContext.Current?.Request?.Headers?.AllKeys.Contains(Commonkey.EmployeeID))
                {
                    string value = HttpContext.Current.Request.Headers[Commonkey.EmployeeID];
                    Guid.TryParse(value, out gEmployeeID);
                }
                return gEmployeeID;
            }
        }

        /// <summary>
        /// Lấy về tên user đăng nhập
        /// </summary>
        /// Create by : dvthang:22.12.2016
        public static string UserName
        {
            get
            {
                return HttpContext.Current.User.Identity.Name;
            }
        }

    }
}
