using MT.Library;
using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region SYS_LogError:EntityBase

    /// <summary>
    /// This object represents the properties and methods of a SYS_Group:EntityBase.
    /// </summary>
    public class SYS_LogError : EntityBase
    {
        [Key]
        public Guid iID_LogError { get; set; }

        public string sLogErrorCode { get; set; }

        public string sMessage { get; set; }

        public string sStackTrace { get; set; }

        public string sSource { get; set; }

        public int iHResult { get; set; }

        public DateTime dNgayTao { get; set; }
        public DateTime dNgaySua { get; set; }
        public string sIPSua { get; set; }
        public string sID_MaNguoiDungSua { get; set; }
        public string sID_MaNguoiDungTao { get; set; }
    }

    #endregion SYS_LogError:EntityBase
}