/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.grantratio.GrantRatioDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.GrantRatioDetail',

    requires:[
        'QLDT.model.GrantRatio'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.GrantRatio',
            data:[
                { GrantRatioCode: '535', GrantRatioName: 'Thiếu úy CN trung cấp nhóm 1', Description: '', Inactive:false },
                 { GrantRatioCode: '030', GrantRatioName: 'Hạ sỹ', Description: '', Inactive: false },
            ]
        }
    }
});
