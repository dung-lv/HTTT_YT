/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectCloseDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectCloseDetail',

    requires: [
        'QLDT.model.ProjectClose',
         'QLDT.view.control.MTStore',
         'QLDT.model.ProjectClose_AttachDetail'
    ],
    stores: {
        
        detail: {
            xtype: 'mtstore',
            setField: 'Details',
            model: 'QLDT.model.ProjectClose_AttachDetail',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectClose_AttachDetail/GetByMasterID')
                },
                reader: { type: 'json' }
            }
        },
        planAttachStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectClose',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('ProjectCloses/GetByMasterID')
                },
                reader: { type: 'json' }
            }
        }
    }
});
