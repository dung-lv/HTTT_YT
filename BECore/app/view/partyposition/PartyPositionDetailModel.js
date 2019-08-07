/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.partyposition.PartyPositionDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.PartyPositionDetail',

    requires:[
        'QLDT.model.PartyPosition'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.PartyPosition',
            data:[
                { PositionCode: '535', PositionName: 'Đảng viên', Description: '', Inactive:false },
                 { PositionCode: '030', PositionName: 'Bí thư chi bộ', Description: '', Inactive: false },
            ]
        }
    }
});
