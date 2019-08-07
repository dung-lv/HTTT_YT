using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MT.Library
{
    public class MTLog
    {
        static MTLog()
        {
            InitVariables();
        }

        /// <summary>
        /// Thiết lập app ghi log
        /// </summary>
        /// <param name="appName"></param>
        private static void InitVariables()
        {
            LogManager.Configuration.Variables["AppName"] = "BECore";
        }

        /// <summary>
        /// Log dùng để debug lỗi
        /// </summary>
        /// Create by: dvthang:27.10.2017
        public static Logger Debug
        {

            get
            {
                InitVariables();
                return LogManager.GetLogger("LoggerDebug");
            }
        }

        /// <summary>
        /// Log để truy vết
        /// </summary>
        /// Create by: dvthang:27.10.2017
        public static Logger Trace
        {
            get
            {
                return LogManager.GetLogger("LoggerTrace");
            }
        }

        /// <summary>
        /// Log để ghi 1 thông tin 
        /// </summary>
        /// Create by: dvthang:27.10.2017
        public static Logger Info
        {
            get
            {
                return LogManager.GetLogger("LoggerInfo");
            }
        }

        /// <summary>
        /// Log để ghi các exception xảy ra => Làm lỗi phần mềm
        /// </summary>
        /// Create by: dvthang:27.10.2017
        public static Logger Error
        {
            get
            {
                return LogManager.GetLogger("LoggerError");
            }
        }

        /// <summary>
        /// Log để ghi các cảnh cáo có thể xảy ra nhưng ko ảnh hưởng đến phần mềm
        /// </summary>
        /// Create by: dvthang:27.10.2017
        public static Logger Warn
        {
            get
            {
                InitVariables();
                return LogManager.GetLogger("LoggerWarn");
            }
        }
    }
}
