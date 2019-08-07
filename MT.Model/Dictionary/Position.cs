using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region Position:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a Position:EntityBase.
    /// </summary>
    public class Position : EntityBase
    {
        [Key]
        public Guid PositionID { get; set; }
        public string PositionCode { get; set; }
        public string PositionName { get; set; }
        public string Description { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
    }
    #endregion
}

