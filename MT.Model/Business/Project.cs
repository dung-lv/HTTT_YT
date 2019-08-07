using MT.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region Project:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a Project:EntityBase.
    /// </summary>
    public class Project : EntityBase
    {
        [Key]
        public Guid ProjectID { get; set; }
        public string ProjectCode { get; set; }
        public string ProjectName { get; set; }
        public string ProjectNameAbbreviation { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public Guid CompanyID { get; set; }
        public Guid EmployeeID { get; set; }
        public String EmployeeName { get; set; }
        public decimal Amount { get; set; }
        public decimal Amount_Level1 { get; set; }
        public decimal Amount_Level2 { get; set; }
        public decimal Amount_Other { get; set; }
        public bool Program { get; set; }
        public string ProgramName { get; set; }
        public bool ProjectScience { get; set; }
        public string ProjectScienceName { get; set; }
        public bool IndependentTopic { get; set; }
        public bool Nature { get; set; }
        public bool AFF { get; set; }
        public bool Technical { get; set; }
        public bool Pharmacy { get; set; }
        public string Result { get; set; }
        public string CompanyApply { get; set; }
        public string Description { get; set; }
        public int Status { get; set; }
        public int LevelID { get; set; }
        public Guid GrantRatioID { get; set; }
        public Guid ProjectChairman { get; set; }
        public Guid ProjectSecretary { get; set; }
        public Guid ProjectCompanyChair { get; set; }
        public Guid ProjectMember { get; set; }
        public Guid ProjectCompanyCombination { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
        /// <summary>
        /// Danh sách thuộc tính thêm vào không xóa
        /// </summary>
        /// Create by: laipv:25.02.2018
        public DateTime? PresentProtectedDate { get; set; }
        public DateTime? ExpenseProtectedDate { get; set; }
        public DateTime? CloseDate { get; set; }
        public string StatusName { get; set; }

        public bool IsProject { get; set; }

        /// <summary>
        /// Số đề tài theo cấp quản lý
        /// </summary>
        public int Total { get; set; }
        /// <summary>
        /// Danh sách file đính kèm
        /// </summary>
        /// Create by: dvthang:31.01.2018
        public List<Project_AttachDetail> Details { get; set; }
        public int MonthFin { get; set; }
        public int YearFin { get; set; }
    }
    #endregion
}

