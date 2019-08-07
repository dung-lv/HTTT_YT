using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
	#region ProjectPresentProtected:EntityBase
	/// <summary>
	/// This object represents the properties and methods of a ProjectPresentProtected:EntityBase.
	/// </summary>
	public class ProjectPresentProtected:EntityBase
	{
        [Key]
		public Guid ProjectPresentProtectedID {get;set;}
		public Guid ProjectID{get;set;}
		public string DecisionNumber{get;set;}
		public DateTime DecisionDate{get;set;}
		public DateTime ProtectedDate{get;set;}
		public int Status{get;set;}
		public bool Inactive{get;set;}
		public int SortOrder{get;set;}
		
	
	}
	#endregion
}

