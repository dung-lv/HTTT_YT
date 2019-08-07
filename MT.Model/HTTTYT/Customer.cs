using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region Customer:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a Customer:EntityBase.
    /// </summary>
    public class Customer : EntityBase
    {
        [Key]
        public int CustomerID { get; set; }
        public string CustomerCode { get; set; }
        public string CustomerName { get; set; }
        public int CustomerGender { get; set; }
        public DateTime DOB { get; set; }
        public string HealthCareNumber { get; set; }
        public string Tel { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string CustomerGroup { get; set; }
        public string CustomerDescription { get; set; }
        public string PresenterName { get; set; }
        public string PresenterPhone { get; set; }
        public string PresenterAddress { get; set; }
        public string PresenterIDC { get; set; }
        public string Relationship { get; set; }


    }
    #endregion
}

