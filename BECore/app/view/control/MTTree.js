/**
 * Custom MTTree
 * Create by: dvthang:04.02.2018
 */
Ext.define('QLDT.view.control.MTTree', {
    extend: 'Ext.tree.Panel',
    alias: 'store.mttree',
    xtype: 'MTTree',

    requires: [
       'Ext.data.*',
       'Ext.grid.*',
       'Ext.tree.*',
       'QLDT.view.control.column.MTTreeColumn'
    ],
    cls: 'cls-mttree-theme',

    columnLines: true,
    autoscroll: true,
    viewConfig: {
        emptyText: 'Không có bản ghi nào',
        stripeRows: true
    },

    /*Disabled sort trên grid*/
    sortable: false,
    appendCls: '',

    contextMenu: [],

    style: 'border: solid #c1c1c1 1px',

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
      
        if (me.contextMenu && me.contextMenu.length > 0) {
            me.on("itemcontextmenu", function (grid, record, item, index, e, eOpts) {
                var menu_grid = new Ext.menu.Menu({
                    items: me.contextMenu, cls: 'context-menu-grid',
                    itemId: Ext.String.format(me.itemId + "_{0}", "ContextMenu"),
                    listeners: {
                        beforeshow: function (sender) {
                            me.fireEvent('beforeshowContextMenu', me, menu_grid,record);
                        }
                    }
                });
                var position = e.getXY();
                e.stopEvent();
                menu_grid.showAt(position);
            });
           
            me.on("containercontextmenu", function (grid, e) {
                var menu_grid = new Ext.menu.Menu({
                    items: me.contextMenu, cls: 'context-menu-grid',
                    itemId:Ext.String.format(me.itemId+ "_{0}","ContextMenu"),
                    listeners: {
                        beforeshow:function (sender) {
                            me.fireEvent('beforeshowContextMenu', me, menu_grid);
                        }
                    }
                });
                var position = e.getXY();
                e.stopEvent();
                menu_grid.showAt(position);
            });
        }
        //treePanel.expandAll();
        //treePanel.collapseAll();
    },


   
});
