/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.customer.CustomerController', {
    extend: 'QLDT.view.base.BaseListController',

    requires: ['QLDT.view.base.BaseListController'],

    alias: 'controller.customer',
    /*
    * Hàm khởi tạo của controller
    * Create by: dvthang:05.01.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            '#': {
                afterrender: 'afterrender',
                scope: me
            },
        });
    },

    afterrender: function () {

    },

});
