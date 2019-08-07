using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
namespace MT.Repository.Gantt
{
    /// <summary>
    /// Repository xử lý hiển thị biểu đồ gantt
    /// </summary>
    /// Create by: dvthang:01.04.2018
    public class GanttRepository : BaseRepository<EntityBase>, IGanttRepository
    {

        #region"Contructor"
        public GanttRepository()
        {
        }
        public GanttRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion

        /// <summary>
        /// Lấy về danh sách task thể hiện trên biểu đò gant
        /// </summary>
        /// <param name="levelId">Cấp quản lý</param>
        /// <param name="projectId">Đề tài</param>
        /// <returns>Trả về danh sách task</returns>
        /// Create by: dvthang:01.04.2018
        public List<MT.Model.Gantt.Task> GetTasks(int levelId, Guid? projectId)
        {
            List<MT.Model.Gantt.Task> ganttTask = new List<Model.Gantt.Task>();

            using (IDataReader projects = this.GetDataReader("dbo.Proc_GetProjectsByLevelIdOrById", levelId, projectId))
            {
                List<MT.Model.Gantt.Task> tasks = this.ExecuteReader<MT.Model.Gantt.Task>("dbo.Proc_GetTasksById", projectId);

                DateTime minDate = DateTime.MinValue;
                DateTime maxDate = DateTime.MaxValue;

                while (projects.Read())
                {
                    DateTime startDate = Convert.ToDateTime(projects["StartDate"]);
                    DateTime endDate = Convert.ToDateTime(projects["EndDate"]);
                    if (startDate > minDate)
                    {
                        minDate = startDate;
                    }
                    if (maxDate > endDate)
                    {
                        maxDate = endDate;
                    }
                    MT.Model.Gantt.Task root = new Model.Gantt.Task
                    {
                        Id = Guid.Parse(projects["Id"].ToString()),
                        Name = Convert.ToString(projects["Name"]),
                        StartDate = startDate,
                        EndDate = endDate,
                        Expanded = true,
                        PercentDone = Convert.ToDecimal(projects["PercentDone"]),
                        IsProject=true
                    };
                    CreateTaskTree(root, tasks);
                    if (root.Data == null)
                    {
                        root.Leaf = true;
                        root.Expanded = null;
                    }
                    ganttTask.Add(root);
                }

                return ganttTask;
            }
        }

        /// <summary>
        /// Tạo danh sách task hình tree
        /// </summary>
        /// <param name="root">Task gốc</param>
        /// <param name="tasks">Danh sách task dạng phẳng</param>
        /// Create by: dvthang:01.04.2018
        private void CreateTaskTree(MT.Model.Gantt.Task root, List<MT.Model.Gantt.Task> tasks)
        {
            if (tasks != null)
            {
                List<MT.Model.Gantt.Task> tasksChild = new List<Model.Gantt.Task>();
                List<MT.Model.Gantt.Task> tasksTemp = null;
                if (root.IsProject)
                {
                    tasksTemp= tasks.Where(m => m.ProjectID == root.Id).ToList();
                }else
                {
                    tasksTemp = tasks.Where(m => m.ParentID == root.Id).ToList();
                }
                if (tasksTemp != null && tasksTemp.Count>0)
                {
                    foreach(var oItem in tasksTemp)
                    {
                        tasksChild.Add(oItem);
                        List<MT.Model.Gantt.Task> taskTemp2 = tasks.Where(m => m.ParentID == oItem.Id).ToList();
                        if (taskTemp2 != null && taskTemp2.Count>0)
                        {
                            oItem.Expanded = true;
                            this.CreateTaskTree(oItem, taskTemp2);
                        }else
                        {

                            oItem.Leaf = true;
                        }
                    }
                    root.Data = tasksChild;
                }
            }
        }
    }
}
