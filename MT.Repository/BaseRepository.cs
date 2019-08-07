using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    /// <summary>
    /// Định nghĩa các hàm chung thao tác với database
    /// </summary>
    /// <typeparam name="TEntity">Đối tượng</typeparam>
    /// Create by: dvthang:19.04.2017
    public class BaseRepository<TEntity> : IBaseRepository<TEntity>, IRepository
        where TEntity : EntityBase
    {
        #region"Declare"

        /// <summary>
        /// Transaction
        /// </summary>
        /// Create by: dvthang:24.04.2017
        private DbTransaction m_ts;

        /// <summary>
        /// Transaction
        /// </summary>
        /// Create by: dvthang:24.04.2017
        private SqlDatabase m_DB;

        public DbTransaction TS
        {
            get
            {
                return m_ts;
            }
            set
            {
                m_ts = value;
            }
        }

        public SqlDatabase DB
        {
            get
            {
                return m_DB;
            }
            set
            {
                m_DB = value;
            }
        }
        #endregion
        #region"Contructor"
        /// <summary>
        /// Contructor không có tham số
        /// </summary>
        /// Create by:dvthang:24.04.2017
        public BaseRepository()
        {

        }

        /// <summary>
        /// Contructor
        /// </summary>
        /// <param name="DB">Đối tượng thao tác với DB</param>
        /// <param name="ts">Transaction</param>
        /// Create by: dvthang:24.04.2017
        public BaseRepository(SqlDatabase DB, DbTransaction ts)
        {
            this.Init(ts,DB);
        }
        #endregion

        /// <summary>
        /// Khởi tạo tham số
        /// </summary>
        /// <param name="TS"></param>
        /// <param name="DB"></param>
        /// Create by: dvthang:28.03.2018
        public void Init(DbTransaction TS, SqlDatabase DB)
        {
            this.DB = DB;
            this.TS = TS;
        }

        /// <summary>
        /// Lấy về danh sách data của bảng
        /// </summary>
        /// <returns>Danh sách dữ liệu của bảng TEntity</returns>
        /// Create by: dvthang:19.04.2017
        public IList GetAllData()
        {
            List<TEntity> lstData = null;
            try
            {
                string storeName = string.Format(Commonkey.mscSelectAll, Commonkey.Schema, typeof(TEntity).Name);
                using (DbCommand command = this.DB.GetStoredProcCommand(storeName))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    IDataReader reader = null;
                    if (m_ts != null)
                    {
                        reader = this.DB.ExecuteReader(command, m_ts);
                    }
                    else
                    {
                        reader = this.DB.ExecuteReader(command);
                    }
                    lstData = reader.FillCollection<TEntity>();
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return lstData;
        }

        /// <summary>
        /// Lấy về danh sách data của bảng
        /// </summary>
        /// <returns>Danh sách dữ liệu của bảng TEntity</returns>
        /// Create by: dvthang:19.04.2017
        public IList GetAllByEditMode(MT.Library.Enummation.EditMode editMode)
        {
            List<TEntity> lstData = null;
            try
            {
                string storeName = string.Format(Commonkey.mscSelectAllByEditMode, Commonkey.Schema, typeof(TEntity).Name);
                using (DbCommand command = this.DB.GetStoredProcCommand(storeName,editMode))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    IDataReader reader = null;
                    if (m_ts != null)
                    {
                        reader = this.DB.ExecuteReader(command, m_ts);
                    }
                    else
                    {
                        reader = this.DB.ExecuteReader(command);
                    }
                    lstData = reader.FillCollection<TEntity>();
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return lstData;
        }

        /// <summary>
        /// Lấy về 1 đối tượng của bảng theo masterID
        /// </summary>
        /// <returns>TEntity</returns>
        /// Create by: dvthang:19.04.2017
        public TEntity GetDataByID(object masterID)
        {
            TEntity oEntity = default(TEntity);
            try
            {
                string storeName = string.Format(Commonkey.mscSelectByID, Commonkey.Schema, typeof(TEntity).Name);
                IDataReader reader = null;
                if (m_ts != null)
                {
                    reader = this.DB.ExecuteReader(storeName, m_ts, masterID);
                }
                else
                {
                    reader = this.DB.ExecuteReader(storeName, masterID);
                }
                oEntity = reader.FillObject<TEntity>();
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return oEntity;
        }

        /// <summary>
        /// 
        /// Lấy về danh detail theo masterID
        /// </summary>
        /// <returns>List<TEntity></returns>
        /// Create by: dvthang:19.04.2017
        public IList GetSelectDetailByMasterID(object masterID)
        {
            List<TEntity> lstData = null;
            try
            {
                string storeName = string.Format(Commonkey.mscSelectByMasterID, Commonkey.Schema, typeof(TEntity).Name);
                IDataReader reader = null;
                if (m_ts != null)
                {
                    reader = this.DB.ExecuteReader(storeName, m_ts, masterID);
                }
                else
                {
                    reader = this.DB.ExecuteReader(storeName, masterID);
                }
                lstData = reader.FillCollection<TEntity>();
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return lstData;
        }

        /// <summary>
        /// Hàm cất 1 object
        /// </summary>
        /// <param name="oEntity">Đối tượng cần cất</param>
        /// <param name="hasIdentity">=true Khóa là tự tăng, ngược lại không phải</param>
        /// <returns>Trả về số rowEffect khi cất đối tượng</returns>
        /// Create by: dvthang:19.04.2017
        public ResultData SaveData(EntityBase oEntity, bool hasIdentity = false)
        {
            ResultData resultData = new ResultData();
            int rs = -1;
            try
            {
                string storeName = UtilityExtensions.GetStoreByEntityState(oEntity);
                if (!string.IsNullOrEmpty(storeName))
                {
                    using (DbCommand command = this.DB.GetSqlStringCommand(storeName))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        this.DB.DiscoverParameters(command);
                        UtilityExtensions.MappingObjectIntoStore(command, oEntity);
                        if (m_ts != null)
                        {
                            if (hasIdentity)
                            {
                                rs = Convert.ToInt32(this.DB.ExecuteScalar(command, m_ts));
                                resultData.PKValue = rs;
                            }
                            else
                            {
                                rs = this.DB.ExecuteNonQuery(command, m_ts);
                            }

                        }
                        else
                        {
                            if (hasIdentity)
                            {
                                rs = Convert.ToInt32(this.DB.ExecuteScalar(command));
                            }
                            else
                            {
                                rs = this.DB.ExecuteNonQuery(command);
                            }
                        }

                    }


                    if (rs > 0)
                    {
                        resultData.Success = true;
                        this.AfterSaveSuccess(oEntity);
                    }
                    else
                    {
                        resultData.Success = false;
                    }
                }
                else
                {
                    resultData.Success = false;
                    resultData.SetError(new Exception("Đối tượng không chưa gán EditMode."));
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                switch (ex.Number)
                {
                    case 2627:  // Unique constraint error
                        break;
                    case 547:   // Constraint check violation
                        break;
                    case 2601:
                        //Duplicated key row error
                        break;
                }
                resultData.SetError(ex);
            }
            catch (Exception ex)
            {
                resultData.SetError(ex);
            }
            return resultData;
        }


        /// <summary>
        /// Hàm cất 1 objec, dùng để lưu dữ liệu dạng bảng
        /// </summary>
        /// <param name="oEntity">Đối tượng cần cất</param>
        /// <param name="hasIdentity">=true Khóa là tự tăng, ngược lại không phải</param>
        /// <returns>Trả về số rowEffect khi cất đối tượng</returns>
        /// Create by: dvthang:19.04.2017
        public bool SaveDataTable(EntityBase oEntity)
        {
            bool isSuccess = false;
            int rs = -1;
            try
            {
                string storeName = String.Format(Commonkey.mscInsertUpdate, Commonkey.Schema, oEntity.GetType().Name);
                if (!string.IsNullOrEmpty(storeName))
                {
                    using (DbCommand command = this.DB.GetSqlStringCommand(storeName))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        this.DB.DiscoverParameters(command);
                        UtilityExtensions.MappingObjectIntoStore(command, oEntity);
                        if (m_ts != null)
                        {
                            rs = this.DB.ExecuteNonQuery(command, m_ts);
                            isSuccess = rs > 0;
                        }
                        else
                        {
                            rs = this.DB.ExecuteNonQuery(command);
                            isSuccess = rs > 0;
                        }

                    }

                }else
                {
                    throw new Exception($"Không thấy store:{storeName}");
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return isSuccess;
        }


        /// <summary>
        /// Lấy về danh sách dữ liệu từ store
        /// </summary>
        /// <typeparam name="T">Kiểu dữ liệu trả về</typeparam>       
        /// <param name="procedureName">Tên store</param>
        /// <param name="paramsValue">Danh sách tham số truyền vào</param>
        /// <returns>Danh sách dữ liệu kiểu T</returns>
        /// Create by: dvthang:20.04.2017
        public List<T> ExecuteReader<T>(string procedureName, params object[] paramsValue)
        {
            List<T> lstData = null;
            try
            {
                using (DbCommand command = this.DB.GetStoredProcCommand(procedureName, paramsValue))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    IDataReader reader = null;
                    if (m_ts != null)
                    {
                        reader = this.DB.ExecuteReader(command, m_ts);
                    }
                    else
                    {
                        reader = this.DB.ExecuteReader(command);
                    }
                    lstData = reader.FillCollection<T>();
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return lstData;
        }

        /// <summary>
        /// Lấy về danh sách dữ liệu từ store
        /// </summary>
        /// <typeparam name="T">Kiểu dữ liệu trả về</typeparam>
        /// <param name="procedureName">Tên store</param>
        /// <param name="paramsValue">Danh sách tham số truyền vào</param>
        /// <returns>Danh sách dữ liệu kiểu T</returns>
        /// Create by: dvthang:20.04.2017
       public List<Dictionary<string, object>> ExecuteReader(string procedureName, params object[] paramsValue)
        {
            List<Dictionary<string,object>> lstData = new List<Dictionary<string, object>>();
            try
            {
                using (IDataReader rd = this.GetDataReader(procedureName, paramsValue))
                {
                    while (rd.Read())
                    {
                        Dictionary<string, object> dic = new Dictionary<string, object>();
                        for(int i = 0; i < rd.FieldCount; i++)
                        {
                            string fieldName = rd.GetName(i);
                            if (!dic.ContainsKey(fieldName))
                            {
                                dic.Add(fieldName, rd.GetValue(i));
                            }
                        }
                        lstData.Add(dic);
                    }
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return lstData;
        }

        /// <summary>
        /// Lấy về đối tượng reader 
        /// </summary>
        /// <param name="procedureName">Tên procedureName</param>
        /// <param name="paramsValue">Danh sách tham số truyền vào</param>
        /// <returns>Trả về DataReader</returns>
        /// Create by: dvthang:24.06.2017
        public IDataReader GetDataReader(string procedureName, params object[] paramsValue)
        {
            IDataReader reader = null;
            try
            {
                using (DbCommand command = this.DB.GetStoredProcCommand(procedureName, paramsValue))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    if (m_ts != null)
                    {
                        reader = this.DB.ExecuteReader(command, m_ts);
                    }
                    else
                    {
                        reader = this.DB.ExecuteReader(command);
                    }
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return reader;
        }

        /// <summary>
        /// Lấy về đối tượng reader 
        /// </summary>
        /// <param name="query">Câu query</param>
        /// <returns>Trả về DataReader</returns>
        /// Create by: dvthang:24.06.2017
        public IDataReader GetDataReaderText(string query)
        {
            IDataReader reader = null;
            try
            {
                if (m_ts != null)
                {
                    reader = this.DB.ExecuteReader(m_ts, CommandType.Text, query);
                }
                else
                {
                    reader = this.DB.ExecuteReader(CommandType.Text, query);
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return reader;
        }

        /// <summary>
        /// Lấy về danh sách dữ liệu từ store
        /// </summary>
        /// <typeparam name="T">Kiểu dữ liệu trả về</typeparam>
        /// <param name="command">Đối tượng thực thi cầu lệnh SQL</param>
        /// <param name="paramsValue">Danh sách tham số truyền vào</param>
        /// <returns>Danh sách dữ liệu kiểu T</returns>
        /// Create by: dvthang:20.04.2017
        public List<T> ExecuteReader<T>(DbCommand command)
        {
            List<T> lstData = null;
            try
            {
                IDataReader reader = null;
                if (m_ts != null)
                {
                    reader = this.DB.ExecuteReader(command, m_ts);
                }
                else
                {
                    reader = this.DB.ExecuteReader(command);
                }

                lstData = reader.FillCollection<T>();
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return lstData;
        }

        /// <summary>
        /// Lấy về danh sách dữ liệu từ store
        /// </summary>
        /// <typeparam name="T">Kiểu dữ liệu trả về</typeparam>      
        /// <param name="query">Câu Query SQL</param>
        /// <returns>Danh sách dữ liệu kiểu T</returns>
        /// Create by: dvthang:20.04.2017
        public List<T> ExecuteReaderText<T>(string query)
        {
            List<T> lstData = null;
            try
            {
                using (DbCommand command = this.DB.GetSqlStringCommand(query))
                {
                    IDataReader reader = null;
                    if (m_ts != null)
                    {
                        reader = this.DB.ExecuteReader(command, m_ts);
                    }
                    else
                    {
                        reader = this.DB.ExecuteReader(command);
                    }
                    lstData = reader.FillCollection<T>();
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return lstData;
        }

        /// <summary>
        /// Thực thi thủ tục thường là Insert,Update,Delete
        /// </summary>      
        /// <param name="procedureName">Tên store</param>
        /// <param name="paramsValue">Danh sách tham số</param>
        /// <returns>True:Thành công, ngược lại thất bại</returns>
        public bool ExecuteNoneQuery(string procedureName, params object[] paramsValue)
        {
            bool bSuccess = false;
            try
            {
                if (m_ts != null)
                {
                    bSuccess = this.DB.ExecuteNonQuery(m_ts, procedureName, paramsValue) > 0;
                }
                else
                {
                    bSuccess = this.DB.ExecuteNonQuery(procedureName, paramsValue) > 0;
                }

            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return bSuccess;
        }

        /// <summary>
        /// Thực thi thủ tục thường là Insert,Update,Delete
        /// </summary>       
        /// <returns>True:Thành công, ngược lại thất bại</returns>
        public bool ExecuteNoneQuery(DbCommand command)
        {
            bool bSuccess = false;
            try
            {
                if (m_ts != null)
                {
                    bSuccess = this.DB.ExecuteNonQuery(command, m_ts) > 0;
                }
                else
                {
                    bSuccess = this.DB.ExecuteNonQuery(command) > 0;
                }

            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return bSuccess;
        }

        /// <summary>
        /// Thực thi thủ tục thường để lấy về 1 giá trị đơn
        /// </summary>       
        /// <param name="procedureName">Tên store</param>
        /// <param name="paramsValue">Danh sách tham số</param>
        /// <returns>True:Thành công, ngược lại thất bại</returns>
        public object ExecuteScalar(string procedureName, params object[] paramsValue)
        {
            object oValue = null;
            try
            {
                if (m_ts != null)
                {
                    oValue = this.DB.ExecuteScalar(m_ts, procedureName, paramsValue);
                }
                else
                {
                    oValue = this.DB.ExecuteScalar(procedureName, paramsValue);
                }

            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return oValue;
        }

        /// <summary>
        /// Thực thi 1 câu query trả về giá trị đơn
        /// </summary>       
        /// <param name="query">Tên câu query</param>
        /// <returns>Giá trị trả về có kiểu object</returns>
        public object ExecuteScalar(string query)
        {
            object oValue = null;
            try
            {
                if (m_ts != null)
                {
                    oValue = this.DB.ExecuteScalar(m_ts, CommandType.Text, query);
                }
                else
                {
                    oValue = this.DB.ExecuteScalar(CommandType.Text, query);
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return oValue;
        }

        /// <summary>
        /// Thực thi thủ tục thường để lấy về 1 giá trị đơn
        /// </summary>    
        /// <returns>True:Thành công, ngược lại thất bại</returns>
        public object ExecuteScalar(DbCommand command)
        {
            object oValue = null;
            try
            {
                if (m_ts != null)
                {
                    oValue = this.DB.ExecuteScalar(command, m_ts);
                }
                else
                {
                    oValue = this.DB.ExecuteScalar(command);
                }

            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return oValue;
        }
        #region"Process Save Data"

        /// <summary>
        /// Sau khi lưu thành công các đối tượng muốn làm gì tiếp
        /// </summary>
        /// <returns>True: CHo commit, ngược lại thì không</returns>
        /// Create by: dvthang:07.01.2018
        public virtual ResultData AfterSaveSuccess(EntityBase master)
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            return resultData;
        }
        /// <summary>
        /// Hàm xóa đối tượng theo ID
        /// </summary>
        /// <param name="id">ID của đối tượng cần xóa</param>
        /// <returns>True xóa thành công, ngược lại xóa thất bại</returns>
        /// Create by: dvthang:07.01.2018
        public ResultData DeleteByID(Guid id)
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            int rowEffect = -1;
            try
            {
                string storeName = string.Format(Commonkey.mscDeleteByID, Commonkey.Schema, typeof(TEntity).Name);
                if (!string.IsNullOrEmpty(storeName))
                {
                    using (DbCommand command = this.DB.GetStoredProcCommand(storeName, id))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        if (m_ts != null)
                        {
                            rowEffect = this.DB.ExecuteNonQuery(command, m_ts);
                        }
                        else
                        {
                            rowEffect = this.DB.ExecuteNonQuery(command);
                        }
                        resultData.Success = rowEffect > 0;
                        if (resultData.Success)
                        {
                            resultData = AfterDeleteSuccess(id);
                        }
                    }
                }
                else
                {
                    resultData.SetError(new Exception($"Không tìm thấy store {storeName}"));
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                resultData.SetError(ex);
            }
            catch (Exception ex)
            {
                resultData.SetError(ex);
            }
            return resultData;
        }

        /// <summary>
        /// Sau khi xóa thành công đối tượng
        /// </summary>
        /// <returns>True: Cho commit, ngược lại thì không</returns>
        /// Create by: dvthang:07.01.2018
        public ResultData AfterDeleteSuccess(Guid id)
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            return resultData;
        }

        /// <summary>
        /// Hàm luôn thực hiện insert đối tượng 
        /// </summary>
        /// <param name="oEntity">Đối tượng</param>
        /// <returns>True: Thành công, ngược lại thất bại</returns>
        public int Insert(EntityBase oEntity, bool isIdentity = false)
        {
            int result = -1;
            try
            {
                oEntity.EditMode = Enummation.EditMode.Add;
                string storeName = MT.Library.UtilityExtensions.GetStoreInsert(oEntity);
                using (DbCommand command = this.DB.GetStoredProcCommand(storeName))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    this.DB.DiscoverParameters(command);
                    MT.Library.UtilityExtensions.MappingObjectIntoStore(command, oEntity);
                    if (m_ts != null)
                    {
                        if (isIdentity)
                        {
                            result = Convert.ToInt32(this.DB.ExecuteScalar(command, m_ts));
                        }
                        else
                        {
                            result = this.DB.ExecuteNonQuery(command, m_ts);
                        }
                    }
                    else
                    {
                        if (isIdentity)
                        {
                            result = Convert.ToInt32(this.DB.ExecuteScalar(command));
                        }
                        else
                        {
                            result = this.DB.ExecuteNonQuery(command);
                        }
                    }
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        /// <summary>
        /// Hàm luôn thực hiện Update đối tượng 
        /// </summary>
        /// <param name="oEntity">Đối tượng</param>
        /// <returns>True: Thành công, ngược lại thất bại</returns>
        public bool Update(EntityBase oEntity)
        {
            int result = -1;
            try
            {
                oEntity.EditMode = Enummation.EditMode.Edit;
                string storeName = MT.Library.UtilityExtensions.GetStoreUpdate(oEntity);
                using (DbCommand command = this.DB.GetStoredProcCommand(storeName))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    this.DB.DiscoverParameters(command);
                    MT.Library.UtilityExtensions.MappingObjectIntoStore(command, oEntity);
                    if (m_ts != null)
                    {
                        result = this.DB.ExecuteNonQuery(command, m_ts);
                    }
                    else
                    {
                        result = this.DB.ExecuteNonQuery(command);
                    }
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result > 0;
        }

        /// <summary>
        /// Hàm luôn thực hiện Xóa đối tượng 
        /// </summary>
        /// <param name="oEntity">Đối tượng</param>
        /// <returns>True: Thành công, ngược lại thất bại</returns>
        public bool Delete(EntityBase oEntity)
        {
            int result = -1;
            try
            {
                oEntity.EditMode = Enummation.EditMode.Delete;
                string storeName = MT.Library.UtilityExtensions.GetStoreDelete(oEntity);
                using (DbCommand command = this.DB.GetStoredProcCommand(storeName, oEntity.GetIdentity()))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    if (m_ts != null)
                    {
                        result = this.DB.ExecuteNonQuery(command, m_ts);
                    }
                    else
                    {
                        result = this.DB.ExecuteNonQuery(command);
                    }
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result > 0;
        }

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
        public ResultData GetDataPaging(string sort, int page, int limit, string where, string columns = "*", params object[] arrParams)
        {
            ResultData oResultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            try
            {
                string storeName = string.Format(MT.Library.Commonkey.mscSelectPaging, "dbo", typeof(TEntity).Name);
                oResultData = this.GetDataPaging(storeName, sort, page, limit, where, columns, arrParams);
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                oResultData.SetError(ex);
                throw ex;
            }
            catch (Exception ex)
            {
                oResultData.SetError(ex);
                throw ex;
            }
            return oResultData;
        }


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
        public ResultData GetDataPaging(string storeName, string sort, int page, int limit, string where, string columns = "*", params object[] arrParams)
        {
            ResultData oResultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            try
            {
                DbParameter pOutput = null;
                using (DbCommand command = this.DB.GetStoredProcCommand(storeName))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    this.DB.DiscoverParameters(command);
                    if (command.Parameters.Count > 0)
                    {
                        command.Parameters.RemoveAt(0);
                        int paramIndex = 0;

                        for (int i = 0; i <= command.Parameters.Count - 1; i++)
                        {
                            DbParameter dbParam = command.Parameters[i];
                            string paramName = dbParam.ParameterName.Replace("@", "").ToLower();

                            switch (paramName)
                            {
                                case "sort":
                                    if (!string.IsNullOrEmpty(sort))
                                    {
                                        dbParam.Value = sort;
                                    }
                                    else
                                    {
                                        dbParam.Value = DBNull.Value;
                                    }
                                    break;
                                case "page":
                                    dbParam.Value = page;
                                    break;
                                case "limit":
                                    dbParam.Value = limit;
                                    break;
                                case "where":
                                    dbParam.Value = where;
                                    break;
                                case "columns":
                                    if (!string.IsNullOrEmpty(columns))
                                    {
                                        dbParam.Value = columns;
                                    }
                                    else
                                    {
                                        dbParam.Value = "*";
                                    }
                                    break;
                                case "totalcount":
                                    pOutput = command.Parameters[i];
                                    pOutput.Value = 0;
                                    break;
                                default:
                                    if (arrParams != null)
                                    {
                                        if (arrParams[paramIndex] != null)
                                        {
                                            dbParam.Value = arrParams[paramIndex];
                                        }
                                        else
                                        {
                                            dbParam.Value = DBNull.Value;
                                        }
                                        paramIndex++;
                                    }
                                    break;
                            }

                        }
                    }

                    using (IDataReader rd = this.DB.ExecuteReader(command))
                    {
                        oResultData.Data = rd.FillCollection<TEntity>(false);
                        if (rd.NextResult())
                        {
                            Dictionary<string, object> dicSummary = new Dictionary<string, object>();
                            while (rd.Read())
                            {
                                for (int i = 0; i < rd.FieldCount; i++)
                                {
                                    dicSummary.Add(rd.GetName(i), rd[i]);
                                }
                            }
                            oResultData.SummaryData = dicSummary;
                        };
                    }
                    if (pOutput != null)
                    {
                        oResultData.Total = pOutput.Value as int? ?? default(int);
                    }
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                oResultData.SetError(ex);
                throw ex;
            }
            catch (Exception ex)
            {
                oResultData.SetError(ex);
                throw ex;
            }
            return oResultData;
        }

        /// <summary>
        /// Thực hiện check phát sinh dữ liệu trước khi xóa
        /// </summary>
        /// <returns>True:Có phát sinh, ngược lại không phát sinh</returns>
        /// Create by: dvthang:28.03.2018
       public bool CheckIncurrentData(string tableName, Guid Id)
        {
            return Convert.ToBoolean(this.ExecuteScalar("dbo.Proc_CheckIncurrentData", tableName, Id));
        }
        #endregion
    }
}
