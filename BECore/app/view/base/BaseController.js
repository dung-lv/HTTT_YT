/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.base.BaseController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.Base',
    
    /*
    * Cập nhật danh sách record thay đổi cập nhật vào masterData
    * Create by: dvthang:30.01.2018
    */
    updateData: function (masterData, storeDetails,callback) {
        var me=this,
            l = storeDetails.length;
        var arrayNewRecords = [], removeRecords = [],
            updateRecords = [];
        for (var i = 0; i < l; i++) {
            var store = me.getViewModel().getStore(storeDetails[i]), setField;
            if (store) {
                var newsData = store.getNewRecords(),
                    removeRecords = store.getRemovedRecords(),
                    updateRecords = store.getUpdatedRecords(),
                        setField = store.setField;
                if (setField) {
                    var dataModifieds = [];
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
                    if (dataModifieds.length > 0) {
                        masterData.set(setField, dataModifieds);
                    }
                }
            }
        }
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
                callback();
            }, function (e) {
                console.log(e);
            });
        } else {
            callback();
        }
    },

    /*
    * Xóa dữ liệu trong store details
    * Create by: dvthang:16.01.2018
    */
    clearDetailsStore: function () {
        var me = this,
            detailsStore = me.getDetailsStores();
        Ext.each(detailsStore, function (name) {
            var store = me.getViewModel().getStore(name);
            if (store) {
                //Cần xử lý store trước khi commit thì overrides lại hàm này
                if (typeof me.processStoreBeforeWhenCommit == 'function') {
                    me.processStoreBeforeWhenCommit(store, name);
                }
                store.commitChanges();
            }
        });
    },

});
