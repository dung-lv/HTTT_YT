using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region DayOff:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a DayOff:EntityBase.
    /// </summary>
    public class DayOff : EntityBase
    {
        [Key]
        public Guid DayOffID { get; set; }
        public DateTime Date { get; set; }
        public string Description { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
        public int Rownum { get; set; }
    }
    #endregion
}

