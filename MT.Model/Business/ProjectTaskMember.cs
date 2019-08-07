using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
	#region ProjectTaskMember:EntityBase
	/// <summary>
	/// This object represents the properties and methods of a ProjectTaskMember:EntityBase.
	/// </summary>
	public class ProjectTaskMember:EntityBase
	{
        [Key]
		public Guid ProjectTaskMemberID {get;set;}
		public Guid ProjectTaskID{get;set;}
		public Guid EmployeeID{get;set;}
		public DateTime StartDate{get;set;}
		public DateTime EndDate{get;set;}
		public decimal MonthForTask{get;set;}
		public int SortOrder{get;set;}
        public string EmployeeName { get; set; }
        public string FullName { get; set; }
        public int Rownum { get; set; }


    }
	#endregion
}

