using System.Web;

namespace MT.Library
{
    public class SessionUtility
    {
        /// <summary>
        /// Lưu giá trị vào session
        /// </summary>
        /// <param name="key">Tên key cần lưu</param>
        /// <param name="value">Giá trị cần lưu</param>
        /// Create by: dvthang:07.10.2016
        public static void SetSession(string key, object value)
        {
            var session = HttpContext.Current.Session;
            string keySession = CommonFunction.GetKeyByUserName(key);
            if (session != null && session[keySession] != null)
            {
                session.Remove(keySession);
            }
            session[keySession] = value;
        }

        /// <summary>
        /// Đọc giá trị vào session
        /// </summary>
        /// <param name="key">Tên key cần lưu</param>
        /// Create by: dvthang:07.10.2016
        public static object GetSession(string key)
        {
            var session = HttpContext.Current.Session;
            string keySession = CommonFunction.GetKeyByUserName(key);
            if (session != null && session[keySession] != null)
            {
                return session[keySession];
            }
            return null;
        }

        /// <summary>
        /// Đọc giá trị vào session
        /// </summary>
        /// <param name="key">Tên key cần lưu</param>
        /// Create by: dvthang:07.10.2016
        public static void RemoveSession(string key)
        {
            var session = HttpContext.Current.Session;
            string keySession = CommonFunction.GetKeyByUserName(key);
            if (session != null && session[keySession] != null)
            {
                session.Remove(keySession);
            }
        }
    }
}
