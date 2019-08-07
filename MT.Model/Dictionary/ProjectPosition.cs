using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
	#region ProjectPosition:EntityBase
	/// <summary>
	/// This object represents the properties and methods of a ProjectPosition:EntityBase.
	/// </summary>
	public class ProjectPosition:EntityBase
	{
        [Key]
		public Guid ProjectPositionID {get;set;}
		public string ProjectPositionCode{get;set;}
		public string ProjectPositionName{get;set;}
		public string ProjectPositionShortName{get;set;}
		public decimal Coefficient{get;set;}
		public string Description{get;set;}
		public bool Inactive{get;set;}
		public int SortOrder{get;set;}

	}
	#endregion
}

