using MT.Library;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MT.Model
{
    /// <summary>
    /// Bảng quản lý chấm công (tính tiền) đề tài
    /// </summary>
    /// Create by: laipv:03.03.2018
    public class ProjectTaskMemberFinance : EntityBase
    {
        [Key]
        public Guid ProjectTaskMemberFinanceID { get; set; }
        public Guid? ProjectID { get; set; }
        public Guid? ProjectTaskID { get; set; }
        public Guid? EmployeeID { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }
        public DateTime Day { get; set; }

        /// <summary>
        /// Trả về ngày dạng text
        /// </summary>
        /// Create by: dvthang:3.3.2018
        public string DayName { get
            {
                return Day.FullDateTime();
            }
        }
        public string Description { get; set; }
        public decimal Hour { get; set; }
        public decimal LaborDay { get; set; }
        public string DescriptionFin { get; set; }
        public decimal HourFin { get; set; }
        public decimal LaborDayFin { get; set; }
        public int SortOrder { get; set; }
        #region trường mới thêm để thực hiện việc cho phép nhập hay không
        //DayOff = true: Ngày này là ngày nghỉ không được nhập; DayOff = false: Ngày này được nhập
        public bool DayOff { get; set; }

        public decimal LaborDayMade { get; set; }

        public string DescriptionMade { get; set; }
        #endregion
    }
}
