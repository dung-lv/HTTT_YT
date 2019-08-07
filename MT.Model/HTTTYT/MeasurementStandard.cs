using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region MeasurementStandard:EntityBase
    /// <summary>
    /// This object represents the properties and methods of a MeasurementStandard:EntityBase.
    /// </summary>
    public class MeasurementStandard : EntityBase
    {
        [Key]
        public int MeasurementStandardID { get; set; }
        public string Code { get; set; }
        public string FullName { get; set; }
        public string ShortName { get; set; }
        public string Description { get; set; }



    }
    #endregion
}

