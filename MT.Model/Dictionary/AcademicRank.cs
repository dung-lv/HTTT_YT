using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region AcademicRank:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a AcademicRank:EntityBase.
    /// </summary>
    public class AcademicRank : EntityBase
    {
        [Key]
        public Guid AcademicRankID { get; set; }
        public string AcademicRankCode { get; set; }
        public string AcademicRankName { get; set; }
        public string AcademicRankShortName { get; set; }
        public string Description { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
    }
    #endregion
}

