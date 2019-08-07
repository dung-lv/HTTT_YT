using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region WageCoefficient:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a WageCoefficient:EntityBase.
    /// </summary>
    public class WageCoefficient : EntityBase
    {
        [Key]
        public Guid WageCoefficientID { get; set; }
        public Guid GrantRatioID { get; set; }
        public Guid ProjectPositionID { get; set; }
        public String ProjectPositionName { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
        public decimal Coefficient { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
        /// <summary>
        /// Edit = 1 cho phep nhap
        /// </summary>
        public bool Edit { get; set; }
        
    }
    #endregion
}

