/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.ho_so_kham_benh.ho_so_kham_benhDetailController', {
    extend: 'QLDT.view.base.BasePopupDetailController',

    requires: ['QLDT.view.base.BasePopupDetailController'],

    alias: 'controller.ho_so_kham_benhDetail',

    apiController: 'MedicalRecord',

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

    getDictionaryStores: function () {
        return ['MeasurementStandardStore', 'Customer'];
    },

    initData: function (record) {
        var me = this, newDate = new Date();
        if (me.editMode !== QLDT.common.Enumaration.EditMode.Edit) {
            record.set("MedicalRecordID", '');
        }
    }
});
