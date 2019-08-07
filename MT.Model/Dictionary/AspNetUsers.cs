using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region AspNetUser:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a AspNetUser:EntityBase.
    /// </summary>
    public class AspNetUsers : EntityBase
    {
        [Key]
        public int Id { get; set; }
        public Int32 AspNetUsersID { get; set; }
        public String AspNetRolesName { get; set; }
        public String CompanyParentName { get; set; }
        public String CompanyName { get; set; }
        public string Email { get; set; }
        public bool EmailConfirmed { get; set; }
        public string PasswordHash { get; set; }
        public string SecurityStamp { get; set; }
        public string PhoneNumber { get; set; }
        public bool PhoneNumberConfirmed { get; set; }
        public bool TwoFactorEnabled { get; set; }
        public DateTime LockoutEndDateUtc { get; set; }
        public bool LockoutEnabled { get; set; }
        public int AccessFailedCount { get; set; }
        public string UserName { get; set; }
        public int GroupID { get; set; }
        public int UserID { get; set; }
        public string FullName { get; set; }
        public int oId { get; set; }
        public string Address { get; set; }

    }
    #endregion
}

