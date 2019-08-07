using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    public interface IWageCoefficientRepository : IBaseRepository<WageCoefficient>
    {
        /// <summary>
        /// Hàm lấy về danh sách hệ số lương theo cấp quản lý đề tài: Các tham số
        /// Create by: manh:26.05.18
        /// </summary>
        /// <param name="Year">Năm</param>
        /// <returns></returns>
        List<WageCoefficient> GetListWageCoefficients(Guid? GrantRatioID, int Year);

    }
}
