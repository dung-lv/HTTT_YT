using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.IO;
using System.Web;
using Newtonsoft.Json;
using System.Drawing;

namespace MT.Library
{
    public class CommonFunction
    {

        /// <summary>
        /// Lấy về key của session theo user
        /// </summary>
        /// Create by: dvthang:28.12.2016
        public static string GetKeyByUserName(string keyName)
        {
            return string.Format("dvthang{0}", keyName);
        }

        /// <summary>
        /// Thực hiện xóa tất cả các file temp của user hiện tại mỗi lần đăng nhập vào chương trình
        /// Create by: dvthang:12.01.2017
        /// </summary>
        public static void CleanFileInDirectoryTemp(Guid userId)
        {
            string targetDirectory = HttpContext.Current.Server.MapPath(MT.Library.Commonkey.Temp);
            // Tìm tất cả các file chứa userId trong thư mục vào xóa nó đi
            string[] fileEntries = Directory.GetFiles(targetDirectory);
            foreach (string fileName in fileEntries)
            {
                if (fileName.Contains(userId.ToString()) || fileName.Contains(Guid.Empty.ToString()))
                {
                    fileName.DeleteFile();
                }
            }
        }

        /// <summary>
        /// Xử lý lỗi sql injection
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static string SQLInjection(string value, string strOperator = "")
        {

            switch (strOperator)
            {
                case "startswith":
                case "endswith":
                case "contains":
                case "doesnotcontain":
                    if (!string.IsNullOrWhiteSpace(value))
                    {
                        value = value.Replace("%", "[%]");
                        value = value.Replace("[", "[[]");
                        value = value.Replace("_", "[_]");
                    }
                    break;
                case "eq":
                case "neq":
                case "lt":
                case "lte":
                case "gt":
                case "gte":
                    break;
            }

            if (string.IsNullOrWhiteSpace(value))
            {
                return string.Empty;
            }
            else
            {

                return value[0].ToString().Replace("'", "") + value.Substring(1, value.Length - 2).Replace("'", "''") + value[value.Length - 1].ToString().Replace("'", "");
            }
        }


