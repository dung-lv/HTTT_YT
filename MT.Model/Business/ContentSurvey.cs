using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region ContentServey:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a ContentServey:EntityBase.
    /// </summary>
    public class ContentServey : EntityBase
    {
        [Key]
        public Guid ID { get; set; }
        public Guid CompanyID { get; set; }
        public string AtCompany { get; set; }
        public string Description { get; set; }

        public DateTime ToDate { get; set; }

        public List<ProjectSurvey_AttachDetail> Details { get; set; }

        public Guid ProjectID { get; set; }

        public string CompanyName { get; set; }

        public string IdFiles { get; set; }
    }
    #endregion
}

