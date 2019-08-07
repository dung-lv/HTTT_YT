using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
	#region ProjectPlanExpense:EntityBase
	/// <summary>
	/// This object represents the properties and methods of a ProjectPlanExpense:EntityBase.
	/// </summary>
	public class ProjectPlanExpense:EntityBase
	{
        [Key]
		public Guid ProjectPlanExpenseID {get;set;}
		public Guid ProjectID{get;set;}
		public string Number{get;set;}
		public DateTime Date{get;set;}
		public decimal Amount{get;set;}
		public bool Inactive{get;set;}
		public int SortOrder{get;set;}
        /// <summary>
        /// Danh sách file đính kèm
        /// </summary>
        /// Create by: truongnm:11.02.2018
        public List<ProjectPlanExpense_AttachDetail> Details { get; set; }

        public string IdFiles { get; set; }
    }
	#endregion
}

