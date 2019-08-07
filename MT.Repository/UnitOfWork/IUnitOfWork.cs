using System.Data.Common;
using MT.Repository;
using MT.Library;
using MT.Model;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;

namespace MT.Repository
{
    public interface IUnitOfWork
    {
        /// <summary>
        /// Tạo transaction
        /// </summary>
        /// <returns>Trả về 1 transaction</returns>
        /// Create by: dvthang:19.04.2017
        void BeginTransaction();

        /// <summary>
        /// Tạo đối tượng command
        /// </summary>
        /// <returns>Trả về đối tượng command</returns>
        /// Create by: dvthang:18.04.2017
        DbCommand CreateCommand(bool isTransaction=true);

        /// <summary>
        /// Hàm thực hiện cất tất cả các repository trong cùng 1 giao dịch
        /// </summary>
        /// Create by: dvthang:18.04.2017
        void Commit();

        /// <summary>
        /// Hủy giao dịch
        /// </summary>
        /// Create by: dvthang:19.04.2017
        void RollBack();

        /// <summary>
        /// Hàm giải phóng transaction và các connection
        /// </summary>
        /// Create by: dvthang:18.04.2017
        void Dispose();

        /// <summary>
        /// Mở connection
        /// </summary>
        /// Create by: dvthang:20.04.2017
        void OpenConn();
        /// <summary>
        /// Đóng connection
        /// </summary>
        /// Create by: dvthang:20.04.2017
        void CloseConn();

        /// <summary>
        /// Trả về repository
        /// </summary>
        /// <param name="name">Tên đối tượng</param>
        /// <returns>Trả về repository</returns>
        /// Create by:dvthang:07.01.2018
        IRepository GetRepByName(string name);
    }
}
