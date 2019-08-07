using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    public interface IProjectTaskRepository : IBaseRepository<ProjectTask>
    {
        /// <summary>
        /// Lấy danh sách nội dụng task của đề tài
        /// </summary>
        /// <param name="masterID">ID của đề tài</param>
        /// <returns>Danh sách nội dung của đề tài</returns>
        /// Create by: dvthang:06.02.2018
        List<ProjectTaskTree> GetTaskTree(Guid? masterID);

        /// <summary>
        /// Lay danh sach task cua de tai
        /// </summary>
        /// <param name="masterID">ID cuar project</param>
        /// <param name="editMode">Trang thai cua form</param>
        /// <returns>Danh sacsh Task</returns>
        /// Create by: dvthang:11.02.2018
        List<ProjectTask> GetProjectTaskAllByProjectAndEditMode(Guid? masterID, Guid? projectTaskID, Library.Enummation.EditMode editMode);
        /// <summary>
        /// Hàm lấy danh sách các ProjectTask + Project
        /// </summary>
        /// <param name="ProjectID"></param>
        /// <returns></returns>
        /// Create by: laipv:12.03.2018
        List<ProjectTask> GetProjectTaskAllByProjectID(Guid? ProjectID);
        // <summary>
        /// Cập nhật trạng thái task
        /// </summary>
        /// <param name="projectTaskID">ID của Task</param>
        /// <returns>TRue: thành công, ngược lại thất bại</returns>
        /// Create by: dvthang:27.02.2018
        bool UpdateStatusTask(Guid projectTaskID, MT.Library.Enummation.StatusTask status);
        /// <summary>
        /// Hàm lấy danh sách các ProjectTask theo ProjectTaskID (lấy các con của ProjectTask này)
        /// </summary>
        /// <param name="projectTaskID">Mã ProjectTask (cha)</param>
        /// <param name="projectID">Mã Project</param>
        /// Create by: laipv:04.03.2018
        List<ProjectTask> GetProjectTaskAllByProjectTaskID(Guid? projectTaskID, Guid? projectID);
        /// <summary>
        /// Cập nhật Sort Order
        /// </summary>
        /// <param name="projectTaskIDOld">ID của Task cũ</param>
        /// /// <param name="projectTaskIDNew">ID của Task mới</param>
        /// <returns>TRue: thành công, ngược lại thất bại</returns>
        /// Create by: Manh:09.03.18
        bool UpdateSortOrderTask(Guid projectTaskIDOld, Guid projectTaskIDNew);

        /// <summary>
        ///Kiểm tra xem các task con của 1 task đã cập nhật trạng thái chưa,nếu tất cả đã cập nhật roh thì mới cho cập task cha
        /// </summary>
        /// <param name="projectTaskID">ID của Task</param>
        /// <returns>TRue: thành công, ngược lại thất bại</returns>
        /// Create by: dvthang:01.03.2018
         bool CheckNoExistsTaskChildUnStatus(Guid projectTaskID, MT.Library.Enummation.StatusTask status);
    }
}
