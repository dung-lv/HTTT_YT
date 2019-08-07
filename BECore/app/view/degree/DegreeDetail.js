/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.degree.DegreeDetail', {
    extend: 'QLDT.view.base.BasePopupDetail',
    xtype: 'app-degreedetail',
    requires: [
        'QLDT.view.base.BasePopupDetail',
        'QLDT.view.degree.DegreeDetailController',
        'QLDT.view.degree.DegreeDetailModel',
        'QLDT.view.control.MTCheckbox',
    ],

    controller: 'DegreeDetail',
    viewModel: 'DegreeDetail',

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
                        fieldLabel: 'Kí hiệu',
                        name: 'DegreeCode',
                        bind: '{masterData.DegreeCode}',
                        allowBlank: false,
                        maxLength: 25,
                        xtype: 'MTTextField'
                    },
                    {
                        fieldLabel: 'Tên học vị',
                        name: 'DegreeName',
                        xtype: 'MTTextField',
                        allowBlank: false,
                        maxLength: 255,
                        bind: '{masterData.DegreeName}'
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
                        xtype: 'MTCheckbox',
                        itemId: 'fieldInactive',
                        bind: '{masterData.Inactive}',
                    }
                ]
            },

            ]

        };
    },
});
