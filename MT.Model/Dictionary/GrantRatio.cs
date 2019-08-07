using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region GrantRatio:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a GrantRatio:EntityBase.
    /// </summary>
    public class GrantRatio : EntityBase
    {
        [Key]
        public Guid GrantRatioID { get; set; }
        public string GrantRatioCode { get; set; }
        public string GrantRatioName { get; set; }
        public string Description { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
        public int Rownum { get; set; }
    }
    #endregion
}

