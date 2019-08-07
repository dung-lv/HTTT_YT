/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.auditlaboday.AuditlabodayModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.Auditlaboday',

    requires: [
        'QLDT.model.AuditLaboday',
        'QLDT.model.ProjectTask',
        'QLDT.model.ProjectTaskMemberFinance',
        'QLDT.model.Employee',
        'QLDT.view.control.MTStore'
    ],
    stores: {
        auditStore: {
            type: 'mtstore',
            model: 'QLDT.model.AuditLaboday',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Projects/GetListReportProjectTaskMemberFinanceByCompanyIDAndEmployeeIDAndProjectID')
                },
                reader: { type: 'json' }
            }
        },

        projectStore: {
            type: 'mtstore',
            model: 'QLDT.model.Project',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Projects/GetAllByEditMode?editMode=1')
                },
                reader: { type: 'json' }
            }
        },
      
        employeeStore: {
            type: 'mtstore',
            model: 'QLDT.model.Employee',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Employees/GetEmployeesByCompanyID')
                },
                reader: { type: 'json' }
            }
        },

        companyStore: {
            type: 'mtstore',
            model: 'QLDT.model.Company',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Company/GetAllByEditMode?editMode=0')
                },
                reader: { type: 'json' }
            }
        },

        monthStore: {
            type: 'mtstore',
            fields: [
                      { name: 'Value', type: 'int' },
                      { name: 'Text', type: 'string' }
            ],
            data: [
                { Value: 1, Text: 'Tháng 1' },
                { Value: 2, Text: 'Tháng 2' },
                { Value: 3, Text: 'Tháng 3' },
                { Value: 4, Text: 'Tháng 4' },
                { Value: 5, Text: 'Tháng 5' },
                { Value: 6, Text: 'Tháng 6' },
                { Value: 7, Text: 'Tháng 7' },
                { Value: 8, Text: 'Tháng 8' },
                { Value: 9, Text: 'Tháng 9' },
                { Value: 10, Text: 'Tháng 10' },
                { Value: 11, Text: 'Tháng 11' },
                { Value: 12, Text: 'Tháng 12' }
            ]
        },
        yearStore: {
            type: 'mtstore',
            fields: [
                      { name: 'Value', type: 'int' },
                      { name: 'Text', type: 'string' }
            ],
            data: [
                { Value: 2018, Text: '2018' },
                { Value: 2017, Text: '2017' },
                { Value: 2016, Text: '2016' },
                { Value: 2015, Text: '2015' }
            ]
        }
    }
});
