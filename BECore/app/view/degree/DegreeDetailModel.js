/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.degree.DegreeDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.DegreeDetail',

    requires:[
        'QLDT.model.Degree'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.Degree',
            data:[
                { DegreeCode: '535', DegreeName: 'Thiếu úy CN trung cấp nhóm 1', Description: '', Inactive:false },
                 { DegreeCode: '030', DegreeName: 'Hạ sỹ', Description: '', Inactive: false },
            ]
        }
    }
});
