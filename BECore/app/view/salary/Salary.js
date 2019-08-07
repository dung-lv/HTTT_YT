/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.salary.Salary', {
    extend: 'QLDT.view.base.BaseEditTable',
    xtype: 'app-salary',
    requires: [
        'QLDT.view.base.BaseEditTable',
        'QLDT.view.salary.SalaryController',
        'QLDT.view.salary.SalaryModel'
    ],
    layout: 'border',

    controller: 'Salary',
    viewModel: 'Salary',

    columnStartEdit: 3,
    /*
    * Overrides hàm lấy lại danh sách các nút
    * Lấy danh sách menu của toolbar
    * Ban tài chính thì thêm nút chuyển dữ liệu
    * Create by: manh:26.05.18
    */
    getToolbarMenu: function () {
        var me = this,
            UserName = QLDT.Config.getUserName(),
            CompanyID = QLDT.Config.getCompanyID(),
            toolbar = [
                {
                    iconCls: 'button-edit menu-button-item fa fa-pencil-square-o',
                    cls: 'menu-button-item',
                    text: 'Sửa',
                    itemId: 'btnEdit',
                },
                {
                    iconCls: 'button-save menu-button-item fa fa-floppy-o',
                    cls: 'menu-button-item',
                    text: 'Lưu',
                    itemId: 'btnSave',
                },
                 {
                     iconCls: 'button-undo menu-button-item fa fa-undo',
                     cls: 'menu-button-item',
                     text: 'Dừng',
                     itemId: 'btnUndo',
                 },
                 {
                     iconCls: 'button-changeAll menu-button-item fa fa-angle-double-down',
                     cls: 'menu-button-item',
                     text: 'Nhập hàng loạt',
                     itemId: 'btnChangeAll',
                 },
                 '->',
                 {
                     iconCls: 'button-excel menu-button-item fa fa-download',
                     cls: 'menu-button-item',
                     text: 'Xuất Excel',
                     itemId: 'btnExcel',
                 }
            ];
        if (CompanyID === QLDT.common.Constant.Company_BTC) {
            toolbar = [
                {
                    iconCls: 'button-edit menu-button-item fa fa-pencil-square-o',
                    cls: 'menu-button-item',
                    text: 'Sửa',
                    itemId: 'btnEdit',
                },
                {
                    iconCls: 'button-save menu-button-item fa fa-floppy-o',
                    cls: 'menu-button-item',
                    text: 'Lưu',
                    itemId: 'btnSave',
                },
                 {
                     iconCls: 'button-undo menu-button-item fa fa-undo',
                     cls: 'menu-button-item',
                     text: 'Dừng',
                     itemId: 'btnUndo',
                 },
                 '->',
                 {
                     iconCls: 'button-excel menu-button-item fa fa-download',
                     cls: 'menu-button-item',
                     text: 'Xuất Excel',
                     itemId: 'btnExcel',
                 }
            ];
        }
        return toolbar;
    },
    /*
    * Vẽ thanh topbar item trên grid
    * Create by: manh:26.05.18
    */
    getTopBar: function () {
        var me = this,
            yearStore = me.getViewModel().getStore('yearStore'),
            UserName = QLDT.Config.getUserName(),
            CompanyID = QLDT.Config.getCompanyID(),
            vitem;

        vitem = [
                {
                    xtype: 'MTPanel',
                    layout: {
                        type: 'hbox',
                    },
                    items: [
                        {
                            xtype: 'MTComboBox',
                            fieldLabel: 'Năm',
                            labelWidth: 60,
                            margin: '0 8 0 8',
                            itemId: 'cboYear',
                            name: 'Year',
                            allowBlank: false,
                            displayField: 'Text',
                            valueField: 'Value',
                            store: yearStore,
                        },
                        {
                            xtype: 'MTButton',
                            text: 'Tìm kiếm',
                            itemId: 'btnSearch',
                            margin: '0 8 8 0',
                            appendCls: 'btn-search',
                            iconCls: 'fa fa-search',
                            name: 'Search'
                        },
                    ]
                },
        ];

        return {
            xtype: 'MTPanel',
            region: 'north',
            title: 'Tìm kiếm',
            layout: { type: 'vbox', align: 'stretch' },
            collapsible: true,
            defaults: {
                labelWidth: 110,
                margin: '8 8 0 8',
            },
            items: vitem
        };
    },
    /*
    * Trả về nội dung của form
    * Ban tài chính thì hiện 3 cột (TC)
    * Create by: manh:26.05.18
    */
    getColumns: function () {
        var me = this,
            column = [
               { text: 'STT', dataIndex: 'SortOrder', width: 70, align: 'center', readOnly: true },
               {
                   text: 'Tháng', dataIndex: 'Month', width: 180, readOnly: true, align: 'center'
               },
               { text: 'Tên', dataIndex: 'SalaryName', width: 180, readOnly: true, align: 'center' },
               {
                   text: 'Mức tiền (VNĐ/Tháng)', dataIndex: 'Money', flex: 1, xtype: 'MTColumnNumberField'
               }
            ];
        return column;
    },

    /*
    * Khai báo store load dữ liệu cho grid
    * Create by: manh:26.05.18
    */
    getStoreMaster: function () {
        var me = this,
            store = me.getViewModel().getStore('masterStore');
        return store;
    }
});
