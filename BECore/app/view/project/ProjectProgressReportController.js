/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.project.ProjectProgressReportController', {
    extend: 'QLDT.view.base.BaseListController',

    requires: ['QLDT.view.base.BaseListController'],

    alias: 'controller.ProjectProgressReport',
    apiController: 'ProjectProgressReport',

   // masterID: null,
    projectID: null,
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
                me.projectID = masterID;
                var proxy = store.getProxy();
                if (proxy) {
                    proxy.setExtraParams({ masterId: masterID });
                    store.load({
                        callback: function (records, operation, success) {
                            var enable = false;
                            //Focus vào row đầu tiên trên grid
                            if (Ext.isArray(records) && records.length > 0) {
                                me.setFocusRowFirst(records[0]);
                                enable = true;
                            }
                            me.setStatusButtonToolBar(enable);

                            //Bắt event click vào lick file để download
                            Ext.each(Ext.select(".form-progressreport .file-download").elements, function (element) {
                                element.onclick = function (e) {
                                    e.preventDefault();
                                    var id = e.target.getAttribute("fileid"),
                                        filetype = e.target.getAttribute("filetype");
                                    if (id && filetype) {
                                        QLDT.utility.Utility.downloadFile({
                                            ID: id,
                                            FT: filetype,
                                            IsTemp: false
                                        });
                                    }
                                };
                            });
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
        return 'QLDT.view.project.ProjectProgressReportDetail';
    },

    /*
   * Hàm thực hiện load lại dữ liệu trên grid
   * Create by: dvthang:09.01.2018
   */
    refreshData: function (sender) {
        var me = this;
        if (me.projectID) {
            me.loadData(me.projectID);
        }
        
    },

    
});
