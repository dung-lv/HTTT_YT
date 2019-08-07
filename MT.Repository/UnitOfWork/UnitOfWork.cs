using System;
using System.Collections.Generic;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System.Data;
using System.Data.Common;
using MT.Repository;
using MT.Library;
using MT.Model;
using MT.Repository.Gantt;

namespace MT.Repository
{
    public class UnitOfWork : IUnitOfWork
    {
        #region"Declare"
        /// <summary>
        /// Đối tượng thao tác với database
        /// </summary>
        /// Create by: dvthang:19.04.2017
        private SqlDatabase m_DB;

        DbTransaction transaction = null;

        DbConnection connection = null;
        /// <summary>
        /// Lưu lại danh sách các repository
        /// </summary>
        /// Create by: dvthang:20.04.2017
        private Dictionary<string, IRepository> dicRepository = null;

        #endregion
        #region"Property"
        public SqlDatabase DB
        {
            get
            {
                if (m_DB == null)
                {
                    m_DB = new SqlDatabase(MT.Library.UtilityExtensions.GetConnectionString());
                }
                return m_DB;
            }
            private set
            {
                m_DB = value;
            }
        }
        #endregion
        #region"Contructor"

        /// <summary>
        /// Contructor có tham số 
        /// </summary>
        /// <param name="DB">Đối tượng thao tác với database</param>
        /// Create by: dvthang:19.04.2017
        public UnitOfWork()
        {
        }

        /// <summary>
        /// Contructor có tham số 
        /// </summary>
        /// <param name="DB">Đối tượng thao tác với database</param>
        /// Create by: dvthang:19.04.2017
        public UnitOfWork(SqlDatabase DB)
        {
            this.DB = DB;
            this.connection = this.DB.CreateConnection();
        }
        #endregion
        #region"Repository"
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Tạo đối tượng command thao tác với DB
        /// </summary>
        /// <returns>Trả về IDbCommand</returns>
        /// Create by: dvthang:19.04.2017
        public DbCommand CreateCommand(bool isTransaction = true)
        {
            DbCommand command = null;
            if (this.connection == null)
            {
                this.connection = this.DB.CreateConnection();
            }
            if (this.connection != null)
            {
                this.OpenConn();
                command = this.connection.CreateCommand();
                if (isTransaction)
                {
                    this.BeginTransaction();
                    command.Transaction = this.transaction;
                }

            }
            return command;
        }

        /// <summary>
        /// Hàm cất tất cả các thông tin trong cùng 1 giao dịch
        /// </summary>
        /// Create by: dvthang:19.04.2017
        public void Commit()
        {
            if (this.transaction != null)
            {
                this.transaction.Commit();
                this.transaction = null;
            }
        }

        /// <summary>
        /// Giải phóng Connection và giao dịch
        /// </summary>
        /// Create by: dvthang:19.04.2017
        public void Dispose()
        {
            if (this.transaction != null)
            {
                this.transaction.Rollback();
                this.transaction = null;
            }

            if (this.connection != null)
            {
                this.connection.Close();
                this.connection = null;
            }
        }
        #endregion

        /// <summary>
        /// Tạo giao dịch
        /// </summary>
        /// Create by: dvthang:19.04.2017
        public void BeginTransaction()
        {
            if (this.transaction == null)
            {
                if (this.connection == null)
                {
                    this.connection = this.DB.CreateConnection();
                }
                this.OpenConn();
                this.transaction = this.connection.BeginTransaction();
            }
        }

        /// <summary>
        /// Hủy 1 giao dịch
        /// </summary>
        /// Create by:dvthang:19.04.2017
        public void RollBack()
        {
            if (this.transaction != null)
            {
                this.transaction.Rollback();
                this.transaction = null;
            }
        }

        /// <summary>
        /// Mở connection
        /// </summary>
        /// Create by: dvthang:20.04.2017
        public void OpenConn()
        {
            if (this.connection != null && this.connection.State == ConnectionState.Closed)
            {
                this.connection.Open();
            }
        }
        /// <summary>
        /// Đóng connection
        /// </summary>
        /// Create by: dvthang:20.04.2017
        public void CloseConn()
        {
            if (this.connection != null && this.connection.State == ConnectionState.Open)
            {
                this.connection.Close();
            }
        }

        /// <summary>
        /// Trả về repository
        /// </summary>
        /// <param name="name">Tên đối tượng</param>
        /// <returns>Trả về repository</returns>
        /// Create by:dvthang:07.01.2018
        public IRepository GetRepByName(string name)
        {
            IRepository repository = null;

            if (dicRepository != null && dicRepository.ContainsKey(name))
            {
                repository = dicRepository[name];
                repository.Init(this.transaction, this.m_DB);
            }
            else
            {
                repository = CreateRepByName(name);
                if (dicRepository == null)
                {
                    dicRepository = new Dictionary<string, IRepository>();
                }
                if (!dicRepository.ContainsKey(name))
                {
                    dicRepository.Add(name, repository);
                }
            }
            //Nếu đã hủy connection thì tạo lại
            if (this.connection == null)
            {
                this.connection = this.DB.CreateConnection();
                this.connection.Open();
            }
            return repository;
        }

        /// <summary>
        /// Tạo repository tại đây
        /// </summary>
        /// <param name="name">Tên đối tượng</param>
        /// <returns>IRepository</returns>
        /// Create by: dvthang:07.01.2018
        private IRepository CreateRepByName(string name)
        {
            IRepository repository = null;
            switch (name)
            {
                case "AspNetUsers":
                    repository = new AspNetUsersRepository(this.DB, this.transaction);
                    break;
                case "Customer":
                    repository = new CustomerRepository(this.DB, this.transaction);
                    break;
                case "Tokens":
                    repository = new TokensRepository(this.DB, this.transaction);
                    break;
                case "MedicalRecord":
                    repository = new MedicalRecordRepository(this.DB, this.transaction);
                    break;
                case "MeasurementStandard":
                    repository = new MeasurementStandardRepository(this.DB, this.transaction);
                    break;
            }
            return repository;
        }
    }
}
