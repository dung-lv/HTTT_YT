/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.project.ProjectPlanExpenseDetailController', {
    extend: 'QLDT.view.base.BasePageDetailController',

    requires: ['QLDT.view.base.BasePageDetailController'],

    alias: 'controller.ProjectPlanExpenseDetail',

    apiController: 'ProjectPlanExpense',
    /*
    * Hàm khởi tạo của controller
    * Create by: laipv:17.01.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            "#grdAttachInfo": {
                'beforeshowContextMenu': 'beforeshowContextMenuGridAttachInfo',
                scope: me
            },
        });


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
            record.set("Date", newDate);
            record.set("ProtectedDate", newDate);
        }
    },

    /*
    * Nếu người tạo đề tài không là người đang đăng nhập thì chỉ cho phép xem Hoặc ban kế hoạch có quyền như người tạo
    * ModifiyBy: manh:02.05.2018
    */
    processLayoutCustom: function (createdBy) {
        var me = this,
            btnSave = Ext.ComponentQuery.query('#btnSave', me.getView())[0],
            UserName = QLDT.Config.getUserName(),
            CompanyID = QLDT.Config.getCompanyID();

        if (btnSave) {
            if ((createdBy === UserName) || (CompanyID === QLDT.common.Constant.Company_BKH) || (CompanyID === QLDT.common.Constant.Company_BTC)) {
                btnSave.show();
            } else if (me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                btnSave.show();
            }
            else {
                btnSave.hide();
            }
        }
    },

    /*
    * Bắt event trước khi hiển thị context menu trên grid của tab thông tin chung
    * Create by: dvthang:21.1.2018
    */
    beforeshowContextMenuGridAttachInfo: function (grid, menuContext) {
        var me = this, store = grid.getStore();
        if (store) {
            var total = store.getCount();
            Ext.each(menuContext.items.items, function (it) {
                switch (it.itemId) {
                    case 'mnAdd':
                        it.setDisabled(false);
                        break;
                    case 'mnEdit':
                        it.setDisabled(total <= 0);
                        break;
                    case 'mnDelete':
                        it.setDisabled(total <= 0);
                        break;
                }
            });
        }
    },

    /*
    * Bắt event click vào context menu trên grid
    * Create by: dvthang:21.01.2018
    */
    contextMenu_OnClick: function (sender) {
        var me = this;
        var frm = Ext.create('QLDT.view.attach.ProjectPlanExpense_AttachDetail');

        if (frm) {
            var controller = frm.getController(), editMode = QLDT.common.Enumaration.EditMode.Add;
            if (controller) {
                var grdAttach = Ext.ComponentQuery.query("#grdAttachInfo", me.getView())[0];
                if (grdAttach) {
                    var sm = grdAttach.getSelectionModel().getSelection(),
                        store = grdAttach.getStore();
                    switch (sender.itemId) {
                        case 'mnAdd':

                            editMode = QLDT.common.Enumaration.EditMode.Add;
                            controller.show(me, store, null, editMode);
                            break;
                        case 'mnEdit':
                            editMode = QLDT.common.Enumaration.EditMode.Edit;
                            controller.show(me, store, sm[0], editMode);
                            break;
                        case 'mnDelete':
                            var detailStore = me.getViewModel().getStore('detail');
                            if (detailStore) {
                                detailStore.remove(sm[0]);
                            }
                            break;
                    }
                }
            }
        }
    },

    /*
    * Add data vào grid file đính kèm
    * Create by: dvthang:26.01.2018
    */
    addData: function (data) {
        var me = this, store = me.getViewModel().getStore('detail');
        if (store && data) {
            var total = store.getCount() + 1;
            var record = {
                SortOrder: total, FileType: data.FileType, FileSize: data.FileSize,
                FileName: data.FileName, IsTemp: true,
                Description: data.Description, FileResourceID: data.FileResourceID
            };
            store.add(record);
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
    },
    /*
    * Danh sách store detail
    * Create by: dvthang:30.1.2018
    */
    getDetailsStores: function () {
        return ["detail"]
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
    },

    /*
    * Thực hiện gán lại cờ temp của store đính kèm file sau khi lưu xong
    * Create by: dvthang:04.02.2018
    */
    processStoreBeforeWhenCommit: function (store, name) {
        var me = this;
        switch (name) {
            case 'detail':
                Ext.each(store.data.items, function (it) {
                    it.set("IsTemp", false);
                });
                break;
        }
    },
    /*
  * Hàm thực hiện xử lý đưa thêm giá trị ProjectID trước khi lưu 
  * Create by: laipv:11.02.2018
  */
    preSaveData: function () {
        var me = this;
        if (me.masterController) {
            me.masterData.set("ProjectID", me.masterController.masterData.get('ProjectID'));
        }
    },

});
