﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
	#region ProjectAcceptanceManage:EntityBase
	/// <summary>
	/// This object represents the properties and methods of a ProjectAcceptanceManage:EntityBase.
	/// </summary>
	public class ProjectAcceptanceManage:EntityBase
	{
        [Key]
		public Guid ProjectAcceptanceManageID {get;set;}
		public Guid ProjectID{get;set;}
		public DateTime EstablishedDate{get;set;}
		public DateTime MeetingDate{get;set;}
		public int Status{get;set;}
		public bool Inactive{get;set;}
		public int SortOrder{get;set;}

        /// <summary>
        /// Danh sách file đính kèm
        /// </summary>
        /// Create by: manh:11.02.2018
        public List<ProjectAcceptanceManage_AttachDetail> Details { get; set; }

    }
	#endregion
}

