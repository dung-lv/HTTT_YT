/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectAcceptanceBasicDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectAcceptanceBasicDetail',

    requires: [
        'QLDT.model.ProjectAcceptanceBasic',
         'QLDT.view.control.MTStore',
         'QLDT.model.ProjectAcceptanceBasic_AttachDetail'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.ProjectAcceptanceBasic',
            data: [
                { ProjectName: '535', EmployeeID_Name: 'Thiếu úy CN trung cấp nhóm 1', StartDate: '', EndDate: '' },
                 { ProjectName: '030', EmployeeID_Name: 'Hạ sỹ', StartDate: '', EndDate: '' },
            ]
        },

        detail: {
            xtype: 'mtstore',
            setField: 'Details',
            model: 'QLDT.model.ProjectAcceptanceBasic_AttachDetail',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectAcceptanceBasic_AttachDetail/GetByMasterID')
                },
                reader: { type: 'json' }
            }
        },

        statusStore: {
            fields: [
                {
                    name: 'text', type: 'string'
                },
                {
                    name: 'value', type: 'int'
                }
            ],
            data: [
                { text: 'Đạt', value: 11 },
                { text: 'Không đạt', value: 12 }
            ]
        }
    }
});
