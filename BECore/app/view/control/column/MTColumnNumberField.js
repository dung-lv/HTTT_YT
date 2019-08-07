/**
 * Custom Column MTColumnNumberField
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.column.MTColumnNumberField', {
    extend: 'Ext.grid.column.Number',
    xtype: 'MTColumnNumberField',

    cls: 'cls-mtcolumn-numberfield-theme',
    readOnly: false,
    allowBlank: true,
    minValue: 0,
    filterable: true,

    filterValue: null,

    /*Giá trị trên ô search*/
    inputValue: null,

    operator: QLDT.common.Enumaration.FilterOperations.LessThanOrEquals,

    dataType: QLDT.common.Enumaration.DataType.Decimal,

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
    filter: function (filterId, value, force) {
        var me = this, store = me.getGrid().getStore();
        if (store.remoteFilter) {
            var hasValue = typeof value != 'undefined' && value != null && value !== "";
            if ((hasValue && me.filterValue !== value) || (hasValue && force)) {
                store.removeFilter(filterId, true);

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
