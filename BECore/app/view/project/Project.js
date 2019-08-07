/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.Project', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-project',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.project.ProjectController',
        'QLDT.view.project.ProjectModel',
        'QLDT.view.project.ProjectDetail'
    ],

    controller: 'Project',
    viewModel: 'Project',

    filterable: false,
    showPaging: false,

    /*
  * Không lọc dữ liệu
  * Create by: laipv:28.03.2018
  */
    filterable: false,
    /*
    * Đánh dấu hiển thị pagging trên grid
    * Create by: laipv:28.03.2018
    */
    showPaging: false,
    /*
    * Trả về nội dung của form
    * Nếu người dùng là BTC thì danh sách trả về Tên đề tài viết tắt và tooltip hiện Tên đề tài đầy đủ
    * Create by: laipv:14.01.2018
    * Modify by:manh: 04.05.18
    */
    getColumns: function () {
        var me = this,
            UserName = QLDT.Config.getUserName(),
            CompanyID = QLDT.Config.getCompanyID(),
            vitem = [
                {
                    text: 'Tên đề tài', dataIndex: 'ProjectName', width: 250, flex: 1, xtype: 'MTColumn',
                    renderer: function (value, metaData, record, rowIndex) {
                        var me = this, isProject = record.get("IsProject"), val = '';
                        if (isProject) {
                            val += "&nbsp;&nbsp;&nbsp;&nbsp;";
                        }
                        value = Ext.String.htmlEncode(value);
                        metaData.tdAttr = 'data-qtip="' + Ext.String.htmlEncode(value) + '"';
                        return Ext.String.format("{0}{1}", val, value);
                    }
                },
                { text: 'Chủ nhiệm', dataIndex: 'EmployeeName', minWidth: 120, xtype: 'MTColumn' },
                { xtype: 'MTColumnDateField', text: 'B.đầu', dataIndex: 'StartDate', width: 100 },
                { xtype: 'MTColumnDateField', text: 'K.thúc', dataIndex: 'EndDate', width: 100 },
                { text: 'Sản phẩm', dataIndex: 'Result', minWidth: 150, xtype: 'MTColumn' },
                { xtype: 'MTColumnDateField', text: 'Ngày T.Minh', dataIndex: 'PresentProtectedDate', width: 100 },
                { xtype: 'MTColumnDateField', text: 'Ngày K.Phí', dataIndex: 'ExpenseProtectedDate', width: 100 },
                { text: 'Kq đ.xuất', dataIndex: 'StatusName', minWidth: 150, xtype: 'MTColumn' },
        ];
        if (CompanyID === QLDT.common.Constant.Company_BTC) {
            vitem = [
                            {
                                text: 'Tên đề tài', dataIndex: 'ProjectName', width: 250, flex: 1, xtype: 'MTColumn',
                                renderer: function (value, metaData, record, rowIndex) {
                                    var me = this, isProject = record.get("IsProject"), val = '';
                                    if (isProject) {
                                        val += "&nbsp;&nbsp;&nbsp;&nbsp;";
                                        value = record.get("ProjectNameAbbreviation");
                                        var projectName = record.get("ProjectName");
                                        metaData.tdAttr = 'data-qtip="' + Ext.String.htmlEncode(projectName) + '"';
                                    }
                                    else {
                                        value = Ext.String.htmlEncode(value);
                                        metaData.tdAttr = 'data-qtip="' + Ext.String.htmlEncode(value) + '"';
                                    }
                                    return Ext.String.format("{0}{1}", val, value);
                                }
                            },
                            { text: 'Chủ nhiệm', dataIndex: 'EmployeeName', minWidth: 120, xtype: 'MTColumn' },
                            { xtype: 'MTColumnDateField', text: 'B.đầu', dataIndex: 'StartDate', width: 100 },
                            { xtype: 'MTColumnDateField', text: 'K.thúc', dataIndex: 'EndDate', width: 100 },
                            { text: 'Sản phẩm', dataIndex: 'Result', minWidth: 150, xtype: 'MTColumn' },
                            { xtype: 'MTColumnDateField', text: 'Ngày T.Minh', dataIndex: 'PresentProtectedDate', width: 100 },
                            { xtype: 'MTColumnDateField', text: 'Ngày K.Phí', dataIndex: 'ExpenseProtectedDate', width: 100 },
                            { text: 'Kq đ.xuất', dataIndex: 'StatusName', minWidth: 150, xtype: 'MTColumn' },
            ];
        }
        return vitem;
    },

    /*
    * Thực hiện bol row không phải project
    * Create by: dvthang:27.02.2018
    */
    getViewConfig: function (record, index) {
        return {
            getRowClass: function (record, index) {
                if (!record.get('IsProject')) {
                    return 'cls-bold';
                }
                return '';
            }
        }
    },

    /*
    * Khai báo store load dữ liệu cho grid
    * Create by: laipv:14.01.2018
    */
    getStoreMaster: function () {
        var me = this,
            store = me.getViewModel().getStore('masterStore');
        return store;
    }

});
