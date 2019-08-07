using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MT.Model
{
    public class Report_DaysLeft
    {
        public Guid? projectID { get; set; }
        public Guid? companyID { get; set; }
        public Guid? employeeID { get; set; }
        public int year { get; set; }
    }
}
