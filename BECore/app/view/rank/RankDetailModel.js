/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.rank.RankDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.RankDetail',

    requires:[
        'QLDT.model.Rank'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.Rank',
            data:[
                { RankCode: '535', RankName: 'Thiếu úy CN trung cấp nhóm 1', Description: '', Inactive:false },
                 { RankCode: '030', RankName: 'Hạ sỹ', Description: '', Inactive: false },
            ]
        }
    }
});
