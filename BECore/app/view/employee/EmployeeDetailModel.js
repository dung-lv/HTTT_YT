/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.employee.EmployeeDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.EmployeeDetail',

    requires: [
        'QLDT.model.Employee',
        'QLDT.model.Position',
        'QLDT.model.Rank'
    ],
    stores: {
        masterStore: {
            model: 'QLDT.model.Employee',
            data: [
                { EmployeeCode: '535', EmployeeName: 'Thiếu úy CN trung cấp nhóm 1', Description: '', Inactive: false },
                 { EmployeeCode: '030', EmployeeName: 'Hạ sỹ', Description: '', Inactive: false },
            ]
        },
        genderStore: {
            fields: [
                    { name: 'text', type: 'string' },
                    { name: 'value', type: 'int' },
            ],
            data:[
                    { text: 'Nam', value: 0 },
                    { text: 'Nữ', value: 1 },
                 ]
        },
        academicRankStore: {
            type: 'mtstore',
            model: 'QLDT.model.AcademicRank',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/AcademicRanks/GetAllByEditMode')
                },
                reader: { type: 'json' }
            }
        },
        degreeStore: {
            type: 'mtstore',
            model: 'QLDT.model.Degree',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Degrees/GetAllByEditMode')
                },
                reader: { type: 'json' }
            }
        },
        companyStore: {
            type: 'mtstore',
            model: 'QLDT.model.Company',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Company/GetAllByEditMode')
                },
                reader: { type: 'json' }
            }
        },
        positionStore: {
            type: 'mtstore',
            model: 'QLDT.model.Position',           
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Positions/GetAllByEditMode')
                },
                reader: { type: 'json' }
            }
        },
        rankStore: {
            type: 'mtstore',
            model: 'QLDT.model.Rank',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/Ranks/GetAllByEditMode')
                },
                reader: { type: 'json' }
            }
        },
    }
});
