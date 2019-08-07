/**
 * Controller thêm tệp đính kèm của project
 */
Ext.define('QLDT.view.attach.ProjectWorkshop_AttachDetailController', {
    extend: 'QLDT.view.base.BaseController',

    requires: ['QLDT.view.base.BaseController'],

    alias: 'controller.ProjectWorkshop_AttachDetail',

    title: 'Tệp đính kèm',

    editMode: null,

    masterData: null,

    /*
    * Controller gọi form này
    * Create by: dvthang:26.01.2018
    */
    masterController: null,

    masterStore: null,

    /*
    * Hàm khởi tạo của controller
    * Create by: dvthang:05.01.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            '#': {
                afterrender: 'afterrender',
                scope: me
            },
            '#btnCancel': {
                click: 'btnCancel_OnClick',
                scope: me
            },
            '#btnSaveAD': {
                click: 'btnSave_OnClick',
                scope: me
            }
        });
    },

    /*
    * Sau khi render xong muốn làm gì thì xử lý ở đây
    * Create by: dvthang:22.01.2018
    */
    afterrender: function () {

    },

    /*
    * Show form chọn tệp đính kèm
    * Create by: dvthang:21.01.2018
    */
    show: function (masterController, masterStore, record, editMode) {
        var me = this, view = me.getView(), sTitle = '';
        if (view) {
            me.masterController = masterController;
            me.editMode = editMode;
            switch (me.editMode) {
                case QLDT.common.Enumaration.EditMode.Add:
                    sTitle = Ext.String.format("Thêm {0}", me.title);
                case QLDT.common.Enumaration.EditMode.Duplicate:
                    break;
                default:
                    sTitle = Ext.String.format("Sửa {0}", me.title);
                    break;
            }
            view.setTitle(sTitle);
            view.show();

            me.masterData = record;

            me.processLayout();
            me.bindingForm();
        }
    },

    /*
    * Xử lý layout cho form trước khi show
    * Create by: dvthang:28.01.2018
    */
    processLayout: function () {
        var me = this;
        var fileItemID = Ext.ComponentQuery.query('#fileItemID', me.getView())[0];
        switch (me.editMode) {
            case QLDT.common.Enumaration.EditMode.Add:
            case QLDT.common.Enumaration.EditMode.Duplicate:
                if (fileItemID) {
                    fileItemID.allowBlank = false;
                }
                break;
            default:
                if (fileItemID) {
                    fileItemID.allowBlank = true;
                }
        }
    },

    /*
    * Binding value cho form
    * Create by: dvthang:28.01.2018
    */
    bindingForm: function () {
        var me = this,
         txtDescription = Ext.ComponentQuery.query('#txtDescription', me.getView())[0];
        if (txtDescription && me.masterData) {
            txtDescription.setValue(me.masterData.get("Description"));
        }
    },


    /*
    * Thực hiện đóng form
    * Create by: dvthang:22.1.2018
    */
    btnCancel_OnClick: function (sender) {
        var me = this, view = me.getView();
        if (view) {
            view.down('form').getForm().reset();
            view.close();
        }
    },


    /*
    * Thực hiện lưu file xuống grid
    * Create by: dvthang:22.01.2018
    */
    btnSave_OnClick: function (sender) {
        var me = this, view = me.getView(),
            store = me.getViewModel().getStore('')
        form = Ext.ComponentQuery.query('#uploadFileID', me.getView())[0];

        if (form && me.masterController) {
            form.editMode = me.editMode;
            if (me.record) {
                form.PKValue = me.record.get(me.record.idProperty);
            }
            form.submitWithFile(function (rep) {
                if (rep.Success && Ext.isArray(rep.Data)) {
                    var record = rep.Data[0],
                    txtDescription = Ext.ComponentQuery.query('#txtDescription', me.getView())[0],
                       description = '';
                    if (txtDescription) {
                        description = txtDescription.getValue();
                    }

                    if (Ext.isArray(rep.Data) && rep.Data.length > 0) {
                        var record = rep.Data[0];
                        me.masterController.addData({
                            FileSize: record["FileSize"],
                            FileType: record["FileType"],
                            FileName: record["FileName"],
                            FileResourceID: record["FileResourceID"],
                            Description: description
                        });
                    } else {
                        if (me.masterData) {
                            me.masterData.set("Description", description);
                        }
                    }
                    view.destroy();
                }
            });
        }
    }
  
});
