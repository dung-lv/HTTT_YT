/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectInfoDetail', {
    extend: 'QLDT.view.control.MTPanel',
    xtype: 'app-projectinfodetail',
    requires: [
        'QLDT.view.control.MTPanel',
        'QLDT.view.project.ProjectInfoDetailController',
        'QLDT.view.project.ProjectInfoDetailModel',
        'QLDT.view.attach.Project_AttachDetail',
        'QLDT.view.control.MTButton'
    ],
    controller: 'ProjectInfoDetail',
    viewModel: 'ProjectInfoDetail',
    layout: {
        type: 'vbox',
        align: 'stretch'
    },

    /*
    * Hàm lấy danh sách cột của lưới
    * Create by: laipv:17.01.2018
    */
    getColumns: function () {
        var me = this;
        return [
                {
                    text: 'STT', dataIndex: 'SortOrder', width: 60, align: 'center',
                },
                { text: 'Mô tả', dataIndex: 'Description', minWidth: 250, flex: 1 },
                { text: 'Kích thước', dataIndex: 'FileSize', width: 120, align: 'center' },
                {
                    xtype: 'MTColumnAction',
                    text: 'Tải tài liệu',
                    width: 90,
                    items: [{
                        iconCls: 'font-size-icon-grid fa fa-download',
                        tooltip: 'Tải',
                        handler: function (grid, rowIndex, colIndex) {
                            var rec = grid.getStore().getAt(rowIndex), ID = rec.get("Project_AttachDetailID");
                            if (rec.get("IsTemp")) {
                                ID = rec.get("FileResourceID");
                            }
                            QLDT.utility.Utility.downloadFile({
                                ID: ID,
                                FT: rec.get("FileType"),
                                IsTemp: rec.get("IsTemp"),
                                EditMode: me.getController().EditMode,
                            });
                        }
                    }, {
                        iconCls: 'font-size-icon-grid fa fa-pencil-square-o',
                        tooltip: 'Sửa',
                        handler: function (grid, rowIndex, colIndex) {
                            var store = grid.getStore();
                            if (store) {
                                var frm = Ext.create('QLDT.view.attach.Project_AttachDetail');
                                if (frm) {
                                    var controller = frm.getController();
                                    if (controller) {
                                        controller.show(me, QLDT.common.Enumaration.EditMode.Edit, store.getAt(rowIndex));
                                    }
                                }
                            }
                        }
                    }, {
                        iconCls: 'font-size-icon-grid fa fa-trash-o',
                        tooltip: 'Xóa',
                        handler: function (grid, rowIndex, colIndex) {
                            var store = grid.getStore();
                            if (store) {
                                store.removeAt(rowIndex);
                            }
                        }
                    }]
                }
        ];
    },
    /*
    * Vẽ nội dung của form
    * Create by: 17.01.2018
    */
    getContent: function () {
        var me = this, store = me.getViewModel().getStore("detail");
        return [
                {
                    fieldLabel: 'Mã đề tài',
                    name: 'ProjectCode',
                    xtype: 'MTTextField',
                    labelWidth: 130,
                    allowBlank: false,
                    maxLength: 64,
                    maxWidth: 400,
                    bind: '{masterData.ProjectCode}'
                },
                {
                    fieldLabel: 'Tên đề tài',
                    name: 'ProjectName',
                    xtype: 'MTTextField',
                    labelWidth: 130,
                    maxLength: 255,
                    allowBlank: false,
                    bind: '{masterData.ProjectName}'
                },
                {
                    fieldLabel: 'Cấp quản lý',
                    name: 'LevelID',
                    xtype: 'MTComboBox',
                    labelWidth: 130,
                    allowBlank: false,
                    displayField: 'LevelName',
                    valueField: 'LevelID',
                    bind: {
                        value: '{masterData.LevelID}',
                        store: '{levelStore}'
                    }
                },
                {
                    fieldLabel: 'Chủ nhiệm đề tài',
                    name: 'EmployeeID',
                    xtype: 'MTComboBox',
                    labelWidth: 130,
                    allowBlank: false,
                    displayField: 'FullName',
                    valueField: 'EmployeeID',
                    bind: {
                        value: '{masterData.EmployeeID}',
                        store: '{employeeStore}'
                    }
                },
                {
                    xtype: 'MTPanel',
                    layout: 'hbox',
                    margin: '0 8 8 0',
                    items: [
                        {
                            fieldLabel: 'Bắt đầu',
                            name: 'StartDate',
                            itemId: 'startDateID',
                            allowBlank: false,
                            labelWidth: 130,
                            xtype: 'MTDateField',
                            bind: '{masterData.StartDate}'
                        },
                        {
                            fieldLabel: 'Kết thúc',
                            name: 'EndDate',
                            itemId: 'endDateID',
                            labelWidth: 80,
                            allowBlank: false,
                            margin: '0 0 0 8',
                            xtype: 'MTDateField',
                            bind: '{masterData.EndDate}'
                        },
                    ]
                },

                {
                    fieldLabel: 'Tổng kinh phí',
                    name: 'Amount',
                    labelWidth: 130,
                    allowBlank: false,
                    xtype: 'MTNumberField',
                    maxWidth: 400,
                    bind: '{masterData.Amount}'
                },
                {
                    fieldLabel: 'Sản phẩm',
                    name: 'Result',
                    labelWidth: 130,
                    allowBlank: false,
                    xtype: 'MTTextField',
                    bind: '{masterData.Result}'
                },
                {
                    fieldLabel: 'Đơn vị áp dụng',
                    name: 'CompanyApply',
                    labelWidth: 130,
                    xtype: 'MTTextField',
                    allowBlank: false,
                    bind: '{masterData.CompanyApply}'
                },
                {
                    xtype: 'MTPanel',
                    layout: 'fit',
                    flex: 1,
                    items: [
                        {
                            xtype: 'MTGrid',
                            store: store,
                            flex: 1,
                            minHeight: 100,
                            columnLines: true,
                            viewConfig: {
                                emptyText: 'Không tệp đính kèm nào',
                            },
                            itemId: 'grdAttachInfo',
                            columns: me.getColumns(),
                            contextMenu: me.getContextMenu()
                        }
                    ]
                },

        ];
    },

    /*
    * Trả về context menu của grid
    * Create by: dvthang:21.01.2018
    */
    getContextMenu: function () {
        var me = this;
        return [
                {
                    iconCls: 'button-add menu-button-item fa fa-plus',
                    cls: 'menu-button-item',
                    text: 'Thêm',
                    itemId: 'mnAdd',
                    handler: function (sender) {
                        var controller = me.getController();
                        if (controller) {
                            controller.contextMenu_OnClick(sender);
                        }
                    }
                },
                 {
                     iconCls: 'button-edit menu-button-item fa fa-pencil-square-o',
                     cls: 'menu-button-item',
                     text: 'Sửa',
                     itemId: 'mnEdit',
                     handler: function (sender) {
                         var controller = me.getController();
                         if (controller) {
                             controller.contextMenu_OnClick(sender);
                         }
                     }
                 },
                 {
                     iconCls: 'button-delete menu-button-item fa fa-trash-o',
                     cls: 'menu-button-item',
                     text: 'Xóa',
                     itemId: 'mnDelete',
                     handler: function (sender) {
                         var controller = me.getController();
                         if (controller) {
                             controller.contextMenu_OnClick(sender);
                         }
                     }
                 }

        ];
    },

    /*
   * Khởi tạo các thành phần của form
   * Create by: 17.01.2018
   */
    initComponent: function () {
        var me = this;
        Ext.apply(me, {
            layout: 'border',
            flex: 1,
            items: [
                {
                    xtype: 'MTForm',
                    region: 'center',
                    flex: 1,
                    itemId: 'formInfo',
                    layout: {
                        type: 'vbox',
                        align: 'stretch'
                    },
                    items: me.getContent()
                },
                {
                    xtype: 'MTPanel',
                    region: 'south',
                    height: 40,
                    layout: {
                        type: 'hbox',
                        pack: 'end'
                    },
                    defaults: {
                        xtype: 'MTButton',
                        margin: '8 0 0 4',
                    },
                    items: [
                        {
                            xtype: 'MTComboBox',
                            fieldLabel: 'Trạng thái đề tài',
                            name: 'Status',
                            displayField: 'text',
                            valueField: 'value',
                            labelWidth: 110,
                            width: 330,
                            bind: {
                                value: '{masterData.Status}',
                                store: '{statusStore}'
                            },
                            margin: '8 0 8 0'
                        },
                        {
                            text: QLDT.GlobalResource.Save,
                            itemId: 'btnSave',
                            appendCls: 'btn-save',
                            iconCls: 'button-save fa fa-floppy-o',
                        }
                    ]
                }

            ]
        });
        me.callParent(arguments);
    },
});
