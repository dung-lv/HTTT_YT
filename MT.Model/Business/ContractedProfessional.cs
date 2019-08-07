using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region ContractedProfessional:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a ContractedProfessional:EntityBase.
    /// </summary>
    public class ContractedProfessional : EntityBase
    {
        [Key]
        public Guid ContractedProfessionalID { get; set; }
        public Guid ProjectID { get; set; }
        public Guid ProjectTaskID { get; set; }
        public Guid EmployeeID { get; set; }
        public string Contents { get; set; }
        public string FullName { get; set; }
        public int MonthForTask { get; set; }
        public int MonthForTaskLaborday { get; set; }
        public bool Inactive { get; set; }
        public bool Verify { get; set; }
        public int SortOrder { get; set; }
        public int RowNum { get; set; }

        /// <summary>
        /// Edit = 1 cho phep nhap
        /// </summary>
        public bool Edit { get; set; }
        /// <summary>
        /// Print = 1 cho phep xuat excel
        /// </summary>
        public bool Print { get; set; }
        public string ND1 { get; set; }
        public int SN_RD1 { get; set; }
        public int SN_CC1 { get; set; }
        public string ND2 { get; set; }
        public int SN_RD2 { get; set; }
        public int SN_CC2 { get; set; }
        public string ND3 { get; set; }
        public int SN_RD3 { get; set; }
        public int SN_CC3 { get; set; }
        public string ND4 { get; set; }
        public int SN_RD4 { get; set; }
        public int SN_CC4 { get; set; }
        public string ND5 { get; set; }
        public int SN_RD5 { get; set; }
        public int SN_CC5 { get; set; }
        public string ND6 { get; set; }
        public int SN_RD6 { get; set; }
        public int SN_CC6 { get; set; }
        public string ND7 { get; set; }
        public int SN_RD7 { get; set; }
        public int SN_CC7 { get; set; }
        public string ND8 { get; set; }
        public int SN_RD8 { get; set; }
        public int SN_CC8 { get; set; }
        public string ND9 { get; set; }
        public int SN_RD9 { get; set; }
        public int SN_CC9 { get; set; }
        public string ND10 { get; set; }
        public int SN_RD10 { get; set; }
        public int SN_CC10 { get; set; }
        public string ND11 { get; set; }
        public int SN_RD11 { get; set; }
        public int SN_CC11 { get; set; }
    }
    #endregion
}

