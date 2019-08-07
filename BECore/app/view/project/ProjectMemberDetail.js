/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectMemberDetail', {
    extend: 'QLDT.view.control.MTWindow',
    xtype: 'app-projectmemberdetail',
    requires: [
        'QLDT.view.control.MTWindow',
        'QLDT.view.project.ProjectMemberDetailController',
        'QLDT.view.project.ProjectMemberDetailModel'

    ],

    controller: 'ProjectMemberDetail',
    viewModel: 'ProjectMemberDetail',

    width: 600,
    height: 400,

    /*
    * Khởi tạo các thành phần của form
    * Create by: laipv:01.02.2018
    */
    initComponent: function () {
        var me = this, items = [];
        Ext.apply(me, {
            items: [{
                xtype: 'MTForm',
                layout: { type: 'vbox', align: 'stretch' },
                flex: 1,
                padding: '16 8 4 8',
                items: me.getContent()
            }]
        });
        me.callParent(arguments);
    },

    /*
    * Vẽ nội dung của form
    * Create by: 01.02.2018
    */
    getContent: function () {
        var me = this;
        return [
            {
                xtype: 'MTComboBox',
                flex: 1,
                fieldLabel: 'Cán bộ',
                name: 'EmployeeID',
                itemId: 'fieldEmployeeID',
                displayField: 'FullName',
                valueField: 'EmployeeID',
                bind:
                    {
                        value: '{masterData.EmployeeID}',
                        store: '{employeeStore}'
                    },
                allowBlank: true
            },
             {
                 xtype: 'MTComboBox',
                 flex: 1,
                 fieldLabel: 'V.trí',
                 name: 'ProjectPositionID',
                 itemId: 'fieldProjectPositionID',
                 displayField: 'ProjectPositionName',
                 valueField: 'ProjectPositionID',
                 bind:
                     {
                         value: '{masterData.ProjectPositionID}',
                         store: '{projectPositionStore}'
                     },
                 allowBlank: true
             },
            {
                xtype: 'MTDateField',
                fieldLabel: 'Từ ngày',
                name: 'StartDate',
                itemId: 'startDateID',
                bind: '{masterData.StartDate}',
                allowBlank: false,
            },
            {
                xtype: 'MTDateField',
                fieldLabel: 'Đến ngày',
                name: 'EndDate',
                itemId: 'endDateID',
                bind: '{masterData.EndDate}',
                allowBlank: true,
            },
            {
                xtype: 'MTNumberField',
                fieldLabel: 'Số tháng',
                name: 'MonthForProject',
                bind: '{masterData.MonthForProject}',
                flex: 1,
                allowBlank: true
            },

        ]

    },

    buttons: [
            {
                text: 'Lưu',
                appendCls: 'btn-save',
                iconCls: 'button-save fa fa-floppy-o',
                xtype: 'MTButton',
                itemId: 'btnSave'
            },
            {
                text: QLDT.GlobalResource.SaveNew,
                itemId: 'btnSaveNew',
                appendCls: 'btn-savenew',
                iconCls: 'button-savenew fa fa-floppy-o',
                xtype: 'MTButton',
            },
            {
                text: 'Hủy bỏ',
                appendCls: 'btn-cancel',
                iconCls: 'button-cancel fa fa-undo',
                xtype: 'MTButton',
                itemId: 'btnCancel'
            }
    ]


});
