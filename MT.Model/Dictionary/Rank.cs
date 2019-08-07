using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MT.Model
{
    /// <summary>
    /// Bảng cấp bậc
    /// </summary>
    /// Create by: dvthang:08.01.2018
    public class Rank : EntityBase
    {
        [Key]
        public Guid RankID { get; set; }
        public string RankCode { get; set; }
        public string RankName { get; set; }
        public string Description { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
    }
}
