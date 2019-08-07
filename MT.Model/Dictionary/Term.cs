using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region Term:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a Term:EntityBase.
    /// </summary>
    public class Term : EntityBase
    {
        [Key]
        public int TermID { get; set; }
        public string TermCode { get; set; }
        public string TermName { get; set; }
        public string Description { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
    }
    #endregion
}

