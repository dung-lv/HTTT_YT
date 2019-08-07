/**
 * Custom MTNumberField
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.MTNumberField', {
    extend: 'Ext.form.field.Number',
    xtype: 'MTNumberField',

    cls: 'cls-mtnumberfield-theme',
    appendCls: '',

    selectOnFocus: true,

    decimalPrecision: 2,

    allowDecimals:true,
    /*
   * Khởi tạo các thành phần của form
   * Create by: dvthang:08.04.2017
   */
    initComponent: function () {
        var me = this;
        me.callParent(arguments);
        if (me.appendCls) {
            me.cls += " " + me.appendCls;
        }
    }
});
