/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectTaskDetail', {
    extend: 'QLDT.view.control.MTWindow',
    xtype: 'app-projecttaskdetail',
    requires: [
        'QLDT.view.control.MTWindow',
        'QLDT.view.project.ProjectTaskDetailController',
        'QLDT.view.project.ProjectTaskDetailModel'

    ],

    controller: 'ProjectTaskDetail',
    viewModel: 'ProjectTaskDetail',

    width: 600,
    height: 400,

    /*
    * Khởi tạo các thành phần của form
    * Create by: laipv:29.01.2018
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
    * Create by: laipv:29.01.2018
    */
    getContent: function () {
        var me = this;
        return [
            {
                xtype: 'MTTextField',
                fieldLabel: 'Nội dung',
                name: 'Contents',
                bind: '{masterData.Contents}',
                flex: 1,
                allowBlank: false
            },
             {
                 xtype: 'MTComboBox',
                 flex: 1,
                 fieldLabel: 'Nội dung (cha)',
                 name: 'ParentID',
                 valueField: 'ProjectTaskID',
                 displayField: 'Contents',
                 isComboTree: true,
                 bind: {
                     value: '{masterData.ParentID}',
                     store: '{projecttaskStore}',
                 }
             },
            {
                xtype: 'MTDateField',
                fieldLabel: 'Từ ngày',
                name: 'StartDate',
                bind: '{masterData.StartDate}',
                allowBlank: false,
            },
            {
                xtype: 'MTDateField',
                fieldLabel: 'Đến ngày',
                name: 'EndDate',
                bind: '{masterData.EndDate}',
                allowBlank: false,
            },
            {
                xtype: 'MTTextField',
                fieldLabel: 'Kết quả',
                name: 'Result',
                bind: '{masterData.Result}',
                flex: 1,
                maxLength: 255
            },
            {
                xtype: 'MTComboBox',
                flex: 1,
                fieldLabel: 'Trạng thái',
                name: 'Status',
                displayField: 'text',
                valueField: 'value',
                bind:
                    {
                        value: '{masterData.Status}',
                        store: '{projecttaskstatusStore}'
                    },
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
