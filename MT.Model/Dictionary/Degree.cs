using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region Degree:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a Degree:EntityBase.
    /// </summary>
    public class Degree : EntityBase
    {
        [Key]
        public Guid DegreeID { get; set; }
        public string DegreeCode { get; set; }
        public string DegreeName { get; set; }
        public string DegreeShortName { get; set; }
        public string Description { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }



    }
    #endregion
}

