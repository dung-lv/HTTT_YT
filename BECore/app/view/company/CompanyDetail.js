/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.company.CompanyDetail', {
    extend: 'QLDT.view.base.BasePopupDetail',
    xtype: 'app-companydetail',
    requires: [
        'QLDT.view.base.BasePopupDetail',
        'QLDT.view.company.CompanyDetailController',
        'QLDT.view.company.CompanyDetailModel',
        'QLDT.view.control.MTCheckbox',
    ],

    controller: 'CompanyDetail',
    viewModel: 'CompanyDetail',

    height: 400,
    width: 800,

    /*
    * Vẽ nội dung của form
    * Create by: dvthang:09.01.2018
    */
    getContent: function () {
        return {
            xtype: 'MTPanel',
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch',
            },
            bodyPadding: 8,

            items: [
                {
                    xtype: 'fieldcontainer',
                    layout: {
                        type: 'hbox',
                        align: 'stretch',
                    },
                    items: [
                        {
                            fieldLabel: 'Kí hiệu',
                            name: 'CompanyCode',
                            flex: 1,
                            xtype: 'MTTextField',
                            allowBlank: false,
                            maxLength: 25,
                            bind: '{masterData.CompanyCode}',
                        },
                        {
                            fieldLabel: 'Tên đơn vị',
                            name: 'CompanyName',
                            flex: 1,
                            margin: '0 0 0 8',
                            xtype: 'MTTextField',
                            allowBlank: false,
                            maxLength: 255,
                            bind: '{masterData.CompanyName}',
                        },
                    ]
                },
                {
                    xtype: 'fieldcontainer',
                    layout: {
                        type: 'hbox',
                        align: 'stretch',
                    },
                    items: [
                        {
                            fieldLabel: 'Điện thoại',
                            name: 'Tel',
                            xtype: 'MTTextField',
                            flex: 1,
                            allowBlank: false,
                            maxLength: 255,
                            bind: '{masterData.Tel}',
                        },
                        {
                            fieldLabel: 'Fax',
                            flex: 1,
                            name: 'Fax',
                            margin: '0 0 0 8',
                            xtype: 'MTTextField',
                            maxLength: 255,
                            bind: '{masterData.Fax}',
                        },
                    ]
                },
                {
                    xtype: 'fieldcontainer',
                    layout: {
                        type: 'hbox',
                        align: 'stretch',
                    },
                    items: [
                        {
                            fieldLabel: 'Email',
                            name: 'Email',
                            flex: 1,
                            xtype: 'MTTextField',
                            maxLength: 255,
                            bind: '{masterData.Email}',
                        },
                       {
                           fieldLabel: 'Địa chỉ',
                           name: 'Address',
                           flex: 1,
                           margin: '0 0 0 8',
                           xtype: 'MTTextField',
                           allowBlank: false,
                           maxLength: 255,
                           bind: '{masterData.Address}',
                       },
                    ]
                },
                   {
                       xtype: 'fieldcontainer',
                       layout: {
                           type: 'hbox',
                           align: 'stretch',
                       },
                       items: [
                           {
                               fieldLabel: 'Website',
                               name: 'Website',
                               flex: 1,
                               xtype: 'MTTextField',
                               maxLength: 255,
                               bind: '{masterData.Website}',
                           },
                           {
                               fieldLabel: 'Thủ trưởng',
                               name: 'Director',
                               flex: 1,
                               margin: '0 0 0 8',
                               xtype: 'MTTextField',
                               allowBlank: false,
                               maxLength: 255,
                               bind: '{masterData.Director}',
                           },
                       ]
                   },
                   {
                       xtype: 'fieldcontainer',
                       layout: {
                           type: 'hbox',
                           align: 'stretch',
                       },
                       items: [
                       {
                           fieldLabel: 'Số tài khoản',
                           name: 'AccountNumber',
                           flex: 1,
                           xtype: 'MTTextField',
                           maxLength: 255,
                           bind: '{masterData.AccountNumber}',
                       },
                       {
                           fieldLabel: 'Tên ngân hàng',
                           name: 'BankName',
                           flex: 1,
                           xtype: 'MTTextField',
                           margin: '0 0 0 8',
                           maxLength: 255,
                           bind: '{masterData.BankName}',
                       }
                       ]
                   },
                   {
                       xtype: 'fieldcontainer',
                       layout: {
                           type: 'hbox',
                           align: 'stretch',
                       },
                       items: [
                           {
                               fieldLabel: 'Diễn giải',
                               name: 'Description',
                               flex: 1,
                               xtype: 'MTTextField',
                               maxLength: 255,
                               bind: '{masterData.Description}',
                           },
                           {
                               
                           }
                       ]
                   },
                   {
                       xtype: 'fieldcontainer',
                       layout: {
                           type: 'hbox',
                           align: 'stretch',
                       },
                       items: [{
                           boxLabel: 'Ngừng theo dõi',
                           name: 'Inactive',
                           xtype: 'MTCheckbox',
                           bind: '{masterData.Inactive}',
                           itemId: 'fieldInactive',
                       },
                       {
                           boxLabel: 'Owned',
                           name: 'Owned',
                           xtype: 'MTCheckbox',
                           bind: '{masterData.Owned}',
                       },
                       ]
                   }
            ]
        };
    }
});