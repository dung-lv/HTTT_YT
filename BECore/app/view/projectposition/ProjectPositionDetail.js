/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.projectposition.ProjectPositionDetail', {
    extend: 'QLDT.view.base.BasePopupDetail',
    xtype: 'app-projectpositiondetail',
    requires: [
        'QLDT.view.base.BasePopupDetail',
        'QLDT.view.projectposition.ProjectPositionDetailController',
        'QLDT.view.projectposition.ProjectPositionDetailModel',
        'QLDT.view.control.MTCheckbox',
    ],

    controller: 'ProjectPositionDetail',
    viewModel: 'ProjectPositionDetail',

    height: 300,
    width: 600,
    /*
    * Vẽ nội dung của form
    * Create by: dvthang:09.01.2018
    */
    getContent: function () {
        return {
            xtype: 'MTPanel',
            region: 'center',
            items: [{
                layout: {
                    type: 'vbox',
                    align: 'stretch'
                },
                defaults: {
                    labelWidth: 160,
                },
                items: [
                    {
                        fieldLabel: 'Kí hiệu',
                        name: 'ProjectPositionCode',
                        allowBlank: false,
                        flex: 1,
                        maxLength: 255,
                        xtype: 'MTTextField',
                        bind: '{masterData.ProjectPositionCode}'
                    },
                    {
                        fieldLabel: 'Tên vai trò',
                        name: 'ProjectPositionName',
                        flex: 1,
                        xtype: 'MTTextField',
                        allowBlank: false,
                        maxLength: 255,
                        bind: '{masterData.ProjectPositionName}'
                    },
                    {
                        fieldLabel: 'Hệ số tham gia dự án',
                        name: 'Coefficient',
                        flex: 1,
                        bind: '{masterData.Coefficient}',
                        allowBlank: false,
                        min: 0,
                        max:1,
                        xtype: 'MTNumberField'
                    },
                    {
                        fieldLabel: 'Diễn giải',
                        name: 'Description',
                        maxLength: 255,
                        flex: 1,
                        bind: '{masterData.Description}',
                        xtype: 'MTTextField'
                    },
                    {
                        boxLabel: 'Ngừng theo dõi',
                        name: 'Inactive',
                        itemId: 'fieldInactive',
                        bind: '{masterData.Inactive}',
                        xtype: 'MTCheckbox'
                    }]
            }]
        };
    },
});
