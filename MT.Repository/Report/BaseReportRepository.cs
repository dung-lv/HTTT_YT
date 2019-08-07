using MT.Model;
using System;
using System.IO;
using FlexCel.Core;
using FlexCel.Report;
using FlexCel.XlsAdapter;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System.Data.Common;

namespace MT.Repository
{
    /// <summary>
    /// In bảng chấm công
    /// </summary>
    /// Create by: laipv:10.03.2018
    public class BaseReportRepository: BaseRepository<EntityBase>, IBaseReportRepository
    {
        #region"Contructor"
        public BaseReportRepository()
        {
        }

        public BaseReportRepository(SqlDatabase db, DbTransaction ts):base(db,ts)
        {

        }
        #endregion
        #region"Sub/Func"

        protected virtual ExcelFile CreateReport(BaseParam data)
        {
            string filePath = MT.Library.CommonFunction.GetMapPathTemplate();
            var destinationPath = Path.Combine(filePath, $"{data.ReportID.ToString()}.xls");

            XlsFile result = new XlsFile(true);
            if (File.Exists(destinationPath))
            {
                result.Open(destinationPath);
                FlexCelReport fr = new FlexCelReport();
                LoadData(fr,data);
                fr.Run(result);
            }else
            {
                throw new Exception("Không có mẫu");
            }
            
            return result;
        }

        /// <summary>
        /// Xử lý render ra file Excel
        /// </summary>
        /// <param name="fr">Đối tượng xử lý file Excell</param>
        /// <param name="data">Giá trị tham số truyền từ CLient lên</param>
        /// Create by: dvthang:10.03.2018
        protected virtual void LoadData(FlexCelReport fr, BaseParam data)
        {

        }

        public byte[] ExportExcel(BaseParam data)
        {
            byte[] xlsInBytes;
            using (MemoryStream ms = new MemoryStream())
            {
                ExcelFile xls = CreateReport(data);
                xls.Save(ms, TFileFormats.Xls);
                xlsInBytes = ms.ToArray();
            }
            return xlsInBytes;
        }
        #endregion
    }
}
