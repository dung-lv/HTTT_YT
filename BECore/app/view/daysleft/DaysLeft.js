/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.daysleft.DaysLeft', {
    extend: 'QLDT.view.base.BaseEditTable',
    xtype: 'app-daysleft',
    requires: [
        'QLDT.view.base.BaseEditTable',
        'QLDT.view.daysleft.DaysLeftController',
        'QLDT.view.daysleft.DaysLeftModel'
    ],
    layout: 'border',

    controller: 'DaysLeft',
    viewModel: 'DaysLeft',

    columnStartEdit: 3,
    checkboxSelect: true,
    /*
    * Overrides hàm lấy lại danh sách các nút
    * Lấy danh sách menu của toolbar
    * Create by: manh:26.05.18
    */
    getToolbarMenu: function () {
        var me = this,
            UserName = QLDT.Config.getUserName(),
            CompanyID = QLDT.Config.getCompanyID(),
            toolbar = [
                 '->',
                 {
                     iconCls: 'button-excel menu-button-item fa fa-download',
                     cls: 'menu-button-item',
                     text: 'Xuất Excel',
                     itemId: 'btnExcel',
                 },
                 //{
                 //    iconCls: 'button-excel menu-button-item fa fa-download',
                 //    cls: 'menu-button-item',
                 //    text: 'Lập TKCM',
                 //    itemId: 'btnTKCM',
                 //}
            ];
        return toolbar;
    },
    /*
    * Vẽ thanh topbar item trên grid
    * Create by: manh:26.05.18
    */
    getTopBar: function () {
        var me = this,
            projectStore = me.getViewModel().getStore('projectStore'),
            companyStore = me.getViewModel().getStore('companyStore'),
            employeeStore = me.getViewModel().getStore('employeeStore'),
            yearStore = me.getViewModel().getStore('yearStore'),
            vitem;
        vitem = [
                {
                    fieldLabel: 'Đề tài',
                    name: 'ProjectID',
                    xtype: 'MTComboBox',
                    itemId: 'cboProjectID',
                    flex: 1,
                    displayField: 'ProjectName',
                    valueField: 'ProjectID',
                    store: projectStore
                }, {
                    fieldLabel: 'Đơn vị',
                    name: 'CompanyID',
                    xtype: 'MTComboBox',
                    itemId: 'cboCompanyID',
                    flex: 1,
                    displayField: 'CompanyName',
                    valueField: 'CompanyID',
                    store: companyStore
                },
                {
                    fieldLabel: 'Cán bộ',
                    name: 'EmployeeID',
                    xtype: 'MTComboBox',
                    itemId: 'cboEmployeeID',
                    flex: 1,
                    displayField: 'FullName',
                    valueField: 'EmployeeID',
                    store: employeeStore
                },
                {
                    xtype: 'MTPanel',
                    layout: {
                        type: 'hbox',
                    },
                    items: [
                         {
                             xtype: 'MTComboBox',
                             fieldLabel: 'Năm',
                             labelWidth: 110,
                             itemId: 'cboYear',
                             name: 'Year',
                             allowBlank: false,
                             displayField: 'Text',
                             valueField: 'Value',
                             store: yearStore,
                         },
                        {
                            xtype: 'MTButton',
                            text: 'Tìm kiếm',
                            itemId: 'btnSearch',
                            margin: '0 8 8 10',
                            appendCls: 'btn-search',
                            iconCls: 'fa fa-search',
                            name: 'Search'
                        },
                    ]
                }
        ];

        return {
            xtype: 'MTPanel',
            region: 'north',
            title: 'Tìm kiếm',
            layout: { type: 'vbox', align: 'stretch' },
            collapsible: true,
            defaults: {
                labelWidth: 110,
                margin: '8 8 0 8',
            },
            items: vitem
        };
    },
    /*
    * Trả về nội dung của form
    * Create by: manh:26.05.18
    */
    getColumns: function () {
        var me = this,
        uri = QLDT.utility.Utility.createUriAPI("DaysLefts/GetListDaysLefts?companyID=NULL&employeeID=NULL&projectID=NULL&year=2018"), method = "GET";
        QLDT.utility.MTAjax.request(uri, method, {}, {}, function (respone) {
            if (respone && respone.Success) {
                var lstDayLeft = respone.Data;
                window.localStorage.setItem('dayLeft_1', lstDayLeft[0].DayLeft_1);
                window.localStorage.setItem('dayLeft_2', lstDayLeft[0].DayLeft_2);
                window.localStorage.setItem('dayLeft_3', lstDayLeft[0].DayLeft_3);
                window.localStorage.setItem('dayLeft_4', lstDayLeft[0].DayLeft_4);
                window.localStorage.setItem('dayLeft_5', lstDayLeft[0].DayLeft_5);
                window.localStorage.setItem('dayLeft_6', lstDayLeft[0].DayLeft_6);
                window.localStorage.setItem('dayLeft_7', lstDayLeft[0].DayLeft_7);
                window.localStorage.setItem('dayLeft_8', lstDayLeft[0].DayLeft_8);
                window.localStorage.setItem('dayLeft_9', lstDayLeft[0].DayLeft_9);
                window.localStorage.setItem('dayLeft_10', lstDayLeft[0].DayLeft_10);
                window.localStorage.setItem('dayLeft_11', lstDayLeft[0].DayLeft_11);
                window.localStorage.setItem('dayLeft_12', lstDayLeft[0].DayLeft_12);
            }
        }, function (error) {
            QLDT.utility.Utility.handleException(error);
        });
        var dayLeft_1 = window.localStorage.getItem('dayLeft_1'),
            dayLeft_2 = window.localStorage.getItem('dayLeft_2'),
            dayLeft_3 = window.localStorage.getItem('dayLeft_3'),
            dayLeft_4 = window.localStorage.getItem('dayLeft_4'),
            dayLeft_5 = window.localStorage.getItem('dayLeft_5'),
            dayLeft_6 = window.localStorage.getItem('dayLeft_6'),
            dayLeft_7 = window.localStorage.getItem('dayLeft_7'),
            dayLeft_8 = window.localStorage.getItem('dayLeft_8'),
            dayLeft_9 = window.localStorage.getItem('dayLeft_9'),
            dayLeft_10 = window.localStorage.getItem('dayLeft_10'),
            dayLeft_11 = window.localStorage.getItem('dayLeft_11'),
            dayLeft_12 = window.localStorage.getItem('dayLeft_12');

        column = [{
            text: 'TT',
            dataIndex: 'RowNum',
            width: 45,
            align: 'center',
            readOnly: true
        },
            {
                text: 'Cán bộ',
                dataIndex: 'FullName',
                minWidth: 120,
                flex: 1,
                readOnly: true,
            },
            {
                text: 'T.1 <span style="color:red;">' + '(' + dayLeft_1 + ')' + '</span>',
                columns: [{
                    text: 'CC',
                    dataIndex: 'DayTimeKeep_1',
                    flex: 1,
                    readOnly: true,
                    renderer: function (value, metaData, record, rowIndex) {
                        metaData.tdAttr = 'data-qtip="Số ngày đã chấm: ' + value + '"';
                        return Ext.String.format("<div style = 'color:#000000;'>{0}</div>", value);
                    }
                },
                    {
                        text: '<span style="color:red;">Còn</span>',
                        dataIndex: 'DayLeft_1',
                        flex: 1,
                        readOnly: true,
                        renderer: function (value, metaData, record, rowIndex) {
                            metaData.tdAttr = 'data-qtip="Số ngày còn: ' + value + '"';
                            return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                        }
                    },
                ]
            },

            {
                text: 'T.2 <span style="color:red;">' + '(' + dayLeft_2 + ')' + '</span>',
                columns: [{
                    text: 'CC',
                    dataIndex: 'DayTimeKeep_2',
                    flex: 1,
                    readOnly: true,
                    renderer: function (value, metaData, record, rowIndex) {
                        metaData.tdAttr = 'data-qtip="Số ngày đã chấm: ' + value + '"';
                        return Ext.String.format("<div style = 'color:#000000;'>{0}</div>", value);
                    }
                },
                    {
                        text: '<span style="color:red;">Còn</span>',
                        dataIndex: 'DayLeft_2',
                        flex: 1,
                        readOnly: true,
                        renderer: function (value, metaData, record, rowIndex) {
                            metaData.tdAttr = 'data-qtip="Số ngày còn: ' + value + '"';
                            return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                        }
                    },
                ]
            },

            {
                text: 'T.3 <span style="color:red;">' + '(' + dayLeft_3 + ')' + '</span>',
                columns: [{
                    text: 'CC',
                    dataIndex: 'DayTimeKeep_3',
                    flex: 1,
                    readOnly: true,
                    renderer: function (value, metaData, record, rowIndex) {
                        metaData.tdAttr = 'data-qtip="Số ngày đã chấm: ' + value + '"';
                        return Ext.String.format("<div style = 'color:#000000;'>{0}</div>", value);
                    }
                },
                    {
                        text: '<span style="color:red;">Còn</span>',
                        dataIndex: 'DayLeft_3',
                        flex: 1,
                        readOnly: true,
                        renderer: function (value, metaData, record, rowIndex) {
                            metaData.tdAttr = 'data-qtip="Số ngày còn: ' + value + '"';
                            return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                        }
                    },
                ]
            },

            {
                text: 'T.4 <span style="color:red;">' + '(' + dayLeft_4 + ')' + '</span>',
                columns: [{
                    text: 'CC',
                    dataIndex: 'DayTimeKeep_4',
                    flex: 1,
                    readOnly: true,
                    renderer: function (value, metaData, record, rowIndex) {
                        metaData.tdAttr = 'data-qtip="Số ngày đã chấm: ' + value + '"';
                        return Ext.String.format("<div style = 'color:#000000;'>{0}</div>", value);
                    }
                },
                    {
                        text: '<span style="color:red;">Còn</span>',
                        dataIndex: 'DayLeft_4',
                        flex: 1,
                        readOnly: true,
                        renderer: function (value, metaData, record, rowIndex) {
                            metaData.tdAttr = 'data-qtip="Số ngày còn: ' + value + '"';
                            return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                        }
                    },
                ]
            },

            {
                text: 'T.5 <span style="color:red;">' + '(' + dayLeft_5 + ')' + '</span>',
                columns: [{
                    text: 'CC',
                    dataIndex: 'DayTimeKeep_5',
                    flex: 1,
                    readOnly: true,
                    renderer: function (value, metaData, record, rowIndex) {
                        metaData.tdAttr = 'data-qtip="Số ngày đã chấm: ' + value + '"';
                        return Ext.String.format("<div style = 'color:#000000;'>{0}</div>", value);
                    }
                },
                    {
                        text: '<span style="color:red;">Còn</span>',
                        dataIndex: 'DayLeft_5',
                        flex: 1,
                        readOnly: true,
                        renderer: function (value, metaData, record, rowIndex) {
                            metaData.tdAttr = 'data-qtip="Số ngày còn: ' + value + '"';
                            return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                        }
                    },
                ]
            },

            {
                text: 'T.6 <span style="color:red;">' + '(' + dayLeft_6 + ')' + '</span>',
                columns: [{
                    text: 'CC',
                    dataIndex: 'DayTimeKeep_6',
                    flex: 1,
                    readOnly: true,
                    renderer: function (value, metaData, record, rowIndex) {
                        metaData.tdAttr = 'data-qtip="Số ngày đã chấm: ' + value + '"';
                        return Ext.String.format("<div style = 'color:#000000;'>{0}</div>", value);
                    }
                },
                    {
                        text: '<span style="color:red;">Còn</span>',
                        dataIndex: 'DayLeft_6',
                        flex: 1,
                        readOnly: true,
                        renderer: function (value, metaData, record, rowIndex) {
                            metaData.tdAttr = 'data-qtip="Số ngày còn: ' + value + '"';
                            return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                        }
                    },
                ]
            },

            {
                text: 'T.7 <span style="color:red;">' + '(' + dayLeft_7 + ')' + '</span>',
                columns: [{
                    text: 'CC',
                    dataIndex: 'DayTimeKeep_7',
                    flex: 1,
                    readOnly: true,
                    renderer: function (value, metaData, record, rowIndex) {
                        metaData.tdAttr = 'data-qtip="Số ngày đã chấm: ' + value + '"';
                        return Ext.String.format("<div style = 'color:#000000;'>{0}</div>", value);
                    }
                },
                    {
                        text: '<span style="color:red;">Còn</span>',
                        dataIndex: 'DayLeft_7',
                        flex: 1,
                        readOnly: true,
                        renderer: function (value, metaData, record, rowIndex) {
                            metaData.tdAttr = 'data-qtip="Số ngày còn: ' + value + '"';
                            return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                        }
                    },
                ]
            },

            {
                text: 'T.8 <span style="color:red;">' + '(' + dayLeft_8 + ')' + '</span>',
                columns: [{
                    text: 'CC',
                    dataIndex: 'DayTimeKeep_8',
                    flex: 1,
                    readOnly: true,
                    renderer: function (value, metaData, record, rowIndex) {
                        metaData.tdAttr = 'data-qtip="Số ngày đã chấm: ' + value + '"';
                        return Ext.String.format("<div style = 'color:#000000;'>{0}</div>", value);
                    }
                },
                    {
                        text: '<span style="color:red;">Còn</span>',
                        dataIndex: 'DayLeft_8',
                        flex: 1,
                        readOnly: true,
                        renderer: function (value, metaData, record, rowIndex) {
                            metaData.tdAttr = 'data-qtip="Số ngày còn: ' + value + '"';
                            return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                        }
                    },
                ]
            },

            {
                text: 'T.9 <span style="color:red;">' + '(' + dayLeft_9 + ')' + '</span>',
                columns: [{
                    text: 'CC',
                    dataIndex: 'DayTimeKeep_9',
                    flex: 1,
                    readOnly: true,
                    renderer: function (value, metaData, record, rowIndex) {
                        metaData.tdAttr = 'data-qtip="Số ngày đã chấm: ' + value + '"';
                        return Ext.String.format("<div style = 'color:#000000;'>{0}</div>", value);
                    }
                },
                    {
                        text: '<span style="color:red;">Còn</span>',
                        dataIndex: 'DayLeft_9',
                        flex: 1,
                        readOnly: true,
                        renderer: function (value, metaData, record, rowIndex) {
                            metaData.tdAttr = 'data-qtip="Số ngày còn: ' + value + '"';
                            return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                        }
                    },
                ]
            },

            {
                text: 'T.10 <span style="color:red;">' + '(' + dayLeft_10 + ')' + '</span>',
                columns: [{
                    text: 'CC',
                    dataIndex: 'DayTimeKeep_10',
                    flex: 1,
                    readOnly: true,
                    renderer: function (value, metaData, record, rowIndex) {
                        metaData.tdAttr = 'data-qtip="Số ngày đã chấm: ' + value + '"';
                        return Ext.String.format("<div style = 'color:#000000;'>{0}</div>", value);
                    }
                },
                    {
                        text: '<span style="color:red;">Còn</span>',
                        dataIndex: 'DayLeft_10',
                        flex: 1,
                        readOnly: true,
                        renderer: function (value, metaData, record, rowIndex) {
                            metaData.tdAttr = 'data-qtip="Số ngày còn: ' + value + '"';
                            return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                        }
                    },
                ]
            },

            {
                text: 'T.11 <span style="color:red;">' + '(' + dayLeft_11 + ')' + '</span>',
                columns: [{
                    text: 'CC',
                    dataIndex: 'DayTimeKeep_11',
                    flex: 1,
                    readOnly: true,
                    renderer: function (value, metaData, record, rowIndex) {
                        metaData.tdAttr = 'data-qtip="Số ngày đã chấm: ' + value + '"';
                        return Ext.String.format("<div style = 'color:#000000;'>{0}</div>", value);
                    }
                },
                    {
                        text: '<span style="color:red;">Còn</span>',
                        dataIndex: 'DayLeft_11',
                        flex: 1,
                        readOnly: true,
                        renderer: function (value, metaData, record, rowIndex) {
                            metaData.tdAttr = 'data-qtip="Số ngày còn: ' + value + '"';
                            return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                        }
                    },
                ]
            },

            {
                text: 'T.12 <span style="color:red;">' + '(' + dayLeft_12 + ')' + '</span>',
                columns: [{
                    text: 'CC',
                    dataIndex: 'DayTimeKeep_12',
                    flex: 1,
                    readOnly: true,
                    renderer: function (value, metaData, record, rowIndex) {
                        metaData.tdAttr = 'data-qtip="Số ngày đã chấm: ' + value + '"';
                        return Ext.String.format("<div style = 'color:#000000;'>{0}</div>", value);
                    }
                },
                    {
                        text: '<span style="color:red;">Còn</span>',
                        dataIndex: 'DayLeft_12',
                        flex: 1,
                        readOnly: true,
                        renderer: function (value, metaData, record, rowIndex) {
                            metaData.tdAttr = 'data-qtip="Số ngày còn: ' + value + '"';
                            return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                        }
                    },
                ]
            },

        ]

        return column;
    },

    /*
    * Khai báo store load dữ liệu cho grid
    * Create by: manh:26.05.18
    */
    getStoreMaster: function () {
        var me = this,
            store = me.getViewModel().getStore('masterStore');
        return store;
    }
});
