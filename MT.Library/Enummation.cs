
namespace MT.Library
{
    public class Enummation
    {
        public enum EditMode
        {
            None = 0,
            View = 0,
            Add = 1,
            Duplicate = 2,
            Edit = 3,
            Delete = 4
        }

        /// <summary>
        /// Các loại lỗi xảy ra khi thực hiện sau lệnh
        /// </summary>
        /// Create by: dvthang:07.01.2018
        public enum ErrorType
        {
            Constraint = 1,
            BadRequest = 2
        }

        /// <summary>
        /// Giới tính
        /// </summary>
        /// Create by: dvthang:20.11.2016
        public enum Gender
        {
            Male = 0,//Nam
            FeMale = 1//Nữ
        }

        /// <summary>
        /// Kiểu dữ liệu của cột trên grid
        /// </summary>
        /// Create by: dvthang:26.11.2016
        public enum DataTypeColumn
        {
            String = 0,
            Number = 1,
            Combo = 2,
            Date = 3,
            Time = 4,
            Interger = 5
        }

        /// <summary>
        /// Danh sách các button trên thanh toolbar
        /// </summary>
        /// Create by: dvthang:17.01.2017
        public enum CommandName
        {
            Add = 0,
            Cancel = 1,
            Close = 2,
            Delete = 3,
            Duplucate = 4,
            Edit = 5,
            Save = 6,
            SaveNew = 7,
            Search = 8,
            Undo = 9,
            Print = 10,
            Export = 11,
            Help = 12,
            SendEmail = 13,
        }

        /// <summary>
        /// Download tệp từ nguồn nào
        /// </summary>
        /// Create by: dvthang:24.02.2017
        public enum DowloadFrom
        {
            Upload = 0,
            ProjectServey = 1
        }

        /// <summary>
        /// Trạng thái của task
        /// </summary>
        /// Create by: dvthang:27.02.2018
        public enum StatusTask
        {
            Finish = 11,
            UnFinish = 12,
            SlowProgress = 13
        }

        /// <summary>
        /// ID của báo cáo
        /// </summary>
        /// Create by: dvthang:10.03.2018
        public enum ReportID
        {
            ChamCong,
            ChamCongTC,
            LuongCoBan,
            HeSoTienCong,
            ThueKhoanChuyenMon,
            ThueKhoanChuyenMonExcel,
            BaoCaoSoNgayConDeChamCong
        }
    }
}
