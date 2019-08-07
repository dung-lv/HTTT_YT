/**
 * Custom Column MTColumnBoolean
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.column.MTColumnCombo', {
    extend: 'Ext.grid.column.Column',
    xtype: 'MTColumnCombo',
    requires: ['Ext.grid.column.Column'],
    cls: 'cls-mtcolumn-combo-theme',
    allowBlank: true,
    readOnly: false,
    editable: true,
    headers: [],
    displayFields: [],

    displayField: '',
    valueField: '',

    store:null,

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

    /*
    * Render lại column để hiển  thị value tỏng combo
    * Create by: dvthang:07.03.2018
    */
    renderer: function (value, metaData, record, rowIndex) {
        var editor = metaData.column.getEditor(record);
        var storeRecord = editor.store.findRecord(editor.valueField, value, 0, false, true, true);
        if (storeRecord) {
            return storeRecord.data[editor.displayField];
        }
        return null;
    },

});
