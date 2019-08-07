/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.ql_nguoi_dung.ql_nguoi_dung', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-ql_nguoi_dung',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.ql_nguoi_dung.ql_nguoi_dungController',
        'QLDT.view.ql_nguoi_dung.ql_nguoi_dungModel',
    ],
    
    controller: 'ql_nguoi_dung',
    viewModel: 'ql_nguoi_dung',

    filterable: true,
    showPaging: true,
    /*
    * Trả về nội dung của form
    */
    getColumns: function () {
        var me = this,
            store = me.getViewModel().getStore('master');
        return [
            { text: 'Id', dataIndex: 'Id', width: 80, xtype: 'MTColumn', align: 'center' },
            { text: 'Email', dataIndex: 'Email', width: 120, xtype: 'MTColumn' },
            { text: 'Điện thoại', dataIndex: 'PhoneNumber', width: 120, xtype: 'MTColumn' },
            { text: 'Tên đăng nhập', dataIndex: 'UserName', width: 120, xtype: 'MTColumn' },
            { text: 'Thuộc nhóm', dataIndex: 'GroupID', width: 120, xtype: 'MTColumn' },
            { text: 'UserID', dataIndex: 'UserID', width: 120, xtype: 'MTColumn' },
            { text: 'Thuộc người dùng', dataIndex: 'FullName',flex: 1, width: 150, xtype: 'MTColumn' },
            { text: 'Địa chỉ', dataIndex: 'Address', width: 180 , xtype: 'MTColumn' }
        ];
    },
    /*
    * Khai báo store load dữ liệu cho grid
    */
    getStoreMaster: function () {
        var me = this,
            store = me.getViewModel().getStore('masterStore');
        return store;
    }
});
