using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region MedicalRecord:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a MedicalRecord:EntityBase.
    /// </summary>
    public class MedicalRecord : EntityBase
    {
        [Key]
        public int MedicalRecordID { get; set; }
        public int CustomerID { get; set; }
        public string CustomerName { get; set; }
        public int AppliedStandardID { get; set; }
        public string MedicalRecordDescription { get; set; }
        public string MedicalRecordLocation { get; set; }
        public DateTime MedicalRecordDate { get; set; }
        public string FinalResult { get; set; }


    }
    #endregion
}

