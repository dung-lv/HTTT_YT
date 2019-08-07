/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.changepassword.ChangePasswordController', {
    extend: 'Ext.app.ViewController',

    requires: ['Ext.app.ViewController'],

    alias: 'controller.changepassword',

    elementMask: null,
    /*
    * Hàm khởi tạo của controller
    * Create by: dvthang:05.01.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            '#': {
                afterrender: 'afterrender',
                scope: me
            },
            "#btnCancel": {
                click: 'btnCancelOnClick',
                scope: me
            },
            "#btnAccept": {
                click: 'btnAcceptOnClick',
                scope: me
            },

        });
    },

    /*
    * Thực hiện show form thay đổi mật khẩu
    * Create by: dvthang:22.02.2018
    */
    show:function(){
        var me = this, view = me.getView();
        if (view) {
            view.show();
            var passwordOld = Ext.ComponentQuery.query("#passwordOld", view)[0];
            if (passwordOld) {
                passwordOld.focus();
            }
        }
    },

    /*
    * Event xảy ra sau khi render form xong
    * Create by: dvthang:21.02.2018
    */
    afterrender: function () {

    },

    /*
    * Sự kiện đóng form
    * Create by: dvthang:21.02.2018
    */
    btnCancelOnClick: function (sender) {
        var me = this, view = me.getView();
        if (view) {
            view.close();
        }
    },

    /*
    * Sự kiện đồng ý form
    * Create by: dvthang:21.02.2018
    */
    btnAcceptOnClick: function (sender) {
        var me = this, view = me.getView();
        if (view) {
            var form = view.down('form');
            if (form && form.isValid()) {
                var data = me.getViewModel().data, isValid = true;
                if (data && data.NewPassword !== data.ConfirmPassword) {
                    isValid = false;
                    QLDT.utility.Utility.showWarning("Mật khẩu và mật khẩu xác nhận phải giống nhau.");
                }
                if (isValid) {
                    me.showMask();
                    var uri = QLDT.utility.Utility.createUriAPI("Account/ChangePassword");

                    QLDT.utility.MTAjax.request(uri, "POST", {}, data, function (respone) {
                        if (respone.Success) {
                            QLDT.utility.Utility.showInfo("Đổi mật khẩu thành công.");
                        } else {
                            QLDT.utility.Utility.showWarning("Đổi mật khẩu thất bại.");
                        }
                        me.hideMask();
                    }, function (error) {
                        me.hideMask();
                        QLDT.utility.Utility.showWarning("Đổi mật khẩu thất bại.");
                    });
                }
            }

        }
    },

    /*
   * Hiển thị mask khi show form
   * Create by: dvthang:16.01.2018
   */
    showMask: function () {
        var me = this,
            view = me.getView();
        if (!me.elementMask) {
            var el = view.getEl();
            me.elementMask = el;
        }
        me.elementMask.mask(QLDT.GlobalResource.Loading);
    },

    /*
    * Hiển thị mask khi show form
    * Create by: dvthang:16.01.2018
    */
    hideMask: function () {
        var me = this,
            view = me.getView();
        if (!me.elementMask) {
            var el = view.getEl();
            me.elementMask = el;
        }
        me.elementMask.unmask();
    },


});
