/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.ql_nguoi_dung.ql_nguoi_dungModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ql_nguoi_dung',

    requires: [
        'QLDT.model.AspNetUsers',
        'QLDT.view.control.MTStore'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            remoteFilter: true,
            model: 'QLDT.model.AspNetUsers',
            proxy: {
                type: 'mtproxy',
                isRemovePaging: false,
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/AspNetUsers')
                },
                reader: { type: 'json' }
            }
        }
    }
});
