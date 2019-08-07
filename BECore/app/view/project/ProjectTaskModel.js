/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectTaskModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectTask',

    requires: [
        'QLDT.view.control.MTStore',
        'QLDT.model.ProjectTask'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            autoload: false, 
            model: 'QLDT.model.ProjectTask',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('ProjectTasks/ByMasterID')
                },
                reader: { type: 'json' }
            },
            root: {
                text: 'Data',
                expanded: true
            }
        }
    }
});
