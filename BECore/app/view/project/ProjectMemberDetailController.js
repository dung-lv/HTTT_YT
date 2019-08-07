/**
 * Controller thêm tệp đính kèm của project
 */
Ext.define('QLDT.view.project.ProjectMemberDetailController', {
    extend: 'QLDT.view.base.BasePopupDetailController',

    requires: ['QLDT.view.base.BasePopupDetailController'],

    alias: 'controller.ProjectMemberDetail',
    apiController: 'ProjectMember',

    title: 'Thành viên đề tài',

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
   
    /*
    *
    */
    afterrender: function () {
    },
    /*
    * Danh sách các store load combo
    * Create by: laipv:01.02.2018
    */
    getDictionaryStores: function () {
        return ['employeeStore','projectPositionStore']
    },
    /*
   * Hàm thực hiện xử lý đưa thêm giá trị ProjectID trước khi lưu 
   * Create by: laipv:11.02.2018
   */
    preSaveData: function () {
        var me = this;
        if(me.masterController)
        {
            me.masterData.set("EmployeeName", Ext.ComponentQuery.query("#fieldEmployeeID", me.getView())[0].rawValue);
            me.masterData.set("ProjectPositionName", Ext.ComponentQuery.query("#fieldProjectPositionID", me.getView())[0].rawValue);
            me.masterData.set("ProjectID", me.masterController.masterData.get('ProjectID'));
        }
    },

});