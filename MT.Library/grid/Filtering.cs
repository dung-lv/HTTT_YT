using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MT.Library
{
    public class Filtering
    {
        public string property { get; set; }
        public string value { get; set; }
        public DataType type { get; set; }
        public FilterOperations @operator { get; set; }

        public Addition addition { get; set; }

        public string group { get; set; }
    }

    /// <summary>
    /// Phép toán nối giữa các toán tử
    /// </summary>
    /// Create by: dvthang:25.02.2018
    public enum Addition
    {
        AND,
        OR       
    }

    /// <summary>
    /// Kiểu dữ liệu filter
    /// </summary>
    /// Create by: dvthang:25.02.2018
    public enum DataType
    {
        String,
        Boolean,
        Byte,
        Int,
        Float,
        Double,
        Decimal,
        Time,
        Date,
        DateTime
    }

    /// <summary>
    /// Danh sách điều kiện Filter
    /// </summary>
    /// Create by: dvthang:25.02.2018
    public enum FilterOperations
    {
        Equals,
        NotEquals,
        Greater,
        GreaterOrEquals,
        LessThan,
        LessThanOrEquals,
        StartsWith,
        EndsWith,
        Contains,
        NotContains,
    }
}
