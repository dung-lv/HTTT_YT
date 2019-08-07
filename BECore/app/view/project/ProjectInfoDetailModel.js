/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectInfoDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectInfoDetail',

    requires: [
        'QLDT.model.Project',
        'QLDT.view.control.MTStore',
        'QLDT.model.Project_AttachDetail'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.Project',
            data: [
                { ProjectName: '535', EmployeeID_Name: 'Thiếu úy CN trung cấp nhóm 1', StartDate: '', EndDate: '' },
                 { ProjectName: '030', EmployeeID_Name: 'Hạ sỹ', StartDate: '', EndDate: '' },
            ]
        },
        detail: {
            xtype: 'mtstore',
            setField: 'Details',
            model: 'QLDT.model.Project_AttachDetail',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Project_AttachDetail/GetByMasterID')
                },
                reader: { type: 'json' }
            }
        },
        levelStore: {
            xtype: 'mtstore',
            model: 'QLDT.model.Level',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Levels/GetAllByEditMode?editMode=1')
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
                    read: QLDT.utility.Utility.createUriAPI('/Employees/GetAllByEditMode?editMode=1')
                },
                reader: { type: 'json' }
            }
        },
        grantRatioStore: {
            xtype: 'mtstore',
            model: 'QLDT.model.GrantRatio',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/GrantRatios/GetAllByEditMode?editMode=1')
                },
                reader: { type: 'json' }
            }
        },
        statusStore: {
            fields: [
                    { name: 'text', type: 'string' },
                    { name: 'value', type: 'int' },
            ],
            data: [
                    { text: 'Đang đề xuất', value: 11 },
                    { text: 'Đang xét duyệt', value: 12 },
                    { text: 'Đã gửi lên cấp trên', value: 13 },
                    { text: 'Đã phê duyệt', value: 14 },
                    { text: 'Đã đưa vào thực hiện', value: 21 },
                    { text: 'Chờ nghiệm thu', value: 22 },
                    { text: 'Đã nghiệm thu cấp cơ sở', value: 23 },
                    { text: 'Đã nghiệm thu cấp quản lý', value: 24 },
                    { text: 'Đã đóng đề tài', value: 31 },
            ]
        }
    }
});
