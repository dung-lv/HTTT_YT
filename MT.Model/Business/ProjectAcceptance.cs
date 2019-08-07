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
    public class ProjectAcceptance : TreeStore
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
        public string StatusName { get; set; }
        public bool IsProject { get; set; }

        public int Status { get; set; }
    }
    #endregion
}

