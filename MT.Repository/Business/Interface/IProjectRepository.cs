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
    public interface IProjectRepository : IBaseRepository<Project>
    {
        /// <summary>
        /// Kiểm tra xem có bị trùng mã hay không
        /// </summary>
        /// <param name="projectID">ID project</param>
        /// <param name="projectCode">Mã project</param>
        /// <param name="editMode">Hành động trên form</param>
        /// <returns>true: Tồn tại, ngược lại chưa</returns>
        /// Create by: dvthang:29.01.2018
        bool CheckExistProject(Guid? projectID, string projectCode, Library.Enummation.EditMode editMode);
        /// <summary>
        /// Hàm lấy danh sách đề tài (nội dung) đang thực hiện
        /// </summary>
        /// <returns></returns>
        /// Create by: laipv:04.02.2018
        List<ProjectAcceptance> GetAcceptances();
        /// <summary>
        /// Hàm lấy danh sách đề tài (nội dung): Đang đề xuất
        /// </summary>
        /// <returns></returns>
        /// Create by: laipv:25.02.2018
        List<Project> GetProjectOffers(string sWhere);
        /// <summary>
        /// Hàm lấy danh sách đề tài (nội dung): Đã kết thúc
        /// </summary>
        /// <returns></returns>
        /// Create by: laipv:25.02.2018
        List<Project> GetProjectFinishs(string sWhere);
        /// <summary>
        /// Hàm lấy danh sách đề tài: Trợ lý có quyền xem
        /// </summary>
        /// <returns></returns>
        /// Create by: laipv:26.02.2018
        List<ProjectAssistant> GetProjectAssistants(string sWhere);
        /// <summary>
        /// Lấy danh sách đề tài theo chủ nhiệm đề tài
        /// Create by: manh 04.05.18
        /// </summary>
        /// <param name="UserName"></param>
        /// <returns></returns>
        List<Project> GetProjectByEmployee(string UserName);

        /// <summary>
        /// Báo cáo tổng chấm công của từng nhân viên
        /// </summary>
        /// <param name="companyID">Đơn vị</param>
        /// <param name="employeeID">Nhân viên</param>
        /// <param name="projectID">Dự án</param>
        /// <param name="fromDate">Từ ngày</param>
        /// <param name="toDate">Đến ngày</param>
        /// <returns>Danh sách chấm công của từng nhân viên</returns>
        /// Create by: dvthang: 03.06.2018
        List<Dictionary<string, object>> GetListReportProjectTaskMemberFinanceByCompanyIDAndEmployeeIDAndProjectID(Guid companyID,
            Guid? employeeID, Guid? projectID, DateTime fromDate, DateTime toDate);
    }
}
