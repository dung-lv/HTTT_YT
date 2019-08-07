using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region ProjectMember:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a ProjectMember:EntityBase.
    /// </summary>
    public class ProjectMember : EntityBase
    {
        [Key]
        public Guid ProjectMemberID { get; set; }
        public Guid ProjectID { get; set; }
        public Guid? EmployeeID { get; set; }
        public string FullName { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public decimal MonthForProject { get; set; }
        public Guid? ProjectPositionID { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
        public string EmployeeName { get; set; }
        public string ProjectPositionName { get; set; }
        public int Rownum { get; set; }
        
    }
    #endregion
}

