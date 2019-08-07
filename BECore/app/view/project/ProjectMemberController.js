/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.project.ProjectMemberController', {
    extend: 'QLDT.view.base.BaseListController',

    requires: ['QLDT.view.base.BasePopupDetailController'],

    alias: 'controller.ProjectMember',
    apiController: 'ProjectMember',
    /*
    * Hàm khởi tạo của controller
    * Create by: laipv:01.02.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
    },
    /*
    * Thực hiện overrides lại - để không load dữ liệu mặc định mà sẽ tự load
    * Create by: laipv:11.02.2018
    */
    afterrender: function () {
        //todo
    },

    /*
    * Hàm load data cho Grid - Overrides lại hàm này trên base
    * Create by: laipv:11.02.2018
    */
    loadData: function (masterID) {
        var me = this, store = me.getViewModel().getStore("masterStore");
        if (store) {
            try {
                var proxy = store.getProxy();
                if (proxy) {
                    proxy.setExtraParams({ masterID: masterID });
                    store.load({
                        callback: function (records, operation, success) {
                            var enable = false;
                            //Focus vào row đầu tiên trên grid
                            if (Ext.isArray(records) && records.length > 0) {
                                me.setFocusRowFirst(records[0]);
                                enable = true;
                            }
                            me.setStatusButtonToolBar(enable);
                        }
                    });
                }
            } catch (e) {
                QLDT.utility.Utility.handleException(e);
            }

        }
    },
    /*
  * Trả về tên của form detail 
  * Create by: laipv:11.02.2018
  */
    getPageDetail: function () {
        return 'QLDT.view.project.ProjectMemberDetail';
    }
});
