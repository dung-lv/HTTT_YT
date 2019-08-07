/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectProposalInfoDetail', {
    extend: 'QLDT.view.control.MTPanel',
    xtype: 'app-projectproposalinfodetail',
    requires: [
        'QLDT.view.control.MTPanel',
        'QLDT.view.project.ProjectProposalInfoDetailController',
        'QLDT.view.project.ProjectProposalInfoDetailModel',
    ],
    controller: 'ProjectProposalInfoDetail',
    viewModel: 'ProjectProposalInfoDetail',
    height: 400,
    width: 600,
    layout: {
        type: 'vbox',
        align: 'stretch'
    },

    /*
    * Hàm lấy danh sách cột của lưới
    * Create by: laipv:17.01.2018
    */
    getColumns: function () {
        var me = this;
        return [
                {
                    text: 'STT', dataIndex: 'ProjectName', width: 120,
                },
                   { text: 'Tên file', dataIndex: 'EmployeeID_Name', minWidth: 250, flex: 1 },
                   { text: 'Kích thước', dataIndex: 'StartDate', width: 120 },
                    { text: 'Tải tài liệu', dataIndex: 'EndDate', width: 120 }
        ];
    },
    /*
    * Vẽ nội dung của form
    * Create by: 17.01.2018
    */
    getContent: function () {
        var me = this, store = me.getViewModel().getStore("detail");
        return [
                {
                    fieldLabel: 'Số quyết định',
                    name: 'Number',
                    xtype: 'MTTextField',
                    bind: '{masterData.DecisionNumber}'
                },
                {
                    fieldLabel: 'Ngày quyết định',
                    name: 'Date',
                    xtype: 'MTDateField',
                    bind: '{masterData.DecisionDate}'
                },
                {
                    fieldLabel: 'Ngày bảo vệ',
                    name: 'Date',
                    xtype: 'MTDateField',
                    bind: '{masterData.ProtectedDate}'
                },
                {
                    fieldLabel: 'Kết quả',
                    xtype: 'MTComboBox',
                    bind: '{masterData.ProtectedDate}'
                },
                {
                    xtype: 'MTPanel',
                    region: 'center',
                    layout: 'fit',
                    items: [
                        {
                            xtype: 'MTGrid',
                            store: store,
                            columns: me.getColumns(),
                            layout: 'fit'
                            //fullscreen: true,
                            //showPaging: me.showPaging,
                            //contextMenu: me.getContextMenu()
                        }
                    ]
                },
        ];
    },

    /*
   * Khởi tạo các thành phần của form
   * Create by: 17.01.2018
   */
    initComponent: function () {
        var me = this;
        Ext.apply(me, {
            items: me.getContent()
        });
        me.callParent(arguments);
    },

});
