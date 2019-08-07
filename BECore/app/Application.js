
/**
 * The main application class. An instance of this class is created by app.js when it
 * calls Ext.application(). This is the ideal place to handle application launch and
 * initialization details.
 */
Ext.define('QLDT.Application', {
    extend: 'Ext.app.Application',

    name: 'QLDT',

    requires: [
        'Ext.data.proxy.Ajax',
        'Ext.data.reader.Json',
        'QLDT.view.control.*',
        'QLDT.controller.GlobalController',
        'QLDT.common.Constant',
        'QLDT.common.Session',
        'QLDT.view.main.Main'
    ],

    controllers: ['GlobalController'],
    /*
    * Hàm chạy đầu tiền khi vào ứng dụng
    */
    launch: function () {
        var me = this;

        //Ext.Ajax.on('beforerequest', function () { Ext.getBody().mask('', 'loading') }, Ext.getBody());
        //Ext.Ajax.on('requestcomplete', Ext.getBody().unmask, Ext.getBody());
        //Ext.Ajax.on('requestexception', Ext.getBody().unmask, Ext.getBody());
        Ext.Ajax.on('requestexception', function (connection, response, options) {
            if (response) {
                if (response.status == 401) {
                    window.location.href = "Account/Logout";
                }
            }
        });

        Ext.create({
            xtype: 'app-main',
            listeners: {
                afterrender: 'afterrender',
                scope: me,
            }
        });
    },

    /*
    * Sau khi rneder xong thì đóng splas lại
    * Create by: dvthang:13.01.2018
    */
    afterrender: function (sender) {
        var me = this;
        var screen = Ext.get('loading-parent');
        if (screen) {
            screen.destroy();
        }
        QLDT.common.Session.menusVertical = sender.getViewModel().titleMenus;
    }
});
