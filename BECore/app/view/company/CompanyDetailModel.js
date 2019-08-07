/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.company.CompanyDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.CompanyDetail',

    requires:[
        'QLDT.model.Company'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.Company',
            data:[
                { CompanyCode: '', CompanyName: '', Description: '', Inactive: false },
            ]
        }
    }
});
