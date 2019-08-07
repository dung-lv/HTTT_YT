using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
namespace MT.Repository
{
    /// <summary>
    /// Bảng chấm công (kinh phí) thực hiện đề tài
    /// </summary>
    /// Create by: laipv:03.03.2018
    public class WageCoefficientRepository : BaseRepository<WageCoefficient>, IWageCoefficientRepository
    {
        #region"Contructor"
        public WageCoefficientRepository()
        {

        }
        public WageCoefficientRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Function"
        /// <summary>
        /// Hàm lấy về danh sách hệ số lương theo cấp quản lý đề tài: Các tham số
        /// Create by: manh:26.05.18
        /// </summary>
        /// <param name="Year">Năm</param>
        /// <returns></returns>
        public List<WageCoefficient> GetListWageCoefficients(Guid? GrantRatioID, int Year)
        {
            return this.ExecuteReader<WageCoefficient>("[dbo].[Proc_GetListWageCoefficient_By_GrantRatioID_Year]", GrantRatioID, Year);
        }
        #endregion
    }
}
