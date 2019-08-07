/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.project.ProjectListController', {
    extend: 'Ext.app.ViewController',

    requires: ['Ext.app.ViewController'],

    alias: 'controller.ProjectList',
    apiController: 'ProjectList',
    /*
    * Hàm khởi tạo của controller
    * Create by: dvthang:05.01.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            "#tabListProject": {
                tabchange: 'tabListProject_OnChange',
                scope: me
            }
        });
    },

    /*
    * Thay đổi tab thì load lại dữ liệu
    * Create by: dvthang:05.02.2018
    */
    tabListProject_OnChange: function (tabPanel, tab) {
        var me = this,view=me.getView();
        try
        {
            switch (tab.name) {
                case "TabOne":
                    break;
                case "TabTwo":
                    var executableItemID = Ext.ComponentQuery.query("#executableItemID")[0];
                    if (executableItemID) {
                        var controller = executableItemID.getController();
                        if (controller) {
                            controller.loadData();
                        }
                    }
                    break;
                case "TabThree":
                    var acceptance = Ext.ComponentQuery.query("#acceptanceItemID")[0];
                    if (acceptance) {
                        var controller = acceptance.getController();
                        if (controller) {
                            controller.loadData();
                        }
                    }
                    break;
            }
        } catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },
});
