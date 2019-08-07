using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
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
    public class ProjectTaskRepository : BaseRepository<ProjectTask>, IProjectTaskRepository
    {
        #region"Contructor"
        public ProjectTaskRepository()
        {

        }

        public ProjectTaskRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Function"
        /// <summary>
        /// Lấy danh sách nội dụng task của đề tài
        /// </summary>
        /// <param name="masterID">ID của đề tài</param>
        /// <returns>Danh sách nội dung của đề tài</returns>
        /// Create by: dvthang:06.02.2018
        public List<ProjectTaskTree> GetTaskTree(Guid? masterID)
        {
            List<ProjectTask> projectTasks = this.ExecuteReader<ProjectTask>("[dbo].[Proc_GetListProjectTaskByMasterID]", masterID);

            List<ProjectTaskTree> trees = new List<ProjectTaskTree>();
            if (projectTasks != null)
            {
                foreach (ProjectTask task in projectTasks)
                {
                    ProjectTaskTree tree = new ProjectTaskTree
                    {
                        ProjectTaskID = task.ProjectTaskID,
                        StartDate = task.StartDate,
                        EndDate = task.EndDate,
                        Contents = task.Contents,
                        ProjectID = task.ProjectID,
                        Inactive = task.Inactive,
                        Expanded = true
                    };
                    if (task.ParentID.HasValue)
                    {
                        tree.ParentID = task.ParentID.Value;
                    }
                    List<ProjectTask> taskChild = projectTasks.Where(m => m.ParentID.HasValue && m.ParentID == task.ProjectTaskID).ToList();
                    if (taskChild != null && taskChild.Count > 0)
                    {
                        tree.Leaf = false;
                        CreateTreeTask(taskChild, task, tree);
                    }
                    else
                    {
                        tree.Expanded = false;
                        tree.Leaf = true;
                    }
                    trees.Add(tree);
                }
            }
            return trees;
        }

        /// <summary>
        /// Tạo cây nội dung đề tài
        /// </summary>
        /// Create by: dvthang:06.02.2018
        private void CreateTreeTask(List<ProjectTask> tasks, ProjectTask task, ProjectTaskTree tree)
        {
            List<ProjectTaskTree> treeChild = new List<ProjectTaskTree>();
            foreach (ProjectTask item in tasks)
            {
                ProjectTaskTree child = new ProjectTaskTree
                {
                    ProjectTaskID = item.ProjectTaskID,
                    StartDate = item.StartDate,
                    EndDate = item.EndDate,
                    Contents = item.Contents,
                    ProjectID = item.ProjectID,
                    Inactive = item.Inactive,
                    ParentID = item.ParentID ?? task.ParentID.Value,
                    Expanded = true
                };
                if (item.ParentID.HasValue)
                {
                    child.ParentID = item.ParentID.Value;
                }
                List<ProjectTask> taskChild = tasks.Where(m => m.ParentID.HasValue && m.ParentID == item.ProjectTaskID).ToList();
                if (taskChild != null && taskChild.Count > 0)
                {
                    child.Leaf = false;
                    CreateTreeTask(taskChild, item, child);
                }
                else
                {
                    child.Expanded = false;
                    child.Leaf = true;
                }
                treeChild.Add(child);
            }
            tree.Data = treeChild;
        }

        /// <summary>
        /// Lay danh sach task cua de tai
        /// </summary>
        /// <param name="masterID">ID cuar project</param>
        /// <param name="editMode">Trang thai cua form</param>
        /// <returns>Danh sacsh Task</returns>
        /// Create by: dvthang:11.02.2018
        public List<ProjectTask> GetProjectTaskAllByProjectAndEditMode(Guid? masterID, Guid? projectTaskID, Library.Enummation.EditMode editMode)
        {
            List<ProjectTask> lstProjectTask = new List<ProjectTask>();
            //Lấy giá trị về
            lstProjectTask = this.ExecuteReader<ProjectTask>("[dbo].[Proc_SelectProjectTaskAllByProjectAndEditMode]", editMode, masterID, projectTaskID);
            //Trả giá trị về
            return lstProjectTask;
        }
        /// <summary>
        /// Hàm lấy danh sách các ProjectTask + Project
        /// </summary>
        /// <param name="ProjectID"></param>
        /// <returns></returns>
        /// Create by: laipv:12.03.2018
        public List<ProjectTask> GetProjectTaskAllByProjectID(Guid? ProjectID)
        {
            List<ProjectTask> lstProjectTask = new List<ProjectTask>();
            //Lấy giá trị về
            lstProjectTask = this.ExecuteReader<ProjectTask>("[dbo].[Proc_SelectProjectTaskAllByProjectID]", ProjectID);
            return lstProjectTask;
        }
        /// <summary>
        /// Hàm lấy danh sách các ProjectTask theo ProjectTaskID (lấy các con của ProjectTask này)
        /// </summary>
        /// <param name="projectTaskID">Mã ProjectTask (cha)</param>
        /// <param name="projectID">Mã Project</param>
        /// Create by: laipv:04.03.2018
        public List<ProjectTask> GetProjectTaskAllByProjectTaskID(Guid? projectTaskID, Guid? projectID)
        {
            return this.ExecuteReader<ProjectTask>("[dbo].[Proc_SelectProjectTaskAllByProjectTaskID]", projectTaskID, projectID);
        }

        /// <summary>
        /// Cập nhật trạng thái task
        /// </summary>
        /// <param name="projectTaskID">ID của Task</param>
        /// <returns>TRue: thành công, ngược lại thất bại</returns>
        /// Create by: dvthang:27.02.2018
        public bool UpdateStatusTask(Guid projectTaskID, MT.Library.Enummation.StatusTask status)
        {
            return this.ExecuteNoneQuery("[dbo].[Proc_UpdateStatusTask]", projectTaskID, status);
        }

        /// <summary>
        /// Cập nhật Sort Order
        /// </summary>
        /// <param name="projectTaskIDOld">ID của Task cũ</param>
        /// /// <param name="projectTaskIDNew">ID của Task mới</param>
        /// <returns>TRue: thành công, ngược lại thất bại</returns>
        /// Create by: Manh:09.03.18
        public bool UpdateSortOrderTask(Guid projectTaskIDOld, Guid projectTaskIDNew)
        {
            return this.ExecuteNoneQuery("[dbo].[Proc_UpdateProjectTaskSortOrder]", projectTaskIDOld, projectTaskIDNew);
        }

        /// <summary>
        ///Kiểm tra xem các task con của 1 task đã cập nhật trạng thái chưa,nếu tất cả đã cập nhật roh thì mới cho cập task cha
        /// </summary>
        /// <param name="projectTaskID">ID của Task</param>
        /// <returns>TRue: thành công, ngược lại thất bại</returns>
        /// Create by: dvthang:01.03.2018
        public bool CheckNoExistsTaskChildUnStatus(Guid projectTaskID, MT.Library.Enummation.StatusTask status)
        {
            return Convert.ToBoolean(this.ExecuteScalar("[dbo].[Proc_CheckNoExistsTaskChildUnStatus]", projectTaskID, status));
        }
        #endregion
    }
}
