/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectPlanPerformDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectPlanPerformDetail',

    requires:[
        'QLDT.model.ProjectPlanPerform',
         'QLDT.view.control.MTStore',
         'QLDT.model.ProjectPlanPerform_AttachDetail'
    ],
    stores: {
        masterStore: {
            xtype: 'mtstore',
            model: 'QLDT.model.ProjectPlanPerform',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectPlanPerform/GetByMasterID')
                },
                reader: { type: 'json' }
            }
        },
        detail: {
            xtype: 'mtstore',
            setField: 'Details',
            model: 'QLDT.model.ProjectPlanPerform_AttachDetail',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectPlanPerform_AttachDetail/GetByMasterID')
                },
                reader: { type: 'json' }
            }
        },
    }
});
