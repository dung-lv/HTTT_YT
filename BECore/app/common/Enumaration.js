Ext.define('QLDT.common.Enumaration', {
    singleton: true,
    /*Action trên form*/
    EditMode: {
        None: 0,
        View: 0,
        Add: 1,
        Duplicate: 2,
        Edit: 3,
        Delete: 4
    },

    /*
    * Icon hiển thị cảnh báo
    */
    IconDialog: {
        Error: 'error',
        Info: 'info',
        Question: 'question',
        Warn: 'Warning'
    },

    /*Download tệp từ nguồm nào*/
    DownLoadFrom: {
        Upload: 0,
        ProjectServey: 1,
        ProjectExperiment: 1
    },

    /// <summary>
    /// Kiểu dữ liệu filter
    /// </summary>
    /// Create by: dvthang:25.02.2018
    DataType:
    {
        String: 0,
        Boolean: 1,
        Byte: 2,
        Int: 3,
        Float: 4,
        Double: 5,
        Decimal: 6,
        Time: 7,
        Date: 8,
        DateTime: 9
    },


    /// <summary>
    /// Trạng thái đề tài
    /// </summary>
    /// Create by: dvthang:27.02.2018
    StatusProject:
    {
        DDT: 11,
        DXT: 12,
        DGCT: 13,
        DPD: 14,
        DDVTH: 21,
        CNT: 22,
        DNTCCS: 23,
        DNTCQL: 24,
        DDDT: 31
    },

    /// <summary>
    /// ID của báo cáo
    /// </summary>
    /// Create by: dvthang:10.03.2018
    ReportID:
    {
        ChamCong: 0,
        ChamCongTC: 1,
        LuongCoBan: 2,
        HeSoTienCong: 3,
        ThueKhoanChuyenMon: 4,
        ThueKhoanChuyenMonExcel: 5,
        BaoCaoSoNgayConDeChamCong: 6
    },

    /// <summary>
    /// Danh sách điều kiện Filter
    /// </summary>
    /// Create by: dvthang:25.02.2018
    FilterOperations:
    {
        Equals: 0,
        NotEquals: 1,
        Greater: 2,
        GreaterOrEquals: 3,
        LessThan: 4,
        LessThanOrEquals: 5,
        StartsWith: 6,
        EndsWith: 7,
        Contains: 8,
        NotContains: 9
    },

    /// <summary>
    /// Kiểu dữ liệu filter
    /// </summary>
    /// Create by: dvthang:25.02.2018
    DataType:
    {
        String: 0,
        Boolean: 1,
        Byte: 2,
        Int: 3,
        Float: 4,
        Double: 5,
        Decimal: 6,
        Time: 7,
        Date: 8,
        DateTime: 9
    },

    /// <summary>
    /// Phép toán nối giữa các toán tử
    /// </summary>
    /// Create by: dvthang:25.02.2018
    Addition:
    {
        AND: 0,
        OR: 1
    }
});