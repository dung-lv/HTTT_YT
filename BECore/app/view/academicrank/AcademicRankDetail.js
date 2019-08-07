/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.academicrank.AcademicRankDetail', {
    extend: 'QLDT.view.base.BasePopupDetail',
    xtype: 'app-academicrankdetail',
    requires: [
        'QLDT.view.base.BasePopupDetail',
        'QLDT.view.academicrank.AcademicRankDetailController',
        'QLDT.view.academicrank.AcademicRankDetailModel',
        'QLDT.view.control.MTCheckbox',
    ],

    controller: 'AcademicRankDetail',
    viewModel: 'AcademicRankDetail',

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
                        name: 'AcademicRankCode',
                        xtype: 'MTTextField',
                        allowBlank: false,
                        maxLength: 25,
                        bind: '{masterData.AcademicRankCode}'
                    },

                    {
                        fieldLabel: 'Tên Học hàm',
                        name: 'AcademicRankName',
                        xtype: 'MTTextField',
                        allowBlank: false,
                        maxLength: 255,
                        bind: '{masterData.AcademicRankName}'
                    },
                    {
                        fieldLabel: 'Diễn giải',
                        name: 'Description',
                        xtype: 'MTTextField',
                        maxLength: 255,
                        bind: '{masterData.Description}'
                    },
                    {
                        boxLabel: 'Ngừng theo dõi',
                        name: 'Inactive',
                        itemId: 'fieldInactive',
                        xtype: 'MTCheckbox',
                        bind: '{masterData.Inactive}'
                    },
                ]
            },

            ]

        };
    },
});