        /// <summary>
        /// Build chuỗi where
        /// </summary>
        /// <param name="filter"></param>
        /// <returns></returns>
        public static string GetWhereClause(string filter)
        {
            System.Text.StringBuilder strSQL = new System.Text.StringBuilder();
            if (!string.IsNullOrWhiteSpace(filter))
            {
                bool boolValue;
                Int32 intValue;
                Int64 bigintValue;
                decimal doubleValue;
                DateTime dateValue;
                filter = filter.Replace("~and~", "|");
                string[] lstFilter = filter.Split(new char[1] { '|' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var item in lstFilter)
                {
                    bool isDate = false;
                    string[] filterItem = item.Split(new char[1] { '~' }, StringSplitOptions.RemoveEmptyEntries);
                    if (!string.IsNullOrWhiteSpace(filterItem[2]) && filterItem[2].IndexOf("datetime") > -1)
                    {
                        string strDate = filterItem[2].Replace("datetime", "").Replace("'", "");
                        string[] strValue = strDate.Split(new char[1] { 'T' }, StringSplitOptions.RemoveEmptyEntries);
                        string dte = strValue[0];
                        string hh = strValue[1].Replace("-", ":");
                        filterItem[2] = "'" + string.Format("{0} {1}", dte, hh) + "'";
                        isDate = true;
                    }
                    switch (filterItem[1])
                    {
                        case "startswith":
                            strSQL.Append(string.Format(" AND [{0}] LIKE N'{1}%'", filterItem[0], SQLInjection(filterItem[2])));
                            break;
                        case "endswith":
                            strSQL.Append(string.Format(" AND [{0}] LIKE N'%{1}'", filterItem[0], SQLInjection(filterItem[2])));
                            break;
                        case "contains":
                            strSQL.Append(string.Format(" AND [{0}] LIKE N'%{1}%'", filterItem[0], SQLInjection(filterItem[2])));
                            break;
                        case "doesnotcontain":
                            strSQL.Append(string.Format(" AND [{0}] NOT LIKE N'%{1}%'", filterItem[0], SQLInjection(filterItem[2])));
                            break;
                        case "eq":
                            if (bool.TryParse(filterItem[2], out boolValue))
                                strSQL.Append(string.Format(" AND isnull([{0}],0)={1}", filterItem[0], boolValue ? 1 : 0));
                            else if (Int32.TryParse(filterItem[2], out intValue))
                                strSQL.Append(string.Format(" AND [{0}]={1}", filterItem[0], intValue));
                            else if (Int64.TryParse(filterItem[2], out bigintValue))
                                strSQL.Append(string.Format(" AND [{0}]={1}", filterItem[0], bigintValue));
                            else if (decimal.TryParse(filterItem[2], out doubleValue))
                                strSQL.Append(string.Format(" AND [{0}]={1}", filterItem[0], doubleValue));
                            else if (DateTime.TryParse(filterItem[2], out dateValue))
                                strSQL.Append(string.Format(" AND [{0}]='{1}'", filterItem[0], dateValue));
                            else
                                strSQL.Append(string.Format(" AND [{0}]=N'{1}'", filterItem[0], SQLInjection(filterItem[2])));
                            break;
                        case "neq":
                            if (bool.TryParse(filterItem[2], out boolValue))
                                strSQL.Append(string.Format("AND isnull([{0}],0)<>{1}", filterItem[0], boolValue ? 1 : 0));
                            else if (Int32.TryParse(filterItem[2], out intValue))
                                strSQL.Append(string.Format(" AND [{0}]<>{1}", filterItem[0], intValue));
                            else if (Int64.TryParse(filterItem[2], out bigintValue))
                                strSQL.Append(string.Format(" AND [{0}]<>{1}", filterItem[0], bigintValue));
                            else if (decimal.TryParse(filterItem[2], out doubleValue))
                                strSQL.Append(string.Format(" AND [{0}]<>{1}", filterItem[0], doubleValue));
                            else if (DateTime.TryParse(filterItem[2], out dateValue))
                                strSQL.Append(string.Format(" AND [{0}]<>'{1}'", filterItem[0], dateValue));
                            else
                                strSQL.Append(string.Format(" AND [{0}]<>N'{1}'", filterItem[0], SQLInjection(filterItem[2])));
                            break;
                        case "lt":
                            if (isDate)
                            {
                                strSQL.Append(string.Format(" AND [{0}] <{1}", filterItem[0], filterItem[2]));
                            }
                            else
                            {
                                strSQL.Append(string.Format(" AND [{0}] <{1}", filterItem[0], SQLInjection(filterItem[2])));
                            }
                            break;
                        case "lte":
                            if (isDate)
                            {
                                strSQL.Append(string.Format(" AND [{0}] <={1}", filterItem[0], filterItem[2]));
                            }
                            else
                            {
                                strSQL.Append(string.Format(" AND [{0}] <={1}", filterItem[0], SQLInjection(filterItem[2])));
                            }
                            break;
                        case "gt":
                            if (isDate)
                            {
                                strSQL.Append(string.Format(" AND [{0}] >{1}", filterItem[0], filterItem[2]));
                            }
                            else
                            {
                                strSQL.Append(string.Format(" AND [{0}] >{1}", filterItem[0], SQLInjection(filterItem[2])));
                            }
                            break;
                        case "gte":
                            if (isDate)
                            {
                                strSQL.Append(string.Format(" AND [{0}] >={1}", filterItem[0], filterItem[2]));
                            }
                            else
                            {
                                strSQL.Append(string.Format(" AND [{0}] >={1}", filterItem[0], SQLInjection(filterItem[2])));
                            }
                            break;
                    }
                }
            }
            return strSQL.ToString();
        }

        /// <summary>
        /// Thiết lập kiểu json dạng isodate và giờ theo giờ server
        /// </summary>
        /// dvthang-03.10.2016
        public static JsonSerializerSettings GetJsonSerializerSettings()
        {
            return new JsonSerializerSettings { DateFormatHandling = DateFormatHandling.IsoDateFormat, DateTimeZoneHandling = DateTimeZoneHandling.Local };
        }

        /// <summary>
        /// Convert chuyển json về dạng object
        /// </summary>
        /// <typeparam name="T">Kiểu object</typeparam>
        /// <param name="value">Chuỗi json</param>
        /// <returns>dvthang-02.10.2016</returns>
        public static T DeserializeObject<T>(string value)
        {
            if (!string.IsNullOrEmpty(value))
            {
                return JsonConvert.DeserializeObject<T>(value, GetJsonSerializerSettings());
            }
            else
            {
                return default(T);
            }
        }

        /// <summary>
        /// Convert chuyển json về dạng object
        /// </summary>
        /// <typeparam name="T">Kiểu object</typeparam>
        /// <param name="value">Chuỗi json</param>
        /// <returns>dvthang-02.10.2016</returns>
        public static object DeserializeObject(string value, Type type)
        {
            if (!string.IsNullOrEmpty(value))
            {
                return JsonConvert.DeserializeObject(value, type, GetJsonSerializerSettings());
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Convert chuyển object về dạng chuỗi json
        /// </summary>
        /// <param name="value">Object cần chuyển đổi</param>
        /// <returns>dvthang-02.10.2016</returns>
        public static string SerializeObject(object value)
        {
            if (value != null)
            {
                return JsonConvert.SerializeObject(value, GetJsonSerializerSettings());
            }
            else
            {
                return string.Empty;
            }
        }
        public static DataTable ToDataTable<T>(IList<T> data)
        {
            PropertyDescriptorCollection properties =
                TypeDescriptor.GetProperties(typeof(T));
            DataTable table = new DataTable();
            foreach (PropertyDescriptor prop in properties)
                table.Columns.Add(prop.Name, Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
            foreach (T item in data)
            {
                DataRow row = table.NewRow();
                foreach (PropertyDescriptor prop in properties)
                    row[prop.Name] = prop.GetValue(item) ?? DBNull.Value;
                table.Rows.Add(row);
            }
            return table;
        }

        /// <summary>
        /// Ghi log lỗi
        /// </summary>
        /// Create by: dvthang:20.04.2017
        public static void CommonLogError(Exception ex)
        {

        }

        /// <summary>
        /// Lấy đường dẫn thư mục temp
        /// </summary>
        /// <returns></returns>
        /// Create by: dvthang:04.02.2018
        public static string GetMapPathTemp()
        {
            string temp = MT.Library.UtilityExtensions.GetKeyAppSetting(Commonkey.Temp);

            return HttpContext.Current.Server.MapPath(temp);
        }

        /// <summary>
        /// Lấy đường dẫn thư mục Thật
        /// </summary>
        /// <returns></returns>
        /// Create by: dvthang:04.02.2018
        public static string GetMapPathUpload()
        {
            string upload = MT.Library.UtilityExtensions.GetKeyAppSetting(Commonkey.Upload);
            return HttpContext.Current.Server.MapPath(upload);
        }

        /// <summary>
        /// Lấy đường dẫn thư mục Thật của ảnh nhân  viên
        /// </summary>
        /// <returns></returns>
        /// Create by: dvthang:04.02.2018
        public static string GetMapPathUploadImg()
        {
            string upload = MT.Library.UtilityExtensions.GetKeyAppSetting(Commonkey.UploadImg);
            return HttpContext.Current.Server.MapPath(upload);
        }

        /// <summary>
        /// Lấy đường dẫn thư mục Chứa Template Email
        /// </summary>
        /// <returns></returns>
        /// Create by: dvthang:23.02.2018
        public static string GetMapPathEmail()
        {
            string email = MT.Library.UtilityExtensions.GetKeyAppSetting(Commonkey.Email);
            return HttpContext.Current.Server.MapPath(email);
        }
        /// <summary>
        /// Lấy đường dẫn thư mục Chứa Tệp khảo sát project
        /// </summary>
        /// <returns></returns>
        /// Create by: dvthang:24.02.2018
        public static string GetMapPathProjectServey()
        {
            return HttpContext.Current.Server.MapPath($"~/Data/{Commonkey.ProjectServey}");
        }

        /// <summary>
        /// Lấy đường dẫn template xuất khẩu excell
        /// </summary>
        /// <returns></returns>
        /// Create by: dvthang:10.03.2018
        public static string GetMapPathTemplate()
        {
            return HttpContext.Current.Server.MapPath($"~/Data/{Commonkey.Template}");
        }

        /// <summary>
        /// Lấy đường dẫn thư mục Chứa Tệp thử nghiệm project
        /// </summary>
        /// <returns></returns>
        /// Create by: manh:25.02.2018
        public static string GetMapPathProjectExperiment()
        {
            return HttpContext.Current.Server.MapPath($"~/Data/{Commonkey.ProjectExperiment}");
        }

        /// <summary>
        /// Thực hiện đọc dữ liệu lưu trong tệp ra
        /// </summary>
        /// <param name="strData">Dữ liệu cần ghi</param>
        /// <param name="strPath">Đường dẫn lưu dữ liệu có thay đổi</param>
        /// Create by: dvthang:11.11.2017
        public static string ReadData(string strPath)
        {
            string data = string.Empty; ;
            try
            {
                using (FileStream fs = new FileStream(strPath, FileMode.Open, FileAccess.Read))
                using (StreamReader sr = new StreamReader(fs))
                {
                    data = sr.ReadToEnd();
                }
            }
            catch (Exception)
            {

            }
            return data;
        }

        /// <summary>
        /// Lấy domain của BE gọi API
        /// </summary>
        /// <returns></returns>
        /// Create by: dvthang:23.02.2018
        public static string GetDomainBEcore()
        {
            Uri myUri = new Uri(HttpContext.Current.Request.UrlReferrer.OriginalString);
            string pathQuery = myUri.PathAndQuery;
            string hostName = myUri.ToString().Replace(pathQuery, "");
            return hostName;
        }


        /// <summary>
        /// Tạo hình capcha
        /// </summary>
        /// <returns>Trả về ảnh có capcha</returns>
        /// Create by: dvthang:22.02.2018
        public static Bitmap CreateCapcha(ref string capcha)
        {
            int length = 5;
            int intZero = '0';
            int intNine = '9';
            int intA = 'A';
            int intZ = 'Z';
            int intCount = 0;
            int intRandomNumber = 0;
            string strCaptchaString = "";

            Random random = new Random(System.DateTime.Now.Millisecond);

            while (intCount < length)
            {
                intRandomNumber = random.Next(intZero, intZ);
                if (((intRandomNumber >= intZero) && (intRandomNumber <= intNine) || (intRandomNumber >= intA) && (intRandomNumber <= intZ)))
                {
                    strCaptchaString = strCaptchaString + (char)intRandomNumber;
                    intCount = intCount + 1;
                }
            }

            Bitmap bmp = new Bitmap(100, 30);
            Graphics g = Graphics.FromImage(bmp);
            g.Clear(Color.Navy);
            capcha = strCaptchaString;

            g.DrawString(capcha, new Font("Courier", 16), new SolidBrush(Color.WhiteSmoke), 2, 2);
            return bmp;
        }

        /// <summary>
        /// Đối tượng dùng để lock khi sinh mật khẩu
        /// </summary>
        private static readonly Object objLock = new Object();


        /// <summary>
        /// Thực hiện sinh random mật khẩu
        /// </summary>
        /// <returns></returns>
        /// Create by: dvthang:23.02.2018
        public static string RandomPassword()
        {
            const int maxLengthPassword = 8;
            string allowedChars = "";

            allowedChars = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,";

            allowedChars += "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,";

            allowedChars += "1,2,3,4,5,6,7,8,9,0,!,@,#,$,%,&,?";

            char[] sep = { ',' };

            string[] arr = allowedChars.Split(sep);

            string passwordString = "";

            string temp = "";
            Random rand = new Random();
            lock (objLock)
            {
                for (int i = 0; i < maxLengthPassword; i++)
                {
                    temp = arr[rand.Next(0, arr.Length)];
                    passwordString += temp;
                }
            }
            return passwordString;
        }

        // Các hàm định dạng số, đọc số
        //Create by: lieudt:01.8.2018

        public static String GetStringDecimal(decimal rNumber)
        {
            string aa = "";
            if (String.IsNullOrEmpty(rNumber.ToString())) aa = "";
            else if (rNumber != 0)
            {

                aa = String.Format("{0:#,#0.0000}", rNumber);
                aa = aa.ToString().Replace(".0000", "").Trim();
                aa = aa.ToString().Replace(",", ".").Trim();
            }
            else aa = "";

            if (aa.ToString().Contains(",0000"))
            {
                aa = aa.ToString().Replace(",0000", "").Trim();
            }
            if (aa.ToString() == "0") aa = "";
        
            return aa;
        }

        public static String GetStringStrDecimal(object oNumber)
        {
            string aa = "";
            if (oNumber == null) aa = "";
            else if (String.IsNullOrEmpty(oNumber.ToString())) aa = "";
            else if (oNumber.ToString() != "0")
            {
                aa = String.Format("{0:#,#0.0000}", oNumber);
                aa = aa.ToString().Replace(".0000", "").Trim();
                aa = aa.ToString().Replace(",", ".").Trim();
            }
            else aa = "";

            if (aa.ToString().Contains(",0000"))
            {
                aa = aa.ToString().Replace(",0000", "").Trim();
            }
            if (aa.ToString() == "0") aa = "";
            return aa;
        }


        public static string NumberToString(decimal _number)
        {
            if (_number == 0)
                return "Không";
            string _source = String.Format("{0:0,0}", _number);
            string[] _arrsource = null;
            if (_source.ToString().Contains("."))
            {
                _arrsource = _source.Split('.');
            }
            else if (_source.ToString().Contains(","))
            {
                _arrsource = _source.Split(',');
            }
           
           // string[] _arrsource = _source.Split('.');

            string _letter = "";

            int _numunit = _arrsource.Length;
            foreach (string _str in _arrsource)
            {
                if (ThreeNumber2Letter(_str).Length != 0)
                    _letter += String.Format("{0} {1} ", ThreeNumber2Letter(_str), NumUnit(_numunit));
                _numunit--;
            }

            if (_letter.StartsWith("không trăm linh"))
                _letter = _letter.Substring(16, _letter.Length - 17);
            if (_letter.StartsWith("không trăm"))
                _letter = _letter.Substring(11, _letter.Length - 12);
            if (_letter.StartsWith("linh"))
                _letter = _letter.Substring(3, _letter.Length - 3);

            return String.Format("{0}{1}", _letter.Substring(0, 1).ToUpper(), _letter.Substring(1, _letter.Length - 1).Trim());
        }
        private static string ThreeNumber2Letter(string _number)
        {
            int _hunit = 0, _tunit = 0, _nunit = 0;
            if (_number.Length == 3)
            {
                _hunit = int.Parse(_number.Substring(0, 1));
                _tunit = int.Parse(_number.Substring(1, 1));
                _nunit = int.Parse(_number.Substring(2, 1));
            }
            else if (_number.Length == 2)
            {
                _tunit = int.Parse(_number.Substring(0, 1));
                _nunit = int.Parse(_number.Substring(1, 1));
            }
            else if (_number.Length == 1)
                _nunit = int.Parse(_number.Substring(0, 1));

            if (_hunit == 0 && _tunit == 0 && _nunit == 0)
                return "";

            switch (_tunit)
            {
                case 0:
                    if (_nunit == 0)
                        return String.Format("{0} trăm", OneNumber2Letter_new(_hunit));
                    else
                        return String.Format("{0} trăm linh {1}", OneNumber2Letter_new(_hunit), OneNumber2Letter_new(_nunit));
                case 1:
                    if (_nunit == 0)
                        return String.Format("{0} trăm mười", OneNumber2Letter(_hunit));
                    else
                        return String.Format("{0} trăm mười {1}", OneNumber2Letter_new(_hunit), OneNumber2Letter(_nunit));
                default:
                    if (_nunit == 0)
                        return String.Format("{0} trăm {1} mươi", OneNumber2Letter_new(_hunit), OneNumber2Letter_new(_tunit));
                    else if (_nunit == 1)
                        return String.Format("{0} trăm {1} mươi mốt", OneNumber2Letter_new(_hunit), OneNumber2Letter_new(_tunit));
                    else if (_nunit == 4)
                        return String.Format("{0} trăm {1} mươi tư", OneNumber2Letter_new(_hunit), OneNumber2Letter_new(_tunit));
                    else
                        return String.Format("{0} trăm {1} mươi {2}", OneNumber2Letter_new(_hunit), OneNumber2Letter_new(_tunit), OneNumber2Letter(_nunit));
            }
        }
        private static string NumUnit(int _unit)
        {
            switch (_unit)
            {
                case 0:
                case 1:
                    return "";
                case 2:
                    return "nghìn";
                case 3:
                    return "triệu";
                case 4:
                    return "tỷ";
                default:
                    return String.Format("{0} {1}", NumUnit(_unit - 3), NumUnit(4));
            }
        }
        private static string OneNumber2Letter(int _number)
        {
            switch (_number)
            {
                case 0:
                    return "không";
                case 1:
                    return "một";
                case 2:
                    return "hai";
                case 3:
                    return "ba";
                case 4:
                    return "bốn";
                case 5:
                    return "lăm";
                case 6:
                    return "sáu";
                case 7:
                    return "bảy";
                case 8:
                    return "tám";
                case 9:
                    return "chín";
                default:
                    return "";
            }
        }
        private static string OneNumber2Letter_new(int _number)
        {
            switch (_number)
            {
                case 0:
                    return "không";
                case 1:
                    return "một";
                case 2:
                    return "hai";
                case 3:
                    return "ba";
                case 4:
                    return "bốn";
                case 5:
                    return "năm";
                case 6:
                    return "sáu";
                case 7:
                    return "bảy";
                case 8:
                    return "tám";
                case 9:
                    return "chín";
                default:
                    return "";
            }
        }
    }
}
