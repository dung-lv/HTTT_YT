/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectDetail',

    requires: [
        'QLDT.model.Project',
        'QLDT.model.ProjectAcceptanceBasic',
        'QLDT.model.ProjectAcceptanceManage',
        'QLDT.model.ProjectPlanPerform',
        'QLDT.model.ProjectPlanExpense',
        'QLDT.model.ProjectClose',
        'QLDT.model.ProjectWorkshop'
    ],


    data:{
        IsDisabled:true
    },
    stores: {
        masterStore: {
            model: 'QLDT.model.Project',
            data: [
                { ProjectName: '535', EmployeeID_Name: 'Thiếu úy CN trung cấp nhóm 1', StartDate: '', EndDate: '' },
                 { ProjectName: '030', EmployeeID_Name: 'Hạ sỹ', StartDate: '', EndDate: '' },
            ]
        },

        projectAcceptanceBasicStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectAcceptanceBasic',

            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectAcceptanceBasics/ByProjectID')
                },
                reader: { type: 'json' }
            }

        },

        projectAcceptanceManageStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectAcceptanceManage',

            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectAcceptanceManages/ByProjectID')
                },
                reader: { type: 'json' }
            }

        },
        projectPlanPerformStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectPlanPerform',

            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectPlanPerforms/ByProjectID')
                },
                reader: { type: 'json' }
            }
        },
        projectPlanExpenseStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectPlanExpense',

            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectPlanExpenses/ByProjectID')
                },
                reader: { type: 'json' }
            }

        },

        projectCloseStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectClose',

            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectCloses/ByProjectID')
                },
                reader: { type: 'json' }
            }

        },
        projectWorkshopStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectWorkshop',

            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectWorkshops/ByProjectID')
                },
                reader: { type: 'json' }
            }

        },
    }
});
