/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.project.ProjectController', {
    extend: 'QLDT.view.base.BaseListController',

    requires: ['QLDT.view.base.BaseListController'],

    alias: 'controller.Project',
    apiController: 'Projects',
    /*
    * Hàm khởi tạo của controller
    * Create by: dvthang:05.01.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
      
    },


    /*
    * Bắt event trước khi show context menu, nếu row là project thì hiện 3 nút, ngược lại thì ẩn
    * Create by: manh:25.02.2018
    */
    customBeforeshowContextMenuGridMaster: function (grid, menuContext, record) {
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
    * Create by: manh:25.02.2018
    */
    customSelectionChangeItem: function (view, selections, options) {
        var me = this, recordSelected = selections[0];
        if (recordSelected) {
            var me = this, toolBar = me.getToolBar();
            if (toolBar) {
                me.setDisableButtonTbr(recordSelected, toolBar.items.items);
            }
        }
    },

    /*
   * Trả về tên của form detail
   * Create by: dvthang:09.01.2018
   */
    getPageDetail: function () {
        return 'QLDT.view.project.ProjectDetail';
    },

    /*
    * Thực hiện diable 1 số button trên toolbar sau khi load xong
    * Create by: dvthang:27.02.2018
    */
    customSetStatusButtonToolBar: function (toolBar, record, items) {
        var me = this;
        me.setDisableButtonTbr(record, items);
    },

    /*
    * Thực hiện ẩn hiện button trên toolbar
    * Create by: dvthang:27.02.2018
    */
    setDisableButtonTbr: function (record,items) {
        if (record) {
            var isProject = record.get("IsProject");
            Ext.each(items, function (it) {
                if (isProject) {
                    it.setDisabled(false);
                }
                else {
                    if (it.itemId != 'mnRefresh' && it.itemId != 'mnAdd') {
                        it.setDisabled(true);
                    }
                }
            });
        }
    }

});
