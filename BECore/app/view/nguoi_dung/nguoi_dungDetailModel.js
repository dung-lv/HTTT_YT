/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.nguoi_dung.nguoi_dungDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.nguoi_dungDetail',

    requires: [
        'QLDT.model.Customer'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.Customer'
        },
        Gender: {
            fields: [
                { name: 'text', type: 'string' },
                { name: 'value', type: 'int' },
            ],
            data: [
                { text: 'Nam', value: 0 },
                { text: 'Nữ', value: 1 },
            ]
        },
    }
});
