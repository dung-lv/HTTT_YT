/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.nguoi_dung.nguoi_dungDetailController', {
    extend: 'QLDT.view.base.BasePopupDetailController',

    requires: ['QLDT.view.base.BasePopupDetailController'],

    alias: 'controller.nguoi_dungDetail',

    apiController: 'Customer',

    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            '#': {
                afterrender: 'afterrender',
                scope: me
            }
        });
    },

    afterrender: function () {

    },

    getMasterObjectName: function () {
        return "Chi tiết bệnh nhân";
    },

    initData: function (record) {
        var me = this, newDate = new Date();
        if (me.editMode !== QLDT.common.Enumaration.EditMode.Edit) {
            record.set("CustomerID", '');
        }
    },
});
