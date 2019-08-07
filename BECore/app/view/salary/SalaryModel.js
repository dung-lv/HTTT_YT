/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.salary.SalaryModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.Salary',

    requires: [
        'QLDT.model.Salary',
        'QLDT.view.control.MTStore'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            model: 'QLDT.model.Salary',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Salarys/GetListSalarys')
                },
                reader: { type: 'json' }
            }
        },

        yearStore: {
            type: 'mtstore',
            fields: [
                      { name: 'Value', type: 'int' },
                      { name: 'Text', type: 'string' }
            ],
            data: [
                { Value: 2018, Text: '2018' },
                { Value: 2017, Text: '2017' },
                { Value: 2016, Text: '2016' },
                { Value: 2015, Text: '2015' }
            ]
        }
    }
});
