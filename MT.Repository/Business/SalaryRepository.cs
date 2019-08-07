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
    public class SalaryRepository : BaseRepository<Salary>, ISalaryRepository
    {
        #region"Contructor"
        public SalaryRepository()
        {

        }
        public SalaryRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Function"
        /// <summary>
        /// Hàm lấy về danh sách lương theo năm: Các tham số
        /// Create by: manh:26.05.18
        /// </summary>
        /// <param name="Year">Năm</param>
        /// <returns></returns>
        public List<Salary> GetListSalarys(int Year)
        {
            return this.ExecuteReader<Salary>("[dbo].[Proc_GetListSalary_By_Year]", Year);
        }
        #endregion
    }
}
