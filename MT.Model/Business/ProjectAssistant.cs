using MT.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region Project:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a Project:EntityBase.
    /// Thông tin đề tài: Trợ lý có quyền xem
    /// CreatedBy:laipv.26.02.2017
    /// </summary>
    public class ProjectAssistant : TreeStore
    {
        [Key]
        public Guid ProjectID { get; set; }
        public string ProjectCode { get; set; }
        public string ProjectName { get; set; }
        public string ProjectNameAbbreviation { get; set; }
        public string EmployeeName { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string Result { get; set; }
        public DateTime? PresentProtectedDate { get; set; }
        public DateTime? ExpenseProtectedDate { get; set; }
        public string StatusName { get; set; }
        public bool IsProject { get; set; }
    }
    #endregion
}

