/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.dayoff.DayOffDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.DayOffDetail',

    requires:[
        'QLDT.model.DayOff'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.DayOff',
            data:[
                { DayOffCode: '535', DayOffName: 'Thiếu úy CN trung cấp nhóm 1', Description: '', Inactive:false },
                 { DayOffCode: '030', DayOffName: 'Hạ sỹ', Description: '', Inactive: false },
            ]
        }
    }
});
