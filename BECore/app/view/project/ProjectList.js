/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectList', {
    extend: 'Ext.panel.Panel',
    xtype: 'app-projectlist',
    requires: [
        'Ext.panel.Panel',
        'QLDT.view.project.ProjectListController',
        'QLDT.view.project.ProjectListModel',
        'QLDT.view.project.Project',
        'QLDT.view.project.Executable',
        'QLDT.view.project.Acceptance'
    ],

    controller: 'ProjectList',
    viewModel: 'ProjectList',

    layout: 'border',

    /*
   * Khởi tạo các thành phần của form
   * Create by: dvthang:05.01.2018
   */
    initComponent: function () {
        var me = this;
        Ext.apply(me, {
            items: me.getContent()
        });
        me.callParent(arguments);
    },

    /*
    * Vẽ nội dung của form
    * Create by: dvthang:04.02.2018
    */
    getContent: function () {
        var me = this;
        //Khai báo biến trả về
        var vitems;
        vitems = [
                {
                    title: 'Đang đề xuất',
                    layout: 'border',
                    flex: 1,
                    name:'TabOne',
                    items: [
                       {
                           xtype: 'MTPanel',
                           layout: 'hbox',
                           hidden:true,
                           region: 'north',
                       },
                        {
                            xtype: 'app-project',
                            flex: 1,
                            region:'center',
                            itemId: 'projecOfferItemID',
                            bodyPadding: '0 0 0 0',
                            padding:'0 0 0 0'
                        }
                    ]
                },
                {
                    title: 'Đang thực hiện',
                    layout: 'border',
                    flex: 1,
                    name: 'TabTwo',
                    items: [
                        {
                            xtype: 'MTPanel',
                            layout: 'hbox',
                            hidden: true,
                            region: 'north',
                        },
                        {
                            xtype: 'app-executable',
                            flex: 1,
                            region:'center',
                            itemId: 'executableItemID'
                        }
                        
                    ]
                },
                {
                    title: 'Đã nghiệm thu',
                    layout: 'fit',
                    flex: 1,
                    name: 'TabThree',
                    items: [
                        {
                            xtype: 'app-acceptance',
                            flex: 1,
                            region: 'center',
                            itemId: 'acceptanceItemID'
                        }
                    ]
                },
        ];
        //1. Nếu là nhóm Thủ Trưởng viện + Ban Kế hoạch + Ban Tài chính + Ban Chính trị --> Được xem tất cả
        var CompanyID = QLDT.Config.getCompanyID();
        var PositionID = QLDT.Config.getPositionID();
        var EmployeeID = QLDT.Config.getEmployeeID();
        //
        if (!(
                CompanyID == QLDT.common.Constant.Company_TTV_B ||
                CompanyID == QLDT.common.Constant.Company_TTV_N ||
                CompanyID == QLDT.common.Constant.Company_BKH ||
                CompanyID == QLDT.common.Constant.Company_BCT ||
                CompanyID == QLDT.common.Constant.Company_BHCHC ||
                CompanyID == QLDT.common.Constant.Company_BTC
          )) {
            //Khi là trợ lý thì chỉ hiện danh sách sau
            vitems = [
                    {
                        title: 'Danh sách đề tài',
                        layout: 'border',
                        flex: 1,
                        name: 'TabOne',
                        items: [
                           {
                               xtype: 'MTPanel',
                               layout: 'hbox',
                               hidden: true,
                               region: 'north',
                           },
                            {
                                xtype: 'app-acceptance',
                                flex: 1,
                                region: 'center',
                                itemId: 'acceptanceItemID',
                                bodyPadding: '0 0 0 0',
                                padding: '0 0 0 0'
                            }
                        ]
                    },
            ];
        }
        //Trả về danh sách
        return [{
            xtype: 'MTTabPanel',
            flex: 1,
            region: 'center',
            appendCls: 'tab-panel-project-detail',
            tabRotation: 0,
            tabBar: {
                border: false
            },
            itemId:'tabListProject',
            bodyPadding: '8 0 0 0',
            items: vitems
        }];
    }

});
