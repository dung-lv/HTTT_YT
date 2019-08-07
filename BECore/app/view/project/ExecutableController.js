/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.project.ExecutableController', {
    extend: 'QLDT.view.base.BaseController',

    requires: ['QLDT.view.base.BaseController'],

    alias: 'controller.Executable',
    apiController: 'Executables',
    /*
    * Hàm khởi tạo của controller
    * Create by: dvthang:05.01.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            "#treeExecutable": {
                'beforeshowContextMenu': 'beforeshowContextMenuGridMaster',
                'selectionchange': 'selectionchangeItem',
                scope: me
            },
            '#toolbarGrid button': {
                click: 'toolbar_OnClick',
                scope: me
            },
        });
    },

    /*
    * Bắt event click vào button trên thanh toolbar
    * Create by: dvthang:09.01.2018
    */
    toolbar_OnClick: function (sender) {
        var me = this;
        switch (sender.name) {
            case 'mnEdit':
                me.editData(sender);
                break;
        }
    },

    /*
    * Event chọn item trên grid
    * Create by: dvthang:25.02.2018
    */
    selectionchangeItem: function (view, selections, options) {
        var me = this, recordSelected = selections[0];
        var mnEdit = Ext.ComponentQuery.query("#mnEdit", me.getView())[0];
        if (recordSelected && recordSelected.get("IsProject")) {
            if (mnEdit) {
                mnEdit.setDisabled(false);
            }
        } else {
            if (mnEdit) {
                mnEdit.setDisabled(true);
            }
        }
    },

    /*
    * Bắt event trước khi show context menu
    * Create by: dvthang:29.01.2018
    */
    beforeshowContextMenuGridMaster: function (grid, menuContext, record) {
        var me = this, store = grid.getStore();
        if (store) {
            var total = store.getCount();

            Ext.each(menuContext.items.items, function (it) {
                switch (it.itemId) {
                    case 'mnEdit':
                        if (!record.get("IsProject") || total <= 0) {
                            it.setDisabled(true);
                        } else {
                            it.setDisabled(false);
                        }
                        break;
                }
            });
        }
    },

    /*
    * Gọi hàm load data cho form
    * Create by: dvthang:04.02.2018
    */
    loadData: function () {
        var me = this, store = me.getViewModel().getStore('masterTreeStore');
        try {
            if (store) {
                store.load({
                    callback: function (records, operation, success) {
                        if (records) {
                            //todo;
                            var treeExecutable = Ext.ComponentQuery.query("#treeExecutable", me.getView())[0];
                            if (treeExecutable) {
                                treeExecutable.expandAll();
                                if (Ext.isArray(records) && records.length > 0) {
                                    treeExecutable.getSelectionModel().select(records[0]);
                                    //me.showFormDetail(records[0], QLDT.common.Enumaration.EditMode.Edit);
                                }
                            }
                        }
                    }
                });
            }
        } catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },


    /*
    * Lấy về đối tượng grid của form
    * Create by: manh:28.02.2018
    */
    getTreeMaster: function () {
        var me = this, view = me.getView();
        if (!me.treeExecutable) {
            me.treeExecutable = Ext.ComponentQuery.query('#treeExecutable', view)[0];
        }
        return me.treeExecutable;
    },

    /*
    * Sửa giá trị trên form
    * Create by: manh:28.02.2018
    */
    editData: function (sender) {
        var me = this;
        try {
            var treeExecutable = me.getTreeMaster();
            if (treeExecutable) {
                treeExecutable.expandAll();
                    var sm = treeExecutable.getSelectionModel().getSelection();
                    if (sm && sm.length > 0) {
                        me.showFormDetail(sm[0], QLDT.common.Enumaration.EditMode.Edit);
                    }
               
            } else {
                QLDT.utility.Utility.showWarning(QLDT.GlobalResource.SelectRecord);
            }
        }

        catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },

    /*
    * Hiển thị form chi tiết
    * Create by: manh:28.02.2018
    */
    showFormDetail: function (record, editMode) {
        var me = this,
         pageDetail = me.getPageDetail();
        if (pageDetail) {
            var frm = Ext.create(pageDetail);
            if (frm) {
                var controller = frm.getController();
                if (controller) {
                    var store = me.getViewModel().getStore('masterTreeStore');
                    controller.show(me, store, record, editMode);
                }
            }
        }
    },

    /*
  * Trả về tên của form detail
  * Create by: manh:28.02.2018
  */
    getPageDetail: function () {
        return 'QLDT.view.project.ProjectDetail';
    }

});
