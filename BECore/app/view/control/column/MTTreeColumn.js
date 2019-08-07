/**
 * Custom MTTreeColumn
 * Create by: dvthang:04.02.2018
 */
Ext.define('QLDT.view.control.column.MTTreeColumn', {
    extend: 'Ext.tree.Column',
    xtype: 'MTTreeColumn',
    requires:[
        'Ext.tree.Column'
    ],
    cls: 'cls-mttreecolumn-theme',
    filterable: true,
    /*
    * Render lại column để show tooltip
    * Create by: dvthang:27.02.2018
    */
    renderer: function (value, metaData, record, rowIndex) {
        value = Ext.String.htmlEncode(value);
        // "double-encode" before adding it as a data-qtip attribute
        metaData.tdAttr = 'data-qtip="' + Ext.String.htmlEncode(value) + '"';

        return value;
    }

});
