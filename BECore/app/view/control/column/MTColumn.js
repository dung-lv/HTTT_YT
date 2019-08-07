/**
 * Custom Column MTColumnBoolean
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.column.MTColumn', {
    extend: 'Ext.grid.column.Column',
    xtype: 'MTColumn',
    requires: ['Ext.grid.column.Column'],
    cls: 'cls-mtcolumn-theme',

    readOnly: false,
    allowBlank: true,

    filterable: true,

    grd: null,

    headerFilter:{
        editable: true,
        displayField: '',
        valueField: '',
        store: null,
        forceSelection: true,
        selectOnFocus: true,
        value:-1
    },
    filterValue: null,

    /*Giá trị trên ô search*/
    inputValue: null,

    isFilterCombo:false,

    operator: QLDT.common.Enumaration.FilterOperations.Contains,

    dataType:QLDT.common.Enumaration.DataType.String,

    /*
    * Render lại column trên grid
    * Create by: dvthang:3.3.2018
    */
    initComponent: function () {
        var me = this;
        QLDT.utility.Utility.createEditorColumn(me);
        //add filter vào grid
        if (me.filterable) {
            QLDT.utility.Utility.createFilterRow(me);
        }
        me.callParent(arguments);

    },

    /*
    * Render lại column để show tooltip
    * Create by: dvthang:27.02.2018
    */
    renderer: function (value, metaData, record, rowIndex) {
        value = Ext.String.htmlEncode(value);

        // "double-encode" before adding it as a data-qtip attribute
        metaData.tdAttr = 'data-qtip="' + Ext.String.htmlEncode(value) + '"';

        return value;
    },

    /*
    * Lấy về đối tượng grid
    * Create by: dvthang:24.03.2018
    */
    getGrid: function () {
        var me = this;
        if (!me.grd) {
            me.grd = me.up('grid');
        }
        return me.grd;
    },

    /*
    * Thực hiện filter row server trong grid
    * Create by: dvthang:22.03.2018
    */
    filter: function (filterId, value,force) {
        var me = this, store = me.getGrid().getStore();
        if (store.remoteFilter) {
            var hasValue = typeof value != 'undefined' && value != null && value !== "";
            if ((hasValue && me.filterValue !== value) || (hasValue && force)) {
                store.removeFilter(filterId,true);

                var filter = {
                    id: filterId, property: filterId, value: value,
                    group: filterId, addition: 0, operator: me.operator,
                    type: me.dataType
                };
                store.addFilter(filter);

                me.filterValue = value;
            } else {
                me.filterValue = null;
                store.removeFilter(filterId);
            }
        } else {
            //Filter Local;
        }
    },

});
