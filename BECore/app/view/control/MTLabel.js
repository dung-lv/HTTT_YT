﻿/**
 * Custom Label
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.MTLabel', {
    extend: 'Ext.form.Label',
    xtype: 'MTLabel',

    cls: 'cls-mtlabel-theme',
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