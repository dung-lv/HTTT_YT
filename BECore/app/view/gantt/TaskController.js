/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.gantt.TaskController', {
    extend: 'QLDT.view.base.BaseController',

    requires: ['QLDT.view.base.BaseController'],

    alias: 'controller.gantttask',


    /*
    * Hàm khởi tạo của controller
    * Create by: dvthang:05.01.2018
    */
    init: function () {
        var me = this;
        me.callParent(arguments);
        me.control({
            '#': {
                afterrender: 'afterrender',
                scope: me
            }
        });
    },

    /*
    * Thực hiện load data cho gantt
    * Create by: dvthang:07.04.2018
    */
    afterrender: function () {
        var me = this, view = me.getView();
        if (view) {
            Ext.defer(function () {
                view.mask('Đang lấy dữ liệu...');
                QLDT.utility.MTAjax.request(QLDT.utility.Utility.createUriAPI('/Gantt/GetTasks?levelId=-1&projectId'), "GET", {}, {}, function (respone) {
                    if (respone.Success && respone.Data.length>0) {
                        var sheduleTask = respone.Data[0];

                        var ganttTaskStore = view.getTaskStore();
                        view.suspendViewsRefresh();

                        view.startDate = sheduleTask.MinDate;
                        view.endDate = sheduleTask.MaxDate;

                        ganttTaskStore.setRoot({ expanded: true, Data: sheduleTask.taskTree });
                        view.resumeViewsRefresh();
                        view.refreshViews();
                    }
                    view.unmask();
                });
            },100);
        }
    }

});
