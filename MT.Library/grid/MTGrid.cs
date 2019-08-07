using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MT.Library
{
    public class MTGrid
    {
        public static string BuildSort(List<Sorting> sorts)
        {
            string expressionSort = "";
            if (sorts != null)
            {
                StringBuilder builder = new StringBuilder();
                string direction = "ASC";
                foreach (var sort in sorts)
                {
                    if (sort.direction == Direction.DESC)
                    {
                        direction = "DESC";
                    }
                    builder.AppendFormat(" [{0}] {1},", sort.property, direction);
                }
                if (builder.Length > 0)
                {
                    string strBuider = builder.ToString();
                    expressionSort = strBuider.Substring(0, strBuider.Length - 1);
                }
            }

            return expressionSort;
        }

        /// <summary>
        /// Dựng biểu thức where 
        /// </summary>
        /// <param name="filters">Chuỗi filter truyền lên</param>
        /// <returns></returns>
        /// Create by: dvthang:25.02.2018
        public static string BuildWhere(List<Filtering> filters)
        {
            List<string> lstExpression = new List<string>();
            if (filters != null)
            {

                var sortFilter = filters.OrderBy(m => m.group).ToList();
                HashSet<string> groups = new HashSet<string>();
                filters.ForEach(m =>
                {
                    groups.Add(m.group);
                });

                foreach (var g in groups)
                {
                    var dataByGroup = sortFilter.Where(m => m.group == g).ToList();
                    byte index = 0;
                    StringBuilder builder = new StringBuilder();
                    int iLast = dataByGroup.Count;
                    foreach (var f in dataByGroup)
                    {
                        var addition = f.addition;
                        index++;
                        bool isFirst = index == 1;
                        string strValue = SQLInection(f.value);
                        string strOperator = GetOperations(f.type, f.@operator);
                        switch (f.@operator)
                        {
                            case FilterOperations.Contains:
                               
                                strValue = $"N\'%{strValue}%\'";
                                break;
                            case FilterOperations.EndsWith:
                                strValue = $"N\'%{strValue}\'";
                                break;
                            case FilterOperations.StartsWith:
                                strValue = $"N\'{strValue}%\'";
                                break;
                            case FilterOperations.Equals:
                            case FilterOperations.Greater:
                            case FilterOperations.GreaterOrEquals:
                            case FilterOperations.LessThan:
                            case FilterOperations.LessThanOrEquals:
                            case FilterOperations.NotContains:
                            case FilterOperations.NotEquals:
                                switch (f.type)
                                {
                                    case DataType.String:
                                        if (!string.IsNullOrEmpty(strValue))
                                        {
                                            strValue = $"N\'{strValue}\'";
                                        }
                                        else
                                        {
                                            strOperator = string.Empty;
                                            if (f.@operator == FilterOperations.Equals)
                                            {
                                                strValue = " IS NULL ";
                                            }
                                            else
                                            {
                                                strValue = " IS NOT NULL ";
                                            }
                                        }
                                        break;
                                    case DataType.Time:
                                    case DataType.DateTime:
                                        if (!string.IsNullOrEmpty(strValue))
                                        {
                                            DateTime dtTime;
                                            if (DateTime.TryParse(strValue, out dtTime))
                                            {
                                                strValue = $"\'{String.Format("{0:yyyy/MM/dd HH:mm:ss}", dtTime)}\'";
                                            }
                                        }
                                        else
                                        {
                                            strOperator = string.Empty;
                                            if (f.@operator == FilterOperations.Equals)
                                            {
                                                strValue = " IS NULL ";
                                            }
                                            else
                                            {
                                                strValue = " IS NOT NULL ";
                                            }
                                        }
                                        break;
                                    case DataType.Date:
                                        if (!string.IsNullOrEmpty(strValue))
                                        {
                                            DateTime dtTime = CommonFunction.DeserializeObject<DateTime>(strValue);
                                            strValue = $"\'{String.Format("{0:yyyy/MM/dd}", dtTime)}\'";
                                        }
                                        else
                                        {
                                            strOperator = string.Empty;
                                            if (f.@operator == FilterOperations.Equals)
                                            {
                                                strValue = " IS NULL ";
                                            }
                                            else
                                            {
                                                strValue = " IS NOT NULL ";
                                            }
                                        }
                                        break;

                                }
                                break;
                        }
                        BuildExpression(ref builder, isFirst, f.property, strOperator,
                            strValue, addition.ToString(),
                            (index == iLast));
                    }
                    lstExpression.Add(builder.ToString());
                }

                return string.Join(" AND ", lstExpression);
            }

            return string.Empty;
        }

        /// <summary>
        /// Xử lý lỗi SQL injection
        /// </summary>
        /// <returns>Trả về chuỗi đã được xử lý lỗi Injection</returns>
        /// Create by: dvthang:25.02.2018
        private static string SQLInection(string input)
        {
            if (!string.IsNullOrEmpty(input))
            {
                input = input.Replace("'", "''");
                input = input.Replace("%", "[%]");
                input = input.Replace("[", "[[]");
                input = input.Replace("_", "[_]");
            }
            return input;
        }

        /// <summary>
        /// Lấy về phép toán quan hệ
        /// </summary>
        /// <param name="dataType">Kiểu dữ liệu</param>
        /// <returns>Lấy về phép toán quan hệ</returns>
        /// Create by: dvthang:25.02.2018
        private static string GetOperations(DataType dataType, FilterOperations op)
        {
            string strOperation = "";

            if (dataType == DataType.String)
            {
                switch (op)
                {
                    case FilterOperations.Contains:
                    case FilterOperations.StartsWith:
                    case FilterOperations.EndsWith:
                        strOperation = " LIKE ";
                        break;
                    case FilterOperations.NotContains:
                        strOperation = " NOT LIKE ";
                        break;
                    case FilterOperations.NotEquals:
                        strOperation = " <> ";
                        break;
                    case FilterOperations.Equals:
                        strOperation = " = ";
                        break;
                }
            }
            else if (dataType == DataType.Boolean)
            {
                strOperation = " = ";
            }
            else if (dataType == DataType.Byte || dataType == DataType.Int
                || dataType == DataType.Float
                || dataType == DataType.Double
                || dataType == DataType.Decimal
                || dataType == DataType.Date
                || dataType == DataType.DateTime
                || dataType == DataType.Time)
            {
                switch (op)
                {
                    case FilterOperations.Equals:
                        strOperation = " = ";
                        break;
                    case FilterOperations.NotEquals:
                        strOperation = " <> ";
                        break;
                    case FilterOperations.Greater:
                        strOperation = " > ";
                        break;
                    case FilterOperations.GreaterOrEquals:
                        strOperation = " >= ";
                        break;
                    case FilterOperations.LessThan:
                        strOperation = " < ";
                        break;
                    case FilterOperations.LessThanOrEquals:
                        strOperation = " <= ";
                        break;
                }
            }

            return strOperation;
        }

        /// <summary>
        /// Dựng biểu thức SQL
        /// </summary>
        /// <returns>Trả về biểu thức SQL</returns>
        /// Create by: dvthang:25.02.2018
        private static void BuildExpression(ref StringBuilder builder, bool isFirst,
            string property, string strOperator, string value,
            string addition, bool isLast = false)
        {
            string quote = "";
            if (isLast)
            {
                quote = " ) ";
                addition = "";
            }

            if (isFirst)
            {
                builder.AppendFormat(" ( [{0}] {1} {2} {3}{4} ",
                    property, strOperator, value, addition, quote);
            }
            else
            {
                builder.AppendFormat(" {0} [{1}] {2} {3}{4}",
                    addition, property, strOperator, value, quote);
            }
        }
    }




}
