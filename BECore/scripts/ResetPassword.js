var myResetPassword = (function () {
    var me = {};

    me.init = function () {
        var location = window.location.href;

        $("#txtUserName").focus();

        $(document).on("click", "#btnRefresh", function (e) {
            e.preventDefault();
            me.generateCapcha();
        });
        
        $(document).on("click", "#btnGetPassword", function (e) {
            e.preventDefault();
            me.resetPassword();
        });
        
        me.generateCapcha();
    },

    me.getParameterByName=function(name, url) {
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
    me.resetPassword=function(){
        var userName = $("#txtUserName").val(),
            capcha = $("#txtCapcha").val(),
            emailConfirm = $("#txtEmail").val();

        if (typeof userName == undefined || userName == null || userName.length == 0) {
            $("#lblerror").html("Tên đăng nhập không được bỏ trống");
            $("#txtUserName").focus();
        } else if (typeof capcha == undefined || capcha == null || capcha.length == 0) {
            $("#lblerror").html("Mã xác nhận không được bỏ trống");
            $("#txtCapcha").focus();
        } else {
            $("#lblerror").html("");
            $("#maskLogin").css({ "display": "block" });
            var uri = QLDT.Config.apiBE + '/Forgot/SendLinkActive?userName=' + userName + "&capcha=" + capcha + "&emailConfirm=" + emailConfirm;
            $.ajax({
                type: 'POST',
                url: uri,
                dataType: 'json',
                success: function (rep) {
                    if (rep.Success) {
                        $(".body-reset").hide();
                        $(".cls-email").html(rep.Data);
                        $(".body-sendlink").show();
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

    /*
    * Thực hiện sinh capcha
    * Create by: dvthang:22.02.2018
    */
    me.generateCapcha = function () {
        var uri = QLDT.Config.apiBE + '/Common/Capcha';
        $.ajax({
            type: 'GET',
            url: uri,
            dataType: 'json',
            success: function (rep) {
                if (rep.Success && rep.Data) {
                    $("#capcha").attr("src", "data:image/png;base64," + rep.Data);
                }
                
            }
        });
    },

    /*
    * Login thất bại
    * Create by: dvthang:14.01.2018
    */
    me.refreshCapcha = function () {
        me.generateCapcha();
    };
    return me;
}());