/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectTaskSort', {
    extend: 'QLDT.view.control.MTWindow',
    xtype: 'app-projecttasksort',
    requires: [
        'QLDT.view.control.MTWindow',
        'QLDT.view.project.ProjectTaskSortController',
        'QLDT.view.project.ProjectTaskSortModel',
    ],
    controller: 'ProjectTaskSort',
    viewModel: 'ProjectTaskSort',

    layout: 'fit',

    width: 800,

    height: 600,

    title:'Sắp xếp nội dung task',

    /*
    * Hàm lấy nội dung form
    * Create by: laipv:04.03.2018
    */
    getContent: function () {
        var me = this, store = me.getViewModel().getStore('masterStore'),
            projectTaskStore = me.getViewModel().getStore('projectTaskStore');
        return {

            xtype: 'MTPanel',
            layout: {
                type: 'vbox',
                align: 'stretch',
            },
            region: 'center',
            items: [
                {
                    xtype: 'MTPanel',
                    layout: {
                        type: 'hbox',
                    },
                    items: [
                        {
                            fieldLabel: 'Nội dung',
                            name: 'ProjectTaskID',
                            xtype: 'MTComboBox',
                            allowBlank: false,
                            flex: 1,
                            displayField: 'Contents',
                            valueField: 'ProjectTaskID',
                            labelWidth: 110,
                            margin: '0 4 8 0',
                            itemId: 'cboProjectTask',
                            isComboTree:true,
                            store: projectTaskStore
                        },
                        {
                            xtype: 'MTButton',
                            text: 'Tìm kiếm',
                            itemId: 'btnSearch',
                            margin: '0 8 8 0',
                            appendCls: 'btn-search',
                            iconCls: 'fa fa-search',
                            name: 'Search'
                        },
                    ]
                },
                {
                    xtype: 'MTPanel',
                    height: 30,
                    items: [
                        {
                            xtype: 'MTToolbar',
                            itemId: 'toolbarGrid',
                            cls: 'toolbar-menu-list',
                            items: me.getToolbarMenu()
                        },
                    ]
                },
                {
                    xtype: 'MTGrid',
                    store: store,
                    flex: 1,
                    columnLines: true,
                    viewConfig: {
                        emptyText: 'Không có nội dung nào',
                    },
                    itemId: 'grdProjectTask',
                    columns: me.getColumns(),
                }

            ]

        };
    },


    /*
    * Trả về nút trên toolbar
    * Create by: laipv:04.03.2018
    */
    getToolbarMenu: function () {
        var me = this;
        return [
                 {
                     iconCls: 'button-up menu-button-item fa fa-upload',
                     cls: 'menu-button-item',
                     text: 'Lên',
                     itemId: 'btnUp',
                 },
                 {
                     iconCls: 'button-down menu-button-item fa fa-download',
                     cls: 'menu-button-item',
                     text: 'Xuống',
                     itemId: 'btnDown',
                 }
        ];
    },


    /*
    * Trả về nội dung grid
    * Create by: laipv:04.03.2018
    */
    getColumns: function () {
        var me = this;
        return [
            {
                xtype: 'MTColumnNumberField', text: 'TT', dataIndex: 'SortOrder', width: 80, readOnly: true, align: 'center', format: '#'

            },
            { xtype: 'MTColumn', text: 'Nội dung', dataIndex: 'Contents', minWidth: 250, flex: 1 },
        ];
    },


    /*
   * Khởi tạo các thành phần của form
   * Create by: dvthang:05.01.2018
   */
    initComponent: function () {
        var me = this;
        Ext.apply(me, {
            items: [{
                xtype: 'MTForm',
                layout: 'border',
                padding: '8 8 4 8',
                items: [ 
                    me.getContent()
                ]
            }]
        });
        me.callParent(arguments);
    },
});
