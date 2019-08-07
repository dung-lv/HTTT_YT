/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.auditlaboday.AuditlabodayController', {
    extend: 'QLDT.view.base.BaseController',

    requires: ['QLDT.view.base.BaseController'],

    alias: 'controller.Auditlaboday',

    isLoaded:false,

    /*
    * Hàm khởi tạo của controller
    * Create by: dvthang:05.01.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            '#btnSearch': {
                click: 'btnSearch_OnClick',
                scope: me
            },
            '#cboCompany': {
                select: 'cboCompany_Select',
                scope: me
            },
            '#': {
                afterrender: 'afterrender',
                scope: me
            },
        });


    },

    /*
    * CHọn đơn vị thì load lên danh sách nhân viên
    * Create by: dvthang:03.06.2018
    */
    cboCompany_Select: function (combo, record, eOpts) {
        var me = this;
        if (record) {
            var employeeStore = me.getViewModel().getStore('employeeStore');
            employeeStore.load({
                params: { companyID: record.get("CompanyID") },
                callback: function (records, operation, opt) {
                    employeeStore.insert(0, { EmployeeID: "00000000-0000-0000-0000-000000000000", FullName: "Tất cả" });
                    if (employeeStore.getCount() > 0) {
                        var cboEmployee = Ext.ComponentQuery.query("#cboEmployee", me.getView())[0];
                        cboEmployee.select(employeeStore.first());
                        //todo
                        var projectStore = me.getViewModel().getStore('projectStore');
                        if (projectStore) {
                            projectStore.load({
                                callback: function (records, operation, opt) {
                                    projectStore.insert(0, { ProjectID: "00000000-0000-0000-0000-000000000000", ProjectName: "Tất cả" });
                                    if (projectStore.getCount() > 0) {
                                        var cboProjectID = Ext.ComponentQuery.query("#cboProjectID", me.getView())[0];
                                        cboProjectID.select(projectStore.first());
                                        //todo
                                        var cboMonth = Ext.ComponentQuery.query("#cboMonth", me.getView())[0],
                                                             cboYear = Ext.ComponentQuery.query("#cboYear", me.getView())[0];
                                        var currentDate = new Date();
                                        if (cboMonth) {
                                            cboMonth.setValue(currentDate.getMonth() + 1);
                                        }
                                        if (cboYear) {
                                            cboYear.setValue(currentDate.getFullYear());
                                        }
                                    }
                                    if (!me.isLoaded) {
                                        me.btnSearch_OnClick();
                                    }
                                }
                            });
                        }
                    }
                }
            });
        }
    },

    /*
    * Thực hiện load danh sách đơn vị
    * Create by: dvthang:03.06.2018
    */
    afterrender: function () {
        var me = this,
            companyStore = me.getViewModel().getStore('companyStore'),
               employeeStore = me.getViewModel().getStore('employeeStore');
        if (companyStore) {
            companyStore.load({
                callback: function (records, operation, opt) {
                    companyStore.insert(0, { CompanyID: "00000000-0000-0000-0000-000000000000", CompanyName: "Tất cả" });
                    if (companyStore.getCount() > 0) {
                        var first = companyStore.first(), cboCompany = Ext.ComponentQuery.query("#cboCompany", me.getView())[0];
                        cboCompany.select(first);
                        cboCompany.fireEvent('select', cboCompany, first);
                    }
                }
            });
        }
    },

    /*
    * Nhấn tìm kiếm
    * Create by: dvthang:03.06.2018
    */
    btnSearch_OnClick: function () {
        var me = this, cboProjectID = Ext.ComponentQuery.query("#cboProjectID", me.getView())[0],
          cboMonth = Ext.ComponentQuery.query("#cboMonth", me.getView())[0],
          cboYear = Ext.ComponentQuery.query("#cboYear", me.getView())[0],
              cboEmployee = Ext.ComponentQuery.query("#cboEmployee", me.getView())[0],
              cboCompany = Ext.ComponentQuery.query("#cboCompany", me.getView())[0];

        var projectID = cboProjectID.getValue(),
            employeeID = cboEmployee.getValue(),
            month = cboMonth.getValue(),
            year = cboYear.getValue(),
            companyID = cboCompany.getValue();
        if (!companyID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn đơn vị');
            return;
        }
        if (!projectID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn thông tin đề tài');
            return;
        }

        if (!month) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn tháng muốn nhập');
            return;
        }
        if (!year) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn năm muốn nhập');
            return;
        }
        if (!employeeID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn cán bộ để nhập');
            return;
        }
        me.loadData({
            projectID: projectID,
            companyID: companyID, employeeID: employeeID,
            fromDate: new Date(year, month - 1, 1), toDate: new Date(year, month - 1, me.getTotalDayOfMonth(month, year)),

        });
    },

    /*
    * Load danh sách tổng ngày công của cán bộ
    * Create by: dvthang:03.06.2018
    */
    loadData: function (params) {
        var me = this;
        try {

            me.renderDynamicGrid(params, function () {
                var auditStore = me.getViewModel().getStore('auditStore');
                if (auditStore) {
                    auditStore.load({
                        params: params,
                        callback: function (records, operation, success) {
                            //todo
                            me.isLoaded = true;
                        }
                    });
                }
            });
        } catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },

    /*
    * Tạo động grid kiểm tra chấm công
    * Create by: dvthang:03.06.2018
    */
    renderDynamicGrid: function (params,callback) {
        var me = this, columns = [], fromDate = params.fromDate,
            totalDay = me.getTotalDayOfMonth(fromDate.getMonth() + 1, fromDate.getFullYear()),
            store = me.getViewModel().getStore('auditStore'),
            grdMaster = Ext.ComponentQuery.query('#grdMaster', me.getView())[0];
        if (grdMaster) {
            columns.push({
                xtype: 'rownumberer',
                text: 'TT',
                filterable: false,
                width: 40,
                align:'center'
            });
            columns.push({
                xtype: 'MTColumn',
                dataIndex: 'FullName',
                text: 'Cán bộ',
                minWidth: 120,
                flex: 1,
                filterable: false
            });
            var uri = QLDT.utility.Utility.createUriAPI("DayOffs/GetDayOffsByMonthYear?month=" + (fromDate.getMonth() + 1) + '&year=' + fromDate.getFullYear()), method = "GET";
            QLDT.utility.MTAjax.request(uri, method, {}, {}, function (respone) {
                if (respone && respone.Success) {
                    var dayoffs = respone.Data,clsDayOff='';
                    for (var i = 1; i <= totalDay; i++) {
                        var currentDate = new Date(fromDate.getFullYear(), fromDate.getMonth(), i);
                        if (dayoffs && dayoffs.length > 0 && dayoffs.filter(function (d) {
                            return new Date(d.Value).getTime() === currentDate.getTime();
                        }).length>0) {
                            clsDayOff = 'cls-dayoff';
                        } else {
                            clsDayOff = '';
                        }
                        var col = {
                            xtype: 'MTColumnNumberField',
                            dataIndex: 'T' + i,
                            text: '' + i,
                            width: 32,
                            filterable: false,
                            tdCls: clsDayOff,
                            renderer: function (value, metaData, record, rowIndex) {
                                if (value === 1) {
                                    metaData.tdCls += 'dayoff cls-green';
                                } else if (value >= 2) {
                                    metaData.tdCls += 'dayoff cls-yellow';
                                }
                                return value;
                            },
                        };
                        columns.push(col);
                    }
                    grdMaster.reconfigure(store, columns);

                    if (typeof callback == 'function') {
                        callback();
                    }
                   
                }
            }, function (error) {
                QLDT.utility.Utility.handleException(error);
            });

            
        }
    },

    /*
    * Lấy về tổng số ngày của tháng
    * Create by: dvthang:03.06.2018
    */
    getTotalDayOfMonth: function (month, year) {
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 9 || month == 10 || month == 12) {
            return 31;
        } else if (month == 2 || month == 4 || month == 6 || month == 8 || month == 11) {
            if (month == 2) {
                if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
                    return 29;
                }
            } else {
                return 30;
            }
        }
        return 30;
    }

});
