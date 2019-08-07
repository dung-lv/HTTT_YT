/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.position.PositionDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.PositionDetail',

    requires:[
        'QLDT.model.Position'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.Position',
            data:[
                { PositionCode: '535', PositionName: 'Thiếu úy CN trung cấp nhóm 1', Description: '', Inactive:false },
                 { PositionCode: '030', PositionName: 'Hạ sỹ', Description: '', Inactive: false },
            ]
        }
    }
});
