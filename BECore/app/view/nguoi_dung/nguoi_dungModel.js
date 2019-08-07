/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.nguoi_dung.nguoi_dungModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.nguoi_dung',

    requires: [
        'QLDT.model.Customer',
        'QLDT.view.control.MTStore'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            remoteFilter: true,
            model: 'QLDT.model.Customer',
            proxy: {
                type: 'mtproxy',
                isRemovePaging: false,
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Customer')
                },
                reader: { type: 'json' }
            }
        },
    }
});
