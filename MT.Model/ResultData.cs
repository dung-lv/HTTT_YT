
using System;

namespace MT.Model
{
    /// <summary>
    /// Định nghĩa data trả về phía client
    /// </summary>
    /// Create by: dvthang:08.04.2017
    public class ResultData
    {
        public ResultData()
        {
            Success = true;
            Code = System.Net.HttpStatusCode.OK;
        }
        /// <summary>
        /// Thực thi thành công
        /// </summary>
        public bool Success{get;set;}
        /// <summary>
        /// Lỗi khi thực thi
        /// </summary>
        public string ErrorMessage{get;set;}
        /// <summary>
        /// Mã llooix
        /// </summary>
        public int ErrorType { get; set; }
        /// <summary>
        /// Data trả về
        /// </summary>
        public object Data { get; set; }//Master
        /// <summary>
        /// Tổng số bản ghi dùng cho paging
        /// </summary>
        public int Total { get; set; }

         /// <summary>
        /// Dùng cho dòng Summary trên grid
        /// </summary>
        /// Create by: dvthang:24.04.2017
        public object SummaryData { get; set; }

        public string PKName { get; set; }
        public object PKValue { get; set; }

        public System.Net.HttpStatusCode Code { get; set; }

        public void SetError(Exception ex)
        {
            Success = false;
            PKValue = null;
            PKName = "";
            Code = System.Net.HttpStatusCode.InternalServerError;
        }
    }
}
