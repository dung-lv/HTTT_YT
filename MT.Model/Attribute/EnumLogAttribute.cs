using System;

namespace MT.Models
{
    /// <summary>
    /// Dùng để ghi log dạng enum
    /// </summary>
    /// Create by: dvthang:26.09.2017
    public class EnumLogAttribute : Attribute
    {
        public string FieldName { get; set; }
        public EnumLogAttribute(string fieldName)
        {
            this.FieldName = fieldName;
        }
    }
}
