/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.employee.EmployeeModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.Employee',

    requires: [
        'QLDT.model.Employee',
        'QLDT.view.control.MTStore'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            remoteFilter: true,
            model: 'QLDT.model.Employee',
            proxy: {
                type: 'mtproxy',
                isRemovePaging: false,
                actionMethods:{
                    read:'GET'
                },
                api:{
                    read: QLDT.utility.Utility.createUriAPI('/Employees')
                },
                reader: { type: 'json' }
            }
        }
    }
});
