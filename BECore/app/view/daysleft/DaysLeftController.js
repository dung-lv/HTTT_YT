/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.daysleft.DaysLeftController', {
    extend: 'QLDT.view.base.BaseEditTableController',

    requires: ['QLDT.view.base.BaseEditTableController'],

    alias: 'controller.DaysLeft',

    apiController: 'DaysLefts',

    /*
    * Hàm khởi tạo của controller
    * Create by: manh:26.05.18
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            '#btnSearch': {
                click: 'btnSearch_OnClick',
                scope: me
            },
            '#btnExcel': {
                'click': 'btnExcel_OnClick',
                scope: me,
            },
        });
    },

    /*
    * Gọi hàm Xuất File Excel
    * Create by: manh:26.05.18
    */
    btnExcel_OnClick: function (sender) {
        var me = this,
            cboProjectID = Ext.ComponentQuery.query("#cboProjectID", me.getView())[0],
            cboCompanyID = Ext.ComponentQuery.query("#cboCompanyID", me.getView())[0],
            cboEmployeeID = Ext.ComponentQuery.query("#cboEmployeeID", me.getView())[0],
            cboYear = Ext.ComponentQuery.query("#cboYear", me.getView())[0],
            projectID = cboProjectID.getValue(),
            companyID = cboCompanyID.getValue(),
            employeeID = cboEmployeeID.getValue(),
            year = cboYear.getValue();

        if (!projectID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn thông tin đề tài');
            return;
        }
        if (!cboCompanyID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn thông tin đơn vị');
            return;
        }
        if (!cboEmployeeID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn thông tin cán bộ');
            return;
        }
        if (!cboYear) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn năm');
            return;
        }

        me.exportExcel({
            projectID: projectID, companyID: companyID, employeeID: employeeID, year: year
        });
    },


    /*
    * Thực hiện xuất khẩu file Excel
    * Create by: manh:26.05.18
    */
    exportExcel: function (data) {
        QLDT.utility.Utility.exportExcel({
            ReportID: QLDT.common.Enumaration.ReportID.BaoCaoSoNgayConDeChamCong,
            Data: JSON.stringify(data)
        });
    },

    /*
   * Sau khi load form xong muốn xử lý gì thêm thì gọi hàm này
   * Create by: manh:26.05.18
   */
    afterrender: function () {
        var me = this,
            projectStore = me.getViewModel().getStore('projectStore'),
            companyStore = me.getViewModel().getStore('companyStore'),
            employeeStore = me.getViewModel().getStore('employeeStore'),
            yearStore = me.getViewModel().getStore('yearStore');

        if (projectStore) {
            projectStore.load({
                callback: function (records, operation, opt) {
                    projectStore.insert(0, { ProjectID: "00000000-0000-0000-0000-000000000000", ProjectName: "Tất cả" });
                    if (projectStore.getCount() > 0) {
                        var cboProjectID = Ext.ComponentQuery.query("#cboProjectID", me.getView())[0];
                        cboProjectID.select(projectStore.first())
                    }
                }
            })
        }
        if (companyStore) {
            companyStore.load({
                callback: function (records, operation, success) {
                    companyStore.insert(0, { CompanyID: "00000000-0000-0000-0000-000000000000", CompanyName: "Tất cả" });
                    if (companyStore.getCount() > 0) {
                        var first = companyStore.first(), cboCompanyID = Ext.ComponentQuery.query("#cboCompanyID", me.getView())[0];
                        cboCompanyID.select(first);
                        cboCompanyID.fireEvent('select', cboCompanyID, first);
                    }
                }
            })
        }
        if (employeeStore) {
            employeeStore.load({
                callback: function (records, operation, success) {
                    employeeStore.insert(0, { EmployeeID: "00000000-0000-0000-0000-000000000000", FullName: "Tất cả" });
                    if (employeeStore.getCount() > 0) {
                        var first = employeeStore.first(), cboEmployeeID = Ext.ComponentQuery.query("#cboEmployeeID", me.getView())[0];
                        cboEmployeeID.select(first);
                        cboEmployeeID.fireEvent('select', cboEmployeeID, first);
                    }
                }
            })
        }
        if (yearStore) {
            yearStore.load({
                callback: function (records, operation, success) {
                    if (Ext.isArray(records) && records.length > 0) {
                        var cboEmployeeID = Ext.ComponentQuery.query("#cboYear", me.getView())[0];
                        if (cboEmployeeID) {
                            cboEmployeeID.select(records[0]);
                        }
                    }
                }
            })
        }
    },

    /*
    * Nhấn tìm kiếm thì lấy danh sách dữ liệu
    * Create by: manh:26.05.18
    */
    btnSearch_OnClick: function (sender) {
        var me = this,
            cboProjectID = Ext.ComponentQuery.query("#cboProjectID", me.getView())[0],
            cboCompanyID = Ext.ComponentQuery.query("#cboCompanyID", me.getView())[0],
            cboEmployeeID = Ext.ComponentQuery.query("#cboEmployeeID", me.getView())[0],
            cboYear = Ext.ComponentQuery.query("#cboYear", me.getView())[0],
            projectID = cboProjectID.getValue(),
            companyID = cboCompanyID.getValue(),
            employeeID = cboEmployeeID.getValue(),
            year = cboYear.getValue();

        if (!cboProjectID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn thông tin đề tài');
            return;
        }
        if (!cboCompanyID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn thông tin đơn vị');
            return;
        }
        if (!cboEmployeeID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn thông tin cán bộ');
            return;
        }
        if (!cboYear) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn năm');
            return;
        }
        me.loadData({
            projectID: projectID, companyID: companyID, employeeID: employeeID, year: year
        });
    },

    /*
    * Thực hiện validate cell trước khi cho sửa
    * Create by: manh:26.05.18
    */
    beforeeditCellCustom: function (grid, editor, e) {
        var me = this;
        if (e.record && (e.record.get("Edit") === false)) {
            e.IsCancel = true;
            QLDT.utility.Utility.showWarning(Ext.String.format('Bạn không được nhập dòng này.'));
        }
    },

});
