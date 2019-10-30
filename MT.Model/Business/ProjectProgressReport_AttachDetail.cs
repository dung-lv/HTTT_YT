﻿using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region ProjectProgressReport_AttachDetail:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a ProjectProgressReport_AttachDetail:EntityBase.
    /// </summary>
    public class ProjectProgressReport_AttachDetail : EntityBase
    {
        [Key]
        public Guid ProjectProgressReport_AttachDetailID { get; set; }
        public Guid ProjectProgressReportID { get; set; }
        public string FileName { get; set; }
        public string FileType { get; set; }
        public double FileSize { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
        public Guid? FileResourceID { get; set; }
        public string Description { get; set; }
    }
    #endregion
}
