/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectMemberModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectMember',

    requires:[
        'QLDT.model.ProjectMember'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectMember',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectMember/ByMasterID')
                },
                reader: { type: 'json' }
            }
        },
    }
});
