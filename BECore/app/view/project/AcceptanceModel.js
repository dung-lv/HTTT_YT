/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.AcceptanceModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.Acceptance',

    requires: [
        'QLDT.model.Project'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',          
            model: 'QLDT.model.Project',
            proxy: {
                type: 'mtproxy',
                isRemovePaging: false,
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Projects/GetProjectFinishs')
                },
            }
        }
    }
});
