/**
 * Custom MTTextField
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.MTTextField', {
    extend: 'Ext.form.field.Text',
    xtype: 'MTTextField',

    cls: 'cls-mttextfield-theme',
    selectOnFocus: true,
    blankText: QLDT.ControlResource.BlankText,

    minLengthText: QLDT.ControlResource.MinLengthText,

    maxLengthText: QLDT.ControlResource.MaxLengthText,

    appendCls: '',
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
