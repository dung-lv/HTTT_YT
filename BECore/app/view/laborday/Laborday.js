/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.laborday.Laborday', {
    extend: 'QLDT.view.base.BaseEditTable',
    xtype: 'app-laborday',
    requires: [
        'QLDT.view.base.BaseEditTable',
        'QLDT.view.laborday.LabordayController',
        'QLDT.view.laborday.LabordayModel'
    ],
    layout: 'border',

    controller: 'Laborday',
    viewModel: 'Laborday',

    columnStartEdit: 2,
    /*
    * Overrides hàm lấy lại danh sách các nút
    * Lấy danh sách menu của toolbar
    * Ban tài chính thì thêm nút chuyển dữ liệu
    * Create by: dvthang:24.1.2018
    * Modify by: manh:04.05.18
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
                 {
                     iconCls: 'button-CopyCell menu-button-item fa fa-copy',
                     cls: 'menu-button-item',
                     text: 'Copy',
                     itemId: 'btnCopyCell',
                     handler: function (sender) {
                         var controller = me.getController();
                         if (controller) {
                             controller.toolbar_OnClickModify(sender);
                         }
                     }
                 },
                 {
                     iconCls: 'button-PasteCell menu-button-item fa fa-clipboard',
                     cls: 'menu-button-item',
                     text: 'Paste',
                     itemId: 'btnPasteCell',
                     handler: function (sender) {
                         var controller = me.getController();
                         if (controller) {
                             controller.toolbar_OnClickModify(sender);
                         }
                     }
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
                 {
                     iconCls: 'button-changeAll menu-button-item fa fa-angle-double-down',
                     cls: 'menu-button-item',
                     text: 'Nhập hàng loạt',
                     itemId: 'btnChangeAll',
                 },
                 {
                     iconCls: 'button-change menu-button-item fa fa-exchange',
                     cls: 'menu-button-item',
                     text: 'Chuyển dữ liệu',
                     itemId: 'btnChange',
                 },
                 {
                     iconCls: 'button-CopyCell menu-button-item fa fa-copy',
                     cls: 'menu-button-item',
                     text: 'Copy',
                     itemId: 'btnCopyCell',
                     handler: function (sender) {
                         var controller = me.getController();
                         if (controller) {
                             controller.toolbar_OnClickModify(sender);
                         }
                     }
                 },
                 {
                     iconCls: 'button-PasteCell menu-button-item fa fa-clipboard',
                     cls: 'menu-button-item',
                     text: 'Paste',
                     itemId: 'btnPasteCell',
                     handler: function (sender) {
                         var controller = me.getController();
                         if (controller) {
                             controller.toolbar_OnClickModify(sender);
                         }
                     }
                 },
                 '->',
                 {
                     iconCls: 'button-excelTC menu-button-item fa fa-download',
                     cls: 'menu-button-item',
                     text: 'Xuất Excel (TC)',
                     itemId: 'btnExcelTC',
                 },
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
    * Tạo context menu cho grid
    * Copy, Paste, Remove
    * Create by: manh:28.05.18
    */
    getContextMenu: function () {
        var me = this;
        return [
                {
                    iconCls: 'button-CopyCell menu-button-item fa fa-copy',
                    cls: 'menu-button-item',
                    text: 'Copy',
                    itemId: 'btnCopyCell',
                    handler: function (sender) {
                        var controller = me.getController();
                        if (controller) {
                            controller.toolbar_OnClickModify(sender);
                        }
                    }
                },
                 {
                     iconCls: 'button-PasteCell menu-button-item fa fa-clipboard',
                     cls: 'menu-button-item',
                     text: 'Paste',
                     itemId: 'btnPasteCell',
                     handler: function (sender) {
                         var controller = me.getController();
                         if (controller) {
                             controller.toolbar_OnClickModify(sender);
                         }
                     }
                 },
                 //{
                 //    iconCls: 'button-delete menu-button-item fa fa-trash-o',
                 //    cls: 'menu-button-item',
                 //    text: 'Xóa',
                 //    itemId: 'mnDelete',
                 //}
        ];
    },
    /*
    * Vẽ thanh topbar item trên grid
    * Ban kết hoạch và Ban tài chính thì full quyền, Nhân viên chỉ xem được đề tài mình là chủ nhiệm
    * Create by: dvthang:03.03.2018
    * Modify by: manh:04.05.18
    */
    getTopBar: function () {
        var me = this,
            monthStore = me.getViewModel().getStore('monthStore'),
            yearStore = me.getViewModel().getStore('yearStore'),
            employeeStore = me.getViewModel().getStore('employeeStore'),
            projectStore = me.getViewModel().getStore('projectStore'),
            projectByEmployeeStore = me.getViewModel().getStore('projectByEmployeeStore'),
            projectTaskStore = me.getViewModel().getStore('projectTaskStore'),
            UserName = QLDT.Config.getUserName(),
            CompanyID = QLDT.Config.getCompanyID(),
            vitem;
        if ((CompanyID === QLDT.common.Constant.Company_BKH) || (CompanyID === QLDT.common.Constant.Company_BTC)) {
            vitem = [
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
                        fieldLabel: 'Nội dung',
                        name: 'ProjectTaskID',
                        xtype: 'MTComboBox',
                        flex: 1,
                        displayField: 'Contents',
                        valueField: 'ProjectTaskID',
                        itemId: 'cboProjectTask',
                        store: projectTaskStore
                    },
                    {
                        fieldLabel: 'Cán bộ',
                        name: 'EmployeeID',
                        xtype: 'MTComboBox',
                        flex: 1,
                        displayField: 'FullName',
                        valueField: 'EmployeeID',
                        store: employeeStore,
                        itemId: 'cboEmployee',
                    },
                    {
                        xtype: 'MTPanel',
                        layout: {
                            type: 'hbox',
                        },
                        items: [
                            {
                                xtype: 'MTComboBox',
                                fieldLabel: 'Tháng',
                                name: 'Month',
                                itemId: 'cboMonth',
                                labelWidth: 110,
                                allowBlank: false,
                                displayField: 'Text',
                                valueField: 'Value',
                                store: monthStore,
                            },
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
        }
        else {
            vitem = [
                           {
                               fieldLabel: 'Đề tài',
                               name: 'ProjectID',
                               xtype: 'MTComboBox',
                               itemId: 'cboProjectID',
                               flex: 1,
                               displayField: 'ProjectName',
                               valueField: 'ProjectID',
                               store: projectByEmployeeStore
                           },
                           {
                               fieldLabel: 'Nội dung',
                               name: 'ProjectTaskID',
                               xtype: 'MTComboBox',
                               flex: 1,
                               displayField: 'Contents',
                               valueField: 'ProjectTaskID',
                               itemId: 'cboProjectTask',
                               store: projectTaskStore
                           },
                           {
                               fieldLabel: 'Cán bộ',
                               name: 'EmployeeID',
                               xtype: 'MTComboBox',
                               flex: 1,
                               displayField: 'FullName',
                               valueField: 'EmployeeID',
                               store: employeeStore,
                               itemId: 'cboEmployee',
                           },
                           {
                               xtype: 'MTPanel',
                               layout: {
                                   type: 'hbox',
                               },
                               items: [
                                   {
                                       xtype: 'MTComboBox',
                                       fieldLabel: 'Tháng',
                                       name: 'Month',
                                       itemId: 'cboMonth',
                                       labelWidth: 110,
                                       allowBlank: false,
                                       displayField: 'Text',
                                       valueField: 'Value',
                                       store: monthStore,
                                   },
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
        }

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
    * Create by: dvthang:03.03.2018
    * Modify by: manh:04.05.18
    */
    getColumns: function () {
        var me = this,
            UserName = QLDT.Config.getUserName(),
            CompanyID = QLDT.Config.getCompanyID(),
            column = [
               { text: 'STT', dataIndex: 'SortOrder', width: 70, align: 'center', readOnly: true },
               {
                   text: 'Ngày', dataIndex: 'DayName', width: 180, readOnly: true,
                   renderer: function (value, metaData, record, rowIndex) {
                       if (record.get("DayOff") === true) { // Là ngày nghỉ
                           return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                       } if (record.get("DescriptionMade") != 0) {
                           metaData.tdAttr = 'data-qtip="' + record.get('DescriptionMade') + '"';
                           return Ext.String.format("<div style = 'color:#FFFF00;'>{0}</div>", value);
                       }
                       return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
                   }
               },
               { text: 'Mô tả', dataIndex: 'Description', minWidth: 180, flex: 1, xtype: 'MTColumn', maxLength: 255 },
               {
                   text: 'Số giờ', dataIndex: 'Hour', width: 120, xtype: 'MTColumnNumberField', maxValue: 24,
                   renderer: function (value, metaData, record, rowIndex) {
                       if (record.get("Description") == "") {
                           return "";
                       }
                       return value;
                   }
               },
               {
                   text: 'Số ngày công', dataIndex: 'LaborDay', width: 130, xtype: 'MTColumnNumberField', maxValue: 1, minValue: 0,
                   renderer: function (value, metaData, record, rowIndex) {
                       if (record.get("Description") == "") {
                           return "";
                       }
                       return value;
                   }
               }
            ];
        if (CompanyID === QLDT.common.Constant.Company_BTC) {
            column = [
               { text: 'STT', dataIndex: 'SortOrder', width: 70, align: 'center', readOnly: true },
               {
                   text: 'Ngày', dataIndex: 'DayName', width: 180, readOnly: true,
                   renderer: function (value, metaData, record, rowIndex) {
                       if (record.get("DayOff") === true) { // Là ngày nghỉ
                           return Ext.String.format("<div  style = 'color:#DD0000;'>{0}</div>", value);
                       } if (record.get("DescriptionMade") != 0) {
                           metaData.tdAttr = 'data-qtip="' + record.get('DescriptionMade') + '"';
                           return Ext.String.format("<div style = 'color:#FFFF00;'>{0}</div>", value);
                       }
                       return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
                   }
               },
               { text: 'Mô tả', dataIndex: 'Description', minWidth: 180, flex: 1, xtype: 'MTColumn', maxLength: 255 },
               { text: 'Số giờ', dataIndex: 'Hour', width: 120, xtype: 'MTColumnNumberField', maxValue: 24 },
               {
                   text: 'Số ngày công', dataIndex: 'LaborDay', width: 130, xtype: 'MTColumnNumberField', maxValue: 1, minValue: 0,
               },
               { text: 'Mô tả (TC)', dataIndex: 'DescriptionFin', minWidth: 180, flex: 1, xtype: 'MTColumn', maxLength: 255 },
               { text: 'Số giờ (TC)', dataIndex: 'HourFin', width: 120, xtype: 'MTColumnNumberField', maxValue: 24 },
               {
                   text: 'Số ngày công (TC)', dataIndex: 'LaborDayFin', width: 130, xtype: 'MTColumnNumberField', maxValue: 1, minValue: 0,
               }
            ];
        }
        return column;
    },

    /*
    * Khai báo store load dữ liệu cho grid
    * Create by: dvthang:03.03.2018
    */
    getStoreMaster: function () {
        var me = this,
            store = me.getViewModel().getStore('masterStore');
        return store;
    }
});
