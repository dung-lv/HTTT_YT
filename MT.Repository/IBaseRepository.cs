using MT.Library;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MT.Model;
namespace MT.Repository
{
    /// <summary>
    /// Định nghĩa các hàm chung thao tác với database
    /// </summary>
    /// <typeparam name="TEntity">Đối tượng</typeparam>
    /// Create by: dvthang:19.04.2017
    public interface IBaseRepository<TEntity>:IRepository
        where TEntity:EntityBase
    {
        /// <summary>
        /// Lấy về 1 đối tượng của bảng theo masterID
        /// </summary>
        /// <returns>TEntity</returns>
        /// Create by: dvthang:19.04.2017
        TEntity GetDataByID(object masterID);

        /// <summary>
        /// Lấy về danh sách dữ liệu từ store
        /// </summary>
        /// <typeparam name="T">Kiểu dữ liệu trả về</typeparam>
        /// <param name="procedureName">Tên store</param>
        /// <param name="paramsValue">Danh sách tham số truyền vào</param>
        /// <returns>Danh sách dữ liệu kiểu T</returns>
        /// Create by: dvthang:20.04.2017
        List<T> ExecuteReader<T>(string procedureName, params object[] paramsValue);

        /// <summary>
        /// Lấy về danh sách dữ liệu từ store
        /// </summary>
        /// <typeparam name="T">Kiểu dữ liệu trả về</typeparam>
        /// <param name="procedureName">Tên store</param>
        /// <param name="paramsValue">Danh sách tham số truyền vào</param>
        /// <returns>Danh sách dữ liệu kiểu T</returns>
        /// Create by: dvthang:20.04.2017
        List<Dictionary<string,object>> ExecuteReader(string procedureName, params object[] paramsValue);

        /// <summary>
        /// Lấy về danh sách dữ liệu từ store
        /// </summary>
        /// <typeparam name="T">Kiểu dữ liệu trả về</typeparam>
        /// <param name="command">Đối tượng thực thi cầu lệnh SQL</param>
        /// <returns>Danh sách dữ liệu kiểu T</returns>
        /// Create by: dvthang:20.04.2017
        List<T> ExecuteReader<T>(DbCommand command);

        /// <summary>
        /// Lấy về danh sách dữ liệu từ store
        /// </summary>
        /// <typeparam name="T">Kiểu dữ liệu trả về</typeparam>
        /// <param name="query">Câu Query SQL</param>
        /// <returns>Danh sách dữ liệu kiểu T</returns>
        /// Create by: dvthang:20.04.2017
        List<T> ExecuteReaderText<T>(string query);

        /// <summary>
        /// Thực thi thủ tục thường là Insert,Update,Delete
        /// </summary>
        /// <param name="procedureName">Tên store</param>
        /// <param name="paramsValue">Danh sách tham số</param>
        /// <returns>True:Thành công, ngược lại thất bại</returns>
        bool ExecuteNoneQuery(string procedureName, params object[] paramsValue);

        /// <summary>
        /// Thực thi thủ tục thường là Insert,Update,Delete
        /// </summary>
        /// <returns>True:Thành công, ngược lại thất bại</returns>
        bool ExecuteNoneQuery(DbCommand command);

        /// <summary>
        /// Thực thi thủ tục thường để lấy về 1 giá trị đơn
        /// </summary>
        /// <param name="procedureName">Tên store</param>
        /// <param name="paramsValue">Danh sách tham số</param>
        /// <returns>True:Thành công, ngược lại thất bại</returns>
        object ExecuteScalar(string procedureName, params object[] paramsValue);

        /// <summary>
        /// Thực thi thủ tục thường để lấy về 1 giá trị đơn
        /// </summary>
        /// <returns>True:Thành công, ngược lại thất bại</returns>
        object ExecuteScalar(DbCommand command);

       
    }
}
