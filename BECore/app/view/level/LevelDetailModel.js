/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.level.LevelDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.LevelDetail',

    requires:[
        'QLDT.model.Level'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.Level',
            data:[
                { LevelCode: '1', LevelName: 'Đề tài, nhiệm vụ cấp Nhà nước', Description: '', Inactive: false },
                 { LevelCode: '2', LevelName: 'Đề tài, nhiệm vụ cấp BQP', Description: '', Inactive: false },
            ]
        }
    }
});
