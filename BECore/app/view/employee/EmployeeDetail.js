Ext.define('QLDT.view.employee.EmployeeDetail', {
    extend: 'QLDT.view.base.BasePopupDetail',
    xtype: 'app-employeedetail',
    requires: [
        'QLDT.view.base.BasePopupDetail',
        'QLDT.view.employee.EmployeeDetailController',
        'QLDT.view.employee.EmployeeDetailModel',
        'QLDT.view.control.MTCheckbox',
        'QLDT.view.control.MTImageUpload'

    ],

    controller: 'EmployeeDetail',
    viewModel: 'EmployeeDetail',

    height: 620,
    width: 900,
    layout: 'fit',

    /*
     * Vẽ nội dung của form
     * Create by: dvthang:09.01.2018
     */

    getContent: function () {
        return {
            xtype: 'MTTabPanel',
            flex: 1,
            region: 'center',
            appendCls: 'tab-panel-project-detail',
            tabRotation: 0,
            tabBar: {
                border: false
            },
            bodyPadding: '8 8 16 16',
            items: [
                {
                    title: 'Thông tin chung',
                    layout: {
                        type: 'vbox',
                        align: 'stretch',
                    },
                    autoScroll: true,
                    flex: 1,
                    items: [{
                        xtype: 'fieldcontainer',
                        layout: {
                            type: 'column',
                            align: 'stretch',
                        },
                        items: [{
                            layout: {
                                type: 'vbox',
                                align: 'stretch',
                            },
                            columnWidth: 0.8,
                            items: [{
                                xtype: 'MTTextField',
                                fieldLabel: 'Mã cán bộ (*) ',
                                name: 'EmployeeCode',
                                bind: '{masterData.EmployeeCode}',
                                itemId: 'employeeCodeId',
                                allowBlank: false,
                                maxLength: 64,
                            },
                                {
                                    xtype: 'fieldcontainer',
                                    layout: {
                                        type: 'hbox',
                                        align: 'stretch',
                                    },
                                    margin: '0 0 8 0',
                                    items: [{
                                        xtype: 'MTTextField',
                                        fieldLabel: 'Họ + đệm (*) ',
                                        name: 'LastName',
                                        bind: '{masterData.LastName}',
                                        itemId:'lastNameId',
                                        allowBlank: false,
                                        maxLength: 128,
                                    },
                                        {
                                            xtype: 'MTTextField',
                                            fieldLabel: 'Tên (*) ',
                                            flex: 1,
                                            labelWidth: 120,
                                            name: 'FirstName',
                                            bind: '{masterData.FirstName}',
                                            allowBlank: false,
                                            margin: '0 0 0 8',
                                            maxLength: 128,
                                            itemId:'firstNameId'
                                        }
                                    ]
                                },
                                {
                                    xtype: 'fieldcontainer',
                                    layout: {
                                        type: 'hbox',
                                        align: 'stretch',
                                    },
                                    items: [{
                                        xtype: 'MTDateField',
                                        fieldLabel: 'Ngày sinh (*) ',
                                        itemId: 'birthDayID',
                                        name: 'BirthDay',
                                        bind: '{masterData.BirthDay}',
                                        allowBlank: false,
                                    },
                                        {
                                            xtype: 'MTComboBox',
                                            fieldLabel: 'Giới tính (*) ',
                                            margin: '0 0 0 8',
                                            flex: 1,
                                            name: 'Gender',
                                            displayField: 'text',
                                            valueField: 'value',
                                            labelWidth: 120,
                                            bind: {
                                                value: '{masterData.Gender}',
                                                store: '{genderStore}'
                                            },

                                            allowBlank: false,
                                        },
                                    ]
                                },



                            ]
                        },
                            {
                                xtype: 'MTImageUpload',
                                columnWidth: 0.2,
                                itemId: 'uploadImg',
                                bind: {
                                    FileResourceID: '{masterData.FileResourceID}'
                                },
                                name: 'PathImage',
                                margin: '0 8 0 10',
                                buttonText: 'Chọn ảnh',
                            },
                        ]
                    },


                        {
                            xtype: 'fieldcontainer',
                            layout: {
                                type: 'hbox',
                                align: 'stretch',
                            },
                            items: [{
                                fieldLabel: 'Học hàm ',
                                name: 'AcademicRankID',
                                valueField: 'AcademicRankID',
                                displayField: 'AcademicRankName',
                                bind: {
                                    value: '{masterData.AcademicRankID}',
                                    store: '{academicRankStore}'
                                },
                                allowBlank: false,
                                flex: 1,
                                xtype: 'MTComboBox'
                            },
                                {
                                    labelWidth: 120,
                                    fieldLabel: 'Năm được phong ',
                                    name: 'YearOfAcademicRank',
                                    bind: '{masterData.YearOfAcademicRank}',
                                    allowBlank: false,
                                    margin: '0 8 0 8',
                                    flex: 1,
                                    xtype: 'MTNumberField'
                                }
                            ]
                        },

                        {
                            xtype: 'fieldcontainer',
                            layout: {
                                type: 'hbox',
                                align: 'stretch',
                            },
                            items: [{
                                fieldLabel: 'Học vị ',
                                name: 'DegreeID',
                                bind: '{masterData.DegreeID}',
                                valueField: 'DegreeID',
                                displayField: 'DegreeName',
                                bind: {
                                    value: '{masterData.DegreeID}',
                                    store: '{degreeStore}'
                                },

                                allowBlank: false,
                                flex: 1,
                                xtype: 'MTComboBox'
                            },
                                {
                                    fieldLabel: 'Năm được phong ',
                                    labelWidth: 120,
                                    name: 'YearOfDegree',
                                    bind: '{masterData.YearOfDegree}',
                                    allowBlank: false,
                                    margin: '0 8 0 8',
                                    flex: 1,
                                    xtype: 'MTNumberField'
                                }
                            ]
                        },

                        {
                            xtype: 'fieldcontainer',
                            layout: {
                                type: 'hbox',
                                align: 'stretch',
                            },
                            items: [{
                                flex: 1,
                                fieldLabel: 'Đơn vị (*) ',
                                name: 'CompanyID',
                                bind: {
                                    value: '{masterData.CompanyID}',
                                    store: '{companyStore}'
                                },
                                allowBlank: false,
                                xtype: 'MTComboBox',
                                displayField: 'CompanyName',
                                valueField: 'CompanyID'
                            },
                                {
                                    flex: 1,
                                    fieldLabel: 'Chức vụ (*) ',
                                    name: 'PositionID',
                                    allowBlank: false,
                                    labelWidth: 120,
                                    margin: '0 8 0 8',
                                    xtype: 'MTComboBox',
                                    displayField: 'PositionName',
                                    valueField: 'PositionID',
                                    bind: {
                                        value: '{masterData.PositionID}',
                                        store: '{positionStore}'
                                    },
                                }
                            ]
                        },

                        {
                            xtype: 'fieldcontainer',
                            layout: {
                                type: 'hbox',
                            },
                            items: [{
                                flex: 1,
                                fieldLabel: 'Cấp bậc ',
                                name: 'RankID',
                                bind: '{masterData.RankID}',
                                xtype: 'MTComboBox',
                                displayField: 'RankName',
                                valueField: 'RankID',
                                bind: {
                                    value: '{masterData.RankID}',
                                    store: '{rankStore}'
                                },
                            },
                                {
                                    labelWidth: 120,
                                    fieldLabel: 'Số di động ',
                                    margin: '0 8 0 8',
                                    flex: 1,
                                    name: 'Mobile',
                                    bind: '{masterData.Mobile}',
                                    maxLength: 64,
                                    xtype: 'MTTextField',
                                    allowBlank: false,
                                },
                            ]
                        },
                        {
                            xtype: 'fieldcontainer',
                            layout: {
                                type: 'hbox',
                                align: 'stretch',
                            },
                            items: [{
                                margin: '0 8 0 0',
                                flex: 1,
                                fieldLabel: 'Số CMT (*) ',
                                name: 'IDNumber',
                                bind: '{masterData.IDNumber}',
                                maxLength: 20,
                                xtype: 'MTTextField',
                                allowBlank: false,
                            }]
                        },
                            {
                                xtype: 'fieldcontainer',
                                layout: {
                                    type: 'hbox',
                                    align: 'stretch',
                                },
                                items: [{
                                    flex: 1,
                                    fieldLabel: 'Nơi cấp (*) ',
                                    name: 'IssuedBy',
                                    bind: '{masterData.IssuedBy}',
                                    maxLength: 255,
                                    xtype: 'MTTextField',
                                    allowBlank: false,
                                },
                                    {
                                        labelWidth: 120,
                                        flex: 1,
                                        fieldLabel: 'Ngày cấp (*) ',
                                        margin: '0 8 0 8',
                                        name: 'DateBy',
                                        bind: '{masterData.DateBy}',
                                        xtype: 'MTDateField',
                                        allowBlank: false,
                                    },

                                ]
                            },
                            {
                                xtype: 'fieldcontainer',
                                layout: {
                                    type: 'hbox',
                                    align: 'stretch',
                                },
                                items: [{
                                    flex: 1,
                                    fieldLabel: 'Số tài khoản (*) ',
                                    name: 'AccountNumber',
                                    bind: '{masterData.AccountNumber}',
                                    maxLength: 20,
                                    xtype: 'MTTextField',
                                    allowBlank: false,
                                },
                                    {
                                        labelWidth: 120,
                                        flex: 1,
                                        fieldLabel: 'Ngân hàng (*) ',
                                        margin: '0 8 0 8',
                                        name: 'Bank',
                                        bind: '{masterData.Bank}',
                                        maxLength: 255,
                                        xtype: 'MTTextField',
                                        allowBlank: false,
                                    },

                                ]
                            },

                    ],
                },

                {
                    title: 'Thông tin cá nhân',
                    layout: {
                        type: 'vbox',
                        align: 'stretch'
                    },
                    flex: 1,
                    items: [
                        {
                            xtype: 'fieldcontainer',
                            layout: {
                                type: 'hbox',
                                align: 'stretch',
                            },
                            margin: '0 0 8 0',
                            items: [{
                                flex: 1,
                                fieldLabel: 'Nơi sinh ',
                                name: 'BirthPlace',
                                bind: '{masterData.BirthPlace}',
                                maxLength: 255,
                                xtype: 'MTTextField'
                            },
                                {
                                    flex: 1,
                                    fieldLabel: 'Nguyên quán ',
                                    name: 'HomeLand',
                                    margin: '0 8 0 8',
                                    bind: '{masterData.HomeLand}',
                                    maxLength: 255,
                                    xtype: 'MTTextField'
                                },
                            ]
                        },
                        {
                            xtype: 'fieldcontainer',
                            layout: {
                                type: 'hbox',
                                align: 'stretch',
                            },
                            items: [{
                                flex: 1,
                                fieldLabel: 'Nơi thường trú ',
                                name: 'NativeAddress',
                                bind: '{masterData.NativeAddress}',
                                maxLength: 255,
                                xtype: 'MTTextField',
                                margin: '0 8 0 0',
                            }]
                        },
                        {
                            xtype: 'fieldcontainer',
                            layout: {
                                type: 'hbox',
                                align: 'stretch',
                            },
                            items: [{
                                flex: 1,
                                fieldLabel: 'SĐT cơ quan ',
                                name: 'Tel',
                                bind: '{masterData.Tel}',
                                maxLength: 255,
                                xtype: 'MTTextField'
                            },
                            {
                                flex: 1,
                                margin: '0 8 0 8',
                                fieldLabel: 'ĐC cơ quan ',
                                name: 'OfficeAddress',
                                bind: '{masterData.OfficeAddress}',
                                maxLength: 255,
                                xtype: 'MTTextField'
                            }
                            ]
                        },
                        {
                            xtype: 'fieldcontainer',
                            layout: {
                                type: 'hbox',
                                align: 'stretch',
                            },
                            items: [{
                                flex: 1,
                                fieldLabel: 'Website ',
                                name: 'Website',
                                bind: '{masterData.Website}',
                                maxLength: 64,
                                xtype: 'MTTextField'
                            },
                            {
                                flex: 1,
                                fieldLabel: 'Email ',
                                margin: '0 8 0 8',
                                name: 'Email',
                                bind: '{masterData.Email}',
                                maxLength: 255,
                                xtype: 'MTTextField'
                            },
                            ]
                        },
                        {
                            xtype: 'fieldcontainer',
                            layout: {
                                type: 'hbox',
                                align: 'stretch',
                            },
                            items: [
                                {
                                    flex: 1,
                                    fieldLabel: 'ĐC nhà riêng ',
                                    name: 'HomeAddress',
                                    bind: '{masterData.HomeAddress}',
                                    maxLength: 255,
                                    xtype: 'MTTextField'
                                },
                                {
                                    fieldLabel: 'Fax ',
                                    flex: 1,
                                    margin: '0 8 0 8',
                                    name: 'Fax',
                                    bind: '{masterData.Fax}',
                                    maxLength: 64,
                                    xtype: 'MTTextField'
                                },
                            ]
                        },
                        {
                            xtype: 'fieldcontainer',
                            layout: {
                                type: 'hbox',
                                align: 'stretch',
                            },
                            items: [{
                                flex: 1,
                                fieldLabel: 'Diễn giải ',
                                name: 'Description',
                                bind: '{masterData.Description}',
                                maxLength: 255,
                                xtype: 'MTTextField',
                                margin: '0 8 0 0',
                            }]
                        },

                    ]
                },
                {
                    title: 'Tài khoản',
                    layout: {
                        type: 'vbox',
                        align: 'stretch'
                    },
                    flex: 1,
                    items: [
                        {
                            xtype: 'fieldcontainer',
                            itemId: 'fieldCheckPassword',
                            layout: {
                                type: 'hbox',
                                align: 'stretch',
                            },
                            items: [{
                                xtype: 'MTCheckbox',
                                boxLabel: 'Thay đổi mật khẩu',
                                itemId: 'checkPassword',
                                bind: '{masterData.IsChangedPassword}'
                            }, ]
                        },
                        {
                            xtype: 'fieldcontainer',
                            itemId: 'fieldPassword',
                            layout: {
                                type: 'hbox',
                                align: 'stretch',
                            },
                            fieldDefaults: {},
                            items: [{
                                xtype: 'MTTextField',
                                itemId: 'passwordAllow',
                                fieldLabel: 'Mật khẩu ',
                                inputType: 'password',
                                labelWidth: 100,
                                flex: 1,
                                name: 'Password',
                                bind: {
                                    value: '{masterData.Password}',
                                },
                                allowBlank: false,
                                maxLength: 128,
                            },
                                {
                                    xtype: 'MTTextField',
                                    itemId: 'confirmPasswordAllow',
                                    margin: '0 8 0 8',
                                    labelWidth: 120,
                                    inputType: 'password',
                                    flex: 1,
                                    fieldLabel: 'Xác nhận mật khẩu ',
                                    name: 'ConfirmPassword',
                                    bind: {
                                        value: '{masterData.ConfirmPassword}',
                                    },
                                    allowBlank: false,
                                    maxLength: 128,
                                }
                            ]
                        },

                    ]
                },

            ],
        };
    }
});