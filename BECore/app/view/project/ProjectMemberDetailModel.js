/**
 * Thêm tệp đính kèm
 * Create by: laipv:01.02.2018
 */
Ext.define('QLDT.view.project.ProjectMemberDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectMemberDetail',
    requires: [
       'QLDT.model.Employee',
       'QLDT.model.ProjectPosition'
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
        }
});
