using ImageResizer;
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
    #region ImageController
    [RoutePrefix("~/api/Images")]
    /// <summary>
    /// Upload file qua API này
    /// </summary>
    public class ImagesController : ApiController
    {
        #region"Declare"

        private readonly string mscTEMP;
        private readonly string mscUPLOAD;
        #endregion
        #region"Contructor"
        public ImagesController()
        {
            mscTEMP = MT.Library.UtilityExtensions.GetKeyAppSetting(Commonkey.Temp);
            mscUPLOAD = MT.Library.UtilityExtensions.GetKeyAppSetting(Commonkey.UploadImg);
        }

        #endregion
        #region"Sub/Func"
        [HttpGet]
        public Task<HttpResponseMessage> Get(string id,int width,int height,bool isTemp)
        {
            try
            {
                string filePath = HttpContext.Current.Server.MapPath(mscUPLOAD);
                if (isTemp)
                {
                    filePath = HttpContext.Current.Server.MapPath(mscTEMP);
                }

                var destinationPath = Path.Combine(filePath, $"{id}.png");

                Instructions it = new Instructions() { Width = width, Height = height };
                it.Mode = FitMode.Crop;
                if (!File.Exists(destinationPath))
                {
                    destinationPath = Path.Combine(filePath, "avatar.png");
                }
                if (File.Exists(destinationPath))
                {
                    HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK);
                    using (FileStream fs = new FileStream(destinationPath, FileMode.Open, FileAccess.Read))
                    {
                        using (var originalStream = new MemoryStream())
                        {
                            ImageJob iJob = new ImageJob(fs, originalStream, it);
                            iJob.Build();
                            result.Content = new ByteArrayContent(originalStream.ToArray());
                        }
                    }
                    result.Content.Headers.ContentType = new MediaTypeHeaderValue("image/png");
                    return Task.FromResult(result);
                }
                else
                {
                    return Task.FromResult(new HttpResponseMessage(HttpStatusCode.NotFound));
                }
            }
            catch (Exception ex)
            {
                CommonFunction.CommonLogError(ex);
            }
            return Task.FromResult(new HttpResponseMessage(HttpStatusCode.NotFound));
        }

        /// <summary>
        /// Nhận tệp upload lên
        /// </summary>
        /// <returns>Trả về thông tin tệp upload</returns>
        /// Create by: dvthang:22.01.2018
        [HttpPost]
        public Task<ResultData> UploadImg()
        {
            ResultData result = new ResultData();

            try
            {
                var httpRequest = HttpContext.Current.Request;
                
                if (httpRequest.Files.Count > 0)
                {

                    var maxHeight = Convert.ToInt32(httpRequest.Form["maxHeight"]);
                    var maxWidth = Convert.ToInt32(httpRequest.Form["maxWidth"]);

                    if (maxHeight <= 0)
                    {
                        maxHeight = 100;
                    }
                    if (maxWidth <= 0)
                    {
                        maxWidth = 100;
                    }

                    List<FileResource> lstFileResource = new List<FileResource>();
                    var filePath = HttpContext.Current.Server.MapPath(mscTEMP);
                    Guid gFID = Guid.NewGuid();
                   
                    foreach (string file in httpRequest.Files)
                    {

                        var postedFile = httpRequest.Files[file];

                        postedFile.InputStream.Seek(0, SeekOrigin.Begin);

                        FileResource objResource = new FileResource();
                        objResource.FileType = Path.GetExtension(postedFile.FileName);

                        objResource.FileResourceID = gFID;
                        objResource.FileName = postedFile.FileName;
                        objResource.FileNameNExt = Path.GetFileNameWithoutExtension(postedFile.FileName);
                        objResource.FileSize = (float)Math.Ceiling((float)postedFile.ContentLength / 1024);

                        var destinationPath = Path.Combine(filePath, $"{objResource.FileResourceID.ToString()}");

                        ImageBuilder.Current.Build(
                            new ImageJob(
                                postedFile,
                                destinationPath,
                                new Instructions($"maxwidth={maxWidth}&maxheight={maxHeight}&format=png"),
                                false,
                                true));
                        lstFileResource.Add(objResource);
                    }
                    result.Data = lstFileResource;
                    result.Code = HttpStatusCode.OK;
                    result.Success = true;
                }
                else
                {
                    result.Code = HttpStatusCode.BadRequest;
                    result.Success = false;
                }

            }
            catch (Exception ex)
            {
                result.Code = HttpStatusCode.BadRequest;
                result.SetError(ex);
            }
            return Task.FromResult(result);
        }
        #endregion
    }
    #endregion
}

