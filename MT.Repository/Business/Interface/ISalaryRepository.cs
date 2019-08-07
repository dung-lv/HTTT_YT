using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    public interface ISalaryRepository : IBaseRepository<Salary>
    {
        /// <summary>
        /// Hàm lấy về danh sách lương theo năm: Các tham số
        /// Create by: manh:26.05.18
        /// </summary>
        /// <param name="Year">Năm</param>
        /// <returns></returns>
        List<Salary> GetListSalarys(int Year);
    }
}
