/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.daysleft.DaysLeftModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.DaysLeft',

    requires: [
        'QLDT.model.Project',
        'QLDT.model.DaysLeft',
        'QLDT.model.Employee',
        'QLDT.model.Company',
        'QLDT.view.control.MTStore'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            model: 'QLDT.model.DaysLeft',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/DaysLefts/GetListDaysLefts')
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
        companyStore: {
            type: 'mtstore',
            model: 'QLDT.model.Company',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Company/GetAllByEditMode?editMode=1')
                },
                reader: { type: 'json' }
            }
        },
        employeeStore: {
            type: 'mtstore',
            model: 'QLDT.model.Employee',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Employees/GetAllByEditMode?editMode=1')
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
