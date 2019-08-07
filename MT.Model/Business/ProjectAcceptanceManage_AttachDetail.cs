using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region ProjectAcceptanceManage_AttachDetail:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a ProjectAcceptanceManage_AttachDetail:EntityBase.
    /// </summary>
    public class ProjectAcceptanceManage_AttachDetail : EntityBase
    {
        [Key]
        public Guid ProjectAcceptanceManage_AttachDetailID { get; set; }
        public Guid ProjectAcceptanceManageID { get; set; }
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

