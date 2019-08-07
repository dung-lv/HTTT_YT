using MT.Library;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MT.Model
{
    /// <summary>
    /// Bảng quản lý đề tài
    /// </summary>
    /// Create by: laipv:28.01.2018
    public class ProjectTask : EntityBase
    {
        [Key]
        public Guid ProjectTaskID { get; set; }
        public Guid? ParentID { get; set; }
        public Guid ProjectID { get; set; }
        public string Contents { get; set; }
        public string SortIndex { get; set; }
        public int SortOrder { get; set; }
        public int Rank { get; set; }
        public string Result { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public Guid EmployeeID { get; set; }
        public int Status
        {
            get; set;
        }
        public byte Grade { get; set; }
        public bool Leaf { get; set; }
        public bool Inactive { get; set; }
        #region Thuộc tính thêm không xóa

        public string StatusName
        {
            get
            {
                switch (Status)
                {
                    case (int)Enummation.StatusTask.UnFinish: return "Chưa hoàn thành";
                    case (int)Enummation.StatusTask.Finish: return "Hoàn thành";
                    case (int)Enummation.StatusTask.SlowProgress: return "Chậm tiến độ";
                }
                return "";
            }
        }
        #endregion
    }
}
