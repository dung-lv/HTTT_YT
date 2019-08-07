/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.laborday.LabordayController', {
    extend: 'QLDT.view.base.BaseEditTableController',

    requires: ['QLDT.view.base.BaseEditTableController'],

    alias: 'controller.Laborday',

    apiController: 'ProjectTaskMemberFinances',

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
            '#cboProjectID': {
                'select': 'cboProjectID_Select',
                scope: me,
            },
            '#btnExcel': {
                'click': 'btnExcel_OnClick',
                scope: me,
            },
            '#btnChange': {
                'click': 'btnChange_OnClick',
                scope: me,
            },
            '#btnExcelTC': {
                'click': 'btnExcelTC_OnClick',
                scope: me,
            },
            '#btnChangeAll': {
                'click': 'btnChangeAll_OnClick',
                'mouseover': 'btnChangeAll_Over',
                scope: me,
            },
            '#grdMaster': {
                'beforeshowContextMenu': 'beforeshowContextMenuGridLaborday',
                scope: me,
            }
        });
    },

    /*
    * Khi xóa mô tả -> đồng thời đưa giá trị số giờ, ngày công về 0
    * Create by: manh:26.07.2018
    */
    preSaveData: function (datas) {
        var me = this;
        if (datas[0].Description === "") {
            datas[0].LaborDay = 0;
            datas[0].Hour = 0;
        }
    },

    /*
    * hiện tooltip khi di chuột vào nút nhập hàng loạt
    * Create by: manh:08.05.2018
    */
    btnChangeAll_Over: function (sender) {
        var me = this,
        btnChangeAll = Ext.ComponentQuery.query("#btnChangeAll", me.getView())[0];
        if (btnChangeAll) {
            btnChangeAll.setTooltip('Thực hiện thay đổi dữ liệu hàng loạt theo dòng đầu tiên');
        }
    },

    /*
    * Bắt event click vào button trên thanh toolbar
    * Create by: manh:28.05.18
    */
    toolbar_OnClickModify: function (sender) {
        var me = this;
        switch (sender.itemId) {
            case 'btnCopyCell':
                me.copyCell(sender);
                break;
            case 'btnPasteCell':
                me.pasteCell(sender);
                break;
        }
    },

    /*
    * Sao chép dữ liệu
    * Create by: manh:28.05.18
    */
    copyCell: function (sender) {
        var me = this,
            btnCopyCell = Ext.ComponentQuery.query("#btnCopyCell", me.getView())[0],
            grid = Ext.ComponentQuery.query("#grdMaster", me.getView())[0],
            record = grid.getSelectionModel().getSelection()[0];
        if (grid) {
            if (btnCopyCell) {
                if (record.getData().DayOff === true) {
                    QLDT.utility.Utility.showWarning(Ext.String.format('Bạn không được Copy vì <b>{0}</b> là ngày nghỉ.', record.getData().DayName));
                } else if (record.data.Description === "") {
                    QLDT.utility.Utility.showWarning(Ext.String.format('Bạn không được Copy vì hàng này chưa có dữ liệu'));
                }
                else {
                    window.localStorage.setItem('tempDescription', record.getData().Description);
                    window.localStorage.setItem('tempHour', record.getData().Hour);
                    window.localStorage.setItem('tempLaborDay', record.getData().LaborDay);
                }

            }
        }
    },

    /*
    * Dán dữ liệu
    * Create by: manh:28.05.18
    */
    pasteCell: function (sender) {
        var me = this,
            btnPasteCell = Ext.ComponentQuery.query("#btnPasteCell", me.getView())[0],
            grid = Ext.ComponentQuery.query("#grdMaster", me.getView())[0],
            record = grid.getSelectionModel().getSelection()[0],
            tempDescription = window.localStorage.getItem('tempDescription');
        if (grid) {
            if (btnPasteCell) {
                if (typeof (tempDescription) === "object") {
                    QLDT.utility.Utility.showWarning(Ext.String.format('Bạn không được Paste vì chưa Copy'));
                }
                else if (record.get("DayOff") === true) {
                    QLDT.utility.Utility.showWarning(Ext.String.format('Bạn không được Paste vì <b>{0}</b> là ngày nghỉ.', record.getData().DayName));
                }
                else if (record.get("LaborDayMade") >= 1) {
                    if (record.get("DescriptionMade")) {
                        QLDT.utility.Utility.showWarning(Ext.String.format('Không chấm công được vì đã chấm công cho <b>{0}</b>', record.get("DescriptionMade")));
                    } else {
                        QLDT.utility.Utility.showWarning('Không chấm công được.');
                    }
                }
                else {
                    record.set("Description", window.localStorage.getItem('tempDescription'));
                    record.set("Hour", window.localStorage.getItem('tempHour'));
                    record.set("LaborDay", window.localStorage.getItem('tempLaborDay'));
                }
            }
        }
    },

    /*
    * Đã override lại từ base
    * Thực hiện thay đổi trạng thái button trên thanh toolbar
    * Modify by: manh:04.05.2018
    */
    setStatusButtonToolBar: function (enabled, disableAll) {
        var me = this, toolBar = me.getToolBar();
        if (toolBar) {
            Ext.each(toolBar.items.items, function (it) {
                if (disableAll) {
                    it.setDisabled(true);
                    return;
                }
                switch (it.itemId) {
                    case 'btnEdit':
                        it.setDisabled(enabled);
                        break;
                    case 'btnSave':
                        it.setDisabled(!enabled);
                        break;
                    case 'btnUndo':
                        it.setDisabled(!enabled);
                        break;
                    case 'btnChange':
                        it.setDisabled(!enabled);
                        break;
                    case 'btnChangeAll':
                        it.setDisabled(!enabled);
                        break;
                    case 'btnCopyCell':
                        it.setDisabled(!enabled);
                        break;
                    case 'btnPasteCell':
                        it.setDisabled(!enabled);
                        break;
                }
            });

            if (typeof me.customSetStatusButtonToolBar == 'function') {
                me.customSetStatusButtonToolBar(toolBar, toolBar.items.items);
            }

        }
    },


    /*
   * Bắt event trước khi hiển thị context menu trên grid
   * Create by: manh:28.05.18
   */
    beforeshowContextMenuGridLaborday: function (grid, menuContext) {
        var me = this, store = grid.getStore();
        if (store) {
            var record = grid.getSelectionModel().getSelection()[0],
                tempDescription = window.localStorage.getItem('tempDescription');
            Ext.each(menuContext.items.items, function (it) {
                switch (it.itemId) {
                    case 'btnCopyCell':
                        it.setDisabled(record.data.DayOff === true || record.data.Description === "");
                        break;
                    case 'btnPasteCell':
                        it.setDisabled(record.data.DayOff === true || typeof (tempDescription) === "object");
                        break;
                }
            });
        }
    },


    /*
    * Chuyển dữ liệu từ Mô tả -> Mô tả (TC),Số giờ -> Số giờ (TC),Số ngày công -> Số ngày công (TC)
    * Created by:manh 04.05.2018
    */
    btnChange_OnClick: function () {
        //alert("Chuyển dữ liệu");
        var me = this,
            gridLaborday = Ext.ComponentQuery.query("#grdMaster", me.getView())[0],
            ranges = gridLaborday.getStore().getRange();

        if (gridLaborday) {
            for (var i = 0; i < ranges.length; i++) {
                row = gridLaborday.getStore().getAt(i);
                row.set("DescriptionFin", row.data.Description);
                row.set("HourFin", row.data.Hour);
                row.set("LaborDayFin", row.data.LaborDay);
            }
        }
    },

    /*
    * Nhập hàng loạt theo dòng đầu tiên
    * Created by:manh 07.05.2018
    */
    btnChangeAll_OnClick: function () {
        //alert("Nhập hàng loạt");
        var me = this,
            gridLaborday = Ext.ComponentQuery.query("#grdMaster", me.getView())[0],
            ranges = gridLaborday.getStore().getRange();

        if (gridLaborday) {
            rowFirst = gridLaborday.getStore().getAt(0);
            for (var i = 1; i < ranges.length; i++) {
                rowNext = gridLaborday.getStore().getAt(i);
                if (rowNext.data.DayOff === false) {
                    rowNext.set("Description", rowFirst.data.Description);
                    rowNext.set("Hour", rowFirst.data.Hour);
                    rowNext.set("LaborDay", rowFirst.data.LaborDay);
                }
            }
        }
    },

    /*
    * Gọi hàm Xuất File Excel
    * Create by: dvthang:10.03.2018
    */
    btnExcel_OnClick: function (sender) {
        var me = this, cboProjectID = Ext.ComponentQuery.query("#cboProjectID", me.getView())[0],
           cboMonth = Ext.ComponentQuery.query("#cboMonth", me.getView())[0],
           cboYear = Ext.ComponentQuery.query("#cboYear", me.getView())[0],
               cboEmployee = Ext.ComponentQuery.query("#cboEmployee", me.getView())[0],
               cboProjectTask = Ext.ComponentQuery.query("#cboProjectTask", me.getView())[0];
        var projectID = cboProjectID.getValue(),
            projectTaskID = cboProjectTask.getValue(),
            employeeID = cboEmployee.getValue(),
            month = cboMonth.getValue(),
            year = cboYear.getValue(),
            projectName = cboProjectID.rawValue,
            contents = cboProjectTask.rawValue,
            fullName = cboEmployee.rawValue

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

        if (!projectTaskID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn nội dụng thực hiện.');
            return;
        }

        me.exportExcel({
            projectID: projectID, projectName: projectName,
            projectTaskID: projectTaskID, contents: contents, employeeID: employeeID, fullName: fullName,
            year: year, month: month
        });
    },

    /*
    * Gọi hàm Xuất File Excel với người dùng là Ban tài chính
    * Create by: manh:04.05.2018
    */
    btnExcelTC_OnClick: function (sender) {
        var me = this, cboProjectID = Ext.ComponentQuery.query("#cboProjectID", me.getView())[0],
           cboMonth = Ext.ComponentQuery.query("#cboMonth", me.getView())[0],
           cboYear = Ext.ComponentQuery.query("#cboYear", me.getView())[0],
               cboEmployee = Ext.ComponentQuery.query("#cboEmployee", me.getView())[0],
               cboProjectTask = Ext.ComponentQuery.query("#cboProjectTask", me.getView())[0];
        var projectID = cboProjectID.getValue(),
            projectTaskID = cboProjectTask.getValue(),
            employeeID = cboEmployee.getValue(),
            month = cboMonth.getValue(),
            year = cboYear.getValue(),
            projectName = cboProjectID.rawValue,
            contents = cboProjectTask.rawValue,
            fullName = cboEmployee.rawValue

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

        if (!projectTaskID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn nội dụng thực hiện.');
            return;
        }

        me.exportExcelTC({
            projectID: projectID, projectName: projectName,
            projectTaskID: projectTaskID, contents: contents, employeeID: employeeID, fullName: fullName,
            year: year, month: month
        });
    },

    /*
    * Thực hiện xuất khẩu file Excel
    * Create by: dvthang:10.03.2018
    */
    exportExcel: function (data) {
        QLDT.utility.Utility.exportExcel({
            ReportID: QLDT.common.Enumaration.ReportID.ChamCong,
            Data: JSON.stringify(data)
        });
    },

    /*
   * Thực hiện xuất khẩu file Excel cho Ban tài chính
   * Create by: dvthang:10.03.2018
   */
    exportExcelTC: function (data) {
        QLDT.utility.Utility.exportExcel({
            ReportID: QLDT.common.Enumaration.ReportID.ChamCongTC,
            Data: JSON.stringify(data)
        });
    },

    /*
    * Thực hiện validate cell trước khi cho sửa
    * Create by: dvthang:11.03.2018
    */
    beforeeditCellCustom: function (grid, editor, e) {
        var me = this;
        if (e.record && e.record.get("DayOff")) {
            e.IsCancel = true;
            QLDT.utility.Utility.showWarning(Ext.String.format('Bạn không được nhập vì <b>{0}</b> là ngày nghỉ.', e.record.get("DayName")));
        }
    },

    /*
    * Bắt event edit Cell
    * Create by: dvthang:11.03.2018
    */
    editGridCustom: function (editor, e) {
        var me = this, record = e.record;
        if (e.field == 'LaborDay' && e.value !== e.originalValue) {
            if (e.value + record.get("LaborDayMade") > 1) {
                if (e.record.get("DescriptionMade")) {
                    QLDT.utility.Utility.showWarning(Ext.String.format('Không chấm công được vì đã chấm công cho <b>{0}</b>', e.record.get("DescriptionMade")));
                } else {
                    QLDT.utility.Utility.showWarning('Không chấm công được.');
                }

                record.set("LaborDay", e.originalValue);
            }
        }
    },

    /*
   * Sau khi load form xong muốn xử lý gì thêm thì gọi hàm này
   * Create by: dvthang:09.01.2018
   */
    afterrender: function () {
        var me = this,
            projectStore = me.getViewModel().getStore('projectStore'),
            projectByEmployeeStore = me.getViewModel().getStore('projectByEmployeeStore'),
            UserName = QLDT.Config.getUserName();
        if (projectStore) {
            projectStore.load({
                callback: function (records, operation, success) {
                    if (Ext.isArray(records) && records.length > 0) {
                        var cboProject = Ext.ComponentQuery.query('#cboProjectID', me.getView())[0];
                        if (cboProject) {
                            cboProject.select(records[0]);
                            cboProject.fireEvent('select', cboProject, records[0]);

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
                    }
                }
            })
        }
        if (projectByEmployeeStore) {
            projectByEmployeeStore.load({
                params: { CreatedBy: UserName },
                callback: function (records, operation, success) {
                    if (Ext.isArray(records) && records.length > 0) {
                        var cboProject = Ext.ComponentQuery.query('#cboProjectID', me.getView())[0];
                        if (cboProject) {
                            cboProject.select(records[0]);
                            cboProject.fireEvent('select', cboProject, records[0]);

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
                    }
                }
            })
        }
    },
    /*
    * Load danh sách Task theo Project
    * Create by: dvthang:3.3.2018
    */
    cboProjectID_Select: function (combo, record, eOpts) {
        var me = this, projectID = null;
        if (record) {
            projectID = record.get("ProjectID");
            var projectTaskStore = me.getViewModel().getStore('projectTaskStore');
            if (projectTaskStore) {
                projectTaskStore.load({
                    params: { masterID: projectID },
                    callback: function (records, operation, success) {
                        if (Ext.isArray(records) && records.length > 0) {
                            var cboProjectTask = Ext.ComponentQuery.query('#cboProjectTask', me.getView())[0];
                            if (cboProjectTask) {
                                cboProjectTask.select(records[0]);
                                var projectTaskID = records[0].get("ProjectTaskID");

                                var employeeStore = me.getViewModel().getStore('employeeStore');
                                if (employeeStore) {
                                    employeeStore.load({
                                        params: { masterID: projectID },
                                        callback: function (records, operation, success) {
                                            if (Ext.isArray(records) && records.length > 0) {
                                                var cboEmployee = Ext.ComponentQuery.query('#cboEmployee', me.getView())[0];
                                                if (cboEmployee) {
                                                    cboEmployee.select(records[0]);
                                                    var cboMonth = Ext.ComponentQuery.query("#cboMonth", me.getView())[0],
                                                       cboYear = Ext.ComponentQuery.query("#cboYear", me.getView())[0];

                                                    var month = cboMonth.getValue(),
                                                        year = cboYear.getValue()

                                                    me.loadData({
                                                        projectID: projectID,
                                                        projectTaskID: projectTaskID, employeeID: records[0].get("EmployeeID"),
                                                        year: year, month: month
                                                    });
                                                }
                                            }
                                        }
                                    });
                                }
                            }
                        }
                    }
                });
            }
        }

    },

    /*
    * Nhấn tìm kiếm thì lấy danh sách dữ liệu
    * Create by: dvthang:03.03.2018
    */
    btnSearch_OnClick: function (sender) {
        var me = this, cboProjectID = Ext.ComponentQuery.query("#cboProjectID", me.getView())[0],
            cboMonth = Ext.ComponentQuery.query("#cboMonth", me.getView())[0],
            cboYear = Ext.ComponentQuery.query("#cboYear", me.getView())[0],
                cboEmployee = Ext.ComponentQuery.query("#cboEmployee", me.getView())[0],
                cboProjectTask = Ext.ComponentQuery.query("#cboProjectTask", me.getView())[0];

        var projectID = cboProjectID.getValue(),
            projectTaskID = cboProjectTask.getValue(),
            employeeID = cboEmployee.getValue(),
            month = cboMonth.getValue(),
            year = cboYear.getValue()
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

        if (!projectTaskID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn nội dụng thực hiện.');
            return;
        }

        me.loadData({
            projectID: projectID,
            projectTaskID: projectTaskID, employeeID: employeeID,
            year: year, month: month
        });
    },

});
