var myLogin = (function () {
    var me = {};
    /*
    * Login thành công
    * Create by: dvthang:14.01.2018
    */
    me.loginSuccess = function (respone) {
        if (respone && respone.Success) {
            $("#maskLogin").show();
            $("#lblError").html("");
            window.location.href = "Home";
        } else {
            if (respone && respone.hasOwnProperty('ErrorMessage')) {
                $("#lblError").html(respone.ErrorMessage);
            }
        }       
    },

    /*
    * Login thất bại
    * Create by: dvthang:14.01.2018
    */
    me.loginFailure = function () {
        console.log('Login failure');
    };
    return me;
}());