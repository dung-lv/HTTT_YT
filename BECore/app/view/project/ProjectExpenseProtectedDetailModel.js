/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectExpenseProtectedDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectExpenseProtectedDetail',

    requires:[
        //'QLDT.model.ProjectExpenseProtected',
        'QLDT.view.control.MTStore'
    ],
    stores: {
        masterStore: {
            //model: 'QLDT.model.ProjectExpenseProtected',
            data:[
                { ProjectName: '535', EmployeeID_Name: 'Thiếu úy CN trung cấp nhóm 1', StartDate: '', EndDate: '' },
                 { ProjectName: '030', EmployeeID_Name: 'Hạ sỹ', StartDate: '', EndDate: '' },
            ]
        },
        detail: {
            xtype:'mtstore',
            fields: ['SortOrder', 'FileName', 'FileSize'],
            data: [
                 { 'SortOrder': '1', "FileName": "lisa@simpsons.com", "FileSize": "100" },
                 { 'SortOrder': '2', "FileName": "bart@simpsons.com", "FileSize": "200" },
                 { 'SortOrder': '3', "FileName": "home@simpsons.com", "FileSize": "300" },
                 { 'SortOrder': '4', "FileName": "marge@simpsons.com", "FileSize": "400" }
            ]
        },        
    }
});
