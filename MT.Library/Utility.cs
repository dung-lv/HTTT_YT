using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Reflection;
using System.Text;
using System.Data.Common;
using System.Web;

namespace MT.Library
{
    public static class UtilityExtensions
    {
        /// <summary>
        /// Chuyển dữ liệu từ datatable về List<Dictionary<string, object>>
        /// </summary>
        /// <param name="dt">Data table</param>
        /// <returns>Create by: dvthang:27.11.2016</returns>
        public static List<Dictionary<string, object>> GetListDicData(this DataTable dt)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dt != null)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
            return rows;
        }

        /// <summary>
        /// Chuyển dữ liệu từ datatable về List<Dictionary<string, object>>
        /// </summary>
        /// <param name="dt">Data table</param>
        /// <returns>Create by: dvthang:27.11.2016</returns>
        public static List<Dictionary<string, object>> ConvertReaderToListDicData(this IDataReader dataReader)
        {
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            if (dataReader != null)
            {
                int countColumn = dataReader.FieldCount;
                while (dataReader.Read())
                {
                    row = new Dictionary<string, object>();
                    for (int i = 0; i < countColumn; i++)
                    {
                        row.Add(dataReader.GetName(i), dataReader.GetValue(i));
                    }
                    rows.Add(row);
                }
            }
            return rows;
        }

        /// <summary>
        /// Trả về kiểu object từ dữ liệu datareader
        /// </summary>
        /// <typeparam name="T">Object</typeparam>
        /// <param name="_dr">datareader</param>
        /// <returns>Create by: dvthang:27.11.2016</returns>
        public static T FillObject<T>(this IDataReader _dr)
        {
            T objTarget = default(T);
            if (_dr == null) return objTarget;
            try
            {
                int countColumn = _dr.FieldCount;
                if (_dr.Read())
                {
                    objTarget = Activator.CreateInstance<T>();
                    for (int i = 0; i < countColumn; i++)
                    {
                        string nameColumn = _dr.GetName(i);
                        PropertyInfo property = objTarget.GetType().GetProperty(nameColumn);
                        if (property != null)
                        {
                            if (!object.Equals(_dr[nameColumn], DBNull.Value))
                            {
                                property.SetValue(objTarget, _dr[nameColumn].ChangeType(property.PropertyType), null);
                            }
                            else
                            {
                                property.SetValue(objTarget, null);
                            }
                        }

                    }
                }
            }
            finally
            {
                _dr.Close();
            }
            return objTarget;
        }

        /// <summary>
        /// Trả về list object từ DataReader
        /// </summary>
        /// <typeparam name="T">object</typeparam>
        /// <param name="_dr">DataReader</param>
        /// <returns>Create by:dvthang:27.11.2016</returns>
        public static List<T> FillCollection<T>(this IDataReader _dr, bool isClose = true)
        {
            List<T> _list = new List<T>();
            if (_dr == null) return _list;
            try
            {
                int countColumn = _dr.FieldCount;
                while (_dr.Read())
                {
                    T objTarget = Activator.CreateInstance<T>();
                    for (int i = 0; i < countColumn; i++)
                    {
                        string nameColumn = _dr.GetName(i);
                        PropertyInfo property = objTarget.GetType().GetProperty(nameColumn);
                        if (property != null)
                        {
                            if (!object.Equals(_dr[nameColumn], DBNull.Value))
                            {
                                property.SetValue(objTarget, _dr[nameColumn].ChangeType(property.PropertyType), null);
                            }
                            else
                            {
                                property.SetValue(objTarget, null);
                            }

                        }

                    }
                    _list.Add(objTarget);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (isClose)
                {
                    _dr.Close();
                }
            }
            return _list;
        }

        /// <summary>
        /// Trả về list object từ DataTable
        /// </summary>
        /// <typeparam name="T">object</typeparam>
        /// <param name="_dr">DataTable</param>
        /// <returns>Create by:dvthang:27.11.2016</returns>
        public static List<T> FillTable<T>(this DataTable _table)
        {
            List<T> _list = new List<T>();
            if (_table == null) return _list;
            DataColumnCollection dataCol = _table.Columns;
            foreach (DataRow dr in _table.Rows)
            {
                T objTarget = Activator.CreateInstance<T>();

                foreach (DataColumn col in dataCol)
                {
                    PropertyInfo property = objTarget.GetType().GetProperty(col.ColumnName);
                    if (property != null)
                    {
                        if (!object.Equals(dr[col.ColumnName], DBNull.Value))
                        {

                            property.SetValue(objTarget, dr[col.ColumnName].ChangeType(property.PropertyType), null);
                        }
                        else
                        {
                            property.SetValue(objTarget, null);
                        }

                    }

                }
                _list.Add(objTarget);
            }
            return _list;
        }

        /// <summary>
        /// Trả về object từ datatable
        /// </summary>
        /// <typeparam name="T">Object</typeparam>
        /// <param name="dt">DataTable</param>
        /// <returns>Create by: dvthang:27.11.2016</returns>
        public static T CreateObject<T>(this DataTable dt)
        {
            T objTarget = Activator.CreateInstance<T>();
            if (dt.Rows.Count > 0)
            {
                DataColumnCollection columns = dt.Columns;
                foreach (DataRow dr in dt.Rows)
                {

                    foreach (DataColumn col in columns)
                    {
                        PropertyInfo property = objTarget.GetType().GetProperty(col.ColumnName);
                        if (property != null)
                        {
                            if (!object.Equals(dr[col.ColumnName], DBNull.Value))
                            {
                                property.SetValue(objTarget, dr[col.ColumnName].ChangeType(property.PropertyType), null);
                            }
                            else
                            {
                                property.SetValue(objTarget, null);
                            }

                        }

                    }
                }
            }
            return objTarget;
        }

        /// <summary>
        /// Lấy về thể hiện của object
        /// </summary>
        /// <param name="strEntityName">Tên object </param>
        /// <returns>dvthang-05.08.2016</returns>
        public static T GetInstance<T>(this string strEntityName, string nameSpace)
        {
            if (!string.IsNullOrEmpty(strEntityName))
            {
                Assembly dd = Assembly.LoadFrom(nameSpace);
                Type t = dd.GetType(strEntityName);
                if (t != null)
                {
                    return Activator.CreateInstance<T>();
                }

            }
            return default(T);
        }

        /// <summary>
        /// Clone object tránh bị byref khi sửa đổi
        /// </summary>
        /// <returns>Create by: dvthang:27.11.2016</returns>
        public static T CopyToObject<T>(this T entity)
        {
            if (entity != null)
            {
                Type type = entity.GetType();
                MethodInfo method = type.GetMethod("Clone");
                if (method != null)
                {
                    return (T)method.Invoke(entity, null);
                }
                else
                {
                    throw new Exception("Đối tượng này không cài đặt InterfaceIClone.");
                }
            }
            return default(T);
        }

        /// Copy file sang thư mục khác
        /// </summary>
        /// <param name="sourceFile">đường dẫn file nguồn</param>
        /// <param name="destFile">Đường dẫn file đích</param>
        /// Create by: dvthang:27.11.2016
        public static void CopyFile(this string sourceFile, string destFile)
        {
            try
            {
                if (System.IO.File.Exists(sourceFile))
                {
                    System.IO.File.Copy(sourceFile, destFile, true);
                    System.IO.File.Delete(sourceFile);
                }
            }
            catch (IOException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Copy file sang thư mục khác
        /// </summary>
        /// <param name="sourceFile">đường dẫn file nguồn</param>
        /// <param name="destFile">Đường dẫn file đích</param>
        /// Create by: dvthang:27.11.2016
        public static void DeleteFile(this string sourceFile)
        {
            try
            {
                if (System.IO.File.Exists(sourceFile))
                {
                    System.IO.File.Delete(sourceFile);
                }
            }
            catch (IOException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Tạo thư mục
        /// </summary>
        /// <param name="Dir"></param>
        /// <returns>dvthang-07.05.2016</returns>
        public static Boolean CreateDirectory(this string Dir)
        {
            if (Directory.Exists(Dir) == false)
            {
                try
                {
                    Directory.CreateDirectory(Dir);
                    return true;
                }
                catch (IOException ex)
                {
                    throw ex;
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            return false;
        }

        /// <summary>
        /// Lấy về chuỗi kết nối đến DB
        /// </summary>
        /// <returns>Create by:dvthang:27.11.2016</returns>
        public static string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        }

        /// <summary>
        /// Lấy về địa chỉ IP của máy đang thao tác
        /// </summary>
        /// Create by: dvthang:30.11.2016
        public static string GetClientIP()
        {
            System.Web.HttpContext context = System.Web.HttpContext.Current;
            string ipAddress = context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

            if (!string.IsNullOrEmpty(ipAddress))
            {
                string[] addresses = ipAddress.Split(',');
                if (addresses.Length != 0)
                {
                    return addresses[0];
                }
            }
            return context.Request.ServerVariables["REMOTE_ADDR"];
        }

        /// <summary>
        /// Lấy về tên user đăng nhập
        /// </summary>
        /// Create by : dvthang:22.12.2016
        public static string GetUserName()
        {
            return HttpContext.Current.User.Identity.Name;
        }

        /// <summary>
        /// Lấy giá trị của trị trong appsettings
        /// </summary>
        /// <param name="key">Tên key</param>
        /// Create by: dvthang:15.01.2017
        public static string GetKeyAppSetting(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }

        /// <summary>
        /// Đọc nội dung text của 1 file
        /// </summary>
        /// <param name="pathVirtual">Đường dẫn vật lý của file cần đọc</param>
        /// Create by: dvthang:16.01.2017
        public static string ReadTextFile(this string pathVirtual)
        {
            string sContent = string.Empty;
            pathVirtual = System.Web.HttpContext.Current.Server.MapPath("~/") + pathVirtual;
            if (System.IO.File.Exists(pathVirtual))
            {
                sContent = System.IO.File.ReadAllText(pathVirtual, Encoding.UTF8);
            }
            return sContent;
        }
        /// <summary>
        /// Lấy về tên store thực hiện thao tác
        /// </summary>
        /// <param name="entity">Đối tượng cất</param>
        /// <returns>dvthang-20.04.2017</returns>
        public static string GetStoreByEntityState(object entity)
        {
            string strStore = string.Empty;
            Enummation.EditMode entityState = entity.GetValue<Enummation.EditMode>("EditMode");
            switch (entityState)
            {
                case Enummation.EditMode.Add:
                    strStore = GetStoreInsert(entity);
                    break;
                case Enummation.EditMode.Edit:
                    strStore = GetStoreUpdate(entity);
                    break;
                case Enummation.EditMode.Delete:
                    strStore = GetStoreDelete(entity);
                    break;
            }
            return strStore;

        }

        /// <summary>
        /// Lấy về tên store insert của đối tượng
        /// </summary>
        /// <param name="entity">Tên đối tượng</param>
        /// <returns>Tên store</returns>
        /// Create by: dvthang:08.01.2018
        public static string GetStoreInsert(object entity)
        {
            return string.Format(Commonkey.mscInsert, Commonkey.Schema, entity.GetType().Name);
        }

        /// <summary>
        /// Lấy về tên store Update của đối tượng
        /// </summary>
        /// <param name="entity">Tên đối tượng</param>
        /// <returns>Tên store</returns>
        /// Create by: dvthang:08.01.2018
        public static string GetStoreUpdate(object entity)
        {
            return string.Format(Commonkey.mscUpdate, Commonkey.Schema, entity.GetType().Name);
        }


        /// <summary>
        /// Lấy về tên store Delete của đối tượng
        /// </summary>
        /// <param name="entity">Tên đối tượng</param>
        /// <returns>Tên store</returns>
        /// Create by: dvthang:08.01.2018
        public static string GetStoreDelete(object entity)
        {
            return string.Format(Commonkey.mscDeleteByID, Commonkey.Schema, entity.GetType().Name);
        }
        /// <summary>
        /// Copy file sang thư mục khác
        /// </summary>
        /// <param name="sourceFile">đường dẫn file nguồn</param>
        /// <param name="destFile">Đường dẫn file đích</param>
        /// Create by: dvthang:27.11.2016
        public static void MoveFile(this string sourceFile, string destFile)
        {
            try
            {
                if (System.IO.File.Exists(sourceFile))
                {
                    System.IO.File.Copy(sourceFile, destFile, true);
                    System.IO.File.Delete(sourceFile);
                }
            }
            catch (Exception)
            {
            }
        }

        /// <summary>
        /// Ánh xạ giá trị của object vào trong store 
        /// </summary>
        /// <param name="_cmd"></param>
        /// <param name="entity">Object</param>
        /// Create by: dvthang:20.04.2017
        public static void MappingObjectIntoStore(DbCommand _cmd, object entity)
        {
            if (_cmd.Parameters.Count > 0)
            {
                string userName = GetUserName();
                string ipAddress = GetClientIP();
                DateTime currentDate = DateTime.Now;
                Enummation.EditMode editMode = entity.GetValue<Enummation.EditMode>("EditMode");

                string name = string.Empty;
                object value = null;
                int totalParams = _cmd.Parameters.Count;
                for (int i = 0; i < totalParams; i++)
                {
                    name = _cmd.Parameters[i].ParameterName;
                    if (!name.Equals("@RETURN_VALUE"))
                    {
                        name = name.Replace("@", "");
                        PropertyInfo pi = entity.GetType().GetProperty(name);
                        if (pi != null && pi.CanWrite)
                        {
                            switch (name)
                            {
                                case Commonkey.CreatedDate:
                                case Commonkey.ModifiedDate:
                                    if (editMode == Enummation.EditMode.Add || editMode == Enummation.EditMode.Duplicate)
                                    {
                                        _cmd.Parameters[i].Value = currentDate;
                                    }
                                    else
                                    {
                                        _cmd.Parameters[i].Value = currentDate;
                                    }
                                    break;
                                case Commonkey.CreatedBy:
                                case Commonkey.ModifiedBy:
                                    if (editMode == Enummation.EditMode.Add || editMode == Enummation.EditMode.Duplicate)
                                    {
                                        _cmd.Parameters[i].Value = userName;
                                    }
                                    else
                                    {
                                        _cmd.Parameters[i].Value = userName;
                                    }
                                    break;
                                default:
                                    value = pi.GetValue(entity, null);
                                    if (value != null)
                                    {
                                        _cmd.Parameters[i].Value = value;
                                    }
                                    else
                                    {
                                        _cmd.Parameters[i].Value = DBNull.Value;
                                    }
                                    break;
                            }
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Lấy về keyCache theo domain của ứng dụng
        /// </summary>
        /// <param name="keyCache">Tên key</param>
        /// Create by: dvthang:16.01.2017
        public static string GetKeyByDomain(string keyCache, bool isUser = false)
        {
            Uri myUri = new Uri(System.Web.HttpContext.Current.Request.Url.AbsoluteUri);
            string pathQuery = myUri.PathAndQuery;
            string hostName = myUri.ToString().Replace(pathQuery, "");
            string strKey = string.Format("{0}_{1}_{2}", hostName, keyCache, (isUser ? MT.Library.UtilityExtensions.GetUserName() : ""));
            return strKey;
        }
    }

    
}
