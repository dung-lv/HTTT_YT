using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace MT.Model.Dictionary
{
    #region PartyPosition:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a PartyPosition:EntityBase.
    /// </summary>
    public class PartyPosition : EntityBase
    {
        [Key]
        public Guid PartyPositionID { get; set; }
        public string PartyPositionCode { get; set; }
        public string PartyPositionName { get; set; }
        public string Description { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
  
    }
    #endregion
}
