/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectProgressReportModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectProgressReport',

    requires:[
        'QLDT.model.ProjectProgressReport'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectProgressReport',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectProgressReport/ByMasterID')
                },
                reader: { type: 'json' }
            }
        },
        resultStore: { // 11: Đảm bảo tiến độ; 12: Chậm tiến độ
            fields: [
                    { name: 'text', type: 'string' },
                    { name: 'value', type: 'int' },
            ],
            data: [
                    { text: 'Đảm bảo tiến độ', value: 11 },
                    { text: 'Chậm tiến độ', value: 12 },
            ]
        },

    }
});
