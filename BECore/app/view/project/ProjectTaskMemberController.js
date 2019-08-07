/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.project.ProjectTaskMemberController', {
    extend: 'QLDT.view.base.BaseController',

    requires: ['QLDT.view.base.BaseController'],

    alias: 'controller.ProjectTaskMember',

    apiController: 'ProjectTaskMember',

    gridMaster: null,

    projectTaskID: null,
    /*
    * Hàm khởi tạo của controller
    * Create by: manh:01.03.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            '#btnSave': {
                click: 'btnSave_OnClick',
                scope: me
            },
            '#btnCancel': {
                click: 'btnCancel_OnClick',
                scope: me
            },
            '#grdMaster': {
                beforeshowContextMenu: 'beforeshowContextMenu',
                scope: me
            }
        });
    },

    /*
    * Xử lý event nhấn vào menu trên grid
    * Create by: dvthang:07.03.2018
    */
    toolbar_OnClick: function (sender) {
        var me = this;
        switch (sender.itemId) {
            case 'mnAdd':
                me.addNewRecord();
                break;
            case 'mnDelete':
                me.deteteRecord();
                break;
        }
    },

    /*
    * Đăng ký event trên contextmenu
    * Create by: dvthang:08.03.2018
    */
    beforeshowContextMenu: function (grd, menuContext, record) {
        var me = this, store = grd.getStore();
        if (store) {
            var total = store.getCount(), items = menuContext.items.items;
            Ext.each(menuContext.items.items, function (it) {
                switch (it.itemId) {
                    case 'mnAdd':
                        it.setDisabled(false);
                        break;
                    case 'mnDelete':
                        it.setDisabled(total <= 0);
                        break;
                }
            });
        }
    },

    /*
    * Add record cho grid
    * Create by: dvthang:07.03.2018
    */
    addNewRecord: function () {
        var me = this, masterStore = me.getViewModel().getStore('masterStore');
        if (masterStore) {
            masterStore.appendData();
            var grdMaster = Ext.ComponentQuery.query('#grdMaster', me.getView())[0];
            if (grdMaster) {
                grdMaster.startEditByPosition(masterStore.getCount(), 0);
            }
        }
    },

    /*
    * Xóa bản ghi đã chọn trên grid
    * Create by: dvthang:08.03.2018
    */
    deteteRecord: function () {
        var me = this, grdMaster = Ext.ComponentQuery.query('#grdMaster', me.getView())[0],
            sm = grdMaster.getSelectionModel().getSelection(),
                 store = grdMaster.getStore();
        if (Ext.isArray(sm) && sm.length > 0) {
            Ext.each(sm, function (item) {
                store.remove(item);
            });
        }
    },

    /*
    * Event thực hiện lưu danh sách cán bộ tham gia đề tài
    * Create by: dvthang:07.03.2018
    */
    btnSave_OnClick: function (sender) {
        var me = this;
        try {
            if (me.validateBeforeSave()) {
                sender.setDisabled(true);
                me.showMask();
                var masterStore = me.getViewModel().getStore('masterStore');
                me.updateDataTable(masterStore, function (datas) {
                    me.processData(sender, datas);
                });
            }
        } catch (e) {
            sender.setDisabled(false);
            me.hideMask();
            QLDT.utility.Utility.handleException(e);
        }
    },
    /*
    * Cập nhật danh sách record thay đổi cập nhật vào masterData
    * Create by: dvthang:30.01.2018
    */
    updateDataTable: function (store, callback) {
        var me = this,
         arrayNewRecords = [], removeRecords = [],
            updateRecords = [];
        if (store) {
            var newsData = store.getNewRecords(),
                removeRecords = store.getRemovedRecords(),
                updateRecords = store.getUpdatedRecords(),
             dataModifieds = [];
            Ext.each(newsData, function (r) {
                r.data.EditMode = QLDT.common.Enumaration.EditMode.Add;
                r.set("ProjectTaskID", me.projectTaskID);
                arrayNewRecords.push(r);
                dataModifieds.push(r.data);
            });

            Ext.each(updateRecords, function (r) {
                r.data.EditMode = QLDT.common.Enumaration.EditMode.Edit;
                r.set("ProjectTaskID", me.projectTaskID);
                dataModifieds.push(r.data);
            });

            Ext.each(removeRecords, function (r) {
                r.data.EditMode = QLDT.common.Enumaration.EditMode.Delete;
                r.set("ProjectTaskID", me.projectTaskID);
                dataModifieds.push(r.data);
            });

            var lAdd = arrayNewRecords.length;
            if (lAdd > 0) {
                var promise = QLDT.utility.Utility.getGuids(lAdd);
                promise.then(function (guids) {
                    Ext.each(arrayNewRecords, function (r, i) {
                        var idProperty = r.idProperty;
                        if (idProperty) {
                            r.set(idProperty, guids[i]);
                        }
                    });
                    callback(dataModifieds);
                }, function (e) {
                    console.log(e);
                });
            } else {
                callback(dataModifieds);
            }
        }
    },
    /*
    * Validate dữ liệu trước khi lưu
    * Create by: dvthang:08.03.2018
    */
    validateBeforeSave: function () {
        var me = this, getGridMaster = me.getGridMaster();
        return getGridMaster.validate();
    },

    /*
   * Hàm thực hiện xử lý data trước khi call API
   * Create by: dvthang:08.01.2018
   */
    processData: function (sender, datas) {
        var me = this;
        var uri = QLDT.utility.Utility.createUriAPI("/ProjectTaskMember/SaveListData"), method = "POST";

        QLDT.utility.MTAjax.request(uri, method, {}, datas, function (respone) {
            if (respone && respone.Success) {
                var gridMaster = me.getGridMaster();
                if (gridMaster) {
                    var store = gridMaster.getStore();
                    if (store) {
                        store.commitChanges();
                    }
                }
            } else {
                if (respone && respone.ErrorMessage) {
                    QLDT.utility.Utility.showError(respone.ErrorMessage);
                } else {
                    QLDT.utility.Utility.showError("Đã có lỗi xảy ra.");
                }
            }
            sender.setDisabled(false);
            me.hideMask();
        }, function (error) {
            sender.setDisabled(false);
            me.hideMask();
            QLDT.utility.Utility.handleException(error);
        });
    },

    /*
    * Lấy về đối tượng grid của form
    * Create by: dvthang:14.01.2018
    */
    getGridMaster: function () {
        var me = this, view = me.getView();
        if (!me.gridMaster) {
            me.gridMaster = Ext.ComponentQuery.query('#grdMaster', view)[0];
        }
        return me.gridMaster;
    },

    /*
    * Hiển thị mask đang lưu
    * Create by: dvthang:3.3.2018
    */
    showMask: function () {
        var me = this, gridMaster = me.getGridMaster();
        if (gridMaster) {
            gridMaster.mask('Đang lưu...');
        }
    },

    /*
    * Event thực hiện đóng form danh sách cán bộ tham gia đề tài
    * Create by: dvthang:07.03.2018
    */
    btnCancel_OnClick: function (sender) {
        var me = this, view = me.getView();
        if (view) {
            view.close();
        }
    },

    /*
    *  Chọn danh sách cán bộ thì hiện lên form
    * Create by: dvthang:07.03.2018
    */
    show: function (masterController, projectTaskID, projectID) {
        var me = this, view = me.getView();
        if (view) {
            me.projectTaskID = projectTaskID;
            view.show();
            var employeeStore = me.getViewModel().getStore('employeeStore');
            if (employeeStore) {
                try {
                    var proxy = employeeStore.getProxy();
                    if (proxy) {
                        proxy.setExtraParams({ masterID: projectID });
                        employeeStore.load({
                            callback: function (records, operation, success) {
                                me.loadData(me.projectTaskID);
                            }
                        });
                    }
                }
                catch (e) {
                    QLDT.utility.Utility.handleException(e);
                }
                
            }
        }
    },

    /*
   * Hàm load data cho Grid - Overrides lại hàm này trên base
   * Create by: laipv:28.01.2018
   */
    loadData: function (masterID) {
        var me = this, store = me.getViewModel().getStore("masterStore");
        if (store) {
            try {
                var proxy = store.getProxy();
                if (proxy) {
                    proxy.setExtraParams({ masterID: masterID });
                    store.load({
                        callback: function (records, operation, success) {
                            //todo
                        }
                    });
                }
            } catch (e) {
                QLDT.utility.Utility.handleException(e);
            }
        }
    },


    /*
    * Hiển thị mask đang lưu
    * Create by: dvthang:3.3.2018
    */
    showMask: function () {
        var me = this, gridMaster = me.getGridMaster();
        if (gridMaster) {
            gridMaster.mask('Đang lưu...');
        }
    },


    /*
    * Ẩn mask sau sau khi lưu xong
    * Create by: dvthang:3.3.2018
    */
    hideMask: function () {
        var me = this, gridMaster = me.getGridMaster();
        if (gridMaster) {
            gridMaster.unmask();
        }
    },

});
