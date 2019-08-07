/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.contractedprofessional.ContractedProfessionalModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ContractedProfessional',

    requires: [
        'QLDT.model.Project',
        'QLDT.model.ContractedProfessional',
        'QLDT.view.control.MTStore'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            model: 'QLDT.model.ContractedProfessional',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ContractedProfessionals/GetListContractedProfessionals')
                },
                reader: { type: 'json' }
            }
        },

        projectStore: {
            type: 'mtstore',
            model: 'QLDT.model.Project',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Projects/GetAllByEditMode?editMode=1')
                },
                reader: { type: 'json' }
            }
        },
    }
});
