/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.ql_nguoi_dung.ql_nguoi_dungDetail', {
    extend: 'QLDT.view.base.BasePopupDetail',
    xtype: 'app-ql_nguoi_dungdetail',
    requires: [
        'QLDT.view.base.BasePopupDetail',
        'QLDT.view.ql_nguoi_dung.ql_nguoi_dungDetailController',
        'QLDT.view.ql_nguoi_dung.ql_nguoi_dungDetailModel',
        'QLDT.view.control.MTCheckbox',
    ],

    controller: 'ql_nguoi_dungDetail',
    viewModel: 'ql_nguoi_dungDetail',

    height: 480,
    width: 650,
    /*
    * Vẽ nội dung của form
    * Create by: haitq:17.09.2018
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
                        fieldLabel: 'Id',
                        name: 'Id',
                        bind: '{masterData.Id}',
                        readOnly: true,
                        maxLength: 80,
                        labelWidth: 130,
                        maxWidth: 210,
                        xtype: 'MTTextField'
                    },
                    {
                        fieldLabel: 'Email',
                        name: 'Email',
                        bind: '{masterData.Email}',
                        maxLength: 245,
                        labelWidth: 130,
                        xtype: 'MTTextField'
                    },
                    {
                        fieldLabel: 'SĐT',
                        name: 'PhoneNumber',
                        bind: '{masterData.PhoneNumber}',
                        maxLength: 245,
                        labelWidth: 130,
                        xtype: 'MTTextField'
                    },
                    {
                        fieldLabel: 'UserName',
                        name: 'UserName',
                        bind: '{masterData.UserName}',
                        maxLength: 245,
                        labelWidth: 130,
                        xtype: 'MTTextField'
                    },
                    {
                        fieldLabel: 'Nhóm người dùng',
                        name: 'GroupID',
                        xtype: 'MTComboBox',
                        maxLength: 270,
                        labelWidth: 130,
                        allowBlank: false,
                        displayField: 'text',
                        valueField: 'value',
                        bind: {
                            value: '{masterData.GroupID}',
                            store: '{GroupUser}'
                        }
                    },
                    {
                        fieldLabel: 'Người dùng',
                        name: 'UserID',
                        xtype: 'MTComboBox',
                        allowBlank: false,
                        maxLength: 270,
                        labelWidth: 130,
                        displayField: 'CustomerName',
                        valueField: 'CustomerID',
                        bind: {
                            value: '{masterData.UserID}',
                            store: '{customerStore}'
                        }
                    },
                    {
                        fieldLabel: 'Tên đầy đủ',
                        name: 'FullName',
                        bind: '{masterData.FullName}',
                        maxLength: 245,
                        labelWidth: 130,
                        xtype: 'MTTextField'
                    },
                    {
                        fieldLabel: 'Địa chỉ',
                        name: 'Address',
                        bind: '{masterData.Address}',
                        maxLength: 245,
                        labelWidth: 130,
                        xtype: 'MTTextField'
                    },
                    {
                        fieldLabel: 'oId',
                        name: 'oId',
                        bind: '{masterData.oId}',
                        readOnly: true,
                        maxLength: 80,
                        labelWidth: 130,
                        maxWidth: 210,
                        xtype: 'MTTextField'
                    },
                ]
            }
            ]

        };
    },
});
