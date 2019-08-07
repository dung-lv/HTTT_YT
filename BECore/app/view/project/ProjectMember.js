/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectMember', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-projectmember',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.project.ProjectMemberController',
        'QLDT.view.project.ProjectMemberModel',
    ],
    controller: 'ProjectMember',
    viewModel: 'ProjectMember',
    /*
   * Đánh dấu hiển thị pagging trên grid
   * Create by: dvthang:07.01.2018
   */
    showPaging: false,

    /*
    * Đánh dấu hiển thị filter trên grid
    * Create by: manh:26.03.2018
    */
    filterable: false,

    /*
    * Hàm lấy danh sách cột của lưới
    * Create by: laipv:01.02.2018
    */
    getColumns: function () {
        var me = this;
        return [
            {
                text: 'TT', dataIndex: 'Rownum', width: 40, align: 'center'
            },
            { text: 'Cán bộ', dataIndex: 'EmployeeName', minWidth: 250, flex: 1 },
            { text: 'V.trí', dataIndex: 'ProjectPositionName', minWidth: 250, flex: 1 },
            { xtype: 'MTColumnDateField', text: 'B.đầu', dataIndex: 'StartDate', width: 120 },
            { xtype: 'MTColumnDateField', text: 'K.thúc', dataIndex: 'EndDate', width: 120 },
            { text: 'Số tháng', dataIndex: 'MonthForProject', width: 120 },
        ];
    },
    /*
    * Store để load dữ liệu cho grid
    * Create by: dvthang:07.01.2018
    */
    getStoreMaster: function () {
        var me = this;
        return me.getViewModel().getStore('masterStore');
    },
});
