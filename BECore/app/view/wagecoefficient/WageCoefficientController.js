/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.wagecoefficient.WageCoefficientController', {
    extend: 'QLDT.view.base.BaseEditTableController',

    requires: ['QLDT.view.base.BaseEditTableController'],

    alias: 'controller.WageCoefficient',

    apiController: 'WageCoefficients',

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
    * Đã override lại từ base
    * Thực hiện thay đổi trạng thái button trên thanh toolbar
    * Create by: manh:26.05.18
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
                }
            });

            if (typeof me.customSetStatusButtonToolBar == 'function') {
                me.customSetStatusButtonToolBar(toolBar, toolBar.items.items);
            }

        }
    },

    /*
    * Gọi hàm Xuất File Excel
    * Create by: manh:26.05.18
    */
    btnExcel_OnClick: function (sender) {
        var me = this, cboGrantRatio = Ext.ComponentQuery.query("#cboGrantRatio", me.getView())[0],
            cboYear = Ext.ComponentQuery.query("#cboYear", me.getView())[0],
            grantRatioID = cboGrantRatio.getValue(),
            grantRatioName = cboGrantRatio.rawValue,
            year = cboYear.getValue();

        if (!grantRatioID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn thông tin đề tài');
            return;
        }

        if (!year) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn năm muốn nhập');
            return;
        }

        me.exportExcel({
            grantRatioID: grantRatioID, grantRatioName: grantRatioName, year: year
        });
    },


    /*
    * Thực hiện xuất khẩu file Excel
    * Create by: manh:26.05.18
    */
    exportExcel: function (data) {
        QLDT.utility.Utility.exportExcel({
            ReportID: QLDT.common.Enumaration.ReportID.HeSoTienCong,
            Data: JSON.stringify(data)
        });
    },

    /*
   * Sau khi load form xong muốn xử lý gì thêm thì gọi hàm này
   * Create by: manh:26.05.18
   */
    afterrender: function () {
        var me = this,
            grantRatioStore = me.getViewModel().getStore('grantRatioStore');
        if (grantRatioStore) {
            grantRatioStore.load({
                callback: function (records, operation, success) {
                    if (Ext.isArray(records) && records.length > 0) {
                        var cboGrantRatio = Ext.ComponentQuery.query('#cboGrantRatio', me.getView())[0];
                        if (cboGrantRatio) {
                            cboGrantRatio.select(records[0]);
                            cboGrantRatio.fireEvent('select', cboGrantRatio, records[0]);

                            cboYear = Ext.ComponentQuery.query("#cboYear", me.getView())[0];

                            var currentDate = new Date();
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
    * Nhấn tìm kiếm thì lấy danh sách dữ liệu
    * Create by: manh:26.05.18
    */
    btnSearch_OnClick: function (sender) {
        var me = this, cboGrantRatio = Ext.ComponentQuery.query("#cboGrantRatio", me.getView())[0],
            cboYear = Ext.ComponentQuery.query("#cboYear", me.getView())[0],
            grantRatioID = cboGrantRatio.getValue(),
            year = cboYear.getValue();

        if (!grantRatioID) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn thông tin đề tài');
            return;
        }
        if (!year) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn năm muốn nhập');
            return;
        }
        me.loadData({
            grantRatioID: grantRatioID,
            year: year
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
