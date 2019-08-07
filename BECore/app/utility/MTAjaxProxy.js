/**
 * AjaxProxy
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.utility.MTAjaxProxy', {
    extend: 'Ext.data.proxy.Ajax',
    xtype: 'MTAjaxProxy',
    alias: 'proxy.mtproxy',

    requires: [
        'Ext.data.proxy.Ajax'
    ],

    isAjaxProxy: true,
    isRemovePaging: true,

    //limitParam: 'false',
    //noCache: false,
    //pageParam: 'false',
    //startParam: 'false',
    //appendId: false,
    //noCache: false,
    //getParams: Ext.emptyFn,
    // Keep a default copy of the action methods here. Ideally could just null
    // out actionMethods and just check if it exists & has a property, otherwise
    // fallback to the default. But at the moment it's defined as a public property,
    // so we need to be able to maintain the ability to modify/access it. 
    defaultActionMethods: {
        create: 'POST',
        read: 'GET',
        update: 'POST',
        destroy: 'POST'
    },
    config: {
        /**
        * @cfg {Boolean} binary
        * True to request binary data from the server.  This feature requires
        * the use of a binary reader such as {@link Ext.data.amf.Reader AMF Reader}
        */
        binary: false,
        /**
         * @cfg {Object} [headers]
         * Any headers to add to the Ajax request.
         *
         * example:
         *
         *     proxy: {
         *         headers: {'Content-Type': "text/plain" }
         *         ...
         *     }
         */
        headers: undefined,
        /**
         * @cfg {Boolean} paramsAsJson
         * Set to `true` to have any request parameters sent as {@link Ext.data.Connection#method-request jsonData}
         * where they can be parsed from the raw request. By default, parameters are sent via the
         * {@link Ext.data.Connection#method-request params} property. **Note**: This setting does not apply when the
         * request is sent as a 'GET' request. See {@link #cfg!actionMethods} for controlling the HTTP verb
         * that is used when sending requests.
         */
        paramsAsJson: false,
        /**
         * @cfg {Boolean} withCredentials
         * This configuration is sometimes necessary when using cross-origin resource sharing.
         * @accessor
         */
        withCredentials: false,
        /**
         * @cfg {Boolean} useDefaultXhrHeader
         * Set this to false to not send the default Xhr header (X-Requested-With) with every request.
         * This should be set to false when making CORS (cross-domain) requests.
         * @accessor
         */
        useDefaultXhrHeader: true,
        /**
         * @cfg {String} username
         * Most oData feeds require basic HTTP authentication. This configuration allows
         * you to specify the username.
         * @accessor
         */
        username: null,
        /**
         * @cfg {String} password
         * Most oData feeds require basic HTTP authentication. This configuration allows
         * you to specify the password.
         * @accessor
         */
        password: null,
        /**
        * @cfg {Object} actionMethods
        * Mapping of action name to HTTP request method. In the basic AjaxProxy these are set to 'GET' for 'read' actions
        * and 'POST' for 'create', 'update' and 'destroy' actions. The {@link Ext.data.proxy.Rest} maps these to the
        * correct RESTful methods.
        */
        actionMethods: {
            create: 'POST',
            read: 'GET',
            update: 'POST',
            destroy: 'POST'
        }
    },

    /*
    * Add header vào request
    * Create by: dvthang:10.01.2018
    */
    getHeaders: function () {
        return QLDT.utility.Utility.getHeaders();
    },

    doRequest: function (operation) {
        var me = this;
        if (me.isRemovePaging) {
            me.noCache = false;
            me.getParams = Ext.emptyFn;
        } else {
            me.noCache = true;
        }
        var writer = me.getWriter(),
            request = me.buildRequest(operation),
            method = me.getMethod(request),
            jsonData, params;
        if (writer && operation.allowWrite()) {
            request = writer.write(request);
        }
        request.setConfig({
            binary: me.getBinary(),
            headers: me.getHeaders(),
            timeout: me.getTimeout(),
            scope: me,
            callback: me.createRequestCallback(request, operation),
            method: method,
            useDefaultXhrHeader: me.getUseDefaultXhrHeader(),
            disableCaching: false
        });
        // explicitly set it to false, ServerProxy handles caching
        if (method.toUpperCase() !== 'GET' && me.getParamsAsJson()) {
            params = request.getParams();
            if (params) {
                jsonData = request.getJsonData();
                if (jsonData) {
                    jsonData = Ext.Object.merge({}, jsonData, params);
                } else {
                    jsonData = params;
                }
                request.setJsonData(jsonData);
                request.setParams(undefined);
            }
        }
        if (me.getWithCredentials()) {
            request.setWithCredentials(true);
            request.setUsername(me.getUsername());
            request.setPassword(me.getPassword());
        }
        return me.sendRequest(request);
    },
    
});
