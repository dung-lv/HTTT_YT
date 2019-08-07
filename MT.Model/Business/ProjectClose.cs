using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
	#region ProjectClose:EntityBase
	/// <summary>
	/// This object represents the properties and methods of a ProjectClose:EntityBase.
	/// </summary>
	public class ProjectClose:EntityBase
	{
        [Key]
		public Guid ProjectCloseID {get;set;}
		public Guid ProjectID{get;set;}
		public DateTime Date{get;set;}
		public DateTime LiquidationDate{get;set;}
		public string FileName{get;set;}
		public string FileType{get;set;}
		public double FileSize{get;set;}
		public bool Inactive{get;set;}
		public int SortOrder{get;set;}
        public Guid FileResourceID { get; set; }
        /// <summary>
        /// Danh sách file đính kèm
        /// </summary>
        /// Create by: manh:11.02.2018
        public List<ProjectClose_AttachDetail> Details { get; set; }

        public string IdFiles { get; set; }

    }
	#endregion
}

