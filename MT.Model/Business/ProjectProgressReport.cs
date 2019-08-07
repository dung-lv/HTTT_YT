using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region ProjectProgressReport:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a ProjectProgressReport:EntityBase.
    /// </summary>
    public class ProjectProgressReport : EntityBase
    {
        [Key]
        public Guid ProjectProgressReportID { get; set; }
        public Guid ProjectID { get; set; }
        public int TermID { get; set; }
        public string TermName { get; set; }
        public DateTime DateReport { get; set; }
        public DateTime DateCheck { get; set; }
        public int Result { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
        /// <summary>
        /// Danh sách file đính kèm
        /// </summary>
        /// Create by: truongnm:25.02.2018
        public List<ProjectProgressReport_AttachDetail> Details { get; set; }

        public string Result_sTen { get; set; }

        public string IdFiles { get; set; }
    }
    #endregion
}

