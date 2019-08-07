/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.project.ProjectTaskController', {
    extend: 'QLDT.view.base.BaseListController',

    requires: ['QLDT.view.base.BasePopupDetailController',
                'QLDT.view.project.ProjectTaskMember'],

    alias: 'controller.ProjectTask',
    apiController: 'ProjectTasks',
    projectID: null,
    /*
    * Hàm khởi tạo của controller
    * Create by: laipv:28.01.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
    },

    /*
    * Thực hiện overrides lại - để không load dữ liệu mặc định mà sẽ tự load
    * Create by: dvthang:04.02.2018
    */
    afterrender: function () {
        //todo
    },

    /*
    * Hàm load data cho Grid - Overrides lại hàm này trên base
    * Create by: laipv:28.01.2018
    */
    loadData: function (masterID) {
        var me = this, store = me.getViewModel().getStore("masterStore");
        if (store) {
            try {
                me.projectID = masterID;
                var proxy = store.getProxy();
                if (proxy) {
                    proxy.setExtraParams({ masterID: masterID });
                    store.load({
                        callback: function (records, operation, success) {
                            var enable = false;
                            //Focus vào row đầu tiên trên grid
                            if (Ext.isArray(records) && records.length > 0) {
                                me.setFocusRowFirst(records[0]);
                                enable = true;
                            }

                            me.setStatusButtonToolBar(enable);

                            //Ext.each(Ext.select(".wrap-projecttask .projecttask-status").elements, function (element) {
                            //    element.onclick = function (e) {
                            //        e.preventDefault();
                            //        var projecttaskid = e.target.getAttribute("projecttaskid"),
                            //            status = e.target.getAttribute("status");
                            //        me.updateStatusTask(me, projecttaskid, eval(status));
                            //    };
                            //});

                        }
                    });
                }
            } catch (e) {
                QLDT.utility.Utility.handleException(e);
            }

        }
    },

    /*
    * Show lên form danh sách cán bộ
    * Create by: manh:04.03.18
    */
    showFormProjectTaskMember: function (projecttaskid) {
        var me = this, frm = Ext.create('QLDT.view.project.ProjectTaskMember'),
            projectID = me.projectID;
        if (frm) {
            var controller = frm.getController();
            if (controller) {
                var store = frm.getViewModel().getStore("masterStore");
                controller.show(me, projecttaskid, projectID);
            }
        }
    },

    /*
    * Cập nhật trạng thái Task
    * Create by: dvthang:27.02.2018
    * Modify by: manh:03.06.18
    * Cập nhật xong thì load lại store
    */
    updateStatusTask: function (projecttaskid, status) {
        var me = this, uri = QLDT.utility.Utility.createUriAPI("ProjectTasks/UpdateStatusTask"), method = "POST";

        uri = Ext.String.format(uri + "?projectTaskID={0}&status={1}", projecttaskid, status)
        QLDT.utility.MTAjax.request(uri, method, {}, {}, function (respone) {
            if (respone && respone.Success) {
                var store = me.getViewModel().getStore('masterStore');
                if (store) {
                    //var recored = store.getById(projecttaskid);
                    //if (recored) {
                    //    recored.set("Status", status);
                    //}
                    //store.commitChanges();
                    store.load({
                        callback: function (records, oparation, success) {
                            //todo
                            if (Ext.isArray(records) && records.length > 0) {
                                me.setFocusRowFirst(records[0]);
                            }
                        }
                    });
                }
                me.showSuccess('Cập nhật trạng thái task thành công.');


            } else {
                QLDT.utility.Utility.showWarning(respone.ErrorMessage);
            }
        }, function (error) {
            QLDT.utility.Utility.showWarning('Cập nhật trạng thái task thất bại.');
            QLDT.utility.Utility.handleException(error);
        });
    },

    /*
    * SHow thông báo cập nhật trạng thái task thành công, thất bại
    * Create by: dvthang:28.02.2018
    */
    showSuccess: function (msg) {
        QLDT.utility.Utility.showInfo(msg);
    },

    /*
   * Trả về tên của form detail 
   * Create by: dvthang:09.01.2018
   */
    getPageDetail: function () {
        return 'QLDT.view.project.ProjectTaskDetail';
    },

    /*
    * Trả về tên của form Sort 
    * Create by: dvthang:04.03.2018
    */
    getPageSort: function () {
        return 'QLDT.view.project.ProjectTaskSort';
    },

    /*
    * Overrides lại hàm sắp xếp
    * Sắp xếp dữ liệu
    * Create by: laipv:04.03.2018
    */
    SortData: function (sender) {
        var me = this;
        try {
            me.showFormSort(null, QLDT.common.Enumaration.EditMode.Add);
        } catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },
    /*
    * Overrides lại hàm sắp xếp
    * Hiển thị form sắp xếp: Sort
    * Create by: laipv:04.03.2018
    */
    showFormSort: function (record, editMode) {
        var me = this,
         pageSort = me.getPageSort();
        if (pageSort) {
            var frm = Ext.create(pageSort);
            if (frm) {
                var controller = frm.getController();
                if (controller) {
                    var masterStore = me.getView().getStoreMaster();
                    controller.show(me, masterStore, record, editMode);
                }
            }
        }
    },
    /*
    * Overrides lại hàm sắp xếp
    * Bắt event click vào button trên thanh toolbar
    * Create by: dvthang:09.01.2018
    * Modify by: laipv:04.03.2018: Thêm chức năng Sort
    */
    toolbar_OnClick: function (sender) {
        var me = this;
        switch (sender.itemId) {
            case 'mnAdd':
                me.addNew(sender);
                break;
            case 'mnDuplicate':
                me.duplicate(sender);
                break;
            case 'mnEdit':
                me.editData(sender);
                break;
            case 'mnDelete':
                me.deleteData(sender);
                break;
            case 'mnRefresh':
                me.refreshData(sender);
                break;
            case 'mnSort':
                me.SortData(sender);
                break;
        }
    },

    /*
 * Nhân bản
 * Create by: laipv:15.05.2018
 */
    duplicate: function (sender) {
        var me = this;
        try {
            var grid = me.getGridMaster();
            if (grid) {
                var sm = grid.getSelectionModel().getSelection();
                if (sm && sm.length > 0) {
                    me.showFormDetail(sm[0], QLDT.common.Enumaration.EditMode.Duplicate);
                } else {
                    QLDT.utility.Utility.showWarning(QLDT.GlobalResource.SelectRecord);
                }
            }

        } catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },
    /*
    * Thêm mới đối tượng
    * Create by: dvthang:15.01.2018
    */
    addNew: function (sender) {
        var me = this;
        try {
            me.showFormDetail(null, QLDT.common.Enumaration.EditMode.Add);
        } catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },

    /*
    * Sửa giá trị trên form
    * Create by: dvthang:15.01.2018
    */
    editData: function (sender) {
        var me = this;
        try {
            var grid = me.getGridMaster();
            if (grid) {
                var sm = grid.getSelectionModel().getSelection();
                if (sm && sm.length > 0) {
                    me.showFormDetail(sm[0], QLDT.common.Enumaration.EditMode.Edit);
                } else {
                    QLDT.utility.Utility.showWarning(QLDT.GlobalResource.SelectRecord);
                }
            }

        } catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },

    /*
    * Thực hiện xóa dữ liệu trên grid
    * Create by: dvthang:09.01.2018
    */
    deleteData: function (sender) {
        var me = this;
        try {
            var grid = me.getGridMaster();
            if (grid) {
                var sm = grid.getSelectionModel().getSelection(),
                selected = [], idProperty, store = grid.getStore();

                if (sm && sm.length > 0) {
                    QLDT.utility.Utility.showConfirm(QLDT.GlobalResource.ConfirmDelRecord, {}, function (btn) {
                        switch (btn) {
                            case 'yes':
                                var idProperty;
                                Ext.each(sm, function (item) {
                                    if (!idProperty) {
                                        idProperty = item.idProperty;
                                    }
                                    selected.push(item.get(idProperty));
                                });
                                me.processDeleteData(selected, grid, idProperty);
                                break;
                            case 'no':
                                break;
                        }
                    });
                } else {
                    QLDT.utility.Utility.showWarning(QLDT.GlobalResource.LeastOneRecord);
                }
            }
        } catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },
    /*
    * Hàm thực hiện load lại dữ liệu trên grid
    * Create by: dvthang:09.01.2018
    */
    refreshData: function (sender) {
        var me = this, view = me.getView();
        if (view) {
            var store = view.getStoreMaster();
            if (store) {
                store.loadPage(1, {
                    callback: function (records, oparation, success) {
                        //todo
                        if (Ext.isArray(records) && records.length > 0) {
                            me.setFocusRowFirst(records[0]);
                        }
                    }
                });
            }
        }
    },
});
