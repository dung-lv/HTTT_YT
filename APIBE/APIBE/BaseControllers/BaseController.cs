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
    public class BaseController<TEntity>
        : ApiController
        where TEntity : EntityBase
    {

        #region"Declare"
        protected readonly IUnitOfWork UnitOfWork;
        protected IRepository Rep;
        #endregion
        #region"Contructor"
        public BaseController(IUnitOfWork UnitOfWork)
        {
            this.UnitOfWork = UnitOfWork;
            Rep = this.GetRep();
        }
        #endregion"Contructor"

        #region"Sub/Func"

        /// <summary>
        /// Lấy về đối tượng rep
        /// </summary>
        /// <returns>Trả về Rep</returns>
        /// Create by: dvthang:29.03.2018
        protected virtual IRepository GetRep()
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
        [HttpPost]
        [HttpPut]
        public virtual ResultData Post(TEntity entity)
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };

            resultData = SubmitData(entity, new List<EntityBase>());

            return resultData;
        }

        [HttpDelete]
        public virtual ResultData Delete([FromBody]List<Guid> lstID)
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            if (lstID != null && lstID.Count > 0)
            {
                resultData = DeleteData(lstID);
            }
            return resultData;
        }
        /// <summary>
        /// Lấy tất cả dữ liệu theo mode của form
        /// </summary>
        /// <returns>Trả về danh sách data</returns>
        /// Create by: dvthang:20.1.2018
        [HttpGet]
        public virtual ResultData GetAllByEditMode(MT.Library.Enummation.EditMode editMode)
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            try
            {
                resultData.Data = this.GetRep().GetAllByEditMode(editMode);
            }
            catch (Exception ex)
            {
                resultData.SetError(ex);
            }
            return resultData;
        }

        /// <summary>
        /// Lấy tất cả dữ liệu
        /// </summary>
        /// <returns>Trả về danh sách data</returns>
        /// Create by: dvthang:20.1.2018
        [HttpGet]
        public virtual ResultData GetAll()
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            try
            {
                resultData.Data = this.GetRep().GetAllData();
            }
            catch (Exception ex)
            {
                resultData.SetError(ex);
            }
            return resultData;
        }

        [HttpGet]
        public virtual ResultData GetByID(Guid masterID)
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            try
            {
                resultData.Data = new BaseRepository<TEntity>().GetDataByID(masterID);
            }
            catch (Exception ex)
            {
                resultData.SetError(ex);
            }
            return resultData;
        }

        [HttpGet]
        public virtual ResultData GetByMasterID(Guid masterId)
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            try
            {
                resultData.Data = this.GetRep().GetSelectDetailByMasterID(masterId);
            }
            catch (Exception ex)
            {
                resultData.SetError(ex);
            }
            return resultData;
        }

        /// <summary>
        /// Action phân trang dữ liệu
        /// </summary>
        /// <param name="page">Trang hiện tại</param>
        /// <param name="limit">Số bản ghi trên 1 trang</param>
        /// <param name="sort">Sắp xếp</param>
        /// <param name="sWhere">ĐIều kiện tìm kiếm</param>
        /// <returns>Danh sách dữ liệu phân trang</returns>
        /// create by: dvthang:19.01.2018
        [HttpGet]
        public virtual ResultData Get(int page, int start, int limit, string sort = "", string filter = "")
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            try
            {
                string sWhere = string.Empty;
                if (!string.IsNullOrEmpty(filter))
                {
                    sWhere = MTGrid.BuildWhere(CommonFunction.DeserializeObject<List<Filtering>>(filter));
                }
                resultData = this.GetRep().GetDataPaging(sort, page, limit, sWhere);
            }
            catch (Exception ex)
            {
                resultData.SetError(ex);
            }
            return resultData;
        }

        /// <summary>
        /// Hàm thực hiện lưu data
        /// </summary>
        /// <param name="master">Thông tin master</param>
        /// <returns>true:Lưu thành công, ngược lại thất bại</returns>
        /// Create by: dvthang:07.01.2018
        private ResultData SubmitData(TEntity master, IList<EntityBase> details)
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };

            resultData = this.ValidateBeforeSave(master, details);
            if (resultData.Success)
            {
                try
                {
                    this.PreSaveData(master, details);

                    string tableName = typeof(TEntity).Name;
                    this.UnitOfWork.BeginTransaction();

                    this.Rep = this.GetRep(tableName);
                    if (this.Rep == null)
                    {
                        resultData.SetError(new Exception($"Chưa khai repository cho {tableName}"));
                    }
                    string keyName = master.GetKeyName();
                    Type type = master.GetPropertyType<TEntity>(keyName);
                    Guid masterID = Guid.NewGuid();
                    if (type.Equals(typeof(Guid)))
                    {
                        if (master.EditMode == Enummation.EditMode.Add ||
                            master.EditMode == Enummation.EditMode.Duplicate)
                        {
                            master.SetValue(keyName, masterID);
                        }
                        else
                        {
                            masterID = Guid.Parse(master.GetIdentity().ToString());
                        }
                    }
                    resultData = Rep.SaveData(master);
                    if (resultData.PKValue == null)
                    {
                        resultData.PKValue = masterID;
                    }
                    resultData.PKName = keyName;
                    if (resultData.Success && details != null)
                    {
                        IRepository repDetail = null;

                        ResultData resultDataDetail = new ResultData();

                        foreach (EntityBase oDetail in details)
                        {
                            tableName = oDetail.GetType().Name;
                            repDetail = this.UnitOfWork.GetRepByName(tableName);
                            if (repDetail != null)
                            {
                                oDetail.SetValue(keyName, resultData.PKValue);

                                resultDataDetail = repDetail.SaveData(oDetail);
                                if (!resultDataDetail.Success)
                                {
                                    resultData.Success = false;
                                    resultData.Code = System.Net.HttpStatusCode.InternalServerError;
                                    break;
                                }
                            }
                            else
                            {
                                resultData.SetError(new Exception($"Chưa khai repository cho {tableName}"));
                            }
                        }

                    }
                    if (resultData.Success)
                    {
                        this.UnitOfWork.Commit();

                        this.AfterCommitSave(master, details);
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

        /// <summary>
        /// Thực hiện xóa danh sách đối tượng
        /// </summary>
        /// <param name="lstID">Danh sách ID truyền lên</param>
        /// <returns>True: Xóa thành công, Ngược lại xóa thất bại</returns>
        /// Create by: dvthang:07.01.2018
        private ResultData DeleteData(List<Guid> lstID)
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            //Danh sách các đối tượng không cho xóa
            List<Guid> lstIDDel = new List<Guid>();
            string tableName = typeof(TEntity).Name;
            foreach (Guid id in lstID)
            {
                bool hasIncurrentData = this.GetRep().CheckIncurrentData(typeof(TEntity).Name, id);
                //Không tồn tại phát sinh
                if (!hasIncurrentData)
                {
                    resultData = this.ValidateBeforeDelete(id);
                    if (resultData.Success)
                    {
                        try
                        {
                           
                            this.UnitOfWork.BeginTransaction();

                            this.Rep = this.UnitOfWork.GetRepByName(tableName);

                            if (this.Rep != null)
                            {
                                resultData = this.Rep.DeleteByID(id);
                                if (!resultData.Success)
                                {
                                    this.UnitOfWork.RollBack();
                                }
                                else
                                {
                                    this.AfterDeleteBeforeCommit(id);
                                    this.UnitOfWork.Commit();
                                    lstIDDel.Add(id);
                                    this.AfterDeleteCommit(id);
                                }
                            }
                            else
                            {
                                resultData.SetError(new Exception($"Chưa khai repository cho {tableName}"));
                            }

                        }
                        catch (SqlException ex)
                        {
                            this.UnitOfWork.RollBack();
                            resultData.SetError(ex);
                            resultData.Success = true;
                            resultData.Code = System.Net.HttpStatusCode.OK;
                        }
                        catch (Exception ex)
                        {
                            this.UnitOfWork.RollBack();
                            resultData.SetError(ex);
                            resultData.Success = true;
                            resultData.Code = System.Net.HttpStatusCode.OK;
                        }
                        finally
                        {
                            this.UnitOfWork.Dispose();
                        }
                    }
                }
            }
            if (lstIDDel.Count > 0)
            {
                //Có ít nhất 1 đối tượng xóa thành công
                resultData.Success = true;
            }
            else
            {
                resultData.Success = false;
            }
            resultData.Data = lstIDDel;
            return resultData;
        }
        #endregion

        #region"Overrides"

        /// <summary>
        /// Thực hiện xử lý gì đó trước khi mở transaction xóa ID
        /// </summary>
        /// <param name="id">ID của đối tượng cần xóa</param>
        /// Create by: dvthang:07.01.2018
        protected virtual ResultData ValidateBeforeDelete(Guid id)
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            return resultData;
        }

        /// <summary>
        /// Thực hiện xử lý gì đó sau khi mở transaction
        /// </summary>
        /// <param name="master">Thông tin master</param>
        /// <param name="details">Danh sách detail</param>
        /// Create by: dvthang:07.01.2018
        protected virtual void AfterDeleteCommit(Guid id)
        {
        }

        /// <summary>
        /// Thực hiện xử lý gì đó trước khi commit transaction
        /// </summary>
        /// <param name="master">Thông tin master</param>
        /// <param name="details">Danh sách detail</param>
        /// Create by: dvthang:07.01.2018
        protected virtual void AfterDeleteBeforeCommit(Guid id)
        {
        }

        /// <summary>
        /// Thực hiện xử lý gì đó trước khi mở transaction
        /// </summary>
        /// <param name="master">Thông tin master</param>
        /// <param name="details">Danh sách detail</param>
        /// Create by: dvthang:07.01.2018
        protected virtual ResultData ValidateBeforeSave(TEntity master, IList<EntityBase> details)
        {
            ResultData resultData = new ResultData { Success = true, Code = System.Net.HttpStatusCode.OK };
            return resultData;
        }

        /// <summary>
        /// Thực hiện xử lý gì đó sau khi mở transaction
        /// </summary>
        /// <param name="master">Thông tin master</param>
        /// <param name="details">Danh sách detail</param>
        /// Create by: dvthang:07.01.2018
        protected virtual void PreSaveData(TEntity master, IList<EntityBase> details)
        {
        }

        /// <summary>
        /// Thực hiện xử lý gì đó sau khi mở transaction
        /// </summary>
        /// <param name="master">Thông tin master</param>
        /// <param name="details">Danh sách detail</param>
        /// Create by: dvthang:07.01.2018
        protected virtual void AfterCommitSave(TEntity master, IList<EntityBase> details)
        {
        }

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
