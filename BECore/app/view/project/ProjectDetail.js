/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectDetail', {
    extend: 'QLDT.view.base.BasePopupDetail',
    xtype: 'app-projectdetail',
    requires: [
        'QLDT.view.project.ProjectDetailController', // Controller
        'QLDT.view.project.ProjectDetailModel',      // Model
        'QLDT.view.project.ProjectInfoDetail', // Tab: Thông tin chung (của đề tài)
        'QLDT.view.project.ProjectPlanExpenseDetail', // Tab: kế hoạch phân bổ kinh phí
        'QLDT.view.project.ProjectPlanPerformDetail', // Tab: Kế hoạch thực hiện
        'QLDT.view.project.ProjectWorkshop',    // Tab: Hội thảo đề tài
        'QLDT.view.project.ProjectSurvey',      // Tab: Thông tin khảo sát
        'QLDT.view.project.ProjectExperiment',  // Tab: Thử nghiệm đề tài
        'QLDT.view.project.ProjectProgressReport', // Tab: Báo cáo tiến độ đề tài
        'QLDT.view.project.ProjectAcceptanceBasicDetail', // Tab: Bảo vệ cấp cơ sở
        'QLDT.view.project.ProjectAcceptanceManageDetail', // Tab: Bảo vệ cấp quản lý
        'QLDT.view.project.ProjectCloseDetail', // Tab: Đóng đề tài
        'QLDT.view.project.ProjectTask',  // Tab: Nội dung thực hiện của để tài
        'QLDT.view.project.ProjectMember', // Tab: Thành viên tham gia đề tài
        'QLDT.view.project.ProjectInfoFin', // Tab: Thông tin tài chính

    ],
    controller: 'ProjectDetail',
    viewModel: 'ProjectDetail',

    width: 800,
    height: 600,

    maximizable: true,
    maximized: true,
    hideBottom: true,
    /*
    * Vẽ nội dung của form
    * Create by: dvthang:09.01.2018
    */
    getContent: function () {
        return {
            xtype: 'MTTabPanel',
            flex: 1,
            region: 'center',
            appendCls: 'tab-panel-project-detail tab-popup',
            tabPosition: 'left',
            tabRotation: 0,
            tabBar: {
                border: false
            },

            defaults: {
                textAlign: 'left',
            },
            bodyPadding: '8 8 16 16',
            itemId: 'tabProject',
            activeTab: 0,
            items: [
                {
                    title: 'Thông tin chung',
                    layout: 'fit',
                    flex: 1,
                    name: 'projectinfodetail',
                    itemId: 'tabProjectInfoDetailID',
                    items: [
                        {
                            xtype: 'app-projectinfodetail',
                            itemId: 'projectinfodetailID',
                        }
                    ]
                },
                {
                    title: 'Thông tin tài chính',
                    layout: 'fit',
                    flex: 1,
                    itemId: 'tabProjectInfoFinID',
                    name: "projectinfofin",
                    items: [
                         {
                             xtype: 'app-projectinfofin',
                             itemId: 'projectinfofinID',
                         }
                    ]
                },
                {
                    title: 'K.hoạch t.hiện',
                    layout: 'fit',
                    flex: 1,
                    bind: {
                        disabled: '{IsDisabled}'
                    },
                    itemId: 'tabProjectPlanPerformDetailID',
                    name: 'projectplanperformdetail',
                    items: [
                        {
                            xtype: 'app-projectplanperformdetail',
                            itemId: 'projectplanperformdetailID',
                        }
                    ]
                },
                {
                    title: 'K.hoạch K.phí',
                    layout: 'fit',
                    flex: 1,
                    bind: {
                        disabled: '{IsDisabled}'
                    },
                    itemId: 'tabProjectPlanExpenseDetailID',
                    name: 'projectplanexpensedetail',
                    items: [
                         {
                             xtype: 'app-projectplanexpensedetail',
                             itemId: 'projectplanexpensedetailID',
                         }
                    ]
                },
                {
                    title: 'Nội dung thực hiện đề tài',
                    layout: 'fit',
                    flex: 1,
                    bind: {
                        disabled: '{IsDisabled}'
                    },
                    itemId: 'tabProjectTaskID',
                    name: 'projecttaskdetail',
                    items: [
                         {
                             xtype: 'app-projecttask',
                             itemId: 'projecttaskID',
                         }
                    ]
                },
                {
                    title: 'Thành viên tham gia đề tài',
                    layout: 'fit',
                    flex: 1,
                    bind: {
                        disabled: '{IsDisabled}'
                    },
                    itemId: 'tabProjectMemberID',
                    name: 'projectmember',
                    items: [
                         {
                             xtype: 'app-projectmember',
                             itemId: 'projectmemberID',
                         }
                    ]
                },

                {
                    title: 'Thông tin hội thảo',
                    layout: 'fit',
                    flex: 1,
                    bind: {
                        disabled: '{IsDisabled}'
                    },
                    itemId: 'tabProjectWorkshopID',
                    name: 'projectworkshop',
                    items: [
                         {
                             xtype: 'app-projectworkshop',
                             itemId: 'projectworkshopID',
                         }
                    ]
                },
                {
                    title: 'Thông tin khảo sát',
                    layout: 'fit',
                    flex: 1,
                    bind: {
                        disabled: '{IsDisabled}'
                    },
                    itemId: 'tabProjectSurveyID',
                    name: 'projectsurvey',
                    items: [
                         {
                             xtype: 'app-projectsurvey',
                             itemId: 'projectsurveyItemId',
                             cls: 'projectsurvey-wrap'
                         }
                    ]
                },
                {
                    title: 'Thông tin thử nghiệm',
                    layout: 'fit',
                    flex: 1,
                    bind: {
                        disabled: '{IsDisabled}'
                    },
                    itemId: 'tabProjectExperimentID',
                    name: 'projectexperiment',
                    items: [
                         {
                             xtype: 'app-projectexperiment',
                             itemId: 'projectexperimentItemId',
                             cls: 'projectexperiment-wrap'
                         }
                    ]
                },
                {
                    title: 'Báo cáo tiến độ',
                    layout: 'fit',
                    name: 'projectprogressreport',
                    flex: 1,
                    bind: {
                        disabled: '{IsDisabled}'
                    },
                    itemId: 'tabProjectProgressReportID',
                    items: [
                         {
                             xtype: 'app-projectprogressreport',
                             itemId: 'projectprogressreportID',
                         }
                    ]
                },
                {
                    title: 'Nghiệm thu cơ sở',
                    layout: 'fit',
                    flex: 1,
                    bind: {
                        disabled: '{IsDisabled}'
                    },
                    itemId: 'tabProjectAcceptanceBasicDetailID',
                    name: 'projectacceptancebasicdetail',
                    items: [
                         {
                             xtype: 'app-projectacceptancebasicdetail',
                             itemId: 'projectacceptancebasicdetailID',
                         }
                    ]
                },
                {
                    title: 'Nghiệm thu cấp quản lý',
                    layout: 'fit',
                    flex: 1,
                    bind: {
                        disabled: '{IsDisabled}'
                    },
                    itemId: 'tabProjectAcceptanceManageDetailID',
                    name: 'projectacceptancemanagedetail',
                    items: [
                         {
                             xtype: 'app-projectacceptancemanagedetail',
                             itemId: 'projectacceptancemanagedetailID'
                         }
                    ]
                },
                {
                    title: 'Đóng đề tài',
                    layout: 'fit',
                    flex: 1,
                    bind: {
                        disabled: '{IsDisabled}'
                    },
                    itemId: 'tabProjectCloseDetailID',
                    name: "projectclosedetail",
                    items: [
                         {
                             xtype: 'app-projectclosedetail',
                             itemId: 'projectclosedetailItemId',
                             cls: 'projectclosedetail-wrap'
                         }
                    ]
                },
                
            ],

        };
    },
});
