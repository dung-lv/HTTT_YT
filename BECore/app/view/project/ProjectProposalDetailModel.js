/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectProposalDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectProposalDetail',

    requires:[
        'QLDT.model.Project'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.Project',
            data:[
                { ProjectName: '535', EmployeeID_Name: 'Thiếu úy CN trung cấp nhóm 1', StartDate: '', EndDate: '' },
                 { ProjectName: '030', EmployeeID_Name: 'Hạ sỹ', StartDate: '', EndDate: '' },
            ]
        }
    }
});
