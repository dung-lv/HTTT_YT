/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectWorkshopDetail', {
    extend: 'QLDT.view.base.BasePopupDetail',
    xtype: 'app-projectworkshopdetail',
    requires: [
        'QLDT.view.base.BasePopupDetail',
        'QLDT.view.project.ProjectWorkshopDetailController',
        'QLDT.view.project.ProjectWorkshopDetailModel',
        'QLDT.view.attach.ProjectWorkshop_AttachDetail',
        'QLDT.view.control.MTButton'
    ],

    controller: 'ProjectWorkshopDetail',
    viewModel: 'ProjectWorkshopDetail',

    width: 800,
    height: 600,

    /*
    * Hàm lấy danh sách cột của lưới
    * Create by: laipv:04.02.2018
    */
    getColumns: function () {
        var me = this;
        return [
                {
                    text: 'STT', dataIndex: 'SortOrder', width: 60, align: 'center',
                },
                { xtype: 'MTColumn', text: 'Mô tả', dataIndex: 'Description', minWidth: 250, flex: 1 },
                { xtype: 'MTColumnNumberField', text: 'Kích thước', dataIndex: 'FileSize', width: 120, align: 'center' },
                {
                    xtype: 'MTColumnAction',
                    text: 'Tải tài liệu',
                    width: 90,
                    items: [{
                        iconCls: 'font-size-icon-grid fa fa-download',
                        tooltip: 'Tải',
                        handler: function (grid, rowIndex, colIndex) {
                            var rec = grid.getStore().getAt(rowIndex), ID = rec.get("ProjectWorkshop_AttachDetailID");
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
                                var frm = Ext.create('QLDT.view.attach.ProjectWorkshop_AttachDetail');
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
    * Trả về context menu của grid
    * Create by: laipv:04.01.2018
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
    * Vẽ nội dung của form
    * Create by: 03.02.2018
    */
    getContent: function () {
        var me = this, store = me.getViewModel().getStore("detail");
        return {
            xtype: 'MTPanel',
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch',
            },
            items: [
                 {
                     xtype: 'MTPanel',
                     height: 160,
                     layout: {
                         type: 'vbox',
                         align: 'stretch',
                     },
                     defaults: {
                         margin: '4 0 4 0',
                     },
                     items: [
                         {
                             xtype: 'MTDateField',
                             fieldLabel: 'Ngày thực hiện',
                             name: 'Date',
                             itemId: 'dateID',
                             bind: '{masterData.Date}',
                             allowBlank: false,
                         },
                         {
                             xtype: 'MTTime',
                             bind: '{masterData.Time}',
                             name: 'Time',
                             fieldLabel: 'Thời gian',
                             flex: 1,
                             allowBlank: false
                         },
                        {
                            xtype: 'MTTextField',
                            fieldLabel: 'Địa điểm',
                            name: 'Adderess',
                            bind: '{masterData.Adderess}',
                            flex: 1,
                            allowBlank: false
                        },
                        {
                            xtype: 'MTTextField',
                            fieldLabel: 'Nội dung',
                            name: 'Contents',
                            bind: '{masterData.Contents}',
                            flex: 1,
                            allowBlank: false
                        },

                     ]
                 },
                {
                    xtype: 'MTGrid',
                    store: store,
                    flex: 1,
                    columnLines: true,
                    viewConfig: {
                        emptyText: 'Không tệp đính kèm nào',
                    },
                    itemId: 'grdAttachInfo',
                    columns: me.getColumns(),
                    contextMenu: me.getContextMenu()
                }
            ]
        }
    },

});
