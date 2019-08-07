using System;

namespace MT.Model
{
    /// <summary>
    /// Đánh dấu thuộc tính nhập không được nhập trùng(Thường dùng để validate mã)
    /// </summary>
    public class DuplicateAttribute : Attribute
    {
        /// <summary>
        /// Chỉ định mã cần check trùng
        /// </summary>
        private string codeName;

        public string CodeName
        {
            get { return codeName; }
            set { codeName = value; }
        }

        /// <summary>
        /// Chỉ định tên dùng để show lên cảnh báo
        /// </summary>
        private string nameDisplay;

        public string NameDisplay
        {
            get { return nameDisplay; }
            set { nameDisplay = value; }
        }

        public DuplicateAttribute()
        {
            this.codeName = "";
            this.nameDisplay = "";
        }
        public DuplicateAttribute(string codeName)
        {
            this.codeName = codeName;
            this.nameDisplay = codeName;
        }

        public DuplicateAttribute(string codeName, string nameDisplay)
        {
            this.codeName = codeName;
            this.nameDisplay = nameDisplay;
        }
    }
}
