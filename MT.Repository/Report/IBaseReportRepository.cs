using MT.Model;
using System.IO;

namespace MT.Repository
{
    /// <summary>
    /// In bảng chấm công
    /// </summary>
    /// Create by: laipv:10.03.2018
    public interface IBaseReportRepository
    {
        byte[] ExportExcel(BaseParam data);
    }
}
