/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ExecutableModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.Executable',

    requires: [
        'QLDT.view.control.MTTreeStore',
        'QLDT.model.Task'
    ],
    stores: {
        masterTreeStore: {
            type: 'mttreestore',          
            model: 'QLDT.model.Task',
            proxy: {
                type: 'mtproxy',
                isRemovePaging: false,
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Projects/GetAcceptances')
                },
            }
           
        }
    }
});
