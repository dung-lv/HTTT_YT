/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectWorkshop', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-projectworkshop',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.project.ProjectWorkshopController',
        'QLDT.view.project.ProjectWorkshopModel',
    ],
    controller: 'ProjectWorkshop',
    viewModel: 'ProjectWorkshop',

    cls:'form-workshop',
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
            { xtype: 'MTColumnDateField', text: 'Ngày t.hiện', dataIndex: 'Date', width: 120 },
            { text: 'Thời gian', dataIndex: 'Time', width: 150, xtype: 'MTColumnTime' },
            { text: 'Địa điểm', dataIndex: 'Adderess', width: 180, xtype: 'MTColumn' },
            { text: 'N.dung t.hiện', dataIndex: 'Contents', minWidth: 250, flex: 1, xtype: 'MTColumn' },
            {
                text: 'Tải tệp', dataIndex: 'IdFiles', width: 120,align:'center',
                renderer: function (value, metaData, record, row, col, store, gridView) {
                    var strLink = '';
                    if (value) {
                        metaData.tdCls = 'wrap-text-of-row';
                        var strFileInfo = value.split('|');
                        strFileInfo.forEach(function (s, index) {
                            if (s) {
                                var strIDs = s.split(',')
                                strLink += Ext.String.format('<a class="file-download" href="javascript:void(0)" fileid="{0}" filetype="{1}">Tệp {2}</a>', strIDs[0], strIDs[1],
                                    (index + 1));
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
