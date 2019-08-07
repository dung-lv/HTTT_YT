using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region ProjectPlanPerform:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a ProjectPlanPerform:EntityBase.
    /// </summary>
    public class ProjectPlanPerform : EntityBase
    {
        [Key]
        public Guid ProjectPlanPerformID { get; set; }
        public Guid ProjectID { get; set; }
        public string Number { get; set; }
        public DateTime Date { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
        /// <summary>
        /// Danh sách file đính kèm
        /// </summary>
        /// Create by: truongnm:11.02.2018
        public List<ProjectPlanPerform_AttachDetail> Details { get; set; }

        public string IdFiles { get; set; }
    }
    #endregion
}

