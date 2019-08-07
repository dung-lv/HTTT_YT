using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region ProjectWorkshop:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a ProjectWorkshop:EntityBase.
    /// </summary>
    public class ProjectWorkshop : EntityBase
    {
        [Key]
        public Guid ProjectWorkshopID { get; set; }
        public Guid ProjectID { get; set; }
        public DateTime Date { get; set; }
        public DateTime Time { get; set; }
        public string Adderess { get; set; }
        public string Contents { get; set; }
        public int SortOrder { get; set; }

        /// <summary>
        /// Danh sách file đính kèm
        /// </summary>
        /// Create by: manh:24.02.2018
        public List<ProjectWorkshop_AttachDetail> Details { get; set; }

        public string IdFiles { get; set; }
    }
    #endregion
}

