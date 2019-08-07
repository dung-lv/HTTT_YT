using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MT.Model.Gantt
{
    public class Task : TreeStore
    {
        public Guid Id { get; set; }
        public Guid ProjectID { get; set; }
        public bool IsProject { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public double Duration {
            get
            {
                return EndDate.Subtract(this.StartDate).TotalDays;
            }
        }
        public decimal PercentDone { get; set; }
        public string Name { get; set; }

        public Guid? ParentID{ get; set; }
    }
}
