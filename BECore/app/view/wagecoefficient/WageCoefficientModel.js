/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.wagecoefficient.WageCoefficientModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.WageCoefficient',

    requires: [
        'QLDT.model.GrantRatio',
        'QLDT.model.WageCoefficient',
        'QLDT.view.control.MTStore'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            model: 'QLDT.model.WageCoefficient',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/WageCoefficients/GetListWageCoefficients')
                },
                reader: { type: 'json' }
            }
        },

        grantRatioStore: {
            type: 'mtstore',
            model: 'QLDT.model.GrantRatio',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/GrantRatios/GetAllByEditMode?editMode=1')
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
