/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.customer.Customer', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-customer',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.customer.CustomerController',
        'QLDT.view.customer.CustomerModel',
    ],

    controller: 'customer',
    viewModel: 'customer',
    /*
    * Trả về nội dung của form
    * Create by: dvthang:06.01.2017
    */
    getColumns: function () {
        var me = this,
            store = me.getViewModel().getStore('master');
        return [
            { text: 'Name', dataIndex: 'name', minWidth: 200, flex: 1 },
            { text: 'Email', dataIndex: 'email', width: 250 },
            { text: 'Phone', dataIndex: 'phone', width: 120 }
        ];
    },

    /*
    * Khai báo store load dữ liệu cho grid
    * Create by: dvthang:07.01.2018
    */
    getStoreMaster: function () {
        var me = this,
            store = me.getViewModel().getStore('master');
        return store;
    }

});
