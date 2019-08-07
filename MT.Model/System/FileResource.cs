using MT.Library;
using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    #region FileResource

    /// <summary>
    /// Đối tượng chứa thông tin file
    /// </summary>
    /// Create by:dvthang:22.01.2018
    public class FileResource 
    {
        [Key]
        public Guid FileResourceID { get; set; }

        public string FileName { get; set; }

        public string FileType { get; set; }

        public float FileSize { get; set; }

        public string FileNameNExt { get; set; }

    }

    #endregion FileResource
}