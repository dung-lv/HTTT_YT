using MT.Library;
using MT.Model;
using MT.Repository;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
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
    #region DownloadController
    [RoutePrefix("~/api/Download")]
    /// <summary>
    /// Upload file qua API này
    /// </summary>
    public class DownloadController : ApiController
    {
        #region"Declare"
        private readonly ITokensRepository tokenRep;
        private readonly IUnitOfWork unitOfWork;

        private readonly string mscTEMP;
        private readonly string mscUPLOAD;
        #endregion
        #region"Contructor"
        public DownloadController()
        {
            mscTEMP = MT.Library.UtilityExtensions.GetKeyAppSetting(Commonkey.Temp);
            mscUPLOAD = MT.Library.UtilityExtensions.GetKeyAppSetting(Commonkey.Upload);
        }
        public DownloadController(IUnitOfWork unitOfWork)
        {
            mscTEMP = MT.Library.UtilityExtensions.GetKeyAppSetting(Commonkey.Temp);
            mscUPLOAD = MT.Library.UtilityExtensions.GetKeyAppSetting(Commonkey.Upload);
            this.unitOfWork = unitOfWork;
            tokenRep = unitOfWork.GetRepByName("Tokens") as ITokensRepository;
        }
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Nhận tệp upload lên
        /// </summary>
        /// <returns>Trả về thông tin tệp upload</returns>
        /// Create by: dvthang:22.01.2018
        [HttpGet]
        public HttpResponseMessage Get()
        {
            try
            {
                string tokenId = HttpContext.Current.Request.QueryString[Commonkey.TokenID],
                    downloadFrom = HttpContext.Current.Request.QueryString[Commonkey.DF];

                 int eDownloadFrom =(int)MT.Library.Enummation.DowloadFrom.Upload;
                Token oToken = null;
                if (tokenRep.ValidateToken(tokenId, ref oToken))
                {
                    string fileResourceID = HttpContext.Current.Request.QueryString["ID"];
                    bool isTemp = Convert.ToBoolean(HttpContext.Current.Request.QueryString["IsTemp"]);
                    string fileType = HttpContext.Current.Request.QueryString["FT"];
                    var filePath = string.Empty;
                    if (isTemp)
                    {
                        filePath = HttpContext.Current.Server.MapPath(mscTEMP);
                    }
                    else
                    {
                        int.TryParse(downloadFrom, out eDownloadFrom);
                        if (eDownloadFrom == (int)MT.Library.Enummation.DowloadFrom.ProjectServey)
                        {
                            filePath = MT.Library.CommonFunction.GetMapPathProjectServey();
                        }
                        else
                        {
                            filePath = HttpContext.Current.Server.MapPath(mscUPLOAD);
                        }
                        
                    }

                    var destinationPath = Path.Combine(filePath, $"{fileResourceID}{fileType}");
                    if (File.Exists(destinationPath))
                    {

                        HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK);
                        var stream = new FileStream(destinationPath, FileMode.Open);
                        result.Content = new StreamContent(stream);
                        result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                        result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
                        result.Content.Headers.ContentDisposition.FileName = $"{fileResourceID}{fileType}";
                        return result;
                    }
                    else
                    {
                        return new HttpResponseMessage(HttpStatusCode.NotFound);
                    }
                }
                else
                {
                    return new HttpResponseMessage(HttpStatusCode.BadRequest);
                }
            }
            catch (Exception)
            {
                return new HttpResponseMessage(HttpStatusCode.BadRequest);
            }
        }
        #endregion
    }
    #endregion
}

