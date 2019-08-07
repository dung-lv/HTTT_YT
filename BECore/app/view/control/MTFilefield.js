/**
 * Custom MTFilefield
 * Create by: dvthang:22.04.2017
 */
Ext.define('QLDT.view.control.MTFilefield', {
    extend: 'Ext.form.field.File',
    xtype: 'MTFilefield',

    requires:[
        'Ext.form.field.File'
    ],
    cls: 'cls-mtfilefield-theme',
    blankText: QLDT.ControlResource.BlankText,

    appendCls: '',  

    initComponent: function (config) {
        var me = this;        
        me.callParent(arguments);
        if (me.appendCls) {
            me.cls += " " + me.appendCls;
        }
    },
    
});
