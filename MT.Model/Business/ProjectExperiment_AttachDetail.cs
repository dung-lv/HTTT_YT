using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region ProjectExperiment_AttachDetail:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a ProjectExperiment_AttachDetail:EntityBase.
    /// </summary>
    public class ProjectExperiment_AttachDetail : EntityBase
    {
        [Key]
        public Guid ProjectExperiment_AttachDetailID { get; set; }
        public Guid ID { get; set; }
        public string Description{ get; set; }
        public string FileName { get; set; }
        public string FileType { get; set; }
        public double FileSize { get; set; }
        public int SortOrder { get; set; }

        public Guid? FileResourceID { get; set; }
    }
    #endregion
}

