/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.projectposition.ProjectPositionDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectPositionDetail',

    requires:[
        'QLDT.model.ProjectPosition'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.ProjectPosition',
            data:[
                { ProjectPositionCode: '535', ProjectPositionName: 'Thiếu úy CN trung cấp nhóm 1', Description: '', Inactive:false },
                 { ProjectPositionCode: '030', ProjectPositionName: 'Hạ sỹ', Description: '', Inactive: false },
            ]
        }
    }
});
