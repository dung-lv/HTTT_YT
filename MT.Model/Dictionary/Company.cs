using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region Company:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a Company:EntityBase.
    /// </summary>
    public class Company : EntityBase
    {
        [Key]
        public Guid CompanyID { get; set; }
        public Guid ParentID { get; set; }
        public string CompanyCode { get; set; }
        public string CompanyName { get; set; }
        public string CompanyShortName { get; set; }
        public string Tel { get; set; }
        public string Fax { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string Website { get; set; }
        public string Director { get; set; }
        public string AccountNumber { get; set; }
        public string BankName { get; set; }
        public string Description { get; set; }
        public bool IsLeaf { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
        public bool Owned { get; set; }
    }
    #endregion
}

