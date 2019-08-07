/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.auditlaboday.Auditlaboday', {
    extend: 'Ext.panel.Panel',
    xtype: 'app-auditlaboday',
    requires: [
        'Ext.panel.Panel',
        'QLDT.view.auditlaboday.AuditlabodayController',
        'QLDT.view.auditlaboday.AuditlabodayModel'
    ],
    layout: 'border',

    controller: 'Auditlaboday',
    viewModel: 'Auditlaboday',

    columnStartEdit: 2,

    /*
    * Vẽ thanh topbar item trên grid
    * Ban kết hoạch và Ban tài chính thì full quyền, Nhân viên chỉ xem được đề tài mình là chủ nhiệm
    * Create by: dvthang:03.03.2018
    * Modify by: manh:04.05.18
    */
    getTopBar: function () {
        var me = this,
            monthStore = me.getViewModel().getStore('monthStore'),
            yearStore = me.getViewModel().getStore('yearStore'),
            employeeStore = me.getViewModel().getStore('employeeStore'),
            projectStore = me.getViewModel().getStore('projectStore'),
            projectByEmployeeStore = me.getViewModel().getStore('projectByEmployeeStore'),
            companyStore = me.getViewModel().getStore('companyStore'),
            viewtem;
        viewtem = [
                    {
                        flex: 1,
                        fieldLabel: 'Đơn vị',
                        store: companyStore,
                        xtype: 'MTComboBox',
                        displayField: 'CompanyName',
                        valueField: 'CompanyID',
                        itemId:'cboCompany'
                    },
                    {
                        fieldLabel: 'Cán bộ',
                        name: 'EmployeeID',
                        xtype: 'MTComboBox',
                        flex: 1,
                        displayField: 'FullName',
                        valueField: 'EmployeeID',
                        store: employeeStore,
                        itemId: 'cboEmployee',
                    },
                    {
                         fieldLabel: 'Đề tài',
                         name: 'ProjectID',
                         xtype: 'MTComboBox',
                         itemId: 'cboProjectID',
                         flex: 1,
                         displayField: 'ProjectName',
                         valueField: 'ProjectID',
                         store: projectStore
                     },
                     {
                         xtype: 'MTPanel',
                         layout: {
                             type: 'hbox',
                         },
                         items: [
                             {
                                 xtype: 'MTComboBox',
                                 fieldLabel: 'Tháng',
                                 name: 'Month',
                                 itemId: 'cboMonth',
                                 labelWidth: 110,
                                 allowBlank: false,
                                 displayField: 'Text',
                                 valueField: 'Value',
                                 store: monthStore,
                             },
                             {
                                 xtype: 'MTComboBox',
                                 fieldLabel: 'Năm',
                                 labelWidth: 60,
                                 margin: '0 8 0 8',
                                 itemId: 'cboYear',
                                 name: 'Year',
                                 allowBlank: false,
                                 displayField: 'Text',
                                 valueField: 'Value',
                                 store: yearStore,
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
        ];

        return {
            xtype: 'MTPanel',
            region: 'north',
            title: 'Tìm kiếm',
            layout: { type: 'vbox', align: 'stretch' },
            collapsible: true,
            defaults: {
                labelWidth: 110,
                margin: '8 8 0 8',
            },
            items: viewtem
        };
    },

    /*
   * Khởi tạo các thành phần của form
   * Create by: dvthang:05.01.2018
   */
    initComponent: function () {
        var me = this;

        Ext.apply(me, {
            items:
            [
                me.getTopBar(),
                {
                    xtype: 'MTPanel',
                    region: 'center',
                    layout: 'fit',
                    items: [
                        {
                            xtype: 'MTGrid',
                            store: me.getViewModel().getStore('auditStore'),
                            itemId: 'grdMaster',
                            layout: 'fit',
                            sortable:false,
                            filterable: false
                        }
                    ]
                }
            ]
        });
        me.callParent(arguments);
    },

});
