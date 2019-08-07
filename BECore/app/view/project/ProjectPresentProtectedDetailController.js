/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.project.ProjectPresentProtectedDetailController', {
    extend: 'QLDT.view.base.BasePopupDetailController',

    requires: ['QLDT.view.base.BasePopupDetailController'],

    alias: 'controller.ProjectPresentProtectedDetail',
    /*
    * Hàm khởi tạo của controller
    * Create by: laipv:14.01.2018
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
    /*
   * Hàm thực hiện khởi tạo các giá trị nhập trên from
   * Create by: dvthang:15.01.2018
   */
    initData: function (record) {
        var me = this, view = me.getView();
        // Create by: truongnm:04.03.2018 - phải đặt ở đây mới đổi đc sự kiện change
        if (me.editMode != QLDT.common.Enumaration.EditMode.Edit) {
            var newDate = new Date();
            record.set("DecisionDate", newDate);
            record.set("ProtectedDate", newDate);
        }
    },
    afterrender: function () {

    },
  
});
