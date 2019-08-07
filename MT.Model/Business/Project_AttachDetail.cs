
using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region Project_AttachDetail:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a Project_AttachDetail:EntityBase.
    /// </summary>
    public class Project_AttachDetail : EntityBase
    {
        [Key]
        public Guid Project_AttachDetailID { get; set; }
        public Guid ProjectID { get; set; }
        public string FileName { get; set; }
        public string FileType { get; set; }
        public double FileSize { get; set; }
        public int SortOrder { get; set; }
        public string Description { get; set; }
        public Guid? FileResourceID { get; set; }
    }
    #endregion
}

