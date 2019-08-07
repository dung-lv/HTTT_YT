/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.project.ProjectInfoFinController', {
    extend: 'QLDT.view.base.BasePageDetailController',

    requires: ['QLDT.view.base.BasePageDetailController'],

    alias: 'controller.ProjectInfoFin',

    apiController: 'Projects',
    /*
    * Hàm khởi tạo của controller
    * Create by: laipv:17.01.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            "#": {
                scope: me
            },

        });
    },

    /*
    * Hàm thực hiện việc xử lý ẩn hiện layout theo action trên form
    * CreatedBy: manh:02.05.2018
    */
    processLayoutCustom: function (record) {
        var me = this,
            createdBy = record.get('CreatedBy'),
            btnSave = Ext.ComponentQuery.query('#btnSave', me.getView())[0],
            UserName = QLDT.Config.getUserName(),
            CompanyID = QLDT.Config.getCompanyID();

        // Nếu chọn Sửa và Nếu người tạo đề tài không là người đang đăng nhập thì chỉ cho phép xem hoặc Ban kế hoạch, BTC có quyền như người tạo
        // ModifiyBy: manh:02.05.2018
        if (((createdBy === UserName) || (CompanyID === QLDT.common.Constant.Company_BKH) || (CompanyID === QLDT.common.Constant.Company_BTC)) && (me.editMode == QLDT.common.Enumaration.EditMode.Edit)) {
            btnSave.show();
        } else if (me.editMode == QLDT.common.Enumaration.EditMode.Add) {
            btnSave.show();
        }
        else {
            btnSave.hide();
        }
    },

    /*
    * Hàm thực hiện khởi tạo các giá trị nhập trên from
    * Create by: dvthang:15.01.2018
    */
    initData: function (record) {
        var me = this, view = me.getView();
        // Create by: truongnm:04.03.2018 - phải đặt ở đây mới đổi đc sự kiện change
        if (me.editMode != QLDT.common.Enumaration.EditMode.Edit) {
            var newDate = new Date();
            record.set("StartDate", newDate);
            record.set("EndDate", newDate);
        }
    },

    /*
    * Lấy về form validate
    * Create by: dvthang:28.01.2018
    */
    getForm: function () {
        var me = this, view = me.getView();
        return Ext.ComponentQuery.query("#formInfo", view)[0];

    },

    /*
  * Sau khi bind dữ liệu thành công
  * Create by: dvthang:28.01.2018
  */
    saveSuccess: function () {
        var me = this;
        QLDT.utility.Utility.showToastSaveSuccess(me.getView());
        if (me.masterController) {
            me.masterController.updateStatusTab();
            if (me.masterController && me.masterController.masterController) {
                me.masterController.masterController.loadData();
            }
        }
    },


    /*
    * Danh sách các store cần load
    * Create by: dvthang:28.01.2018
    */
    getDictionaryStores: function () {
        return ["grantRatioStore"];
    },


    /*
    * Hàm thực hiện show window
    */
    show: function (masterController, masterStore, record, editMode) {
        var me = this, view = me.getView();
        if (view) {
            me.editMode = editMode;
            me.masterController = masterController;
            me.masterStore = masterStore;
            me.processLayoutCustom(record);
            //Khởi tạo các giá trị nhập
            me.initData(record);
            me.masterData = record;
            me.masterData.set('EditMode', me.editMode);
            //Load dữ liệu cho form
            me.loadDataDictionary();
        }
    },

    /*
    * Close mask của form cha
    * Create by: dvthaang:31.1.2018
    */
    afterBindFinish: function () {
        var me = this;
        if (me.masterController) {
            me.masterController.hideMask();
        }
    }
});
