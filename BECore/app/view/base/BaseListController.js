/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.base.BaseListController', {
    extend: 'QLDT.view.base.BaseController',
    alias: 'controller.BaseList',

    requires: [
        'QLDT.view.base.BaseController'
    ],

    apiController: null,
    
    gridMaster: null,


    /*
    * Bản ghi trên form
    * Create by: dvthang:08.01.2018
    */
    masterData: null,

    /*ID của form*/
    masterId: null,

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
            "#grdMaster": {
                'beforeshowContextMenu': 'beforeshowContextMenuGridMaster',
                'selectionchange': 'selectionChangeItem',
                scope: me
            },
            '#toolbarGrid button': {
                click: 'toolbar_OnClick',
                scope: me
            }
        });

    },

    /*
    * Event chọn item trên grid
    * Create by: dvthang:25.02.2018
    */
    selectionChangeItem: function (view, selections, options) {
        var me = this;
        //todo
        if (typeof me.customSelectionChangeItem === 'function') {
            me.customSelectionChangeItem(view, selections, options);
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
    * Bắt event trước khi show context menu
    * Create by: dvthang:29.01.2018
    */
    beforeshowContextMenuGridMaster: function (grid, menuContext,record) {
        var me = this, store = grid.getStore();
        if (store) {
            var total = store.getCount(), items = menuContext.items.items;
            Ext.each(menuContext.items.items, function (it) {
                switch (it.itemId) {
                    case 'mnAdd':
                        it.setDisabled(false);
                        break;
                    case 'mnDuplicate':
                        it.setDisabled(total <= 0);
                        break;
                    case 'mnEdit':
                        it.setDisabled(total <= 0);
                        break;
                    case 'mnDelete':
                        it.setDisabled(total <= 0);
                        break;
                }
            });

            /*Thực custom hiển thị contex trên grid*/
            if (typeof me.customBeforeshowContextMenuGridMaster === 'function') {
                me.customBeforeshowContextMenuGridMaster(grid, menuContext, record, items);
            }
        }
    },

    /*
    * Thực hiện thay đổi trạng thái button trên thanh toolbar
    * Create by: dvthang:04.02.2018
    */
    setStatusButtonToolBar: function (enabled, record) {
        var me = this, toolBar = me.getToolBar();
        if (toolBar) {
            Ext.each(toolBar.items.items, function (it) {
                switch (it.itemId) {
                    case 'mnAdd':
                        it.setDisabled(false);
                        break;
                    case 'mnDuplicate':
                        it.setDisabled(!enabled);
                        break;
                    case 'mnEdit':
                        it.setDisabled(!enabled);
                        break;
                    case 'mnDelete':
                        it.setDisabled(!enabled);
                        break;
                }
            });

            if (typeof me.customSetStatusButtonToolBar === 'function') {
                me.customSetStatusButtonToolBar(toolBar,record, toolBar.items.items);
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
    * Modify by: laipv:04.03.2018: Thêm chức năng Sort2
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
            case 'mnCopy':
                me.duplicate(sender);
                break;
        }
    },
	
	/*
    * Nhân bản
    * Create by: dvthang:15.01.2018
    */
    duplicate: function (sender) {
        var me = this, reportYear = QLDT.Config.getReportYear();
        try {
            var grid = me.getGridMaster();
            if (grid) {
                var sm = grid.getSelectionModel().getSelection();
                if (sm && sm.length > 0) {
                    sm[0].data.ReportYear = reportYear;
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
    *Xem giá trị trên form
    *Created by:haitq
    */
    readData: function (sender) {
        var me = this;
        try {
            var grid = me.getGridMaster();
            if (grid) {
                var sm = grid.getSelectionModel().getSelection();
                if (sm && sm.length > 0) {
                    me.showFormDetail(sm[0], QLDT.common.Enumaration.EditMode.Read);
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
debugger;
                                var idProperty;
                                Ext.each(sm, function (item) {
                                    if (!idProperty) {
                                        idProperty = item.idProperty;
                                    }
                                    selected.push(item.get(idProperty));
                                });
                                me.processDeleteData(selected, grid, idProperty,sm);
                                if (typeof me.FuncLoadGrid === 'function') {
                                    me.FuncLoadGrid();
                                }
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
    * Xử lý xóa dữ liệu trên grid
    * Create by: dvthang:15.01.2018
    */
    processDeleteData: function (selected, grid, idProperty, sm) {
        var me = this, uriDel = QLDT.utility.Utility.createUriAPI(me.apiController), store = grid.getStore();
        QLDT.utility.MTAjax.request(uriDel, "DELETE", {}, selected, function (respone) {
            if (respone.Success) {
                var lstDel = respone.Data,
                    recordsNotAllowDelete = [];
                Ext.each(selected, function (id) {
                    debugger;
                    var index = store.find(idProperty, id);
                    if (lstDel && Ext.isArray(lstDel) && Ext.Array.indexOf(lstDel, id) > -1) {
                        if (store && index > -1) {
                            store.removeAt(index);
                        }
                    } else {
                        debugger;
                        //Các bản ghi không xóa được
                        if (store && index > -1) {
                            var record = store.getAt(index);
                            recordsNotAllowDelete.push(record);
                        }
                       
                    }
                });
                store.commitChanges();
                if (store.getCount() > 0) {
                    me.setFocusRowFirst(store.first());
                }

                var messages = [], name = '';
                Ext.each(recordsNotAllowDelete, function (r) {
                    name = r.name;
                    messages.push(Ext.String.format('<span class="cls-bold">{0}</span>', r.get(name)));
                });
                if (messages.length > 0) {
                    debugger;
                    //todo đã có lỗi xảy ra
                    QLDT.utility.Utility.showWarning(Ext.String.format(QLDT.GlobalResource.Incurred, messages.join(', ')));
                }

            } else {
                debugger;
                var messages = [], name = '';
                Ext.each(sm, function (r) {
                    name = r.name;
                    messages.push(Ext.String.format('<span class="cls-bold">{0}</span>', r.get(name)));
                });
                if (messages.length > 0) {
                    //todo đã có lỗi xảy ra
                    QLDT.utility.Utility.showWarning(Ext.String.format(QLDT.GlobalResource.Incurred, messages.join(', ')));
                } else {
                    if (respone.ErrorMessage) {
                        //todo đã có lỗi xảy ra
                        QLDT.utility.Utility.showError(respone.ErrorMessage);
                    }
                }
            }

        }, function (error) {
            QLDT.utility.Utility.handleException(error);
        });
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
    
    /*
    * Hiển thị form chi tiết
    * Create by: dvthang:09.01.2018
    */
    showFormDetail: function (record, editMode) {
        var me = this,
         pageDetail = me.getPageDetail();

        if (pageDetail) {
            var frm = Ext.create(pageDetail);
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
    * Sau khi load form xong muốn xử lý gì thêm thì gọi hàm này
    * Create by: dvthang:09.01.2018
    */
    afterrender: function () {
        var me = this;
        me.loadData();
    },

    /*
    * Thực hiện load dữ liệu cho grid
    * Create by: dvthang:29.01.2018
    */
    loadData: function () {
        var me = this;
        try {
            var masterStore = me.getView().getStoreMaster();
            if (masterStore) {
                masterStore.load({
                    callback: function (records, operation, success) {
                        //todo;
                        var enable = false,record=null;
                        if (Ext.isArray(records) && records.length > 0) {
                            record = records[0];
                            me.setFocusRowFirst(records[0]);
                            enable = true;
                        }
                        me.setStatusButtonToolBar(enable, record);
                    }
                });
            }
        } catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },
    LoadGrid: function () {
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
    * Trả về tên của form detail
    * Create by: dvthang:09.01.2018
    */
    getPageDetail: function () {
        return null;
    },
    /*
    * Trả về tên của form Sort
    * Create by: laipv:04.03.2018
    */
    getPageSort: function () {
        return null;
    },
    /*
    * Hàm thực hiện validate dữ liệu trước khi lưu
    * Create by: dvthang:08.01.2018
    */
    validateBeforeSave: function () {
        var me = this, isValid = true, view = me.getView(),
            form = me.getForm();

        isValid = form && form.isDirty() && form.isValid();
        if (isValid) {
            isValid = me.validateBeforeSaveCustom();
        }
        return isValid;
    },
    
    /*
    * Lưu data của form
    * Create by: dvthang:08.01.2018
    */
    saveData: function (masterData, saveNew) {
        var me = this;
        try {
            if (me.validateBeforeSave()) {
                var storeDetails = me.getDetailsStores();
                me.updateData(masterData, storeDetails, function () {
                    if (typeof me.confirmBeforeSave !== 'function' && me.confirmBeforeSave) {
                        me.confirmBeforeSave(masterData, saveNew);
                    } else {
                        me.processData(masterData, saveNew);
                    }
                });
                if (typeof me.masterController.masterController.FuncLoadGrid() === 'function') {
                    me.masterController.masterController.FuncLoadGrid();
                }

            }
        } catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },
    /*
    * Hàm thực hiện xử lý data sau khi đã validate thành công
    * Create by: dvthang:08.01.2018
    */
    preSaveData: function () {
        var me = this;
    },
    /*
   * Xử lý lỗi 
   * dvthang:21.01.2018
   */
    processError: function (respone) {
        var me = this;
        if (respone.ErrorMessage) {
            QLDT.utility.Utility.showError(respone.ErrorMessage);
        }
    },
    /*
    * Hàm thực hiện xử lý data trước khi call API
    * Create by: dvthang:08.01.2018
    */
    processData: function (masterData, saveNew) {
        var me = this;
        var uri = QLDT.utility.Utility.createUriAPI(me.apiController), method = "POST";

        if (me.editMode === QLDT.common.Enumaration.EditMode.Edit) {
            method = "PUT";
        }
        var idProperty = me.masterData.idProperty;

        me.preSaveData();

        QLDT.utility.MTAjax.request(uri, method, {}, masterData.data, function (respone) {
            if (respone && respone.Success) {
                if (idProperty && me.editMode !== QLDT.common.Enumaration.EditMode.Edit) {
                    me.masterData.set(idProperty, respone["PKValue"]);
                }
                me.masterData.commit();
                me.clearDetailsStore();

                if (typeof me.saveSuccess === 'function') {
                    me.saveSuccess();
                }
                if (saveNew) {
                    me.addNew();
                }
                //else {
                //    me.editMode = QLDT.common.Enumaration.EditMode.Edit;
                //}
                if (me.masterController) {
                    me.masterStore.commitChanges();
                }
            } else {
                me.processError(respone);
            }
        }, function (error) {
            QLDT.utility.Utility.handleException(error);
        });
    }
});
