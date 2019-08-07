/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.project.ProjectTaskSortController', {
    extend: 'QLDT.view.base.BaseController',
    requires: ['QLDT.view.base.BaseController'],

    alias: 'controller.ProjectTaskSort',
    apiController: 'ProjectTasks',

    title:'Sắp xếp nội dung đề tài',
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
            '#btnUp': {
                click: 'btnUp_OnClick',
                scope: me
            },
            '#btnDown': {
                click: 'btnDown_OnClick',
                scope: me
            },
            "#grdProjectTask": {
                afterWhenSwapRow: 'afterWhenSwapRow'
            }
        });
    },


    /*
    * Show lên form Sắp xếp
    * Create by: manh:08.03.18
    */
    show: function (masterController, masterStore, record, editMode) {
        var me = this, view = me.getView();
        if (view) {
            me.editMode = editMode;
            me.masterController = masterController;
            view.show();
            //Load dữ liệu cho form
            me.loadDataDictionary();
            
        }
    },

    /*
    * Thực hiện load dữ liệu danh combo
    * Create by: dvthang:09.01.2018
    */
    loadDataDictionary: function () {
        var me = this, store = me.getViewModel().getStore('projectTaskStore');
        if (store) {
            var proxy = store.getProxy(), masterID = me.masterController.projectID,
                   projectTaskID = null;
            if (me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                projectTaskID = me.masterData.get("ProjectTaskID");
            }
            proxy.setExtraParams({ projectID: masterID});
            store.load({
                callback: function (records, operation, success) {
                    if (Ext.isArray(records) && records.length > 0) {
                        var cboProjectTask = Ext.ComponentQuery.query("#cboProjectTask", me.getView())[0];
                        if (cboProjectTask) {
                            cboProjectTask.select(records[0]);
                            me.loadData(records[0].get("ProjectTaskID"), masterID);
                        }
                    }                   
                }
            });
        }
    },
    
    /*
    * Nhấn tìm kiếm thì lấy danh sách dữ liệu
    * Create by: dvthang:03.03.2018
    */
    btnSearch_OnClick: function (sender) {
        var me = this, masterID = me.masterController.projectID, cboProjectTask = Ext.ComponentQuery.query("#cboProjectTask", me.getView())[0];
        if (cboProjectTask) {
            var projectTaskID = cboProjectTask.getValue();
            //   
            if (!projectTaskID) {
                QLDT.utility.Utility.showWarning('Bạn phải chọn nội dụng thực hiện.');
                return;
            }
            me.loadData(projectTaskID, masterID);
        }
    },

    /*
    * Load danh sách Task
    * Create by: dvthang:10.03.2018
    */
    loadData: function (projectTaskID, projectID) {
        var me = this,
            masterStore = me.getViewModel().getStore('masterStore');
        if (masterStore) {
            masterStore.load({
                params: {
                    projectTaskID: projectTaskID, projectID: projectID
                },
                callback: function (records, operation, success) {
                    //todo;
                    if (Ext.isArray(records) &&records.length>0) {
                        var grid = me.getGridMaster();
                        if (grid) {
                            me.setFocusRow(grid, records[0]);
                        }
                    }
                    
                }
            });
        }
    },

    /*
    * Focus row đầu tiên trên grid
    * Create by: dvthang:10.03.2018
    */
    setFocusRow:function(grd,record){
        grd.getSelectionModel().select(record);
    },

    /*
    * Bắt event sau khi swap row in grid
    * Create by: dvthang:16.03.2018
    */
    afterWhenSwapRow: function (grd, isDown,new_index, rec) {
        var me = this,projectTaskIdOld = rec.get("ProjectTaskID"),recordNew=null;
        if (isDown) {
            recordNew = grd.getStore().getAt(new_index - 1);
        } else {
            recordNew = grd.getStore().getAt(new_index + 1);
        }
        me.updateSortOrderTask(me, projectTaskIdOld, recordNew.get("ProjectTaskID"));
    },

   
    /*
    * Cập nhật SortOrder, chọn lên xuống đẩy gọi api luôn
    * Create by: manh:09.03.18
    */
    updateSortOrderTask: function (controller, projectTaskIdOld, projectTaskIdNew) {
        var me = controller, uri = QLDT.utility.Utility.createUriAPI("ProjectTasks/UpdateSortOrderTask"), method = "POST";

        uri = Ext.String.format(uri + "?projectTaskIDOld={0}&projectTaskIdNew={1}",projectTaskIdOld,projectTaskIdNew )
        QLDT.utility.MTAjax.request(uri, method, {}, {}, function (respone) {
            if (respone && respone.Success) {
            } else {
                QLDT.utility.Utility.showWarning(respone.ErrorMessage);
            }
        }, function (error) {
            QLDT.utility.Utility.showWarning('Cập nhật trạng thái task thất bại.');
            QLDT.utility.Utility.handleException(error);
        });
    },

    /*
    * Thực hiện đưa dòng dữ liệu lên: Nếu không phải là dòng trên cùng
    * Create by: laipv:04.03.2018
    */
    btnUp_OnClick: function (sender) {
        var me = this, grdProjectTask = me.getGridMaster();
      
        if (grdProjectTask) {
            grdProjectTask.upRow();
        }
    },
    /*
    * Thực hiện đưa dòng dữ liệu xuống: Nếu không phải là dòng dưới cùng
    * Create by: laipv:04.03.2018
    */
    btnDown_OnClick: function (sender) {
        var me = this, grdProjectTask = me.getGridMaster();
        if (grdProjectTask) {
            grdProjectTask.downRow();
        }
    },
   
    /*
    * Lấy về đối tượng grid của form
    * Create by: dvthang:14.01.2018
    */
    getGridMaster: function () {
        var me = this, view = me.getView();
        if (!me.gridMaster) {
            me.gridMaster = Ext.ComponentQuery.query('#grdProjectTask', view)[0];
        }
        return me.gridMaster;
    },

});
