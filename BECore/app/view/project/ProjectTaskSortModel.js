/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectTaskSortModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectTaskSort',

    requires: [
        'QLDT.model.ProjectTask'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectTask',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectTasks/ByProjectTaskID')
                },
                reader: { type: 'json' }
            }
        },
        projectTaskStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectTask',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectTasks/ByProjectID')
                },
                reader: { type: 'json' }
            }
        },
    }
});
