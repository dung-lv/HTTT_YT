using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region ProjectExperiment:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a ProjectExperiment:EntityBase.
    /// </summary>
    public class ProjectExperiment : EntityBase
    {
        [Key]
        public Guid ProjectExperimentID { get; set; }
        public Guid ProjectID { get; set; }
        public string FileName { get; set; }
        public string FileType { get; set; }
        public double FileSize { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }

        public Guid FileResourceID { get; set; }
    }
    #endregion
}

