using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region ProjectClose_AttachDetail:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a ProjectClose_AttachDetail:EntityBase.
    /// </summary>
    public class ProjectClose_AttachDetail : EntityBase
    {
        [Key]
        public Guid ProjectClose_AttachDetailID { get; set; }
        public Guid ProjectCloseID { get; set; }
        public string Contents { get; set; }
        public string FileName { get; set; }
        public string FileType { get; set; }
        public double FileSize { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }

        public Guid? FileResourceID { get; set; }

    }
    #endregion
}

