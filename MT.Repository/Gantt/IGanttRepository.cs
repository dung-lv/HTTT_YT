using MT.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MT.Repository.Gantt
{
    /// <summary>
    /// Repository xử lý hiển thị biểu đồ gantt
    /// </summary>
    /// Create by: dvthang:01.04.2018
    public interface IGanttRepository : IBaseRepository<EntityBase>
    {
        /// <summary>
        /// Lấy về danh sách task thể hiện trên biểu đò gant
        /// </summary>
        /// <param name="levelId">Cấp quản lý</param>
        /// <param name="projectId">Đề tài</param>
        /// <returns>Trả về danh sách task</returns>
        /// Create by: dvthang:01.04.2018
        List<MT.Model.Gantt.Task> GetTasks(int levelId, Guid? projectId);
    }
}
