using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region Salary:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a Salary:EntityBase.
    /// </summary>
    public class Salary : EntityBase
    {
        [Key]
        public Guid SalaryID { get; set; }
        public string SalaryCode { get; set; }
        public string SalaryName { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
        public int Money { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }

    }
    #endregion
}

