using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region ProjectSurvey:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a ProjectSurvey:EntityBase.
    /// </summary>
    public class ProjectSurvey : EntityBase
    {
        [Key]
        public Guid ProjectSurveyID { get; set; }
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

