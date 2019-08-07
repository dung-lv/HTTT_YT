using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MT.Model
{
    public class Report_Laborday
    {
        public Guid? projectID { get; set; }
        public string projectName { get; set; }
        public Guid? projectTaskID { get; set; }
        public string contents { get; set; }
        public Guid? employeeID { get; set; }
        public string fullName { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }

    }
}
