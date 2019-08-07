using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
namespace MT.Repository
{
    /// <summary>
    /// Danh mục cấp quản lý đề tài
    /// </summary>
    /// Create by: laipv:13.01.2018
    public class ProjectRepository : BaseRepository<Project>, IProjectRepository
    {
        #region"Contructor"
        public ProjectRepository()
        {

        }

        public ProjectRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Kiểm tra xem có bị trùng mã hay không
        /// </summary>
        /// <param name="projectID">ID project</param>
        /// <param name="projectCode">Mã project</param>
        /// <param name="editMode">Hành động trên form</param>
        /// <returns>true: Tồn tại, ngược lại chưa</returns>
        /// Create by: dvthang:29.01.2018
        public bool CheckExistProject(Guid? projectID, string projectCode, Library.Enummation.EditMode editMode)
        {
            bool isValid = false;
            isValid = Convert.ToBoolean(this.ExecuteScalar("dbo.Proc_CheckExistProject", projectID,
                projectCode, editMode));
            return isValid;
        }

        /// <summary>
        /// Hàm lấy danh sách đề tài (nội dung) đang thực hiện
        /// </summary>
        /// <returns></returns>
        /// Create by: laipv:04.02.2018
        public List<ProjectAcceptance> GetAcceptances()
        {
            List<ProjectAcceptance> lstResult = new List<ProjectAcceptance>();

            List<ProjectTask> lstProjectTask = new List<ProjectTask>();
            List<Level> lstLevel = new List<Level>();
            List<Project> lstProject = new List<Project>();

            using (IDataReader reader = GetDataReader("[dbo].[Proc_HierarchicalProjectTask]"))
            {
                lstLevel = reader.FillCollection<Level>(false);// Cap của đề tài
                if (reader.NextResult())
                {
                    lstProject = reader.FillCollection<Project>(false);
                }
                if (reader.NextResult())
                {
                    lstProjectTask = reader.FillCollection<ProjectTask>(false);
                }
            }

            if (lstLevel != null && lstProject != null)
            {
                foreach (var item in lstLevel)
                {
                    ProjectAcceptance oParent = new ProjectAcceptance { ProjectID = Guid.NewGuid(), ProjectName = item.LevelName, Expanded = true };
                    List<Project> temp = lstProject.Where(m => m.LevelID == item.LevelID).ToList();
                    if (temp != null && temp.Count > 0)
                    {
                        oParent.Leaf = false;

                        List<ProjectAcceptance> children = new List<ProjectAcceptance>();
                        foreach (var p in temp)
                        {
                            ProjectAcceptance oChild = new ProjectAcceptance { EmployeeName = p.EmployeeName, ProjectID = p.ProjectID, ProjectName = p.ProjectName, ProjectNameAbbreviation = p.ProjectNameAbbreviation, Result = p.Result, StatusName = p.StatusName, StartDate = p.StartDate, EndDate = p.EndDate, IsProject = true, Expanded = true, Status = p.Status };

                            var lstChildrens = lstProjectTask.Where(m => m.ProjectID == p.ProjectID).ToList();

                            if (lstChildrens != null && lstChildrens.Count > 0)
                            {
                                oChild.Leaf = false;
                                CreateTree(lstChildrens, null, oChild);//lstChildrens[0]
                            }
                            else
                            {
                                oChild.Leaf = true;
                            }

                            children.Add(oChild);
                        }

                        oParent.Data = children;
                    }
                    else
                    {
                        oParent.Leaf = true;
                    }
                    lstResult.Add(oParent);
                }
            }
            return lstResult;
        }

