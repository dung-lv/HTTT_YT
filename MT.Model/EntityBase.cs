using MT.Library;
using System;
using System.ComponentModel.DataAnnotations;
using System.Reflection;
namespace MT.Model
{
    public class EntityBase
    {
        /// <summary>
        /// Trạng thái của object
        /// </summary>
        /// Create by: dvthang:20.04.2017
        public Enummation.EditMode EditMode { get; set; }

        /// <summary>
        /// Tên của khóa chính
        /// </summary>
        /// <returns>Tên khóa</returns>
        /// Create by: dvthang:20.04.2017
        public string GetKeyName()
        {
            PropertyInfo[] properties = this.GetType().GetProperties();

            foreach (PropertyInfo property in properties)
            {
               KeyAttribute keyAttr= property.GetCustomAttribute<KeyAttribute>(true);
               if (keyAttr != null)
                {
                    return property.Name;
                }
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy về giá trị của khóa chính
        /// </summary>
        /// <returns>Giá trị của khóa</returns>
        /// Create by:dvthang:20.04.2017
        public object GetIdentity()
        {
            PropertyInfo[] properties = this.GetType().GetProperties();
            foreach (PropertyInfo property in properties)
            {
               KeyAttribute keyAttr= property.GetCustomAttribute<KeyAttribute>(true);
               if (keyAttr != null)
                {
                    return property.GetValue(this);
                }
            }
            return null;
        }

        /// <summary>
        /// Lấy về giá trị của khóa chính
        /// </summary>
        /// <returns>Giá trị của khóa</returns>
        /// Create by:dvthang:20.04.2017
        public void SetIdentity(object value)
        {
            PropertyInfo[] properties = this.GetType().GetProperties();
            foreach (PropertyInfo property in properties)
            {
                KeyAttribute keyAttr = property.GetCustomAttribute<KeyAttribute>(true);
                if (keyAttr != null)
                {
                    property.SetValue(this, value);
                    break;
                }
            }
        }

        /// <summary>
        /// Kiểm tra giá trị khóa có phải là kiểu tự tăng hay không
        /// </summary>
        /// Create by:dvthang:20.04.2017
        public bool HasIdentity()
        {
            bool isIdentity = false;
            PropertyInfo[] properties = this.GetType().GetProperties();
            foreach (PropertyInfo pi in properties)
            {
                KeyAttribute keyAttr = pi.GetCustomAttribute<KeyAttribute>(true);
                if (keyAttr != null)
                {
                    if (pi.PropertyType == typeof(int) || pi.PropertyType == typeof(Int32)
                        || pi.PropertyType == typeof(Int64)|| pi.PropertyType == typeof(Int16)){
                            isIdentity=true;
                        }
                    break;
                }
            }
            return isIdentity;
        }

        /// <summary>
        /// Gán giá trị cho object
        /// </summary>
        public void SetValue(string propertyName, object value)
        {
            PropertyInfo info = this.GetType().GetProperty(propertyName);
            if (info != null)
            {
                info.SetValue(this, value, null);
            }
        }

        /// <summary>
        /// Đọc giá trị của properties
        /// </summary>
        /// <param name="entity"></param>
        /// <param name="propertyName"></param>
        /// <returns></returns>
        public object GetValue(string propertyName)
        {
            PropertyInfo property = this.GetType().GetProperty(propertyName);
            if (property != null)
            {
                return property.GetValue(this, null);
            }
            return null;
        }

        /// <summary>
        /// Copy object
        /// </summary>
        /// <returns></returns>
        public object Clone()
        {
            return MemberwiseClone();
        }

        public bool IsAuditLog { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public string IPAddress { get; set; }
        public string ModifiedBy { get; set; }
        public string CreatedBy { get; set; }
    }
}
