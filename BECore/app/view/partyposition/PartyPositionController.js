/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.partyposition.PartyPositionController', {
    extend: 'QLDT.view.base.BaseListController',

    requires: [
        'QLDT.view.base.BaseListController',
    ],

    alias: 'controller.PartyPosition',

    apiController: 'PartyPosition',
    /*
   * Trả về tên của form detail
   * Create by: cuonglp:09.01.2018
   */
    getPageDetail: function () {
        return 'QLDT.view.partyposition.PartyPositionDetail';
    }
  
});
