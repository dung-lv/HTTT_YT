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
    #region CommonController
    [RoutePrefix("~/api/Common")]
    /// <summary>
    /// Upload file qua API này
    /// </summary>
    public class CommonController : ApiController
    {
        #region"Declare"
        #endregion
        #region"Contructor"
        
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Lấy mặc định về 10 guid
        /// </summary>
        /// <returns></returns>
        [Route("~/api/Common/Guids")]
        [HttpGet]       
        public List<Guid> GetListGuid(int number)
        {
            List<Guid> guids = new List<Guid>();
            if (number > 100)
            {
                number = 100;
            }
            for(int i = 0; i < number; i++)
            {
                guids.Add(Guid.NewGuid());
            }
            return guids;
        }

        /// <summary>
        /// Sinh mã capcha phục vụ việc bảo mật
        /// </summary>
        /// <returns>Trả về chuỗi capcha</returns>
        /// Create by: dvthang:22.02.2018
        [Route("~/api/Common/Capcha")]
        [HttpGet]
        public ResultData GetCaptcha()
        {
            ResultData oResultData = new ResultData();
            try
            {
                string capcha = "";
                Bitmap bm=  MT.Library.CommonFunction.CreateCapcha(ref capcha);

                MemoryCacheHelper.Add(Commonkey.Capcha, capcha, DateTimeOffset.Now.AddMinutes(5));

                using (System.IO.MemoryStream stream = new System.IO.MemoryStream())
                {
                    bm.Save(stream, System.Drawing.Imaging.ImageFormat.Bmp);
                    byte[] imageBytes = stream.ToArray();
                    string base64String = Convert.ToBase64String(imageBytes);
                    oResultData.Data = base64String;
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

