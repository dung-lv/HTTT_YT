using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace MT.Library
{
    public static class ExtensionMethod
    {
        /// <summary>
        /// Lấy giá trị của control
        /// </summary>
        /// <typeparam name="T">Kiểu giá trị trả về</typeparam>
        /// <param name="oEntity">Entity</param>
        /// <param name="fieldName">Tên cột</param>
        /// <returns>Giá trị của thuộc tính</returns>
        /// Create by: dvthang:21.10.2017
        public static T GetValue<T>(this object oEntity, string fieldName)
        {
            T t = default(T);
            if (oEntity != null && !string.IsNullOrEmpty(fieldName))
            {
                PropertyInfo info = oEntity.GetType().GetProperty(fieldName);
                if (info != null)
                {
                    object oValue = info.GetValue(oEntity);
                    if (oValue != null)
                    {
                        t = oValue.ChangeType<T>();
                    }
                }
            }

            return t;
        }

        /// <summary>
        /// Gán giá trị cho object
        /// </summary>
        /// Create by: dvthang:21.10.2017
        public static void SetValue(this object entity, string fieldName, object value)
        {
            PropertyInfo info = entity.GetType().GetProperty(fieldName);
            if (info != null && info.CanWrite)
            {
                info.SetValue(entity, value.ChangeType(info.PropertyType), null);
            }
        }

        /// <summary>
        /// Lấy về kiểu dữ liệu của thuộc tính
        /// </summary>
        /// <param name="entity">Tên đối tượng</param>
        /// <param name="propertyName"></param>
        /// <returns>Create by: dvthang:06.03.2017</returns>
        public static Type GetPropertyType<T>(this T entity, string propertyName)
        {
            PropertyInfo pInfo = entity.GetType().GetProperty(propertyName);
            if (pInfo != null)
            {
                Type type = pInfo.PropertyType;
                return type;
            }
            return null;
        }

        /// <summary>
        /// CHuyển kiểu dữ liệu cho object
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="value"></param>
        /// <returns>Trả về giá trị</returns>
        /// Create by: dvthang:23.10.2017
        public static T ChangeType<T>(this object value)
        {
            var t = typeof(T);

            if (t.IsGenericType && t.GetGenericTypeDefinition().Equals(typeof(Nullable<>)))
            {
                if (value == null)
                {
                    return default(T);
                }

                t = Nullable.GetUnderlyingType(t);
            }

            return (T)Convert.ChangeType(value, t);
        }

        /// <summary>
        /// CHuyển kiểu dữ liệu cho object
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="value"></param>
        /// <returns>Trả về giá trị</returns>
        /// Create by: dvthang:23.10.2017
        public static object ChangeType(this object value, Type conversion)
        {
            var t = conversion;
            if (value == null)
            {
                return null;
            }
            if (t.IsGenericType && t.GetGenericTypeDefinition().Equals(typeof(Nullable<>)))
            {
                
                t = Nullable.GetUnderlyingType(t);
            }              

            return Convert.ChangeType(value, t);
        }

        /// <summary>
        /// Xử lý lỗi SQL Injection
        /// </summary>
        /// <param name="value">Chuỗi cần xử lý</param>
        /// <returns>Trả về chuỗi sau khi đã xử lý</returns>
        /// Create by: dvthang:05.11.2017
        public static string ProcessSQLInjetion(this string value)
        {
            //todo
            return value;
        }

        /// <summary>
        /// Thực hiện chuyển từ kiểu IDataReader sang sang List<object></object>
        /// </summary>
        /// <typeparam name="object">objectCreate</typeparam>
        /// <param name="dr">datareader</param>
        /// <returns>Create by: dvthang:11.11.2017</returns>

        /// <summary>
        /// Thực hiện lưu dữ liệu ra file để
        /// </summary>
        /// <param name="strData">Dữ liệu cần ghi</param>
        /// <param name="strPath">Đường dẫn lưu dữ liệu có thay đổi</param>
        /// Create by: dvthang:11.11.2017
        public static bool WriteData(this string strData, string strPath, bool isCompress = false)
        {
            bool isSuccess = false;
            try
            {

                using (FileStream fs = new FileStream(strPath, FileMode.Create, FileAccess.Write))
                using (StreamWriter sw = new StreamWriter(fs))
                {
                    if (isCompress)
                    {
                        strData = strData.CompressString();
                    }
                    sw.WriteLine(strData);
                }
                isSuccess = true;
            }
            catch (Exception ex)
            {
               
            }
            return isSuccess;
        }

        /// <summary>
        /// Thực hiện đọc dữ liệu lưu trong tệp ra
        /// </summary>
        /// <param name="strData">Dữ liệu cần ghi</param>
        /// <param name="strPath">Đường dẫn lưu dữ liệu có thay đổi</param>
        /// Create by: dvthang:11.11.2017
        public static string ReadData(this string strPath, bool isDecompress = false)
        {
            string data = string.Empty; ;
            try
            {
                using (FileStream fs = new FileStream(strPath, FileMode.Open, FileAccess.Read))
                using (StreamReader sr = new StreamReader(fs))
                {
                    data = sr.ReadToEnd();
                    if (isDecompress)
                    {
                        data = data.DecompressString();
                    }
                }
            }
            catch (Exception ex)
            {
             
            }
            return data;
        }

        /// <summary>
        /// Thực hiện nén chuỗi string
        /// </summary>
        /// <param name="text">CHuỗi cần nén</param>
        /// Trả về nội dung chuỗi sau khi nén
        public static string CompressString(this string text)
        {
            byte[] buffer = Encoding.ASCII.GetBytes(text);
            MemoryStream ms = new MemoryStream();
            using (GZipStream zip = new GZipStream(ms, CompressionMode.Compress, true))
            {
                zip.Write(buffer, 0, buffer.Length);
            }

            ms.Position = 0;
            MemoryStream outStream = new MemoryStream();

            byte[] compressed = new byte[ms.Length];
            ms.Read(compressed, 0, compressed.Length);

            byte[] gzBuffer = new byte[compressed.Length + 4];
            System.Buffer.BlockCopy(compressed, 0, gzBuffer, 4, compressed.Length);
            System.Buffer.BlockCopy(BitConverter.GetBytes(buffer.Length), 0, gzBuffer, 0, 4);
            return Convert.ToBase64String(gzBuffer);
        }

        /// <summary>
        /// Thực hiện giải nén chuỗi
        /// </summary>
        /// <param name="data">CHuỗi cần giải nén</param>
        /// TRả về danh sách dữ liệu trước khi nén
        public static string DecompressString(this string data)
        {
            byte[] compressed = Convert.FromBase64String(data);
            using (var compressedStream = new MemoryStream(compressed))
            {
                byte[] lengthBytes = new byte[4];
                compressedStream.Read(lengthBytes, 0, 4);

                var length = BitConverter.ToInt32(lengthBytes, 0);
                using (var decompressionStream = new GZipStream(compressedStream,
                    CompressionMode.Decompress))
                {
                    var result = new byte[length];
                    decompressionStream.Read(result, 0, length);
                    return Encoding.UTF8.GetString(result);
                }
            }
        }

        /// <summary>
        /// Chuyển chuỗi Datetime sang định dạng Thứ X, "dd '/' MM '/' yyyy"
        /// </summary>
        /// <param name="datetime">Chuỗi Datetime</param>
        /// <returns>Create by:dvthang:05.03.2018</returns>
        public static string FullDateTime(this DateTime datetime)
        {
            string strCurDT = datetime.ToString("dd/MM/yyyy");
            string mydt = datetime.DayOfWeek.ToString().Substring(0, 3);
            string output = "";
            switch (mydt)
            {
                case "Mon":
                    output = "Thứ hai, " + strCurDT;
                    break;
                case "Tue":
                    output = "Thứ ba, " + strCurDT;
                    break;
                case "Wed":
                    output = "Thứ tư, " + strCurDT;
                    break;
                case "Thu":
                    output = "Thứ năm, " + strCurDT;
                    break;
                case "Fri":
                    output = "Thứ sáu, " + strCurDT;
                    break;
                case "Sat":
                    output = "Thứ bảy, " + strCurDT;
                    break;
                case "Sun":
                    output = "Chủ nhật, " + strCurDT;
                    break;

            }
            return output;
        }
    }

    public static class NumberFormart
    {
        /// <summary>
        /// Convert string value to decimal ignore the culture.
        /// </summary>
        /// <param name="value">Gia tri can chuyen.</param>
        /// <returns>Decimal value.</returns>
        /// Create by: dvthang:15.11.2017
        public static decimal ToDecimal(this string value)
        {
            decimal number;
            string tempValue = value;

            var punctuation = value.Where(x => char.IsPunctuation(x)).Distinct();
            int count = punctuation.Count();

            NumberFormatInfo format = CultureInfo.InvariantCulture.NumberFormat;
            switch (count)
            {
                case 0:
                    break;
                case 1:
                    tempValue = value.Replace(",", ".");
                    break;
                case 2:
                    if (punctuation.ElementAt(0) == '.')
                        tempValue = value.SwapChar('.', ',');
                    break;
                default:
                    throw new InvalidCastException();
            }

            number = decimal.Parse(tempValue, format);
            return number;
        }

        /// <summary>
        /// Convert string value to decimal ignore the culture.
        /// </summary>
        /// <param name="value">Gia tri can chuyen.</param>
        /// <returns>Decimal value.</returns>
        /// Create by: dvthang:15.11.2017
        public static decimal ToDecimal(this object value)
        {
            decimal number = 0;
            if (value != null)
            {
                number = ToDecimal(value.ToString());
            }
            return number;
        }
        /// <summary>
        /// Swaps the char.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <param name="from">From.</param>
        /// <param name="to">To.</param>
        /// <returns></returns>
        /// Create by: dvthang:15.11.2017
        public static string SwapChar(this string value, char from, char to)
        {
            if (value == null)
                throw new ArgumentNullException("value");

            StringBuilder builder = new StringBuilder();

            foreach (var item in value)
            {
                char c = item;
                if (c == from)
                    c = to;
                else if (c == to)
                    c = from;

                builder.Append(c);
            }
            return builder.ToString();
        }

    }
}
