using System;
using System.Collections;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Caching;
namespace MT.Library
{
    /// <summary>
    /// Class xử lý cache
    /// Tất cả các key ở đây đều được lưu theo Domain
    /// </summary>
    /// Create by: dvthang:16.01.2017
    public class CacheUtility
    {
        /// <summary>
        /// Đối tượng Cache
        /// </summary>
        /// Create by: dvthang:16.01.2017
        private static readonly Cache cache;

        /// <summary>
        /// Contructor 
        /// </summary>
        static CacheUtility()
        {
            HttpContext current = HttpContext.Current;
            if (current != null)
            {
                cache = current.Cache;
            }
            else
            {
                cache = HttpRuntime.Cache;
            }
        }

        /// <summary>
        /// Xóa hết Cache
        /// </summary>
        /// Create by: dvthang:16.01.2017
        public static void Clear()
        {
            ArrayList list = new ArrayList();
            IDictionaryEnumerator enumerator = cache.GetEnumerator();
            while (enumerator.MoveNext())
            {
                list.Add(enumerator.Key.ToString());
            }
            foreach (string str in list)
            {
                RemoveCache(str);
            }
        }

        /// <summary>
        /// Lấy về đối tượng Cache được lưu
        /// </summary>
        /// <param name="cacheKey">Tên key lưu Cache</param>
        /// <returns></returns>
        public static object GetCache(string cacheKey, bool isUser = false)
        {
            string strKey = GetKeyByDomain(cacheKey, isUser);
            return cache.Get(strKey);
        }

        /// <summary>
        /// Lưu cache theo key
        /// </summary>
        /// <param name="cacheKey"></param>
        /// <param name="data">Data cần lưu Cache</param>
        /// Create by: dvthang:16.01.2017
        public static void InsertCache(string cacheKey, object data, bool isUser = false)
        {
            InsertCache(cacheKey, data, 24 * 3600, isUser);
        }

        /// <summary>
        /// Lưu cache theo key theo thời gian truyền vào
        /// </summary>
        /// <param name="cacheKey"></param>
        /// <param name="data">Data cần lưu Cache</param>
        /// Create by: dvthang:16.01.2017
        public static void InsertCache(string cacheKey, object data, int iExpireTime, bool isUser = false)
        {
            InsertCache(cacheKey, data, iExpireTime, null, isUser);
        }
        /// <summary>
        /// Thêm cache vào 
        /// </summary>
        /// <param name="cacheKey">Tên key</param>
        /// <param name="data">Data cần lưu Cache</param>
        /// <param name="ExpireTime">Thời gian lưu Cache</param>
        /// <param name="dep"></param>
        /// Create by: dvthang:16.01.2017
        public static void InsertCache(string cacheKey, object data, int iExpireTime, CacheDependency dep, bool isUser = false)
        {
            string strKey = GetKeyByDomain(cacheKey, isUser);
            if (data != null)
            {
                if (iExpireTime < 0)
                {
                    //Mặc định là 1 ngày
                    iExpireTime = 24 * 3600;
                }
                if (iExpireTime > 0)
                {
                    cache.Insert(strKey, data, dep, DateTime.Now.AddSeconds((double)iExpireTime), TimeSpan.Zero);
                }
                else
                {
                    cache.Insert(strKey, data, dep);
                }
            }
        }

        /// <summary>
        /// Xóa cache theo theo thức chính quy
        /// </summary>
        /// <param name="cacheKey">Tên key Cache</param>
        /// <param name="byPattern">Xóa cache theo biểu thức chính quy</param>
        /// Create by: dvthang:16.01.2017
        public static void Remove(string cacheKey, bool byPattern = false,bool isUser=false)
        {
            string strKey = GetKeyByDomain(cacheKey, isUser);
            if (byPattern)
            {
                RemoveByPattern(strKey);
            }
            else
            {
                RemoveCache(strKey, isUser);
            }
        }

        /// <summary>
        /// Xóa tất cả các key có dạng biểu thức chính quy pattern
        /// </summary>
        /// Create by: dvthang:16.01.2017
        public static void RemoveByPattern(string pattern)
        {
            IDictionaryEnumerator enumerator = cache.GetEnumerator();
            Regex regex = new Regex(pattern, RegexOptions.Singleline | RegexOptions.Compiled | RegexOptions.IgnoreCase);
            while (enumerator.MoveNext())
            {
                if (regex.IsMatch(enumerator.Key.ToString()))
                {
                    cache.Remove(enumerator.Key.ToString());
                }
            }
        }

        /// <summary>
        /// Xóa cache theo Key
        /// </summary>
        /// <param name="cacheKey">Tên key cache</param>
        /// Create by: dvthang:16.01.2017
        public static void RemoveCache(string cacheKey,bool isUser=false)
        {
            string strKey = GetKeyByDomain(cacheKey, isUser);
            if (cache[strKey] != null)
            {
                cache.Remove(strKey);
            }
        }

        /// <summary>
        /// Lấy về keyCache theo domain của ứng dụng
        /// </summary>
        /// <param name="keyCache">Tên key</param>
        /// Create by: dvthang:16.01.2017
        public static string GetKeyByDomain(string keyCache,bool isUser=false)
        {
            return MT.Library.UtilityExtensions.GetKeyByDomain(keyCache,isUser);
        }
    }
}
