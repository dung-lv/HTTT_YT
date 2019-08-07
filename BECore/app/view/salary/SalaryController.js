/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.salary.SalaryController', {
    extend: 'QLDT.view.base.BaseEditTableController',

    requires: ['QLDT.view.base.BaseEditTableController'],

    alias: 'controller.Salary',

    apiController: 'Salarys',

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
        var me = this,
            cboYear = Ext.ComponentQuery.query("#cboYear", me.getView())[0],
            year = cboYear.getValue();

        if (!year) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn năm muốn nhập');
            return;
        }

        me.exportExcel({
            year: year
        });
    },


    /*
    * Thực hiện xuất khẩu file Excel
    * Create by: manh:26.05.18
    */
    exportExcel: function (data) {
        QLDT.utility.Utility.exportExcel({
            ReportID: QLDT.common.Enumaration.ReportID.LuongCoBan,
            Data: JSON.stringify(data)
        });
    },


    /*
   * Sau khi load form xong muốn xử lý gì thêm thì gọi hàm này
   * Create by: manh:26.05.18
   */
    afterrender: function () {
        var me = this,
            yearStore = me.getViewModel().getStore('yearStore'),
            UserName = QLDT.Config.getUserName();
        if (yearStore) {
            yearStore.load({
                callback: function (records, operation, success) {
                    if (Ext.isArray(records) && records.length > 0) {
                        var cboYear = Ext.ComponentQuery.query("#cboYear", me.getView())[0];
                        if (cboYear) {
                            cboYear.select(records[0]);
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
            cboYear = Ext.ComponentQuery.query("#cboYear", me.getView())[0],
            year = cboYear.getValue();

        if (!year) {
            QLDT.utility.Utility.showWarning('Bạn phải chọn năm muốn nhập');
            return;
        }

        me.loadData({
            year: year
        });
    },

});
