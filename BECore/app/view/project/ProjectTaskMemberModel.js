/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectTaskMemberModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectTaskMember',

    requires: [
        'QLDT.model.ProjectTaskMember',
        'QLDT.model.ProjectMember'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectTaskMember',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectTaskMember/ByMasterID')
                },
                reader: { type: 'json' }
            }
        },

        
        
        
        employeeStore: {
            xtype: 'mtstore',
            model: 'QLDT.model.Employee',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Employees/ByMasterID')
                },
                reader: { type: 'json' }
            }
        },
    }
});
