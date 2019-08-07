using MT.Library;
using Newtonsoft.Json;
using System;
using System.ComponentModel.DataAnnotations;
using System.Reflection;
namespace MT.Model
{
    /// <summary>
    /// Đối tượng lấy về dữ liệu cho store tree
    /// </summary>
    /// Create by: dvthang:04.02.2018
    public class TreeStore
    {
        /// <summary>
        /// Trạng thái của object
        /// </summary>
        /// Create by: dvthang:20.04.2017
        public Enummation.EditMode EditMode { get; set; }

        [JsonProperty(PropertyName = "expanded")]
        public bool? Expanded { get; set; }
        [JsonProperty(PropertyName = "Data")]
        public object Data { get; set; }
        [JsonProperty(PropertyName = "leaf")]
        public bool? Leaf { get; set; }
        [JsonProperty(PropertyName = "iconCls")]
        public string IconCls { get; set; }

        [JsonProperty(PropertyName = "grade")]
        public int Grade { get; set; }
    }
}
