using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MT.Model
{
    /// <summary>
    /// Bảng cấp quản lý đề tài
    /// </summary>
    /// Create by: laipv:13.01.2018
    public class Level : EntityBase
    {
        [Key]
        public Int32 LevelID { get; set; }
        public string LevelCode { get; set; }
        public string LevelName { get; set; }
        public string Description { get; set; }
        public bool Inactive { get; set; }
        public int SortOrder { get; set; }
    }
}
