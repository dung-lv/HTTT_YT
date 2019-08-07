/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.academicrank.AcademicRankDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.AcademicRankDetail',

    requires:[
        'QLDT.model.AcademicRank'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.AcademicRank',
            data:[
                { AcademicRankCode: 'GS', RankName: 'Giáo sư', Description: '', Inactive: false },
            ]
        }
    }
});
