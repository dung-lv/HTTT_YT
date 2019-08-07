/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.grantratio.GrantRatioDetail', {
    extend: 'QLDT.view.base.BasePopupDetail',
    xtype: 'app-grantratiodetail',
    requires: [
        'QLDT.view.base.BasePopupDetail',
        'QLDT.view.grantratio.GrantRatioDetailController',
        'QLDT.view.grantratio.GrantRatioDetailModel',
        'QLDT.view.control.MTCheckbox',
    ],

    controller: 'GrantRatioDetail',
    viewModel: 'GrantRatioDetail',

    height: 320,
    width: 500,

    /*
    * Vẽ nội dung của form
    * Create by: dvthang:09.01.2018
    */
    getContent: function () {
        return {
            xtype: 'MTPanel',
            region: 'center',
            layout:{
                type: 'vbox',
                align:'stretch'
            },
            bodyPadding: 8,
            items: [
                //{
                //    fieldLabel: 'Mã',
                //    name: 'GrantRatioID',
                //    bind: '{masterData.GrantRatioID}',
                //    allowBlank: false,
                //    maxLength: 255,
                //    xtype: 'MTTextField'
                //},
                {
                    fieldLabel: 'Tên',
                    name: 'GrantRatioName',
                    bind: '{masterData.GrantRatioName}',
                    allowBlank: false,
                    maxLength: 255,
                    xtype: 'MTTextField'
                },
                {
                    fieldLabel: 'Kí hiệu',
                    name: 'Sign',
                    bind: '{masterData.GrantRatioCode}',
                    maxLength: 255,
                    xtype: 'MTTextField'
                },
                {
                    fieldLabel: 'Diễn giải',
                    name: 'Note',
                    bind: '{masterData.Description}',
                    maxLength: 255,
                    xtype: 'MTTextField'
                },
                {
                    boxLabel: 'Ngừng theo dõi',
                    name: 'Inactive',
                    itemId: 'fieldInactive',
                    bind: '{masterData.Inactive}',
                    xtype: 'MTCheckbox'
                }
            ]
        };
    },
});
