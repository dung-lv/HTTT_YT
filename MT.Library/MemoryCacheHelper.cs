using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Caching;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Caching;
namespace MT.Library
{
    /// <summary>   
    /// Chú ý: Bạn nên nhớ là MemoryCache sẽ được xóa mỗi khi IIS app pool được làm mới (recycle)
    /// Nếu Web API của bạn :
    /// Không nhận được bất cứ request nào trong vòng hơn 20 phút
    /// Hoặc đặt thời gian mặc định cho IIS làm mới Pool là 1740 phút
    /// Hoặc bạn deploy một bản build mới lên thư mục Web API được triển khai trên IIS
    /// Lưu dữ liệu vào ram
    /// </summary>
    /// Create by: dvthang:22.02.2018
    public class MemoryCacheHelper
    {
        /// <summary>
        /// Get cache value by key
        /// </summary>
        /// <param name="key">Key lưu giá trị vào cache</param>
        /// <returns>Trả về giá trị lưu trong bộ nhớ</returns>
        /// Create by: dvthang:22.02.2018
        public static object GetValue(string key, bool isUser = false)
        {
            key = MT.Library.UtilityExtensions.GetKeyByDomain(key, isUser);
            return MemoryCache.Default.Get(key);
        }

        /// <summary>
        /// Add a cache object with date expiration
        /// </summary>
        /// <param name="key">Tên key</param>
        /// <param name="value">Giá trị</param>
        /// <param name="absExpiration">Thời gian lưu</param>
        /// <returns>Lưu thành công</returns>
        /// Create by: dvthang:22.02.2018
        public static bool Add(string key,object value, DateTimeOffset absExpiration, bool isUser = false)
        {
            key = MT.Library.UtilityExtensions.GetKeyByDomain(key, isUser);
            if (HasExitsKey(key, isUser))
            {
                Delete(key, isUser);
            }
            return MemoryCache.Default.Add(key, value, absExpiration);
        }

        /// <summary>
        /// Delete cache value from key
        /// </summary>
        /// <param name="key">Key cache</param>
        /// Create by: dvthang:22.02.2018
        public static void Delete(string key,bool isUser=false)
        {
            MemoryCache memoryCache = MemoryCache.Default;
            key = MT.Library.UtilityExtensions.GetKeyByDomain(key, isUser);
            if (memoryCache.Contains(key))
            {
                memoryCache.Remove(key);
            }
        }

        /// <summary>
        /// Kiểm tra tồn key trong bộ nhớ
        /// </summary>
        /// <param name="key">Key cache</param>
        /// Create by: dvthang:22.02.2018
        public static bool HasExitsKey(string key, bool isUser = false)
        {
            MemoryCache memoryCache = MemoryCache.Default;
            key = MT.Library.UtilityExtensions.GetKeyByDomain(key, isUser);
            if (memoryCache.Contains(key))
            {
                return true;
            }
            return false;
        }

    }
}
