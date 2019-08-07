using MT.Library;
using MT.Model;
using MT.Repository;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;

namespace APIBE.Controllers
{
    [Authorize]
    public class BaseEditTableController<TEntity>
        : ApiController
        where TEntity : EntityBase
    {

        #region"Declare"
        protected readonly IUnitOfWork UnitOfWork;
        protected IRepository Rep;
        #endregion
        #region"Contructor"
        public BaseEditTableController(IUnitOfWork UnitOfWork)
        {
            this.UnitOfWork = UnitOfWork;
            Rep = this.UnitOfWork.GetRepByName(typeof(TEntity).Name);
        }
        #endregion"Contructor"

        #region"Sub/Func"

        /// <summary>
        /// Lấy về đối tượng rep
        /// </summary>
        /// <returns>Trả về Rep</returns>
        /// Create by: dvthang:29.03.2018
        protected IRepository GetRep()
        {
            this.Rep = this.UnitOfWork.GetRepByName(typeof(TEntity).Name);
            return this.Rep;
        }

        /// <summary>
        /// Lấy về đối tượng rep
        /// </summary>
        /// <returns>Trả về Rep</returns>
        /// Create by: dvthang:29.03.2018
        protected IRepository GetRep(string repName)
        {
            this.Rep = this.UnitOfWork.GetRepByName(repName);
            return this.Rep;
        }

        /// <summary>
        /// Action để lưu dữ liệu dạng bảng
        /// </summary>
        /// <param name="datas">Danh sách dữ liệu dạng bảng</param>
        /// <returns>Lưu thành công:true, ngược lại thất bại</returns>
        /// Create by: dvthang:05.03.2018
        [HttpPost]
        [ActionName("edittable")]
        public virtual ResultData EditTable([FromBody]List<TEntity> datas)
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            if (datas != null && datas.Count > 0)
            {
                resultData = this.ValidateDataTable(datas);
                string tableName = typeof(TEntity).Name;
                this.UnitOfWork.BeginTransaction();

                IRepository repMaster = this.UnitOfWork.GetRepByName(tableName);

                if (repMaster == null)
                {
                    resultData.SetError(new Exception($"Chưa khai repository cho {tableName}"));
                }
                try
                {
                    foreach (TEntity oItem in datas)
                    {
                        if (resultData.Success)
                        {
                            resultData.Success = repMaster.SaveDataTable(oItem);
                            if (!resultData.Success)
                            {
                                break;
                            }
                        }

                    }

                    if (resultData.Success)
                    {
                        this.UnitOfWork.Commit();
                    }
                    else
                    {
                        this.UnitOfWork.RollBack();
                    }
                }
                catch (SqlException ex)
                {
                    this.UnitOfWork.RollBack();
                    resultData.SetError(ex);
                }
                catch (Exception ex)
                {
                    this.UnitOfWork.RollBack();
                    resultData.SetError(ex);
                }
                finally
                {
                    this.UnitOfWork.Dispose();
                }
            }
            return resultData;
        }
        #endregion

        #region"Overrides"

        /// <summary>
        /// Thực hiện xử lý validate thông tin - dùng khi lưu dữ liệu dạng bảng
        /// </summary>
        /// <param name="master">Thông tin master</param>
        /// <param name="details">Danh sách detail</param>
        /// Create by: dvthang:07.01.2018
        protected virtual ResultData ValidateDataTable(List<TEntity> datas)
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            return resultData;
        }

        #endregion
    }
}
