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
    #region ExportExcelController
    [RoutePrefix("~/api/ExportExcel")]
    /// <summary>
    /// Xuaat
    /// </summary>
    public class ExportExcelController : ApiController
    {
        #region"Declare"
        private readonly ITokensRepository tokenRep;
        private readonly IUnitOfWork unitOfWork;

        private readonly string mscExcel;
        #endregion
        #region"Contructor"
        public ExportExcelController()
        {
            mscExcel = MT.Library.UtilityExtensions.GetKeyAppSetting(Commonkey.Excel);
        }
        public ExportExcelController(IUnitOfWork unitOfWork)
        {
            mscExcel = MT.Library.UtilityExtensions.GetKeyAppSetting(Commonkey.Excel);
            this.unitOfWork = unitOfWork;
            tokenRep = unitOfWork.GetRepByName("Tokens") as ITokensRepository;
        }
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Xuất data file Excel
        /// </summary>
        /// <returns>Trả về thông tin tệp Excel</returns>
        /// Create by: dvthang:10.03.2018
        [HttpGet]
        public Task<HttpResponseMessage> Get(string data)
        {
            try
            {
                if (!string.IsNullOrEmpty(data))
                {
                    BaseParam param = CommonFunction.DeserializeObject<BaseParam>(data);
                    Token oToken = null;
                    if (tokenRep.ValidateToken(param.TokenID, ref oToken))
                    {
                        HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK);

                        IBaseReportRepository rep = this.GetRep(param);

                        byte[] xlsInBytes = rep.ExportExcel(param);

                        result.Content = new ByteArrayContent(xlsInBytes);
                        result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                        result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
                        result.Content.Headers.ContentDisposition.FileName = $"{Guid.NewGuid()}.xls";
                        result.Content.Headers.ContentLength = xlsInBytes.Length;
                        return Task.FromResult(result);
                    }
                    else
                    {
                        return Task.FromResult(new HttpResponseMessage(HttpStatusCode.Unauthorized));
                    }
                }
            }
            catch (Exception ex)
            {
                CommonFunction.CommonLogError(ex);
            }
            return Task.FromResult(new HttpResponseMessage(HttpStatusCode.InternalServerError));
        }

        /// <summary>
        /// Lấy về rep tương ứng
        /// </summary>
        /// <param name="data">Dữ liều</param>
        /// <returns>Lấy về Rep</returns>
        /// Create by: dvthang:10.03.2018
        private IBaseReportRepository GetRep(BaseParam data)
        {
            IBaseReportRepository rep = null;
            switch (data.ReportID)
            {
                //case MT.Library.Enummation.ReportID.ChamCong:
                //    rep = (LabordayRepository)this.unitOfWork.GetRepByName("Laborday");
                //    break;
                //case MT.Library.Enummation.ReportID.ChamCongTC:
                //    rep = (LabordayRepository)this.unitOfWork.GetRepByName("Laborday");
                //    break;
                //case MT.Library.Enummation.ReportID.LuongCoBan:
                //    rep = (SalaryExportRepository)this.unitOfWork.GetRepByName("SalaryExport");
                //    break;
                //case MT.Library.Enummation.ReportID.HeSoTienCong:
                //    rep = (WageCoefficientExportRepository)this.unitOfWork.GetRepByName("WageCoefficientExport");
                //    break;
                //case MT.Library.Enummation.ReportID.ThueKhoanChuyenMon:
                //    rep = (ContractedProfessionalExportRepository)this.unitOfWork.GetRepByName("ContractedProfessionalExport");
                //    break;
                //case MT.Library.Enummation.ReportID.ThueKhoanChuyenMonExcel:
                //    rep = (ContractedProfessionalExportExcelRepository)this.unitOfWork.GetRepByName("ContractedProfessionalExportExcel");
                //    break;
                //case MT.Library.Enummation.ReportID.BaoCaoSoNgayConDeChamCong:
                //    rep = (DaysLeftExportExcelRepository)this.unitOfWork.GetRepByName("DaysLeftExportExcel");
                    //break;
            }
            return rep;
        }

        #endregion
    }
    #endregion
}

