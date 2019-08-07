using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System;
using System.Data.Common;
using MT.Model;
using System.Collections;

namespace MT.Repository
{
    /// <summary>
    /// Định nghĩa các hàm chung thao tác với database
    /// </summary>
    /// <typeparam name="TEntity">Đối tượng</typeparam>
    /// Create by: dvthang:19.04.2017
    public interface IRepository
    {

        /// <summary>
        /// Transaction
        /// </summary>
        /// Create by: dvthang:24.04.2017
        DbTransaction TS { get; set; }

        /// <summary>
        /// Đối tượng thao tác với database
        /// </summary>
        /// Create by: dvthang:20.04.2017
        SqlDatabase DB { get; set; }

        /// <summary>
        /// Khởi tạo tham số
        /// </summary>
        /// <param name="TS"></param>
        /// <param name="DB"></param>
        /// Create by: dvthang:28.03.2018
        void Init(DbTransaction TS, SqlDatabase DB);

        /// <summary>
        /// Hàm cất 1 object
        /// </summary>
        /// <param name="oEntity">Đối tượng cần cất</param>
        /// <param name="hasIdentity">=true Khóa là tự tăng, ngược lại không phải</param>
        /// <returns>Trả về số rowEffect khi cất đối tượng</returns>
        /// Create by: dvthang:19.04.2017
        ResultData SaveData(EntityBase oEntity, bool hasIdentity = false);

        /// <summary>
        /// Hàm cất 1 objec, dùng để lưu dữ liệu dạng bảng
        /// </summary>
        /// <param name="oEntity">Đối tượng cần cất</param>
        /// <param name="hasIdentity">=true Khóa là tự tăng, ngược lại không phải</param>
        /// <returns>Trả về số rowEffect khi cất đối tượng</returns>
        /// Create by: dvthang:19.04.2017
        bool SaveDataTable(EntityBase oEntity);
        /// <summary>
        /// Sau khi lưu thành công các đối tượng muốn làm gì tiếp
        /// </summary>
        /// <returns>True: CHo commit, ngược lại thì không</returns>
        /// Create by: dvthang:07.01.2018
        ResultData AfterSaveSuccess(EntityBase master);

        /// <summary>
        /// Hàm xóa đối tượng theo ID
        /// </summary>
        /// <param name="id">ID của đối tượng cần xóa</param>
        /// <returns>True xóa thành công, ngược lại xóa thất bại</returns>
        /// Create by: dvthang:07.01.2018
        ResultData DeleteByID(Guid id);

        /// <summary>
        /// Sau khi xóa thành công đối tượng
        /// </summary>
        /// <returns>True: Cho commit, ngược lại thì không</returns>
        /// Create by: dvthang:07.01.2018
        ResultData AfterDeleteSuccess(Guid id);

        /// <summary>
        /// Hàm luôn thực hiện insert đối tượng 
        /// </summary>
        /// <param name="oEntity">Đối tượng</param>
        /// <param name="hasIdentity">=true insert kiểu tự tăng</param>
        /// <returns>True: Thành công, ngược lại thất bại</returns>
        int Insert(EntityBase oEntity, bool isIdentity = false);

        /// <summary>
        /// Hàm luôn thực hiện Update đối tượng 
        /// </summary>
        /// <param name="oEntity">Đối tượng</param>
        /// <returns>True: Thành công, ngược lại thất bại</returns>
        bool Update(EntityBase oEntity);

        /// <summary>
        /// Hàm luôn thực hiện Xóa đối tượng 
        /// </summary>
        /// <param name="oEntity">Đối tượng</param>
        /// <returns>True: Thành công, ngược lại thất bại</returns>
        bool Delete(EntityBase oEntity);

        /// <summary>
        /// Lấy về danh sách data của bảng
        /// </summary>
        /// <returns>Danh sách dữ liệu của bảng TEntity</returns>
        /// Create by: dvthang:19.04.2017
         IList GetAllByEditMode(MT.Library.Enummation.EditMode editMode);

        /// <summary>
        /// Lấy về danh sách data của bảng
        /// </summary>
        /// <returns>Danh sách dữ liệu của bảng TEntity</returns>
        /// Create by: dvthang:19.04.2017
        IList GetAllData();   
           

        /// <summary>
        /// Lấy về danh detail theo masterID
        /// </summary>
        /// <returns>List<TEntity></returns>
        /// Create by: dvthang:19.04.2017
        IList GetSelectDetailByMasterID(object masterID);

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
        ResultData GetDataPaging(string sort, int page, int limit, string where, string columns = "*", params object[] arrParams);

        /// <summary>
        /// Lấy về danh sách dữ liệu phần trang
        /// </summary>
        /// <param name="storeName">Tên store</param>
        /// <param name="sort">Sắp xếp</param>
        /// <param name="page">Trang hiện tại</param>
        /// <param name="limit">Số bản ghi trên 1 trang</param>
        /// <param name="where">Điều kiện where</param>
        /// <param name="columns">Cột</param>
        /// <param name="arrParams">Danh sách tham số mở rộng</param>
        /// <returns>Danh sách dữ liệu</returns>
        /// Create by: dvthang:11.01.2018
        ResultData GetDataPaging(string storeName,string sort, int page, int limit, string where, string columns = "*", params object[] arrParams);
        
        /// <summary>
        /// Thực hiện check phát sinh dữ liệu trước khi xóa
        /// </summary>
        /// <returns>True:Có phát sinh, ngược lại không phát sinh</returns>
        /// Create by: dvthang:28.03.2018
        bool CheckIncurrentData(string tableName, Guid Id);
    }
}
