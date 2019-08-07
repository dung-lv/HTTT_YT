/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectProgressReport', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-projectprogressreport',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.project.ProjectProgressReportController',
        'QLDT.view.project.ProjectProgressReportModel',
    ],
    controller: 'ProjectProgressReport',
    viewModel: 'ProjectProgressReport',

    cls: 'form-progressreport',
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
        var me = this, resultStore = me.getViewModel().getStore("resultStore");
        return [
            { xtype: 'MTColumn', text: 'Kỳ báo cáo', dataIndex: 'TermName', minWidth: 250, flex: 1 },
            { xtype: 'MTColumnDateField', text: 'Ngày báo cáo', dataIndex: 'DateReport', width: 130 },
            { xtype: 'MTColumnDateField', text: 'Ngày kiểm tra', dataIndex: 'DateCheck', width: 130 },
            //{ xtype: 'MTColumnNumberField', text: 'K.quả', dataIndex: 'Result_sTen', width: 120 },
            {
                text: 'K.quả', dataIndex: 'Result', width: 120, xtype: 'MTColumn',
                dataType: QLDT.common.Enumaration.DataType.Int,
                headerFilter: {
                    store: resultStore,
                    valueField: 'Value',
                    displayField: 'Text',
                    editable: false,
                    selectOnFocus: false
                },
                isFilterCombo: true,
                renderer: function (value, metaData, record, rowIndex) {
                    var strText = 'Đảm bảo tiến độ';
                    if (value == 12) {
                        strText = "Chậm tiến độ";
                    }
                    return strText;
                },
            },
            {
                text: 'Tải tệp', dataIndex: 'IdFiles', width: 200, align: 'center',
                renderer: function (value, metaData, record, row, col, store, gridView) {
                    var strLink = '';
                    if (value) {
                        metaData.tdCls = 'wrap-text-of-row';
                        var strFileInfo = value.split('|');
                        strFileInfo.forEach(function (s, index) {
                            if (s) {
                                var strIDs = s.split(',')
                                strLink += Ext.String.format('<a class="file-download" href="javascript:void(0)" fileid="{0}" filetype="{1}">{2}</a>', strIDs[0], strIDs[1],
                                    strIDs[2]);
                            }
                        });
                    }
                    if (!strLink) {
                        strLink = '<a class="file-download" href="javascript:void(0)">Không có</a>';
                    }
                    return strLink;
                }
            },
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
