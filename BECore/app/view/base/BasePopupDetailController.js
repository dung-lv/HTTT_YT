/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.base.BasePopupDetailController', {
    extend: 'QLDT.view.base.BaseController',
    alias: 'controller.BasePopupDetail',

    requires: [
       'QLDT.common.Enumaration',
       'QLDT.view.base.BaseController'
    ],

    /*Form thao tác với controller nào*/
    apiController: null,

    /*
    * EL hiển thị mask của window
    */
    elementMask:null,

    /*
    * Bản ghi trên form
    * Create by: dvthang:08.01.2018
    */
    masterData: null,

    /*ID của form*/
    masterId: null,

    /*
    * Giá trị ban đầu của form trước khi lưu
    * Create by: dvthang:08.01.2018
    */
    originalMasterData: null,

    /*
    * ID ban đầu của bản ghi
    * Create by: dvthang:15.01.2018
    */
    oldId: null,

    editMode: QLDT.common.Enumaration.None,

    /*
    * Controller gọi form này
    */
    masterController: null,

    /*
    * Store của màn hình danh sách
    * Create by: dvthang:16.01.2018
    */
    masterStore: null,

    /*
    * Nếu cờ này bằng true thì luôn đóng form mà không cần phải check
    * Create by: dvthang:16.01.2018
    */
    forceClose:false,

    /*
   * Hàm khởi tạo của controller
   * Create by: dvthang:05.01.2018
   */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            "#":{
                beforeclose: 'beforecloseWindow',
                scope: me
            },
            "#btnSave": {
                click: 'btnSave_OnClick',
                scope: me
            },
            "#btnSaveNew": {
                click: 'btnSaveNew_OnClick',
                scope: me
            },

            "#btnCancel": {
                click: 'btnCancel_OnClick',
                scope: me
            }
        });
    },

    /*
    * Hàm thực hiện xử lý trước khi đóng form
    * Create by: dvthang:16.01.2018
    */
    beforecloseWindow: function (panel, eOpts) {
        debugger;
        var me = this;
        try {
            if (!me.forceClose && me.checkChangeData()) {
                QLDT.utility.Utility.showDataNoSave(panel,QLDT.GlobalResource.DataChanged, {}, function (btn) {
                    switch (btn) {
                        case 'yes':
                            me.saveData(me.masterData, false);
                            break;
                        case 'no':
                            me.force = true;
                            me.closeWindow();
                            break;
                        default:
                            break;
                    }
                });
            } else {
                me.rejectChangeData();
            }
        } catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },
    /*
    * Hiển thị toast
    * Create by: dvthang:29.1.2018
    */
    showToastSaveSuccess: function (target, width, texthtml) {
        Ext.toast({
            html: texthtml,
            closable: false,
            align: 't',
            cls: 'toast-custom',
            style: {
                border: '1px solid #00577b',
                background: '#00577b',
                color: 'white'
            },
            centered: true,
            animateTarget: target,
            timeout: 2000,
            width: width
        });
    },

    /*
    * Hiển thị mask khi show form
    * Create by: dvthang:16.01.2018
    */
    showMask:function(){
        var me=this,
            view = me.getView();
        if (!me.elementMask) {
            var el = view.getEl();
            me.elementMask=el;
        }
        me.elementMask.mask(QLDT.GlobalResource.Loading);
    },

    /*
    * Hiển thị mask khi show form
    * Create by: dvthang:16.01.2018
    */
    hideMask: function () {
        var me = this,
            view = me.getView();
        if (!me.elementMask) {
            var el = view.getEl();
            me.elementMask = el;
        }
        me.elementMask.unmask();
    },

    /*
    * Bắt event nhấn nút lưu trên form
    * Create by: dvthang:15.01.2018
    */
    btnSave_OnClick: function (sender) {
        var me = this;
        me.saveData(me.masterData, false);
    },
    /*
    * Bắt event nhấn nút lưu và thêm trên form
    * Create by: dvthang:15.01.2018
    */
    btnSaveNew_OnClick: function (sender) {
        var me = this;
        me.saveData(me.masterData, true);
    },

    /*
    * Bắt event nhấn nút hủy trên form
    * Create by: dvthang:15.01.2018
    */
    btnCancel_OnClick: function (sender) {
        var me = this, view = me.getView();
        if (view) {
            me.forceClose = true;
            me.closeWindow();
        }
    },

    /*
    * Trả về danh sách store load dữ liệu combo dạng danh mục
    * Create by: dvthang:09.01.2018
    */
    getDictionaryStores: function () {
        return [];
    },

    /*
    * Trả về danh sách store load dữ liệu cho grid nếu có
    * Create by: dvthang:09.01.2018
    */
    getDetailsStores: function () {
        return [];
    },

    /*
    * Hàm thực hiện show window, khi show form hàm này chạy đầu tiên, xem các bước nó chạy như thế nào
    */
    show: function (masterController, masterStore, record, editMode) {
        debugger;
        var me = this, view = me.getView(),data;
        if (view) {
            me.editMode = editMode;
            me.masterController = masterController;
            me.masterStore = masterStore;
            me.setTitleWindow();
            view.show();
            me.showMask();
            me.focusFirstControl();
            me.processLayout();
            switch (me.editMode) {
                case QLDT.common.Enumaration.EditMode.Add:
                    data = masterStore.addNew();
                    break;
                case QLDT.common.Enumaration.EditMode.Duplicate:
                    data = masterStore.addNew(Ext.clone(record));
                    me.oldId = data.get(data.idProperty);
                    break;
                default:
                    data = record;
                    break;
            }
            //Khởi tạo các giá trị nhập
            me.initData(data);

            me.masterData = data;
            me.masterData.set('EditMode', me.editMode);
            //Load dữ liệu cho form
            me.loadDataDictionary();
        }
    },

    /*
    * Hàm thực hiện khởi tạo các giá trị nhập trên from
    * Create by: dvthang:15.01.2018
    */
    initData: function (record) {
    },

    /*
    * Thực hiện binding dữ liệu cho form
    * Create by: dvthang:09.01.2018
    */
    formBinding: function () {
        var me = this;

        me.getViewModel().setData({
            masterData: me.masterData
        });
        //Binding các giá trị lên control qua hàm này: Tất cả các giá trị nằm trong biến  me.masterData
        me.getViewModel().bind("{masterData}", function () {

            if (typeof me.afterBindFinish == 'function') {
                //Sau khi binding xong muốn xử lý thêm thì overrides lại hàm này
                me.afterBindFinish();
            }

            me.originalMasterData = me.masterData.getData();
            if (me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                //Commit hết các store
                var stores = me.getDetailsStores();
                if (stores && stores.length > 0) {
                    Ext.each(stores, function (name) {
                        var store = me.getViewModel().getStore(name);
                        if (store) {
                            store.commitChanges();
                        }
                    });
                }
            }

            me.hideMask();
        });
    },

    /*
    * Thực hiện load dữ liệu danh combo
    * Create by: dvthang:09.01.2018
    */
    loadDataDictionary: function () {
        var me = this;
        var stores = me.getDictionaryStores();
        if (stores && stores.length > 0) {
            var count = stores.length, countStoreLoad = 0;
            //Duyệt tưng store để load
            for (var i = 0; i < stores.length; i++) {
                var storeName = stores[i];

                var store = me.getViewModel().getStore(storeName);
                if (store) {
                    var proxy = store.getProxy();
                    if (typeof me.addExtraParams == 'function') {
                        //Custom tham số truyền vào store nếu có hàm addExtraParams overrides ở dưới page
                        me.addExtraParams(store, storeName);
                    } else {
                        //Nếu không chạy luồng mặc định
                        proxy.setExtraParams({ editMode: me.editMode });
                    }                
                    //Call lên api
                    store.load({
                        callback: function (records, operation, success) {
                            countStoreLoad++;
                            //Sau khi load hết store combo thì load tiếp đến store chi tiết của grid nếu có
                            if (countStoreLoad == count) {
                                me.loadDetailsStore();
                            }
                        }
                    });
                }
            }
        } else {
            me.loadDetailsStore();
        }
    },

    /*
    * Thực hiện load store cho grid, tương tự như trên
    * Create by: dvthang:15.01.2018
    */
    loadDetailsStore: function () {
debugger;
        var me = this;
        var stores = me.getDetailsStores();
        if (stores && stores.length > 0) {
            var count = stores.length, countStoreLoad = 0;
            for (var i = 0; i < stores.length; i++) {
                var storeName = stores[i];

                var store = me.getViewModel().getStore(storeName);
                if (store) {
                    var data = [];
                    switch (me.editMode) {
                        case QLDT.common.Enumaration.EditMode.Edit:
                        case QLDT.common.Enumaration.EditMode.Duplicate:
                            var proxy = store.getProxy(),
                             idProperty = me.masterData.idProperty;;
                            proxy.setExtraParams({ masterId: me.masterData.get(idProperty) });
                            store.load({
                                callback: function (records, operation, success) {
                                    countStoreLoad++;
                                    //Load xong store thì gọi tiếp hàm binding các giá trị cho của control trên from
                                    if (countStoreLoad == count) {
                                        me.formBinding();
                                    }
                                }
                            });
                            break;
                        default:
                            store.setData(data);
                            countStoreLoad++;
                            if (countStoreLoad == count) {
                                me.formBinding();
                            }
                            break;
                    }

                }
            }
        } else {
            me.formBinding();
        }
        
    },

    /*
    * Lấy về tên của chức năng
    * Create by: dvthang:15.01.2018
    */
    getMasterObjectName: function () {
        return '';
    },

    /*
    * Hàm thực hiện việc xử lý ẩn hiện layout theo action trên form

    */
    processLayout: function () {
        var me = this;

        //Hàm thực hiện custom xử lý layout
        if (typeof me.processLayoutCustom == 'function') {
            me.processLayoutCustom();
        }
    },

    /*
    * Thiết title cho window
    * Create by: dvthang:08.01.2018
    */
    setTitleWindow: function () {
        var me = this, view = me.getView(),
            title = '';
        switch (me.editMode) {
            case QLDT.common.Enumaration.EditMode.Add:
            case QLDT.common.Enumaration.EditMode.Duplicate:
                title = Ext.String.format("{0} {1}", QLDT.GlobalResource.Add, me.getMasterObjectName());
                break;
            default:
                title = Ext.String.format("{0} {1}", QLDT.GlobalResource.Edit, me.getMasterObjectName());
                break;
        }
        view.setTitle(title);
    },

    /*
    * Hàm thực hiện validate dữ liệu trước khi lưu
    * Create by: dvthang:08.01.2018
    */
    validateBeforeSave: function () {
        debugger;
        var me = this, isValid = true,view=me.getView(),
        form = me.getForm();

        isValid = form && form.isDirty() && form.isValid();
        if (isValid) {
            isValid = me.validateBeforeSaveCustom();
        }
        return isValid;
    },

    /*
    * Lấy về from validate
    * Create by: dvthang:28.01.2018
    */
    getForm:function(){
        var me = this,
            view = me.getView();
        return view.down('[xtype=MTForm]');
    },

    /*
    * Hàm thực hiện validate dữ liệu trước khi lưu - ở các form overrides lại hàm này
    * Create by: dvthang:08.01.2018
    */
    validateBeforeSaveCustom: function () {
        var me = this, isValid = true;
        return isValid;
    },

    /*
    * Hàm thực hiện xử lý data sau khi đã validate thành công
    * Create by: dvthang:08.01.2018
    */
    preSaveData: function () {
        var me = this;
    },

    /*
    * Lưu data của form
    * Create by: dvthang:08.01.2018
    */
    saveData: function (masterData, saveNew) {
        debugger;
        var me = this;
        try {
            if (me.validateBeforeSave()) {
                me.showMask();
                var storeDetails = me.getDetailsStores();
                me.updateData(masterData, storeDetails, function () {
                    if (typeof me.confirmBeforeSave != 'function' && me.confirmBeforeSave) {
                        me.confirmBeforeSave(masterData, saveNew);
                    } else {
                        me.processData(masterData, saveNew);
                    }
                    if (typeof me.masterController.LoadGrid == 'function') {
                        me.masterController.LoadGrid();
                    }
                    else {
                        me.masterController.loadData();
                    }
                    
                });
            } 
        } catch (e) {
            me.hideMask();
            QLDT.utility.Utility.handleException(e);
        }
    },

    /*
    * Hàm thực hiện xử lý data trước khi call API
    * Create by: dvthang:08.01.2018
    */
    processData: function (masterData, saveNew) {
        debugger;
        var me = this;
        var uri = QLDT.utility.Utility.createUriAPI(me.apiController), method = "POST";

        if (me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
            method = "PUT";
        }
        var idProperty = me.masterData.idProperty;

        me.preSaveData();

        QLDT.utility.MTAjax.request(uri, method, {}, masterData.data, function (respone) {
            if (respone && respone.Success) {
                if (idProperty) {
                    me.masterData.set(idProperty, respone["PKValue"]);
                }
                me.masterData.commit();
                me.clearDetailsStore();

                if (typeof me.saveSuccess == 'function') {
                    me.saveSuccess(me.masterController);
                }
                
                me.hideMask();

                if (saveNew) {
                    me.addNew();
                } else {
                    me.editMode = QLDT.common.Enumaration.EditMode.None;
                    me.forceClose = true;
                    me.closeWindow();
                }
                if (me.masterController) {
                    me.masterStore.commitChanges(); 
                }
            } else {
                me.hideMask();
                me.processError(respone);
            }
        }, function (error) {
            me.hideMask();
            QLDT.utility.Utility.handleException(error);
        });
    },

    /*
    * Xử lý lỗi 
    * dvthang:21.01.2018
    */
    processError:function(respone){
        var me=this;
        if (respone.ErrorMessage) {
            QLDT.utility.Utility.showError(respone.ErrorMessage);
        }
    },

    /*
    * Hàm được gọi sau khi nhấn lưu và thêm trên form
    * Create by: 16.01.2018
    */
    addNew: function () {
    
        var me = this;
        me.editMode = QLDT.common.Enumaration.EditMode.Add;
        var record = me.masterStore.addNew();
        if (record) {

            me.setTitleWindow();

            //Clear hết các giá trị nhập trên form
            me.resetForm();
            me.forceClose = false;
            me.clearDetailsStore();

            me.initData(record);
            me.masterData = record;
            me.masterData.set("EditMode", me.editMode);
            me.formBinding();
        }
    },

    /*
    * Reset các giá trị trên form
    * Create by: dvthang:16.01.2018
    */
    resetForm:function(){
        var me = this,
        view = me.getView();
        var form = me.getForm();
        if (form) {
            var frm = form.getForm();
            if (frm) {
                frm.clearInvalid();
                frm.reset();
                var controls = frm.getFields().items;
                if (controls && Ext.isArray(controls) && controls.length > 0) {
                    me.setFocusControl(controls[0]);
                }
            }
        }
    },

    /*
    * Hàm thực hiện focus vào ô nhập đầu tiền trên control
    */
    focusFirstControl:function(){
        var me = this,
       view = me.getView();
        var form = me.getForm();
        if (form) {
            var frm = form.getForm();
            if (frm) {
                var controls = frm.getFields().items;
                if (controls && Ext.isArray(controls) && controls.length > 0) {
                    me.setFocusControl(controls[0]);
                }
            }
        }
    },

    /*
    * Hàm focus vào control
    * Create by: dvthang:16.1.2018
    */
    setFocusControl:function(control){
        if (control) {
            control.focus();
            control.selectText();
        }
    },
    
    /*
    * Thực hiện đóng form
    * Create by: dvthang:08.01.2018
    */
    closeWindow: function () {
        var me = this, view = me.getView();
        if (view) {
            me.rejectChangeData();
            view.close();
        }
    },

    /*
    * Hàm thực hiện commit store sau khi lưu thành công
    * Create by: dvthang:08.01.2018
    */
    acceptChange: function () {

    },

    /*
    * Hàm thực hiện undo record trên form nhập về giá trị cũ
    * Create by: dvthang:08.01.2018
    */
    rejectChangeData: function () {
        var me = this;
        try {
            if (me.masterStore) {
                me.masterStore.rejectChanges();
            }
        } catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },

    /*
    * Hàm thực hiện kiểm tra data đã có thay đổi
    * Create by: dvthang:08.01.2018
    */
    checkChangeData: function () {
        var me = this, hasChangeData = false;

        if (!Ext.Object.equals(me.originalMasterData, me.masterData.getData())) {
            hasChangeData = true;
        }

        if (!hasChangeData) {
            //Kiểm tra đến detailsStore;
            var detailsStore = me.getDetailsStores();
            if (detailsStore && detailsStore.length > 0) {
                for (var i = 0; i < detailsStore.length; i++) {
                    var store = me.getViewModel().getStore(detailsStore[i]);
                    if (store) {
                        var modifiedRecords = store.getModifiedRecords();
                        if (modifiedRecords && modifiedRecords.length > 0) {
                            hasChangeData = true;
                            break;
                        }
                    }
                }
            }
        }
        return hasChangeData;
    },
});
