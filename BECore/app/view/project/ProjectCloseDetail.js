/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectCloseDetail', {
    extend: 'QLDT.view.control.MTPanel',
    xtype: 'app-projectclosedetail',
    requires: [
        'QLDT.view.control.MTPanel',
        'QLDT.view.project.ProjectCloseDetailController',
        'QLDT.view.project.ProjectCloseDetailModel',
        'QLDT.view.attach.ProjectClose_AttachDetail',
        'QLDT.view.control.MTButton'
    ],
    controller: 'ProjectCloseDetail',
    viewModel: 'ProjectCloseDetail',
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
                { xtype: 'MTColumn', text: 'Mô tả', dataIndex: 'Contents', minWidth: 250, flex: 1 },
                { xtype: 'MTColumnNumberField', text: 'Kích thước', dataIndex: 'FileSize', width: 120, align: 'center' },
                {
                    xtype: 'MTColumnAction',
                    text: 'Tải tài liệu',
                    width: 90,
                    items: [{
                        iconCls: 'font-size-icon-grid fa fa-download',
                        tooltip: 'Tải',
                        handler: function (grid, rowIndex, colIndex) {
                            var rec = grid.getStore().getAt(rowIndex), ID = rec.get("ProjectClose_AttachDetailID");
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
                                var frm = Ext.create('QLDT.view.attach.ProjectClose_AttachDetail');
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
                    xtype: 'MTPanel',
                    layout: 'hbox',
                    margin: '0 8 8 0',
                    items: [{
                        fieldLabel: 'Ngày nộp hồ sơ',
                        labelWidth: 150,
                        name: 'Date',
                        itemId: 'dateID',
                        xtype: 'MTDateField',
                        bind: '{masterData.Date}'
                    },
                    {
                        fieldLabel: 'Ngày thanh lý',
                        labelWidth: 150,
                        margin: '0 0 0 8',
                        name: 'LiquidationDate',
                        itemId: 'liquidationDateID',
                        xtype: 'MTDateField',
                        bind: '{masterData.LiquidationDate}'
                    },
                    ]
                },
                 {
                     xtype: 'MTPanel',
                     //margin: '0 0 8 0',
                     items: [
                            {
                                xtype: 'MTForm',
                                layout: {
                                    type: 'vbox',
                                    align: 'stretch',
                                },
                                itemId: 'uploadFile',
                                items: [
                                        {
                                            xtype: 'MTFilefield',
                                            itemId: 'fileItemID',
                                            labelWidth: 150,
                                            flex: 1,
                                            emptyText: 'Chọn tệp đính kèm',
                                            fieldLabel: 'Phiếu nộp hồ sơ',
                                            name: 'planClose',
                                            buttonText: '',
                                            buttonConfig: {
                                                iconCls: 'fa fa-cloud-upload'
                                            }
                                        },
                                        {
                                            xtype: 'MTPanel',
                                            itemId: 'linkDowloadFile',
                                            html: 'Tải tệp đính kèm',
                                            margin: '4 0 8 0',
                                            hidden: true,
                                        },
                                ]
                            }]
                 },
                {
                    xtype: 'MTPanel',
                    layout: 'hbox',
                    margin: '0 8 8 0',
                    items: [

                    ]
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
   * Vẽ thanh top bar menu
   * Create by: dvthang:24.02.2018
   */
    getTopBar: function () {
        return {
            xtype: 'MTPanel',
            region: 'north',
            padding: '8 0 4 0',
            items: [
                   {
                       xtype: 'MTForm',
                       layout: {
                           type: 'vbox',
                           align: 'stretch',
                       },
                       itemId: 'uploadFile',
                       items: [
                               {
                                   xtype: 'MTFilefield',
                                   itemId: 'fileItemID',
                                   labelWidth: 120,
                                   flex: 1,
                                   emptyText: 'Chọn tệp đính kèm',
                                   fieldLabel: 'Đóng đề tài',
                                   name: 'planClose',
                                   buttonText: '',
                                   buttonConfig: {
                                       iconCls: 'fa fa-cloud-upload'
                                   }
                               },
                               {
                                   xtype: 'MTPanel',
                                   itemId: 'linkDowloadFile',
                                   html: 'Tải tệp đính kèm',
                                   margin: '4 0 8 0',
                                   hidden: true,
                               },
                       ]
                   }]
        };
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
