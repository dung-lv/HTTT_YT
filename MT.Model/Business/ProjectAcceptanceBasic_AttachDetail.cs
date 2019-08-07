using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
	#region ProjectAcceptanceBasic_AttachDetail:EntityBase
	/// <summary>
	/// This object represents the properties and methods of a ProjectAcceptanceBasic_AttachDetail:EntityBase.
	/// </summary>
	public class ProjectAcceptanceBasic_AttachDetail:EntityBase
	{
        [Key]
		public Guid ProjectAcceptanceBasic_AttachDetailID {get;set;}
		public Guid ProjectAcceptanceBasicID{get;set;}
		public string Contents{get;set;}
		public string FileName{get;set;}
		public string FileType{get;set;}
		public double FileSize{get;set;}
		public bool Inactive{get;set;}
		public int SortOrder{get;set;}

        public Guid? FileResourceID { get; set; }

    }
	#endregion
}

