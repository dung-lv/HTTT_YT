/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.base.BaseEditTable', {
    extend: 'Ext.panel.Panel',
    xtype: 'app-baseedittable',
    requires: [
        'QLDT.view.base.BaseEditTableController',
    ],

    controller: 'BaseEditTable',

    layout: 'border',
    /*
    * Edit đầu tiên khi nhấn sửa
    */
    columnStartEdit: 0,

    /*Thuộc tính ẩn header trên grid*/
    hideHeader: false,

    /*
    * Đánh dấu hiển thị pagging trên grid
    * Create by: dvthang:07.01.2018
    */
    showPaging: true,

    /*
    * Khởi tạo các thành phần của form
    * Create by: dvthang:05.01.2018
    */
    initComponent: function () {
        var me = this, items = [], top = me.getTopBar();
        if (top) {
            items.push(top);
        }
        if (!me.hideHeader) {
            items.push(me.getHeader());
        }
        var center = me.getCenter(),
            bottom = me.getBottom();
        if (center && center.hasOwnProperty('xtype')) {
            items.push(center);
        }
        if (bottom && bottom.hasOwnProperty('xtype')) {
            items.push(bottom);
        }
        Ext.apply(me, {
            items: items
        });
        me.callParent(arguments);
    },

    /*
    * Vẽ top bar
    * Create by: dvthang:24.02.2018
    */
    getTopBar: function () {
        return null;
    },


    /*
    * Vẽ nội dung header của form danh sách
    * Create by: dvthang:07.01.2018
    */
    getHeader: function () {
        var me = this;
        return {
            xtype: 'MTToolbar',
            region: 'north',
            itemId: 'toolbarGrid',
            cls: 'toolbar-menu-list',
            items: me.getToolbarMenu()
        };
    },

    /*
    * Lấy danh sách menu của toolbar
    * Create by: dvthang:24.1.2018
    */
    getToolbarMenu: function () {
        var me = this;
        return [
                {
                    iconCls: 'button-edit menu-button-item fa fa-pencil-square-o',
                    cls: 'menu-button-item',
                    text: 'Sửa',
                    itemId: 'btnEdit',
                },
                {
                    iconCls: 'button-save menu-button-item fa fa-floppy-o',
                    cls: 'menu-button-item',
                    text: 'Lưu',
                    itemId: 'btnSave',
                },
                 {
                     iconCls: 'button-undo menu-button-item fa fa-undo',
                     cls: 'menu-button-item',
                     text: 'Hoãn',
                     itemId: 'btnUndo',
                 }

        ];
    },

    /*
    * Tạo context menu cho grid
    * Copy, Paste, Remove
    * Create by: manh:28.05.18
    */
    getContextMenu: function () {
        var me = this;
        return [];
    },

    /*
    * Trả về nội dung của form
    * Create by: dvthang:06.01.2017
    */
    getCenter: function () {
        var me = this, store = me.getStoreMaster();
        return {
            xtype: 'MTPanel',
            region: 'center',
            layout: 'fit',
            items: [
                {
                    xtype: 'MTGrid',
                    store: store,
                    itemId: 'grdMaster',
                    columns: me.getColumns(),
                    layout: 'fit',
                    showPaging: false,
                    editGrid: true,
                    editCell: true,
                    columnStartEdit: me.columnStartEdit,
                    contextMenu: me.getContextMenu(),
                    viewConfig: me.getViewConfig()
                }
            ]
        };

    },

    /*
    * Laays thong tin config cua grid neu co
    */
    getViewConfig: function (record, index) {
        return {};
    },

    /*
    * Trả về nội dung vùng center
    * Create by: dvthang:07.01.2018
    */
    getColumns: function () {
        return [];
    },

    /*
    * Store để load dữ liệu cho grid
    * Create by: dvthang:07.01.2018
    */
    getStoreMaster: function () {
        return null;
    },

    /*
    * Vẽ chân của footter
    * Create by: dvthang:07.01.2018
    */
    getBottom: function () {
        return {

        };
    }
});
