/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.Project',

    requires: [
        'QLDT.model.Project',
        'QLDT.view.control.MTStore'
    ],
    stores: {
        masterStore: {
            type:'mtstore',
            model: 'QLDT.model.Project',            
            proxy: {
                type: 'mtproxy',
                isRemovePaging:false,
                actionMethods:{
                    read:'GET'
                },
                api:{
                    read: QLDT.utility.Utility.createUriAPI('/Projects/GetProjectOffers')
                },
                reader: 'mtreader'
            }
        }
    }
});
