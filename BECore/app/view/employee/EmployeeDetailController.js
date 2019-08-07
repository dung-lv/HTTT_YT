/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.employee.EmployeeDetailController', {
    extend: 'QLDT.view.base.BasePopupDetailController',

    requires: ['QLDT.view.base.BasePopupDetailController'],

    alias: 'controller.EmployeeDetail',

    apiController: 'Employees',

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
            "#checkPassword": {
                change: 'checkPassword',
                scope: me
            },
            "#lastNameId": {
                change: 'lastNameChange',
                scope: me
            },
            "#firstNameId": {
                change: 'firstNameChange',
                scope: me
            },
        });
    },

    /*
    * Sau khi load view xong thì hàm này đc chạy
    * Create by: dvthang:15.01.2018
    */
    afterrender: function () {

    },

    /*
    * Tên form
    * Create by: manh:17.01.2018
    */
    getMasterObjectName: function () {
        return "Nhân viên";
    },

    /*
     * Trả về danh sách store load dữ liệu combo dạng danh mục
     * Create by: dvthang:09.01.2018
     */
    getDictionaryStores: function () {
        return ['academicRankStore', 'degreeStore', 'companyStore', 'positionStore', 'rankStore'];
    },

    /*
   * Hàm thực hiện khởi tạo các giá trị nhập trên from
   * Create by: manh:30.05.18
   */
    initData: function (record) {
        var me = this, newDate = new Date();
        if (me.editMode != QLDT.common.Enumaration.EditMode.Edit) {
            record.set("Password", 123456);
            record.set("ConfirmPassword", 123456);
            record.set("DateBy", newDate);
        }
    },


    /*
     * Kiểm tra password trùng confirm password thì mới cho lưu
     * Create by: dvthang:09.01.2018
     * Nếu là sửa thì không kiểm tra password trùng confirm password
     * Modify by: manh:29.05.18
     */
    validateBeforeSaveCustom: function () {
        var me = this;
        if (me.editMode === QLDT.common.Enumaration.EditMode.Edit) {
            return true;
        }
        else if (me.masterData.get("Password") != me.masterData.get("ConfirmPassword")) {
            QLDT.utility.Utility.showWarning('Mật khẩu không trùng nhau');
            return false;
        }
        return true;
    },

    /*
     * Nối Tên đầy đủ = tên đầu + tên cuối
     * Create by: manh:28.01.2018
     */
    preSaveData: function () {
        var me = this;
        if (me.editMode === QLDT.common.Enumaration.EditMode.Edit) {
            var firstName = me.masterData.get("FirstName"),
                lastName = me.masterData.get("LastName");
        } else {
            var firstName = me.toTitleCase(me.masterData.get("FirstName")),
                lastName = me.toTitleCase(me.masterData.get("LastName"));
        }

        fullName = Ext.String.format("{0} {1}", lastName, firstName);
        me.masterData.set("FirstName", firstName);
        me.masterData.set("LastName", lastName);
        me.masterData.set("FullName", fullName);
    },

    /*
    * Thực hiện sinh mã nhân viên = họ + đệm
    * Sửa thì không chuyển
    * Create by: manh:30.05.2018
    */
    lastNameChange: function (sender, newValue, oldValue, eOpts) {
        var me = this,
            lastNameId = Ext.ComponentQuery.query("#lastNameId", me.getView())[0],
            firstNameId = Ext.ComponentQuery.query("#firstNameId", me.getView())[0],
            employeeCodeId = Ext.ComponentQuery.query("#employeeCodeId", me.getView())[0],
            lastName = me.changeEmployeeCode(lastNameId.getValue());
        if (me.editMode != QLDT.common.Enumaration.EditMode.Edit) {
            if (lastNameId) {
                if (employeeCodeId) {
                    employeeCodeId.setValue(lastName);
                }
            }
        }

    },

    /*
    * Thực hiện sinh mã nhân viên = tên + (họ + đệm) đã có ở trên
    * Sửa thì không chuyển
    * Create by: manh:30.05.2018
    */
    firstNameChange: function (sender, newValue, oldValue, eOpts) {
        var me = this,
            lastNameId = Ext.ComponentQuery.query("#lastNameId", me.getView())[0],
            firstNameId = Ext.ComponentQuery.query("#firstNameId", me.getView())[0],
            employeeCodeId = Ext.ComponentQuery.query("#employeeCodeId", me.getView())[0],
            lastName = me.changeEmployeeCode(lastNameId.getValue()),
            firstName = me.changeEmployeeCode(firstNameId.getValue());
        if (me.editMode != QLDT.common.Enumaration.EditMode.Edit) {
            if (firstNameId) {
                if (employeeCodeId) {
                    employeeCodeId.setValue(firstName + '' + lastName);
                }
            }
        }
    },

    /*
     * Chọn thay đổi mật khẩu thì hiện ô mật khẩu và xác nhận mật khẩu
     * Create by: manh:28.01.2018
     */
    checkPassword: function (sender, newValue, oldValue, eOpts) {
        var me = this,
            txt = Ext.ComponentQuery.query("#checkPassword", me.getView()),
            hiddenField = Ext.ComponentQuery.query("#fieldPassword", me.getView())[0];
        if (newValue) {
            if (txt) {
                hiddenField.show();
            }
        }
        else {
            hiddenField.hide();
        }
    },

    /*
     * Chọn thêm mới thì ẩn checkbox
     * Chọn sửa thì hiện checkbox, ẩn và cho phép trống mật khẩu và xác nhận mật khẩu
     * Create by: manh:04.02.2018
     */
    processLayout: function () {
        var me = this,
            fieldCheckPassword = Ext.ComponentQuery.query("#fieldCheckPassword", this.getView())[0],
            hiddenField = Ext.ComponentQuery.query("#fieldPassword", me.getView())[0],
            passwordAllow = Ext.ComponentQuery.query("#passwordAllow", me.getView())[0],
            confirmPasswordAllow = Ext.ComponentQuery.query("#confirmPasswordAllow", me.getView())[0],
            employeeCodeId = Ext.ComponentQuery.query("#employeeCodeId", me.getView())[0];

        if (fieldCheckPassword) {
            if (hiddenField) {
                if (passwordAllow && confirmPasswordAllow) {
                    switch (me.editMode) {
                        case QLDT.common.Enumaration.EditMode.Add:
                        case QLDT.common.Enumaration.EditMode.Duplicate:
                            fieldCheckPassword.hide();
                            break;
                        default:
                            fieldCheckPassword.show();
                            hiddenField.hide();
                            passwordAllow.allowBlank = true;
                            confirmPasswordAllow.allowBlank = true;
                            employeeCodeId.disable();
                            break;
                    }
                }
            }
        }
    },

    /*
    * THực hiện chuyển ký tự có dấu --> không dấu, loại bỏ khoảng trắng
    * Create by: manh:29.05.18
    */
    changeEmployeeCode: function (str) {
        var me = this;
        str = str.toLowerCase();
        str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
        str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
        str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
        str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
        str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
        str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
        str = str.replace(/đ/g, "d");
        str = str.replace(/!|@|%|\^|\*|\(|\)|\+|\=|\<|\>|\?|\/|,|\.|\:|\;|\'|\"|\&|\#|\[|\]|~|\$|_|`|-|{|}|\||\\/g, " ");
        str = str.replace(/[^0-9a-zàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ\s]/gi, '');
        str = str.replace(/ + /g, " ");
        str = str.replace(/\s/g, "");
        str = str.trim();
        return str;
    },

    /*
    * THực hiện chuyển ký tự đầu tiên trong mỗi từ thành chữ hoa, ký tự tiếp theo chữ thường
    * Create by: manh:29.05.18
    */
    toTitleCase: function (str) {
        return str.toLowerCase().split(' ').map(function (word) {
            return word.replace(word[0], word[0].toUpperCase());
        }).join(' ');
    }
});