/**
 * Thêm tệp đính kèm
 * Create by: laipv:01.02.2018
 */
Ext.define('QLDT.view.project.ProjectWorkshopDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectWorkshopDetail',
    requires: [
       'QLDT.model.Employee',
       'QLDT.model.ProjectPosition',
       'QLDT.model.ProjectWorkshop',
        'QLDT.view.control.MTStore',
        'QLDT.model.ProjectWorkshop_AttachDetail'
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
                model: 'QLDT.model.ProjectWorkshop',
                proxy: {
                    type: 'mtproxy',
                    actionMethods: {
                        read: 'GET'
                    },
                    api: {
                        read: QLDT.utility.Utility.createUriAPI('/ProjectWorkshop/GetByMasterID')
                    },
                    reader: { type: 'json' }
                }
            },
            detail: {
                xtype: 'mtstore',
                setField: 'Details',
                model: 'QLDT.model.ProjectWorkshop_AttachDetail',
                proxy: {
                    type: 'mtproxy',
                    actionMethods: {
                        read: 'GET'
                    },
                    api: {
                        read: QLDT.utility.Utility.createUriAPI('/ProjectWorkshop_AttachDetail/GetByMasterID')
                    },
                    reader: { type: 'json' }
                }
            },
        }
});
