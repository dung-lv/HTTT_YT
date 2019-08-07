using MT.Library;
using MT.Model;
using MT.Repository;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
namespace APIBE.Controllers
{
    #region UploadController
    [Authorize]
    [RoutePrefix("~/api/Upload")]
    /// <summary>
    /// Upload file qua API này
    /// </summary>
    public class UploadController : ApiController
    {
        #region"Declare"
        private readonly string mscTEMP;
        private readonly string mscUPLOAD;
        #endregion
        #region"Contructor"
        public UploadController()
        {
            mscTEMP = MT.Library.UtilityExtensions.GetKeyAppSetting(Commonkey.Temp);
            mscUPLOAD = MT.Library.UtilityExtensions.GetKeyAppSetting(Commonkey.Upload);
        }
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Nhận tệp upload lên
        /// </summary>
        /// <returns>Trả về thông tin tệp upload</returns>
        /// Create by: dvthang:22.01.2018
        [HttpPost]
        public Task<ResultData> Files()
        {
            ResultData result = new ResultData();

            try
            {
                var httpRequest = HttpContext.Current.Request;
                var editMode = 0 ;
                int.TryParse(httpRequest.Form["EditMode"], out editMode);
                var ID = httpRequest.Form["PKValue"];
                if (httpRequest.Files.Count > 0)
                {
                    List<FileResource> lstFileResource = new List<FileResource>();
                    var filePath = HttpContext.Current.Server.MapPath(mscTEMP);
                    Guid gFID = Guid.NewGuid();
                    if (editMode == (int)Enummation.EditMode.Edit)
                    {
                         Guid.TryParse(ID.ToString(),out gFID);
                    }
                    foreach (string file in httpRequest.Files)
                    {

                        var postedFile = httpRequest.Files[file];

                        FileResource objResource = new FileResource();
                        objResource.FileType = Path.GetExtension(postedFile.FileName);

                        objResource.FileResourceID = gFID;
                        objResource.FileName = postedFile.FileName;
                        objResource.FileNameNExt = Path.GetFileNameWithoutExtension(postedFile.FileName);
                        objResource.FileSize = (float)Math.Ceiling((float)postedFile.ContentLength / 1024);

                        var destinationPath = Path.Combine(filePath, $"{objResource.FileResourceID.ToString()}{objResource.FileType}");
                        postedFile.SaveAs(destinationPath);
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
                    result.ErrorMessage = "Can't find file";
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

