/**
 * Custom MTDateField
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.MTDateField', {
    extend: 'Ext.form.field.Date',
    xtype: 'MTDateField',

    cls: 'cls-mtdatefield-theme',
    blankText: QLDT.ControlResource.BlankText,
    format: 'd/m/Y',
    appendCls: '',
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
