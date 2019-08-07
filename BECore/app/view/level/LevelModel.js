/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.level.LevelModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.Level',

    requires: [
        'QLDT.model.Level',
        'QLDT.view.control.MTStore'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            remoteFilter: true,
            model: 'QLDT.model.Level',
            proxy: {
                type: 'mtproxy',
                isRemovePaging: false,
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Levels')
                },
                reader: { type: 'json' }
            }
        },

        statusStore: {
            type: 'mtstore',
            fields:
                [
                    { name: 'Text', type: 'string' },
                    { name: 'Value', type: 'int' },
                ],
            data:
            [
                { Text: 'Tất cả', Value: -1 },
                { Text: 'Đang theo dõi', Value: 0 },
                { Text: 'Ngừng theo dõi', Value: 1 }
            ]
        }
    }
});
