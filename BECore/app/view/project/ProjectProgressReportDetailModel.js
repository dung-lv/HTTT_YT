/**
 * Thêm tệp đính kèm
 * Create by: laipv:01.02.2018
 */
Ext.define('QLDT.view.project.ProjectProgressReportDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectProgressReportDetail',
    requires: [
       'QLDT.model.Employee',
       'QLDT.model.Term',
       'QLDT.model.ProjectPosition',
       'QLDT.model.ProjectProgressReport',
        'QLDT.view.control.MTStore',
        'QLDT.model.ProjectProgressReport_AttachDetail'
    ],
    stores:
        {
            projectPositionStore: {
                type: 'mtstore',
                model: 'QLDT.model.ProjectPosition',
                proxy: {
                    type: 'mtproxy',
                    actionMethods: {
                        read: 'GET'
                    },
                    api: {
                        read: QLDT.utility.Utility.createUriAPI('/ProjectPositions/GetAllByEditMode')
                    },
                    reader: { type: 'json' }
                }
            },
            employeeStore: {
                xtype: 'mtstore',
                model: 'QLDT.model.Employee',
                proxy: {
                    type: 'mtproxy',
                    actionMethods: {
                        read: 'GET'
                    },
                    api: {
                        read: QLDT.utility.Utility.createUriAPI('/Employees/GetAllByEditMode')
                    },
                    reader: { type: 'json' }
                }
            },
            masterStore: {
                xtype: 'mtstore',
                model: 'QLDT.model.ProjectProgressReport',
                proxy: {
                    type: 'mtproxy',
                    actionMethods: {
                        read: 'GET'
                    },
                    api: {
                        read: QLDT.utility.Utility.createUriAPI('/ProjectProgressReport/GetByMasterID')
                    },
                    reader: { type: 'json' }
                }
            },
            detail: {
                xtype: 'mtstore',
                setField: 'Details',
                model: 'QLDT.model.ProjectProgressReport_AttachDetail',
                proxy: {
                    type: 'mtproxy',
                    actionMethods: {
                        read: 'GET'
                    },
                    api: {
                        read: QLDT.utility.Utility.createUriAPI('/ProjectProgressReport_AttachDetail/GetByMasterID')
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
            termStore: {
                xtype: 'mtstore',
                model: 'QLDT.model.Term',
                proxy: {
                    type: 'mtproxy',
                    actionMethods: {
                        read: 'GET'
                    },
                    api: {
                        read: QLDT.utility.Utility.createUriAPI('/Terms/GetAllByEditMode?editMode=1')
                    },
                    reader: { type: 'json' }
                }
            },
            
        }
});
