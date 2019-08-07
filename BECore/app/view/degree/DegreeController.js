/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.degree.DegreeController', {
    extend: 'QLDT.view.base.BaseListController',

    requires:['QLDT.view.base.BaseListController'],

    alias: 'controller.Degree',

    apiController: 'Degrees',

    /*
    * Hàm khởi tạo của controller
    * Create by: dvthang:05.01.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
    },

    /*
   * Trả về tên của form detail
   * Create by: dvthang:09.01.2018
   */
    getPageDetail: function () {
        return 'QLDT.view.degree.DegreeDetail';
    }
  
});
