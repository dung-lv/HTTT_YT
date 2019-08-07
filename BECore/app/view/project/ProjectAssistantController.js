/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.project.ProjectAssistantController', {
    extend: 'QLDT.view.base.BaseListController',

    requires:['QLDT.view.base.BaseListController'],

    alias: 'controller.ProjectAssistant',
    apiController: 'Projects',
    /*
    * Hàm khởi tạo của controller
    * Create by: laipv:26.02.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            "#grdMaster": {
                'selectionchange': 'selectionchangeItem',
                scope: me
            },
            
        });
    },


    /*
    * Bắt event trước khi show context menu, nếu row là project thì hiện 3 nút, ngược lại thì ẩn
    * Create by: laipv:26.02.2018
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
                    case 'mnDuplicate':
                        if (!record.get("IsProject") || total <= 0) {
                            it.setDisabled(true);
                        } else {
                            it.setDisabled(false);
                        }
                        break;
                    case 'mnDelete':
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
    * Event chọn item trên grid, nếu row là project thì hiện 3 nút, ngược lại thì ẩn
    * Create by: laipv:26.02.2018
    */
    selectionchangeItem: function (view, selections, options) {
        var me = this, recordSelected = selections[0];
        var mnEdit = Ext.ComponentQuery.query("#mnEdit", me.getView())[0];
        var mnDuplicate = Ext.ComponentQuery.query("#mnDuplicate", me.getView())[0];
        var mnDelete = Ext.ComponentQuery.query("#mnDelete", me.getView())[0];
        if (recordSelected && recordSelected.get("IsProject")) {
            if (mnEdit && mnDuplicate && mnDelete) {
                mnEdit.setDisabled(false);
                mnDuplicate.setDisabled(false);
                mnDelete.setDisabled(false);
            }
            
        } else {
            if (mnEdit && mnDuplicate && mnDelete) {
                mnEdit.setDisabled(true);
                mnDuplicate.setDisabled(true);
                mnDelete.setDisabled(true);
            }
        }
    },

    /*
   * Trả về tên của form detail
   * Create by: laipv:26.02.2018
   */
    getPageDetail: function () {
        return 'QLDT.view.project.ProjectDetail';
    }
});
