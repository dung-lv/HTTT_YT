/**
 * Thêm tệp đính kèm
 * Create by: laipv:04.02.2018
 */
Ext.define('QLDT.view.project.ProjectExperimentDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectExperimentDetail',
    requires: [
        //'QLDT.model.Project',
        'QLDT.view.control.MTStore',
        'QLDT.model.ProjectExperiment_AttachDetail'
    ],
    stores: {
        companyStore: {
            type: 'mtstore',
            model: 'QLDT.model.Company',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Company/GetAllByEditMode')
                },
                reader: { type: 'json' }
            }
        },
        detail: {
            xtype: 'mtstore',
            setField: 'Details',
            model: 'QLDT.model.ProjectExperiment_AttachDetail',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectExperiment_AttachDetail/GetByMasterID')
                },
                reader: { type: 'json' }
            }
        },
    }
});
