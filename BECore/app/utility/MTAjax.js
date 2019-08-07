Ext.define('QLDT.utility.MTAjax', {
    singleton: true,

    /*
    * Gọi giao thức post 
    * Create by: dvthang:14.10.2017
    */
    httpPost: function (uri, addConfig,data, callBack, failure) {
        var me = this;
        me.request(uri, "POST",addConfig, data, callBack, failure);
    },

    /*
    * Gọi giao thức GET 
    * Create by: dvthang:14.10.2017
    */
    httpGet: function (uri,addConfig, data, callBack, failure) {
        var me = this;
        me.request(uri, "GET", addConfig,data, callBack, failure);
    },

    /*
    * Gọi giao thức DELETE 
    * Create by: dvthang:14.10.2017
    */
    httpDelete: function (uri,addConfig, data, callBack, failure) {
        var me = this;
        me.request(uri, "DELETE", addConfig,data, callBack, failure);
    },

    /*
    * Gọi giao thức DELETE 
    * Create by: dvthang:14.10.2017
    */
    httpPut: function (uri,addConfig, data, callBack, failure) {
        var me = this;
        me.request(uri, "PUT",addConfig, data, callBack, failure);
    },

    privates: {
        /*
        * Gọi ajax request
        * Create by: dvthang:14.10.2017
        */
        request: function (uri, method, addConfig, data, callBack, failure) {
            var header = QLDT.utility.Utility.getHeaders();
            debugger;
            var config = {
                url: uri,
                method: method,
                headers: header,
                success: function (conn, response, options, eOpts) {
                    var result = Ext.JSON.decode(conn.responseText);
                    if (typeof callBack == 'function') {
                        callBack(result);
                    }
                },
                failure: function (conn, response, options, eOpts) {
                    if(typeof failure=='function'){
                        failure(response);
                    }
                }
            };
            if (typeof addConfig == 'object') {
                for (var p in addConfig) {
                    config[p] = addConfig[p];
                }
            }

            if (method.toUpperCase() !== 'GET') {
                config["jsonData"] = Ext.JSON.encode(data);
            } else {
                config["params"] = Ext.JSON.encode(data);
            }
            Ext.Ajax.request(config);
        },
    }
});