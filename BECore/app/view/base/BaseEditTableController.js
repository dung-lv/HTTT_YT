/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.base.BaseEditTableController', {
    extend: 'QLDT.view.base.BaseController',
    alias: 'controller.BaseEditTable',

    requires: [
        'QLDT.view.base.BaseController'
    ],

    apiController: null,

    gridMaster: null,

    /*Toolbar trên grid*/
    toolbarGrid: null,

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
            '#toolbarGrid button': {
                click: 'toolbar_OnClick',
                scope: me
            },
            '#grdMaster': {
                'beforeeditCell': 'beforeeditCell',
                scope: me,
            }
        });

        me.gridMaster = me.getGridMaster();
        if (me.gridMaster) {
            me.gridMaster.on('edit', function (editor, e) {
                if (typeof me.editGridCustom == 'function') {
                    me.editGridCustom(editor,e);
                }
            });
        }
        
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
    * Thực hiện validate cell trước khi sửa
    * Create by: dvthang:11.03.2018
    */
    beforeeditCell: function (grid, editor, e) {
        var me = this;

        if (typeof me.beforeeditCellCustom == 'function') {
            me.beforeeditCellCustom(grid, editor, e);
        }
    },


    /*
    * Thực hiện thay đổi trạng thái button trên thanh toolbar
    * Create by: dvthang:04.02.2018
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
                }
            });

            if (typeof me.customSetStatusButtonToolBar == 'function') {
                me.customSetStatusButtonToolBar(toolBar, toolBar.items.items);
            }

        }
    },

    /*
    * Lấy về toolbar trên grid
    * Create by: dvthang:04.02.2018
    */
    getToolBar: function () {
        var me = this;
        if (!me.toolbarGrid) {
            me.toolbarGrid = Ext.ComponentQuery.query("#toolbarGrid", me.getView())[0];
        }
        return me.toolbarGrid;
    },

    /*
    * Bắt event click vào button trên thanh toolbar
    * Create by: dvthang:09.01.2018
    */
    toolbar_OnClick: function (sender) {
        var me = this;
        switch (sender.itemId) {
            case 'btnEdit':
                me.editData(sender);
                break;
            case 'btnSave':
                me.saveData(sender);
                break;
            case 'btnUndo':
                me.undo(sender);
                break;
        }
    },

    /*
    * Thêm mới đối tượng
    * Create by: dvthang:15.01.2018
    */
    editData: function (sender) {
        var me = this;
        try {
            var gridMaster = me.getGridMaster();
            if (gridMaster) {
                gridMaster.setReadOnly(false);
                gridMaster.startEditByPosition(0, gridMaster.columnStartEdit);
            }
            me.setStatusButtonToolBar(true);
        } catch (e) {
            QLDT.utility.Utility.handleException(e);
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
    /*
     * Lưu danh sách đối tượng
     * Create by: dvthang:03.03.2018
     */
    saveGrid: function () {
        debugger;
        var me = this;
        try {
            if (me.validateBeforeSave()) {
                me.showMask();
                var masterStore = me.getView().getStoreMaster();
                me.updateDataTable(masterStore, function (datas) {
                    if (typeof me.confirmBeforeSave != 'function' && me.confirmBeforeSave) {
                        me.confirmBeforeSave(datas);
                    } else {
                        me.processData(datas);
                    }
                    if (typeof me.masterController.masterController.FuncLoadGrid == 'function') {
                        me.masterController.masterController.FuncLoadGrid();
                    }
                });
            }
        } catch (e) {
            me.hideMask();
            QLDT.utility.Utility.handleException(e);
        }
    },

    /*
     * Lưu danh sách đối tượng
     * Create by: dvthang:03.03.2018
     */
    saveData: function (sender) {
        debugger;
        var me = this;
        try {
            if (me.validateBeforeSave()) {
                sender.setDisabled(true);
                me.showMask();
                var masterStore = me.getView().getStoreMaster();
                me.updateDataTable(masterStore, function (datas) {
                    if (typeof me.confirmBeforeSave != 'function' && me.confirmBeforeSave) {
                        me.confirmBeforeSave(datas);
                    } else {
                        me.processData(datas);
                    }
                    if (typeof me.masterController.masterController.FuncLoadGrid == 'function') {
                        me.masterController.masterController.FuncLoadGrid();
                    }
                });
            }
        } catch (e) {
            sender.setDisabled(false);
            me.hideMask();
            QLDT.utility.Utility.handleException(e);
        }
    },

    /*
    * Validate dữ liệu trước khi lưu
    * Create by: dvthang:04.02.2018
    */
    validateBeforeSave: function () {
        return true;
    },

    /*
   * Hàm thực hiện xử lý data trước khi call API
   * Create by: dvthang:08.01.2018
   */
    processData: function (datas) {
        debugger;
        var me = this;
        var uri = QLDT.utility.Utility.createUriAPI(me.apiController), method = "POST";

        if (typeof me.preSaveData == 'function') {
            me.preSaveData(datas);
        }
        QLDT.utility.MTAjax.request(uri + '/EditTable', "POST", {}, datas, function (respone) {
            if (respone && respone.Success) {
                me.setStatusButtonToolBar(false);
                var gridMaster = me.getGridMaster();
                if (gridMaster) {
                    var store = gridMaster.getStore();
                    if (store) {
                        store.commitChanges();
                    }
                    //gridMaster.setReadOnly(true);
                }
            } else {
                if (respone && respone.ErrorMessage) {
                    QLDT.utility.Utility.showError(respone.ErrorMessage);
                } else {
                    QLDT.utility.Utility.showError("Đã có lỗi xảy ra.");
                }
            }
            me.hideMask();
        }, function (error) {
            //sender.setDisabled(false);
            me.hideMask();
            QLDT.utility.Utility.handleException(error);
        });
    },

    /*
    * Thực hiện undo lại giá trị trước
    * Create by: dvthang:03.03.2018
    */
    undo: function (sender) {
        var me = this;
        try {
            me.setStatusButtonToolBar(false);
            var gridMaster = me.getGridMaster();
            if (gridMaster) {
                var store = gridMaster.getStore();
                if (store) {
                    store.rejectChanges();
                }
                //gridMaster.setReadOnly(true);
            }
        } catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },

    /*
    * Sau khi load form xong muốn xử lý gì thêm thì gọi hàm này
    * Create by: dvthang:09.01.2018
    */
    afterrender: function () {
        var me = this;
    },

    /*
    * Thực hiện load dữ liệu cho grid
    * Create by: dvthang:29.01.2018
    */
    loadData: function (params, callBack) {
        var me = this;
        try {
            var masterStore = me.getView().getStoreMaster();
            if (masterStore) {
                masterStore.load({
                    params: params,
                    callback: function (records, operation, success) {
                        //todo;
                        if (Ext.isArray(records) && records.length > 0) {
                            me.setStatusButtonToolBar(false);
                            var gridMaster = me.getGridMaster();
                            if (gridMaster) {
                                //gridMaster.setReadOnly(true);
                            }
                        } else {
                            me.setStatusButtonToolBar(false, true);
                        }
                        if (typeof callBack == 'function') {
                            callBack(records);
                        }
                    }
                });
            }
        } catch (e) {
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
                arrayNewRecords.push(r);
                dataModifieds.push(r.data);
            });

            Ext.each(updateRecords, function (r) {
                r.data.EditMode = QLDT.common.Enumaration.EditMode.Edit;
                dataModifieds.push(r.data);
            });

            Ext.each(removeRecords, function (r) {
                r.data.EditMode = QLDT.common.Enumaration.EditMode.Delete;
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
    * Focus row đầu tiên trên grid
    * Create by: dvthang:29.01.2018
    */
    setFocusRowFirst: function (record) {
        var me = this;
        var newRecordsToSelect = [],
         grid = me.getGridMaster();
        if (grid) {
            if (!Ext.isEmpty(record)) {
                grid.getSelectionModel().select(record);
            }
        }
    },
    /*
   *Kiểm tra đầu vào tọa độ
   *Created by:haitq
   */
    checkCoordinates: function (value) {
        var me = this, check = false, i, temp = value.toString();
        if (temp.length == 9) {
            for (i = 0; i < temp.length; i++) {
                if (i == 2) {
                    if (temp[i] == ".") {
                        check = true;
                    }
                    else {
                        check = false;
                        break;
                    }
                } else {
                    if (!isNaN(temp[i])) {
                        check = true;
                    }
                    else {
                        check = false;
                        break;
                    }
                }
            }

        } else if (temp.length == 10) {
            for (i = 0; i < temp.length; i++) {
                if (i == 3) {
                    if (temp[i] == ".") {
                        check = true;
                    }
                    else {
                        check = false;
                        break;
                    }
                } else {
                    if (!isNaN(temp[i])) {
                        check = true;
                    }
                    else {
                        check = false;
                        break;
                    }
                }
            }
        }
        if (check == false) {
            me.showToastSaveSuccess(me.getView(), 300, QLDT.GlobalResource.Coordinates);
        }
        return check
    },

});
