/**
 * Custom MTTime
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.MTTime', {
    extend: 'Ext.form.field.Time',
    xtype: 'MTTime',
    cls: 'cls-mt-time',
    appendCls: '',

    format: 'H:i:s A',

    selectOnFocus: true,
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
