/**
 * Custom MTStore
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.MTTreeStore', {
    extend: 'Ext.data.TreeStore',
    alias: 'store.mttreestore',
    xtype: 'MTTreeStore',

    requires: [
        'Ext.data.TreeStore',
        'QLDT.utility.MTAjaxProxy'        
    ],
    autoload: false,

    /*
    * Tạo recores từ store
    * Create by: dvthang:15.01.2018
    */
    addNew: function () {
        var me = this, record;
        record = Ext.create(me.config.model);
        if (record) {
            me.insert(0, record);
        }
        return record;
    }
});
