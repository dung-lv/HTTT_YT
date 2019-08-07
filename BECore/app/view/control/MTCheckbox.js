/**
 * Custom MTCheckbox
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.MTCheckbox', {
    extend: 'Ext.form.field.Checkbox',
    xtype: 'MTCheckbox',

    cls: 'cls-mtcheckbox-theme',
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