        /// <summary>
        /// Hàm lấy danh sách đề tài (nội dung): Đang đề xuất
        /// </summary>
        /// <returns></returns>
        /// Create by: laipv:25.02.2018
        public List<Project> GetProjectOffers(string where)
        {
            List<Project> lstResult = new List<Project>();
            List<Level> lstLevel = new List<Level>();
            List<Project> lstProject = new List<Project>();
            //
            using (IDataReader reader = GetDataReader("[dbo].[Proc_GetProjectOffers]", where))
            {
                lstLevel = reader.FillCollection<Level>(false);
                if (reader.NextResult())
                {
                    lstProject = reader.FillCollection<Project>(false);
                }
            }
            //
            if (lstLevel != null && lstProject != null)
            {
                foreach (var item in lstLevel) //Duyệt qua tất cả các cấp
                {
                    List<Project> temp = lstProject.Where(m => m.LevelID == item.LevelID).ToList();
                    if (temp != null && temp.Count > 0)//Nếu có con
                    {
                        lstResult.Add(new Project
                        {
                            ProjectID = Guid.NewGuid(),
                            ProjectName = item.LevelName,
                            IsProject = false,
                            Total = temp.Count
                        });
                        lstResult.AddRange(temp);
                    }
                }
            }
            return lstResult;
        }
        /// <summary>
        /// Hàm lấy danh sách đề tài: Trợ lý có thể xem
        /// </summary>
        /// <returns></returns>
        /// Create by: laipv:26.02.2018
        public List<ProjectAssistant> GetProjectAssistants(string where)
        {
            List<ProjectAssistant> lstResult = new List<ProjectAssistant>();
            List<Level> lstLevel = new List<Level>();
            List<Project> lstProject = new List<Project>();
            //
            using (IDataReader reader = GetDataReader("[dbo].[Proc_GetProjectAssistants]", where))
            {
                lstLevel = reader.FillCollection<Level>(false);
                if (reader.NextResult())
                {
                    lstProject = reader.FillCollection<Project>(false);
                }
            }
            //
            if (lstLevel != null && lstProject != null)
            {
                foreach (var item in lstLevel) //Duyệt qua tất cả các cấp
                {
                    ProjectAssistant oParent = new ProjectAssistant { ProjectID = Guid.NewGuid(), ProjectName = item.LevelName, IsProject = false, Expanded = true };
                    List<Project> temp = lstProject.Where(m => m.LevelID == item.LevelID).ToList();
                    //Đưa cha vào
                    lstResult.Add(oParent);
                    if (temp != null && temp.Count > 0)//Nếu có con
                    {
                        //Đưa các con vào
                        foreach (var p in temp)
                        {
                            ProjectAssistant oChild = new ProjectAssistant { ProjectID = p.ProjectID, ProjectCode = p.ProjectCode, ProjectName = p.ProjectName, EmployeeName = p.EmployeeName, StartDate = p.StartDate, EndDate = p.EndDate, Result = p.Result, PresentProtectedDate = p.PresentProtectedDate, ExpenseProtectedDate = p.ExpenseProtectedDate, StatusName = p.StatusName, IsProject = true, Expanded = true };
                            lstResult.Add(oChild);
                        }
                    }
                }
            }
            return lstResult;
        }
        /// <summary>
        /// Hàm lấy danh sách đề tài (nội dung): Đã kết thúc
        /// </summary>
        /// <returns></returns>
        /// Create by: laipv:25.02.2018
        public List<Project> GetProjectFinishs(string where)
        {
            List<Project> lstResult = new List<Project>();
            List<Level> lstLevel = new List<Level>();
            List<Project> lstProject = new List<Project>();
            //
            using (IDataReader reader = GetDataReader("[dbo].[Proc_GetProjectFinishs]", where))
            {
                lstLevel = reader.FillCollection<Level>(false);
                if (reader.NextResult())
                {
                    lstProject = reader.FillCollection<Project>(false);
                }
            }
            //
            if (lstLevel != null && lstProject != null)
            {
                foreach (var item in lstLevel)
                {
                    List<Project> temp = lstProject.Where(m => m.LevelID == item.LevelID).ToList();
                    //Thêm cha
                    if (temp != null && temp.Count > 0)//Có con
                    {
                        lstResult.Add(new Project { ProjectID = Guid.NewGuid(), ProjectName = item.LevelName, IsProject = false, Total = temp.Count });
                        lstResult.AddRange(temp);
                    }
                }
            }
            return lstResult;
        }
        /// <summary>
        /// Create cây tree
        /// </summary>
        /// <param name="lstTreeStore"></param>
        /// Create by: dvthang:04.02.2018
        private void CreateTree(List<ProjectTask> lstProjectTask, ProjectTask task, ProjectAcceptance parent)
        {
            if (task == null)
            {
                var lstChildrens_ParentID_Null = lstProjectTask.Where(m => m.ParentID == null).ToList();
                if (lstChildrens_ParentID_Null != null && lstChildrens_ParentID_Null.Count > 0)
                {
                    parent.Leaf = false;
                    List<ProjectAcceptance> childs_ = new List<ProjectAcceptance>();
                    foreach (ProjectTask it_ParentNull in lstChildrens_ParentID_Null)
                    {
                        string StatusName = "";
                        switch (it_ParentNull.Status)
                        {
                            case 11:
                                StatusName = "Đã hoàn thành";
                                break;
                            case 12:
                                StatusName = "Chưa hoàn thành";
                                break;
                            case 13:
                                StatusName = "Chậm tiến độ";
                                break;
                            default:
                                StatusName = "";
                                break;
                        }
                        ProjectAcceptance oTemp = new ProjectAcceptance { ProjectID = Guid.NewGuid(), ProjectName = it_ParentNull.Contents, Result = it_ParentNull.Result, StatusName = StatusName, Expanded = true };
                        var lstItemp = lstProjectTask.Where(m => m.ParentID.HasValue && m.ParentID == it_ParentNull.ProjectTaskID).ToList();
                        if (lstItemp != null && lstItemp.Count > 0)
                        {
                            oTemp.Leaf = false;
                            CreateTree(lstProjectTask, it_ParentNull, oTemp);
                        }
                        else
                        {
                            oTemp.Leaf = true;
                        }
                        childs_.Add(oTemp);
                    }
                    parent.Data = childs_;
                }
                else
                {
                    parent.Leaf = true;
                }
            }
            else
            {
                var lstChildrens = lstProjectTask.Where(m => m.ParentID.HasValue && m.ParentID.Value == task.ProjectTaskID).ToList();

                if (lstChildrens != null && lstChildrens.Count > 0)
                {
                    parent.Leaf = false;
                    List<ProjectAcceptance> childs = new List<ProjectAcceptance>();
                    foreach (ProjectTask it in lstChildrens)
                    {
                        ProjectAcceptance oTemp = new ProjectAcceptance { ProjectID = Guid.NewGuid(), ProjectName = it.Contents, Expanded = true };
                        var lstItemp = lstProjectTask.Where(m => m.ParentID.HasValue && m.ParentID == it.ProjectTaskID).ToList();
                        if (lstItemp != null && lstItemp.Count > 0)
                        {
                            oTemp.Leaf = false;
                            CreateTree(lstProjectTask, it, oTemp);
                        }
                        else
                        {
                            oTemp.Leaf = true;
                        }
                        childs.Add(oTemp);
                    }
                    parent.Data = childs;
                }
                else
                {
                    parent.Leaf = true;
                }
            }
        }

        /// <summary>
        /// Lấy danh sách đề tài theo chủ nhiệm đề tài
        /// Create by: manh 04.05.18
        /// </summary>
        /// <param name="UserName"></param>
        /// <returns></returns>
        public List<Project> GetProjectByEmployee(string UserName)
        {
            List<Project> lstProject = ExecuteReader<Project>("[dbo].[Proc_SelectProjectByEmployee]", UserName);
            return lstProject;
        }

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
        public List<Dictionary<string,object>> GetListReportProjectTaskMemberFinanceByCompanyIDAndEmployeeIDAndProjectID(Guid companyID,
            Guid? employeeID,Guid? projectID,DateTime fromDate, DateTime toDate)
        {
            List<Dictionary<string, object>> lstDic = new List<Dictionary<string, object>>();
            using (IDataReader rd=this.GetDataReader("Proc_GetListReportProjectTaskMemberFinanceByCompanyIDAndEmployeeIDAndProjectID", companyID, employeeID,
                projectID, fromDate, toDate))
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
                    lstDic.Add(dic);
                }
            }
                return lstDic;
        }

        #endregion
    }
}
