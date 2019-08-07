using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    #region IAspNetUsersRepository:IBaseRepository<DocumentType>
    /// <summary>
    /// This object represents the properties and methods of a IDocumentTypeRepository:IBaseRepository<DocumentType>.
    /// </summary>
    public interface IAspNetUsersRepository : IBaseRepository<AspNetUsers>
    {

        #region"Sub/Func"
        /// <summary>
        /// Lấy về danh sách dữ liệu phần trang
        /// </summary>
        /// <param name="sort">Sắp xếp</param>
        /// <param name="page">Trang hiện tại</param>
        /// <param name="limit">Số bản ghi trên 1 trang</param>
        /// <param name="where">Điều kiện where</param>
        /// <param name="columns">Cột</param>
        /// <param name="arrParams">Danh sách tham số mở rộng</param>
        /// <returns>Danh sách dữ liệu</returns>
        /// Create by: dvthang:11.01.2018
        ResultData GetAspNetUsersDataPaging(string sort, int page, int limit, string where, string columns = "*", params object[] arrParams);
        List<AspNetUsers> GetAspNetUsersbyPermissionInfor(int editMode);
        List<AspNetUsers> GetAspNetUsersbyPermissionInforTempStore(int editMode);
        ResultData ValidateBeforeSave(AspNetUsers master);
        #endregion
    }
    #endregion
}

