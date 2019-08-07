/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.rank.RankDetail', {
    extend: 'QLDT.view.base.BasePopupDetail',
    xtype: 'app-rankdetail',
    requires: [
        'QLDT.view.base.BasePopupDetail',
        'QLDT.view.rank.RankDetailController',
        'QLDT.view.rank.RankDetailModel',
        'QLDT.view.control.MTCheckbox',
    ],

    controller: 'RankDetail',
    viewModel: 'RankDetail',

    height: 270,
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
                {
                    fieldLabel: 'Mã chức vụ',
                    name: 'RankCode',
                    bind: '{masterData.RankCode}',
                    allowBlank: false,
                    maxLength:25,
                    xtype: 'MTTextField'
                },
                {
                    fieldLabel: 'Tên chức vụ',
                    name: 'RankName',
                    bind: '{masterData.RankName}',
                    allowBlank: false,
                    maxLength: 255,
                    xtype: 'MTTextField'
                },
                {
                    fieldLabel: 'Diễn giải',
                    name: 'Description',
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
