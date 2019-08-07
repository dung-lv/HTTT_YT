/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.ho_so_kham_benh.ho_so_kham_benhModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ho_so_kham_benh',

    requires: [
        'QLDT.model.MedicalRecord',
        'QLDT.view.control.MTStore'
    ],

    stores: {
        masterStore: {
            type: 'mtstore',
            remoteFilter: true,
            model: 'QLDT.model.MedicalRecord',
            proxy: {
                type: 'mtproxy',
                isRemovePaging: false,
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/MedicalRecord')
                },
                reader: { type: 'json' }
            }
        },
    }
});
