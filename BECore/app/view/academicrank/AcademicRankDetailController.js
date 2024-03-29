﻿/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.academicrank.AcademicRankDetailController', {
    extend: 'QLDT.view.base.BasePopupDetailController',

    requires: ['QLDT.view.base.BasePopupDetailController'],

    alias: 'controller.AcademicRankDetail',

    apiController: 'AcademicRanks',

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
        });
    },

    afterrender: function () {

    },

    /*
    * Tên form
    * Create by: manh:17.01.2018
    */
    getMasterObjectName: function () {
        return "Học hàm";
    },


    /*
    * Sửa và nhân bản thì hiện checkbox, thêm thì ẩn checkbox
    * Create by: manh:18.03.2018
    */
    processLayout: function () {
        var me = this, fieldInative = Ext.ComponentQuery.query("#fieldInactive", me.getView())[0];
        if (fieldInative) {
            if (me.editMode == QLDT.common.Enumaration.EditMode.Duplicate || me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                fieldInative.show();
            }
            else {
                fieldInative.hide();
            }
        }
    }, 

    /*
    * Hàm thực hiện khởi tạo các giá trị nhập trên from
    * Thêm và nhân bản thì là 'đang theo dõi'
    * Create by: manh:18.03.2018
    */
    initData: function (record) {
        var me = this;
        if (me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
            record.set("Inactive", 1);
        }
    },

});
