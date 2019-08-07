/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectPlanExpenseDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectPlanExpenseDetail',

    requires: [
        'QLDT.model.ProjectPlanExpense',
         'QLDT.view.control.MTStore',
         'QLDT.model.ProjectPlanExpense_AttachDetail'
    ],
    stores: {
        
        detail: {
            xtype: 'mtstore',
            setField: 'Details',
            model: 'QLDT.model.ProjectPlanExpense_AttachDetail',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectPlanExpense_AttachDetail/GetByMasterID')
                },
                reader: { type: 'json' }
            }
        },
        //statusStore: {
        //    fields: [
        //            { name: 'text', type: 'string' },
        //            { name: 'value', type: 'int' },
        //    ],
        //    data: [
        //            { text: 'Đang đề xuất', value: 11 },
        //            { text: 'Đang xét duyệt', value: 12 },
        //            { text: 'Đã gửi lên cấp trên', value: 13 },
        //            { text: 'Đã phê duyệt', value: 14 },
        //            { text: 'Đã đưa vào thực hiện', value: 21 },
        //            { text: 'Chờ nghiệm thu', value: 22 },
        //            { text: 'Đã nghiệm thu cấp cơ sở', value: 23 },
        //            { text: 'Đã nghiệm thu cấp quản lý', value: 24 },
        //            { text: 'Đã đóng đề tài', value: 31 },
        //    ]
        //}
    }
});
