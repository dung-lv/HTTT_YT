/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.changepassword.ChangePassword', {
    extend: 'QLDT.view.control.MTWindow',
    xtype: 'app-changepassword',
    requires: [
        'QLDT.view.control.MTWindow',
        'QLDT.view.changepassword.ChangePasswordController',
        'QLDT.view.changepassword.ChangePasswordModel',
    ],

    controller: 'changepassword',
    viewModel: 'changepassword',

    layout: 'fit',

    width: 360,
    bodyPadding: '15 15 15 15',
    height: 240,
    title:'Thay đổi mật khẩu',

    /*
    * Khởi tạo các thành phần của form
    * Create by: dvthang:21.02.2018
    */
    initComponent: function () {
        var me = this, items = [];
       
        Ext.apply(me, {
            items: [{
                xtype: 'MTForm',
                layout: 'fit',               
                items: me.getContent()
            }]
        });
        me.callParent(arguments);
    },

    /*
    * Vẽ các control nhập liệu trên form
    * Create by: dvthang:21.02.2018
    */
    getContent: function () {
        var me = this;
        return [
            {
                xtype: 'fieldcontainer',
                itemId: 'fieldPassword',
                flex: 1,
                padding: '0 0 0 0',
                margin:'0 0 0 0',
                layout: {
                    type: 'vbox',
                    align: 'stretch',
                },
                items: [{
                    xtype: 'MTTextField',
                    itemId: 'passwordOld',
                    fieldLabel: 'Mật khẩu cũ',
                    inputType: 'password',
                    labelWidth: 120,
                    flex: 1,
                    name: 'Password',
                    bind: {
                        value: '{OldPassword}',
                    },
                    allowBlank: false,
                    maxLength: 64,
                    minLength: 6,
                },
                {
                    xtype: 'MTTextField',
                    itemId: 'passwordNew',
                    margin: '0 0 0 0',
                    labelWidth: 120,
                    inputType: 'password',
                    flex: 1,
                    fieldLabel: 'Mật khẩu mới',
                    name: 'NewPassword',
                    bind: {
                        value: '{NewPassword}',
                    },
                    allowBlank: false,
                    maxLength: 64,
                    minLength: 6,
                },
                {
                    xtype: 'MTTextField',
                    itemId: 'passwordConfirm',
                    margin: '8 0 0 0',
                    labelWidth: 120,
                    inputType: 'password',
                    flex: 1,
                    fieldLabel: 'Xác nhận mật khẩu',
                    name: 'ConfirmPassword',
                    bind: {
                        value: '{ConfirmPassword}',
                    },
                    allowBlank: false,
                    maxLength: 64,
                    minLength: 6,
                }]
            },
        ];
    },

    buttons: [
            {
                text: 'Đồng ý',
                appendCls: 'btn-save',
                iconCls: 'button-accept fa fa-check',
                itemId: 'btnAccept',
                xtype: 'MTButton',
            }, {
                text: 'Hủy bỏ',
                appendCls: 'btn-cancel',
                iconCls: 'button-cancel fa fa-undo',
                xtype: 'MTButton',
                itemId: 'btnCancel',
            }
    ]
});
