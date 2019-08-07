/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectWorkshopModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectWorkshop',

    requires:[
        'QLDT.model.ProjectWorkshop'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectWorkshop',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectWorkshop/ByMasterID')
                },
                reader: { type: 'json' }
            }
        },
    }
});
