using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region Employee:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a Employee:EntityBase.
    /// </summary>
    public class Employee : EntityBase
    {
        [Key]
        public Guid EmployeeID { get; set; }
        public Guid CompanyID { get; set; }
        public string EmployeeCode { get; set; }
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FullName { get; set; }
        public Guid RankID { get; set; }
        public int Gender { get; set; }

        public string GenderName
        {
            get
            {
                string name = "Nam";
                if (this.Gender == 1)
                {
                    name = "Nữ";
                }
                return name;
            }
        }
        public Guid AcademicRankID { get; set; }
        public int YearOfAcademicRank { get; set; }
        public Guid DegreeID { get; set; }
        public int YearOfDegree { get; set; }
        public Guid PositionID { get; set; }
        public DateTime BirthDay { get; set; }
        public string BirthPlace { get; set; }
        public string HomeLand { get; set; }
        public string NativeAddress { get; set; }
        public string Tel { get; set; }
        public string HomeTel { get; set; }
        public string Mobile { get; set; }
        public string Fax { get; set; }
        public string Email { get; set; }
        public string OfficeAddress { get; set; }
        public string HomeAddress { get; set; }
        public string Website { get; set; }
        public string Description { get; set; }
        public string FileResourceID { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
        public string IDNumber { get; set; }
        public string IssuedBy { get; set; }
        public DateTime DateBy { get; set; }
        public string AccountNumber { get; set; }
        public string Bank { get; set; }
        public bool IsChangedPassword { get; set; }

    }
    #endregion
}

