/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.ho_so_kham_benh.ho_so_kham_benhController', {
    extend: 'QLDT.view.base.BaseListController',

    requires: ['QLDT.view.base.BaseListController'],

    alias: 'controller.ho_so_kham_benh',

    apiController: 'MedicalRecord',

    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        //me.control({
        //    '#': {
        //        afterrender: 'afterrender',
        //        scope: me
        //    },
        //});
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
        return 'QLDT.view.ho_so_kham_benh.ho_so_kham_benhDetail';
    }
});
