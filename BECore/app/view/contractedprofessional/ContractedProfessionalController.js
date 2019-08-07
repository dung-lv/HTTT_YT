/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.contractedprofessional.ContractedProfessionalController', {
    extend: 'QLDT.view.base.BaseEditTableController',

    requires: ['QLDT.view.base.BaseEditTableController'],

    alias: 'controller.ContractedProfessional',

    apiController: 'ContractedProfessionals',

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
            '#btnTKCM': {
                'click': 'btnTKCM_OnClick',
                scope: me,
            },
            '#btnExcel': {
                'click': 'btnExcel_OnClick',
                scope: me,
            },
        });
    },


    /*
    * Gọi hàm Xuất File TKCM
    * Create by: manh:26.05.18
    */
    btnTKCM_OnClick: function (sender) {
        var me = this, projectTaskIDArr = new Array(),
            cboProjectID = Ext.ComponentQuery.query("#cboProjectID", me.getView())[0],
            projectID = cboProjectID.getValue(),
            projectName = cboProjectID.rawValue,
            ranges = me.gridMaster.store.getRange();

        // ném ProjecttaskID được tích vào 1 mảng
        for (var i = 0; i < ranges.length; i++) {
            if (ranges[i].data.Inactive === true) {
                projectTaskIDArr.join();
                projectTaskIDArr.push(ranges[i].data.ProjectTaskID);
                projectTaskIDArr.join();
            }
        }

        // ghép các phần tử trong mảng phân cách bẳng dấu ,
        var lstProjectTaskID = projectTaskIDArr.join(",");

        if (!projectID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn thông tin đề tài');
            return;
        }

        me.exportExcelTKCM({
            projectID: projectID, projectName: projectName, projectTaskID: lstProjectTaskID
        });
    },

    /*
    * Gọi hàm Xuất File Excel
    * Create by: manh:26.05.18
    */
    btnExcel_OnClick: function (sender) {
        var me = this, projectTaskIDArr = new Array(),
            cboProjectID = Ext.ComponentQuery.query("#cboProjectID", me.getView())[0],
            projectID = cboProjectID.getValue(),
            projectName = cboProjectID.rawValue,
            ranges = me.gridMaster.store.getRange();
        // ném ProjecttaskID được tích vào 1 mảng
        for (var i = 0; i < ranges.length; i++) {
            if (ranges[i].data.Inactive === true) {
                projectTaskIDArr.join();
                projectTaskIDArr.push(ranges[i].data.ProjectTaskID);
                projectTaskIDArr.join();
            }
        }

        // ghép các phần tử trong mảng phân cách bẳng dấu ,
        var lstProjectTaskID = projectTaskIDArr.join(",");

        if (!projectID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn thông tin đề tài');
            return;
        }

        me.exportExcel({
            projectID: projectID, projectName: projectName, projectTaskID: lstProjectTaskID
        });
    },

    /*
    * Thực hiện xuất khẩu file Excel
    * Create by: manh:26.05.18
    */
    exportExcelTKCM: function (data) {
        QLDT.utility.Utility.exportExcel({
            ReportID: QLDT.common.Enumaration.ReportID.ThueKhoanChuyenMon,
            Data: JSON.stringify(data)
        });
    },

    /*
    * Thực hiện xuất khẩu file Excel
    * Create by: manh:26.05.18
    */
    exportExcel: function (data) {
        QLDT.utility.Utility.exportExcel({
            ReportID: QLDT.common.Enumaration.ReportID.ThueKhoanChuyenMonExcel,
            Data: JSON.stringify(data)
        });
    },

    /*
   * Sau khi load form xong muốn xử lý gì thêm thì gọi hàm này
   * Create by: manh:26.05.18
   */
    afterrender: function () {
        var me = this,
            projectStore = me.getViewModel().getStore('projectStore');
        if (projectStore) {
            projectStore.load({
                callback: function (records, operation, success) {
                    if (Ext.isArray(records) && records.length > 0) {
                        var cboProjectID = Ext.ComponentQuery.query("#cboProjectID", me.getView())[0];
                        if (cboProjectID) {
                            cboProjectID.select(records[0]);
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
        var me = this, cboProjectID = Ext.ComponentQuery.query("#cboProjectID", me.getView())[0],
            projectID = cboProjectID.getValue();

        if (!cboProjectID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn thông tin đề tài');
            return;
        }
        me.loadData({
            projectID: projectID,
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
