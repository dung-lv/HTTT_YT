var myResetPassword = (function () {
    var me = {};

    me.init = function () {
        debugger;
        var location = window.location.href;
        if (location && location.indexOf("?token=") > -1) {
            var token = me.getParameterByName("token", location);
            var uri = QLDT.Config.apiBE + '/Forgot/CheckToken?token=' + token;
            $.ajax({
                type: 'POST',
                url: uri,
                dataType: 'json',
                success: function (rep) {
                    if (!rep.Success) {
                        $(".body-sendlink").show();
                        $(".msg").html(rep.ErrorMessage);
                    } else {
                        $(".body-sendlink").hide();
                        $(".body-reset").show();
                    }
                },
                failure: function (e) {
                    $(".msg").html("Xảy ra lỗi.");
                }
            });
            //return;
        }

        $("#txtPassword").focus();

        $(document).on("click", "#btnSetNewPassword", function (e) {
            debugger;
            e.preventDefault();
            me.resetPassword();
        });
    },

    me.getParameterByName = function (name, url) {
        if (!url) url = window.location.href;
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    }

    /*
    * Hàm thực hiện lấy lại mật khẩu
    * Create by: dvthang:22.02.2018
    */
    me.resetPassword = function () {
        debugger;
        var Password = $("#txtPassword").val(),
            confirmPassword = $("#txtConfirmPassword").val();

        if (typeof Password == undefined || Password == null ) {
            $("#lblerror").html("Mật khẩu không được bỏ trống");
            $("#txtPassword").focus();
        }
        else if (typeof confirmPassword == undefined || confirmPassword == null) {
            $("#lblerror").html("Mật khẩu xác nhận không được bỏ trống");
            $("#txtConfirmPassword").focus();
        }
        else if (Password.length < 6) {
            $("#lblerror").html("Mật khẩu phải trên 6 ký tự");
            $("#txtPassword").focus();
        }
        else if (Password!=confirmPassword) {
            $("#lblerror").html("Mật khẩu xác nhận không khớp");
            $("#txtConfirmPassword").focus();
        }
        else {
            var token = me.getParameterByName("token", location);
            $("#lblerror").html("");
            $("#maskLogin").css({ "display": "block" });
            var uri = QLDT.Config.apiBE + '/Forgot/SetNewPassword?token=' + token + "&Password=" + Password;
            $.ajax({
                type: 'POST',
                url: uri,
                dataType: 'json',
                success: function (rep) {
                    if (rep.Success) {
                        $(".body-reset").hide();
                        $(".footer-success").show();
                        $(".msg").html("Cập nhật mật khẩu thành công.");
                    } else {
                        $("#lblerror").html(rep.ErrorMessage);
                    }
                    $("#maskLogin").css({ "display": "none" });
                },
                failure: function (e) {
                    $("#maskLogin").css({ "display": "none" });
                }
            });
        }
    }
    return me;
}());