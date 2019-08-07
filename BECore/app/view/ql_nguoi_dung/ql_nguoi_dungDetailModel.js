/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.ql_nguoi_dung.ql_nguoi_dungDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ql_nguoi_dungDetail',

    requires: [
        'QLDT.model.AspNetUsers'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.AspNetUsers'
        },
        customerStore: {
            xtype: 'mtstore',
            model: 'QLDT.model.Customer',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Customer/GetAll')
                },
                reader: { type: 'json' }
            }
        },
        GroupUser: {
            fields: [
                { name: 'text', type: 'string' },
                { name: 'value', type: 'int' },
            ],
            data: [
                { text: 'Thường', value: 1 },
                { text: 'Quản trị', value: -1 },
            ]
        }
    }
});
