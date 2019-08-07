using MT.Library;
using Newtonsoft.Json;
using System;
using System.ComponentModel.DataAnnotations;
using System.Reflection;
namespace MT.Model
{
    /// <summary>
    /// Khai báo đối tượng tree store
    /// </summary>
    public class ProjectTaskTree:TreeStore
    {
        [Key]
        public Guid ProjectTaskID { get; set; }
        public Guid ParentID { get; set; }
        public Guid ProjectID { get; set; }
        public string Contents { get; set; }
        public string SortIndex { get; set; }
        public int SortOrder { get; set; }
        public int Rank { get; set; }
        public string Result { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public Guid EmployeeID { get; set; }
        public int Status { get; set; }
        public bool Inactive { get; set; }
    }
}
