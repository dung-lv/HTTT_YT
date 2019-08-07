/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectAcceptanceManageDetail', {
    extend: 'QLDT.view.control.MTPanel',
    xtype: 'app-projectacceptancemanagedetail',
    requires: [
        'QLDT.view.control.MTPanel',
        'QLDT.view.project.ProjectAcceptanceManageDetailController',
        'QLDT.view.project.ProjectAcceptanceManageDetailModel',
        'QLDT.view.attach.ProjectAcceptanceManage_AttachDetail',
        'QLDT.view.control.MTButton'
    ],
    controller: 'ProjectAcceptanceManageDetail',
    viewModel: 'ProjectAcceptanceManageDetail',


    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    /*
    * Hàm lấy danh sách cột của lưới
    * Create by: laipv:14.01.2018
    */
    getColumns: function () {
        var me = this;
        return [
            {
                text: 'STT', dataIndex: 'SortOrder', width: 60, align: 'center',
            },
                { text: 'Mô tả', xtype: 'MTColumn', dataIndex: 'Contents', minWidth: 250, flex: 1 },
                { text: 'Kích thước', xtype: 'MTColumnNumberField', dataIndex: 'FileSize', width: 120, align: 'center' },
                {
                    xtype: 'MTColumnAction',
                    text: 'Tải tài liệu',
                    width: 90,
                    items: [{
                        iconCls: 'font-size-icon-grid fa fa-download',
                        tooltip: 'Tải',
                        handler: function (grid, rowIndex, colIndex) {
                            var rec = grid.getStore().getAt(rowIndex), ID = rec.get("ProjectAcceptanceManage_AttachDetailID");
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
                                var frm = Ext.create('QLDT.view.attach.ProjectAcceptanceManage_AttachDetail');
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
    * Create by: manh:21.01.2018
    */
    getContent: function () {
        var me = this, store = me.getViewModel().getStore("detail");
        return [{
            xtype: 'MTPanel',
            layout: 'hbox',
            margin: '0 8 8 0',
            items: [{
                fieldLabel: 'Quyết định thành lập',
                labelWidth: 150,
                name: 'EstablishedDate',
                itemId: 'establishedDateID',
                xtype: 'MTDateField',
                bind: '{masterData.EstablishedDate}'
            },
                {
                    fieldLabel: 'Ngày họp hội đồng',
                    labelWidth: 150,
                    name: 'MeetingDate',
                    itemId: 'meetingDateID',
                    xtype: 'MTDateField',
                    margin: '0 0 0 8',
                    bind: '{masterData.MeetingDate}'
                }, ]
        },

                {
                    fieldLabel: 'Kết quả nghiệm thu',
                    labelWidth: 150,
                    name: 'Status',
                    xtype: 'MTComboBox',
                    displayField: 'text',
                    valueField: 'value',
                    bind: {
                        value: '{masterData.Status}',
                        store: '{statusStore}'
                    }
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
    *Trả về context menu của grid
    * Create by: manh:21.01.2018
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
   * Create by: laipv:14.01.2018
   */
    initComponent: function () {
        var me = this;
        Ext.apply(me, {
            layout: 'border',
            flex: 1,
            items: [{
                xtype: 'MTForm',
                itemId: 'formInfo',
                layout: {
                    type: 'vbox',
                    align: 'stretch'
                },
                region: 'center',
                flex: 1,
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
                    margin: 4,
                },
                items: [
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
