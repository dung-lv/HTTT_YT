/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.grantratio.GrantRatioController', {
    extend: 'QLDT.view.base.BaseListController',

    requires: [
        'QLDT.view.base.BaseListController',
    ],

    alias: 'controller.GrantRatio',

    apiController:'GrantRatios',
    /*
   * Trả về tên của form detail
   * Create by: dvthang:09.01.2018
   */
    getPageDetail: function () {
        return 'QLDT.view.grantratio.GrantRatioDetail';
    }
  
});
