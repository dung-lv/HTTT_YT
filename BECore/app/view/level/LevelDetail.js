/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.level.LevelDetail', {
    extend: 'QLDT.view.base.BasePopupDetail',
    xtype: 'app-leveldetail',
    requires: [
        'QLDT.view.base.BasePopupDetail',
        'QLDT.view.level.LevelDetailController',
        'QLDT.view.level.LevelDetailModel',
        'QLDT.view.control.MTCheckbox',
    ],

    controller: 'LevelDetail',
    viewModel: 'LevelDetail',
    
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
            bodyPadding: 8,
            items: [{
                columnWidth: 0.5,
                layout: {
                    type: 'vbox',
                    align: 'stretch'
                },
                items: [
                    {
                        fieldLabel: 'Ký hiệu',
                        name: 'LevelCode',
                        xtype: 'MTTextField',
                        maxLength: 255,
                        bind: '{masterData.LevelCode}',
                    },
                    {
                        fieldLabel: 'Tên cấp quản lý',
                        name: 'LevelName',
                        xtype: 'MTTextField',
                        maxLength: 255,
                        bind: '{masterData.LevelName}',
                    },
                    {
                        fieldLabel: 'Diễn giải',
                        name: 'Description',
                        xtype: 'MTTextField',
                        maxLength: 255,
                        bind: '{masterData.Description}',
                    },
                    {
                        boxLabel: 'Ngừng theo dõi',
                        name: 'Inactive',
                        itemId: 'fieldInactive',
                        bind: '{masterData.Inactive}',
                        xtype: 'MTCheckbox'
                    }
                ]
            },
            
            ]
            
        };
    },
});
