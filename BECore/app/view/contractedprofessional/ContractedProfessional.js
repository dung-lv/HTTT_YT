/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.contractedprofessional.ContractedProfessional', {
    extend: 'QLDT.view.base.BaseEditTable',
    xtype: 'app-contractedprofessional',
    requires: [
        'QLDT.view.base.BaseEditTable',
        'QLDT.view.contractedprofessional.ContractedProfessionalController',
        'QLDT.view.contractedprofessional.ContractedProfessionalModel'
    ],
    layout: 'border',

    controller: 'ContractedProfessional',
    viewModel: 'ContractedProfessional',

    columnStartEdit: 3,
    checkboxSelect: true,
    /*
    * Overrides hàm lấy lại danh sách các nút
    * Lấy danh sách menu của toolbar
    * Create by: manh:26.05.18
    */
    getToolbarMenu: function () {
        var me = this,
            UserName = QLDT.Config.getUserName(),
            CompanyID = QLDT.Config.getCompanyID(),
            toolbar = [
                 '->',
                 {
                     iconCls: 'button-excel menu-button-item fa fa-download',
                     cls: 'menu-button-item',
                     text: 'Xuất Excel',
                     itemId: 'btnExcel',
                 },
                 {
                     iconCls: 'button-excel menu-button-item fa fa-download',
                     cls: 'menu-button-item',
                     text: 'Lập TKCM',
                     itemId: 'btnTKCM',
                 }
            ];
        return toolbar;
    },
    /*
    * Vẽ thanh topbar item trên grid
    * Create by: manh:26.05.18
    */
    getTopBar: function () {
        var me = this,
            projectStore = me.getViewModel().getStore('projectStore'),
            vitem;
        vitem = [
                {
                    xtype: 'MTPanel',
                    layout: {
                        type: 'hbox',
                    },
                    items: [
                        {
                            fieldLabel: 'Đề tài',
                            name: 'ProjectID',
                            xtype: 'MTComboBox',
                            itemId: 'cboProjectID',
                            flex: 1,
                            displayField: 'ProjectName',
                            valueField: 'ProjectID',
                            store: projectStore
                        },
                        {
                            xtype: 'MTButton',
                            text: 'Tìm kiếm',
                            itemId: 'btnSearch',
                            margin: '0 8 8 10',
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
    * Create by: manh:26.05.18
    */
    getColumns: function () {
        var me = this,
            CompanyID = QLDT.Config.getCompanyID(), column;
        if (CompanyID === QLDT.common.Constant.Company_BTC) {
            column = [
               { text: 'STT', dataIndex: 'RowNum', width: 70, align: 'center', readOnly: true },
               {
                   text: 'Nội dung', dataIndex: 'Contents', minWidth: 180, flex: 1, readOnly: true, xtype: 'MTColumn'
               },
               {
                   text: 'Chọn in', dataIndex: 'Inactive', width: 70, xtype: 'MTColumnCheckBox',
                   renderer: function (value, metaData, record, rowIndex, colIndex, store) {
                       return (record.data.Edit == true) ? '' : this.defaultRenderer(value, metaData);
                   },
                   listeners: {
                       beforecheckchange: function (sender, rowIndex, checked, record, e, eOpts) {
                           if (record.data.Edit == true) {
                               return false;
                           }
                           else return true;
                       }
                   },
               },
               {
                   text: 'Xác nhận lập TKCM', dataIndex: 'Verify', width: 70, xtype: 'MTColumnCheckBox',
                   renderer: function (value, metaData, record, rowIndex, colIndex, store) {
                       return (record.data.Edit == true) ? '' : this.defaultRenderer(value, metaData);
                   },
                   listeners: {
                       beforecheckchange: function (sender, rowIndex, checked, record, e, eOpts) {
                           if (record.data.Edit == true) {
                               return false;
                           }
                           else return true;
                       }
                   },
               },
               {
                   text: 'Cán bộ', dataIndex: 'FullName', width: 180, readOnly: true
               },
               {
                   text: 'Số ngày công (RD)', dataIndex: 'MonthForTask', width: 180, xtype: 'MTColumnNumberField', maxValue: 24,
               },
               {
                   text: 'Số ngày công (Đã chấm)', dataIndex: 'MonthForTaskLaborday', width: 180, xtype: 'MTColumnNumberField', maxValue: 24,
               }
            ];
        }
        else {
            column = [
               { text: 'STT', dataIndex: 'RowNum', width: 70, align: 'center', readOnly: true },
               {
                   text: 'Nội dung', dataIndex: 'Contents', minWidth: 180, flex: 1, readOnly: true, xtype: 'MTColumn'
               },
               {
                   text: 'Chọn in', dataIndex: 'Inactive', width: 70, xtype: 'MTColumnCheckBox',
                   renderer: function (value, metaData, record, rowIndex, colIndex, store) {
                       return (record.data.Edit == true) ? '' : this.defaultRenderer(value, metaData);
                   },
                   listeners: {
                       beforecheckchange: function (sender, rowIndex, checked, record, e, eOpts) {
                           if (record.data.Edit == true) {
                               return false;
                           }
                           else return true;
                       }
                   },
               },
               {
                   text: 'Cán bộ', dataIndex: 'FullName', width: 180, readOnly: true
               },
               {
                   text: 'Số ngày công (RD)', dataIndex: 'MonthForTask', width: 180, xtype: 'MTColumnNumberField', maxValue: 24,
               },
               {
                   text: 'Số ngày công (Đã chấm)', dataIndex: 'MonthForTaskLaborday', width: 180, xtype: 'MTColumnNumberField', maxValue: 24,
               }
            ];
        }
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
