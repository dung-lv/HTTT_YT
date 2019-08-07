/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.ho_so_kham_benh.ho_so_kham_benhDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ho_so_kham_benhDetail',

    requires: [
        'QLDT.model.MedicalRecord',
        'QLDT.model.MeasurementStandard',
        'QLDT.model.Customer'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.MedicalRecord'
        },
        MeasurementStandardStore: {
            xtype: 'mtstore',
            model: 'QLDT.model.MeasurementStandard',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/MeasurementStandard/GetAll')
                },
                reader: { type: 'json' }
            }
        },
        Customer: {
            xtype: 'mtstore',
            model: 'QLDT.model.Customer',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Customer/GetAll')
                },
                reader: { type: 'json' }
            }
        },
    }
});
