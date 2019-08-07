/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.nguoi_dung.nguoi_dungController', {
    extend: 'QLDT.view.base.BaseListController',

    requires: ['QLDT.view.base.BaseListController'],

    alias: 'controller.nguoi_dung',

    apiController: 'Customer',

    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
    },
    toolbar_OnClick: function (sender) {
        var me = this;
        switch (sender.itemId) {
            case 'mnAdd':
                me.addNew(sender);
                break;
            case 'mnEdit':
                me.editData(sender);
                break;
            case 'mnDelete':
                me.deleteData(sender);
                break;
            case 'mnRefresh':
                me.refreshData(sender);
                break;
        }
    },

    getPageDetail: function () {
        return 'QLDT.view.nguoi_dung.nguoi_dungDetail';
    }
});
