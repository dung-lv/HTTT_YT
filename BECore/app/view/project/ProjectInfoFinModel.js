/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectInfoFinModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectInfoFin',

    requires: [
        'QLDT.model.Project',
        'QLDT.view.control.MTStore'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.Project',
            data: [
                { ProjectName: '535', EmployeeID_Name: 'Thiếu úy CN trung cấp nhóm 1', StartDate: '', EndDate: '' },
                 { ProjectName: '030', EmployeeID_Name: 'Hạ sỹ', StartDate: '', EndDate: '' },
            ]
        },
        grantRatioStore: {
            xtype: 'mtstore',
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
        monthStore: {
            type: 'mtstore',
            fields: [
                      { name: 'Value', type: 'int' },
                      { name: 'Text', type: 'string' }
            ],
            data: [
                { Value: 1, Text: 'Tháng 1' },
                { Value: 2, Text: 'Tháng 2' },
                { Value: 3, Text: 'Tháng 3' },
                { Value: 4, Text: 'Tháng 4' },
                { Value: 5, Text: 'Tháng 5' },
                { Value: 6, Text: 'Tháng 6' },
                { Value: 7, Text: 'Tháng 7' },
                { Value: 8, Text: 'Tháng 8' },
                { Value: 9, Text: 'Tháng 9' },
                { Value: 10, Text: 'Tháng 10' },
                { Value: 11, Text: 'Tháng 11' },
                { Value: 12, Text: 'Tháng 12' }
            ]
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
