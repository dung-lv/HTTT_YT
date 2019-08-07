/**
 * Custom Column MTColumnCheckBox
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.column.MTColumnCheckBox', {
    extend: 'Ext.grid.column.Check',
    xtype: 'MTColumnCheckBox',

    cls: 'cls-mtcolumn-checkbox-theme',
    filterable: true,
    /*
   * Render lại column trên grid
   * Create by: dvthang:3.3.2018
   */
    initComponent: function () {
        var me = this;
        QLDT.utility.Utility.createEditorColumn(me);
        me.callParent(arguments);

    },

});
