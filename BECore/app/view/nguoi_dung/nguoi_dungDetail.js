/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.nguoi_dung.nguoi_dungDetail', {
    extend: 'QLDT.view.base.BasePopupDetail',
    xtype: 'app-nguoi_dungdetail',
    requires: [
        'QLDT.view.base.BasePopupDetail',
        'QLDT.view.nguoi_dung.nguoi_dungDetailController',
        'QLDT.view.nguoi_dung.nguoi_dungDetailModel',
        'QLDT.view.control.MTCheckbox',
    ],

    controller: 'nguoi_dungDetail',
    viewModel: 'nguoi_dungDetail',

    height: 650,
    width: 700,
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
                        fieldLabel: 'CustomerID',
                        name: 'CustomerID',
                        xtype: 'MTTextField',
                        allowBlank: true,
                        readOnly: true,
                        margin: '0 8 8 0',
                        maxLength: 1500,
                        bind: '{masterData.CustomerID}'
                    },
                    {
                        fieldLabel: 'Tên bệnh nhân',
                        name: 'CustomerName',
                        xtype: 'MTTextField',
                        allowBlank: false,
                        margin: '0 8 8 0',
                        maxLength: 1500,
                        bind: '{masterData.CustomerName}'
                    },
                    {
                        xtype: 'fieldcontainer',
                        layout: {
                            type: 'hbox',
                            align: 'stretch'
                        },
                        margin: '0 8 10 0',
                        items: [{
                            fieldLabel: 'Giới tính',
                            name: 'CustomerGender',
                            xtype: 'MTComboBox',
                            allowBlank: false,
                            margin: '0 8 0 0',
                            maxLength: 1500,
                            displayField: 'text',
                            valueField: 'value',
                            bind: {
                                value: '{masterData.CustomerGender}',
                                store: '{Gender}'
                            }
                        },
                        {
                            fieldLabel: 'Ngày sinh',
                            name: 'DOB',
                            xtype: 'MTDateField',
                            allowBlank: false,
                            margin: '0 8 0 0',
                            maxLength: 1500,
                            bind: '{masterData.DOB}'
                        }
                        ]
                    },
                    {
                        xtype: 'fieldcontainer',
                        layout: {
                            type: 'hbox',
                            align: 'stretch'
                        },
                        margin: '0 8 10 0',
                        items: [{
                            fieldLabel: 'Số BHYT',
                            name: 'HealthCareNumber',
                            xtype: 'MTTextField',
                            allowBlank: false,
                            margin: '0 8 0 0',
                            maxLength: 1500,
                            bind: '{masterData.HealthCareNumber}'
                        },
                        {
                            fieldLabel: 'SĐT',
                            name: 'Tel',
                            xtype: 'MTTextField',
                            allowBlank: false,
                            margin: '0 8 0 0',
                            maxLength: 1500,
                            bind: '{masterData.Tel}'
                        }
                        ]
                    },
                    {
                        fieldLabel: 'Email',
                        name: 'Email',
                        xtype: 'MTTextField',
                        allowBlank: false,
                        margin: '0 8 8 0',
                        maxLength: 1500,
                        bind: '{masterData.Email}'
                    },
                    {
                        fieldLabel: 'Địa chỉ',
                        name: 'Address',
                        xtype: 'MTTextField',
                        allowBlank: false,
                        margin: '0 8 8 0',
                        maxLength: 1500,
                        bind: '{masterData.Address}'
                    },
                    {
                        fieldLabel: 'Nhóm bệnh nhân',
                        name: 'CustomerGroup',
                        xtype: 'MTTextField',
                        allowBlank: false,
                        margin: '0 8 8 0',
                        maxLength: 1500,
                        bind: '{masterData.CustomerGroup}'
                    },
                    {
                        fieldLabel: 'Mô tả bệnh nhân',
                        name: 'CustomerDescription',
                        xtype: 'MTTextField',
                        allowBlank: false,
                        margin: '0 8 8 0',
                        maxLength: 1500,
                        bind: '{masterData.CustomerDescription}'
                    },
                    {
                        fieldLabel: 'Người đại diện',
                        name: 'PresenterName',
                        xtype: 'MTTextField',
                        allowBlank: false,
                        margin: '0 8 8 0',
                        maxLength: 1500,
                        bind: '{masterData.PresenterName}'
                    },
                    {
                        xtype: 'fieldcontainer',
                        layout: {
                            type: 'hbox',
                            align: 'stretch'
                        },
                        margin: '0 8 10 0',
                        items: [{
                            fieldLabel: 'SĐT NĐD',
                            name: 'PresenterPhone',
                            xtype: 'MTTextField',
                            allowBlank: false,
                            margin: '0 8 0 0',
                            maxLength: 1500,
                            bind: '{masterData.PresenterPhone}'
                        },
                        {
                            fieldLabel: 'CMT NĐD',
                            name: 'PresenterIDC',
                            xtype: 'MTTextField',
                            allowBlank: false,
                            margin: '0 8 0 0',
                            maxLength: 1500,
                            bind: '{masterData.PresenterIDC}'
                        }
                        ]
                    },
                    {
                        fieldLabel: 'Địa chỉ NĐD',
                        name: 'PresenterAddress',
                        xtype: 'MTTextField',
                        allowBlank: false,
                        margin: '0 8 8 0',
                        maxLength: 1500,
                        bind: '{masterData.PresenterAddress}'
                    },
                    {
                        fieldLabel: 'Mối q.hệ với bệnh nhân',
                        name: 'Relationship',
                        xtype: 'MTTextField',
                        allowBlank: false,
                        margin: '0 8 8 0',
                        maxLength: 1500,
                        bind: '{masterData.Relationship}'
                    },
                ]
            }
            ]
        };
    },
});
