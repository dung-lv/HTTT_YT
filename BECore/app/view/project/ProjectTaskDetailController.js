/**
 * Controller thêm tệp đính kèm của project
 */
Ext.define('QLDT.view.project.ProjectTaskDetailController', {
    extend: 'QLDT.view.base.BasePopupDetailController',

    requires: ['QLDT.view.base.BasePopupDetailController'],

    alias: 'controller.ProjectTaskDetail',

    title: 'Nội dung đề tài',

    apiController: 'ProjectTasks',

    /*
    * Custom tham số truyển vào store
    * Create by: laipv:29.01.2018
    */
    addExtraParams: function (store, storeName) {
        var me = this;
        switch (storeName) {
            case "projecttaskStore":
                var proxy = store.getProxy(), masterID = me.masterController.projectID,
                    projectTaskID = null;
                if (me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                    projectTaskID = me.masterData.get("ProjectTaskID");
                }
                proxy.setExtraParams({ masterID: masterID, editMode: me.editMode, projectTaskID: projectTaskID });
                break;
        }
    },
    /*
    * Danh sách các store load combo
    * Create by: laipv:29.01.2018
    */
    getDictionaryStores: function () {
        return ["projecttaskStore"]
    },

    /*
   * Hàm thực hiện khởi tạo các giá trị nhập trên from
   * Create by: dvthang:15.01.2018
   */
    initData: function (record) {
        var me = this;
        if (me.editMode == QLDT.common.Enumaration.EditMode.Add) {
            record.set("Status", 12);
        }
    },

    /*
   * Hàm thực hiện xử lý data sau khi đã validate thành công
   * Create by: dvthang:08.01.2018
   */
    preSaveData: function () {
        var me = this;
        if (me.masterController) {
            me.masterData.set("ProjectID", me.masterController.projectID);
        }
    },

    /*
    * Luu xong thi load lai man hinh danh sach
    * Create by: dvthang:11.02.2018
    */
    saveSuccess: function () {
        var me = this;
        if (me.masterController) {
            me.masterController.loadData(me.masterData.get("ProjectID"));
        }
    }
});