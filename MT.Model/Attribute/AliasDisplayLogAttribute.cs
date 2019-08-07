using System;

namespace MT.Models
{
    /// <summary>
    /// Dùng để ghi log cho các thuộc tính kiểu bool
    /// </summary>
    /// Create by: dvthang:26.09.2017
    public class AliasDisplayLogAttribute : Attribute
    {
        public string YesAlias { get; set; }
        public string NoAlias { get; set; }

        public AliasDisplayLogAttribute(string yesAlias, string noAlias)
        {
            this.YesAlias = yesAlias;
            this.NoAlias = noAlias;
        }
    }
}
