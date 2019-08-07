/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectTaskMember', {
    extend: 'QLDT.view.control.MTWindow',
    xtype: 'app-projecttaskmember',
    requires: [
        'QLDT.view.control.MTWindow',
        'QLDT.view.project.ProjectTaskMemberController',
        'QLDT.view.project.ProjectTaskMemberModel',
        'QLDT.view.control.column.MTColumnCombo'
    ],
    controller: 'ProjectTaskMember',
    viewModel: 'ProjectTaskMember',
    title: 'Cán bộ thực hiện nội dung đề tài',

    layout: 'fit',

    width: 800,

    height: 600,
    /*
    * Hàm lấy nội dung form
    * Create by: manh:01.03.2018
    */
    getContent: function () {
        var me = this, store = me.getViewModel().getStore("masterStore");
        return {

            xtype: 'MTPanel',
            layout: {
                type: 'vbox',
                align: 'stretch',
            },
            region: 'center',
            items: [
                {
                    xtype: 'MTGrid',
                    store: store,
                    flex: 1,
                    columnLines: true,
                    editGrid: true,
                    editCell: true,
                    viewConfig: {
                        emptyText: 'Không có cán bộ nào',
                    },
                    itemId: 'grdMaster',
                    columns: me.getColumns(),
                    contextMenu: me.getContextMenu()

                }

            ]

        };
    },

    /*
    * Tạo context menu cho grid
    * Create by: dvthang:07.01.2018
    */
    getContextMenu: function () {
        var me = this;
        return [
                {
                    iconCls: 'button-add menu-button-item fa fa-plus',
                    cls: 'menu-button-item',
                    text: 'Thêm',
                    itemId: 'mnAdd',
                    handler: function (sender) {
                        var controller = me.getController();
                        if (controller) {
                            controller.toolbar_OnClick(sender);
                        }
                    }
                },
                {
                    iconCls: 'button-delete menu-button-item fa fa-trash-o',
                    cls: 'menu-button-item',
                    text: 'Xóa',
                    itemId: 'mnDelete',
                    handler: function (sender) {
                        var controller = me.getController();
                        if (controller) {
                            controller.toolbar_OnClick(sender);
                        }
                    }
                },
        ];
    },

    /*
    * Trả về nội dung grid
    * Create by: manh:01.03.2018
    */
    getColumns: function () {
        var me = this,employeeStore=me.getViewModel().getStore('employeeStore');
        return [           
            {
                text: 'Cán bộ', dataIndex: 'EmployeeID', minWidth: 250, flex: 1, xtype: 'MTColumnCombo',
                store: employeeStore,
                valueField: 'EmployeeID', displayField: 'FullName', allowBlank: false
            },
            {
                text: 'B.đầu', dataIndex: 'StartDate', width: 120, xtype: 'MTColumnDateField', allowBlank: false
            },
            {
                text: 'K.thúc', dataIndex: 'EndDate', width: 120, xtype: 'MTColumnDateField', allowBlank: false
            },
            {
                text: 'Số ngày', dataIndex: 'MonthForTask', width: 120, xtype: 'MTColumnNumberField',
            }

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
                itemId:'formProjectTaskMember',
                padding: '8 8 4 8',
                items: [
                    me.getContent()
                ]
            }]
        });
        me.callParent(arguments);
    },

    buttons: [
            {
                text: 'Lưu',
                appendCls: 'btn-save',
                iconCls: 'button-save fa fa-floppy-o',
                itemId: 'btnSave',
                xtype: 'MTButton',
            }, {
                text: 'Hủy bỏ',
                appendCls: 'btn-cancel',
                iconCls: 'button-cancel fa fa-undo',
                xtype: 'MTButton',
                itemId: 'btnCancel'

            }
    ]
});
