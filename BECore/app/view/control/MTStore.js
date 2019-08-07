/**
 * Custom MTStore
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.MTStore', {
    extend: 'Ext.data.Store',
    alias: 'store.mtstore',
    xtype: 'MTStore',

    requires: [
        'QLDT.utility.MTAjaxProxy'        
    ],
    autoload: false,
    /*
    * Thuộc tính dùng để lưu đối tượng
    */
    setField:'',
   /*
    * Tạo recores từ store
    * Create by: dvthang:15.01.2018
    */
    addNew: function (record) {
        var me = this,crudRecord;
        crudRecord = Ext.create(me.config.model);
        if (record) {
            crudRecord.data = record.data;
        }
        me.insert(0, [crudRecord]);
        return crudRecord;
    },

    /*
   * Tạo recores từ store
   * Create by: dvthang:15.01.2018
   */
    appendData: function () {
        var me = this, record;
        record = Ext.create(me.config.model);
        if (record) {
            me.add(record);
        }
        return record;
    }
});
