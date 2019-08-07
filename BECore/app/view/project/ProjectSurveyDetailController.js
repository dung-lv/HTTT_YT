/**
 * Controller thêm tệp đính kèm của project
 */
Ext.define('QLDT.view.project.ProjectSurveyDetailController', {
    extend: 'QLDT.view.base.BasePopupDetailController',

    requires: ['QLDT.view.base.BasePopupDetailController'],

    alias: 'controller.ProjectSurveyDetail',

    apiController:'ContentServey',

    title: 'Thông tin hội thảo đề tài',
    /*
    * Hàm khởi tạo của controller
    * Create by: laipv:04.02.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            '#': {
                afterrender: 'afterrender',
                scope: me
            }
           
        });
    },

    /*
    *
    */
    afterrender: function () {
    },
    /*
    * Bắt event click vào context menu trên grid
    * Create by: laipv:04.02.2018
    */
    contextMenu_OnClick: function (sender) {
        var me = this;
        var frm = Ext.create('QLDT.view.attach.ProjectSurvey_AttachDetail');

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
    * Tên form
    * Create by: manh:17.01.2018
    */
    getMasterObjectName: function () {
        return "Thông tin khảo sát";
    },

    /*
     * Trả về danh sách store load dữ liệu combo dạng danh mục
     * Create by: dvthang:09.01.2018
     */
    getDictionaryStores: function () {
        return ['companyStore'];
    },

    /*
    * Danh sách store detail
    * Create by: dvthang:24.02.2018
    */
    getDetailsStores: function () {
        return ["detail"]
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
    * Lưu thêm thông tin ProjectID
    * Create by: dvthang:24.02.2018
    */
    preSaveData: function () {
        var me = this;
        if (me.masterController) {
            me.masterData.set("ProjectID", me.masterController.projectID);
        }
    },

    /*
    * Lưu thành công thì load lại màn hình danh sách
    * Create by: dvthang:24.02.2018
    */
    saveSuccess:function(){
        var me = this;
        if (me.masterController) {
            me.masterController.loadData(me.masterController.projectID);
        }
    }
    
});