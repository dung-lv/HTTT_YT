/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.project.ProjectDetailController', {
    extend: 'QLDT.view.base.BasePopupDetailController',

    requires: ['QLDT.view.base.BasePopupDetailController'],

    alias: 'controller.ProjectDetail',

    forceClose: true,
    /*
    * Hàm khởi tạo của controller
    * Create by: dvthang:05.01.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            "#tabProject": {
                tabchange: 'tabchangeProject',
                scope: me
            }
        });

    },

    /*
   * Bắt event nhấn nút lưu trên form
   * Create by: dvthang:15.01.2018
   */
    btnSave_OnClick: function (sender) {
        var me = this;
        //overrides todo
    },

    /*
    * Bắt event nhấn nút lưu và thêm trên form
    * Create by: dvthang:15.01.2018
    */
    btnSaveNew_OnClick: function (sender) {
        var me = this;
        //overrides todo
    },
    /*
    * Thực hiện kiểm tra trạng thái Thêm Sửa Xóa
    * Mở form detail từ tab "Đang đề xuất" thì chỉ hiện 3 tab đầu, ẩn hết các tab còn lại
    * Người dùng thuộc BTC thì hiện tab thông tin tài chính
    * Create by: truongnm:10.03.2018
    * Modify by: manh:30.03.2018
    */
    processLayoutCustom: function () {
        var me = this, tabProject = Ext.ComponentQuery.query("#tabProject", me.getView())[0],
            tabProjectTaskID = tabProject.getComponent("tabProjectTaskID"),
            tabProjectMemberID = tabProject.getComponent("tabProjectMemberID"),
            tabProjectWorkshopID = tabProject.getComponent("tabProjectWorkshopID"),
            tabProjectSurveyID = tabProject.getComponent("tabProjectSurveyID"),
            tabProjectExperimentID = tabProject.getComponent("tabProjectExperimentID"),
            tabProjectProgressReportID = tabProject.getComponent("tabProjectProgressReportID"),
            tabProjectAcceptanceBasicDetailID = tabProject.getComponent("tabProjectAcceptanceBasicDetailID"),
            tabProjectAcceptanceManageDetailID = tabProject.getComponent("tabProjectAcceptanceManageDetailID"),
            tabProjectCloseDetailID = tabProject.getComponent("tabProjectCloseDetailID"),
            tabProjectInfoFinID = tabProject.getComponent("tabProjectInfoFinID"),
            UserName = QLDT.Config.getUserName(),
            CompanyID = QLDT.Config.getCompanyID();

        if (me.masterController.alias == "controller.Project") {
            tabProject.remove(tabProjectTaskID);
            tabProject.remove(tabProjectMemberID);
            tabProject.remove(tabProjectWorkshopID);
            tabProject.remove(tabProjectSurveyID);
            tabProject.remove(tabProjectExperimentID);
            tabProject.remove(tabProjectProgressReportID);
            tabProject.remove(tabProjectAcceptanceBasicDetailID);
            tabProject.remove(tabProjectAcceptanceManageDetailID);
            tabProject.remove(tabProjectCloseDetailID);

        }

        if (me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
            me.getViewModel().data.IsDisabled = false;
        }
        else {
            me.getViewModel().data.IsDisabled = true;
        }

        if (CompanyID != QLDT.common.Constant.Company_BTC) {
            tabProject.remove(tabProjectInfoFinID);
        }
    },

    /*
    * Cập nhật trạng thái các Tab của Project
    * Create by: dvthang:11.03.2018
    */
    updateStatusTab: function () {
        var me = this;
        me.getViewModel().data.IsDisabled = false;
    },

    /*
    * Thực hiện binding dữ liệu cho form
    * Create by: dvthang:09.01.2018
    */
    formBinding: function () {
        var me = this;
        me.bindingInfoDetail();
    },

    /*
    * Load dữ liệu cho form detail
    * Create by: dvthang:28.01.2018
    */
    bindingInfoDetail: function () {
        var me = this, view = me.getView(),
            tabInfo = Ext.ComponentQuery.query("#projectinfodetailID", view)[0];
        if (tabInfo) {
            var controller = tabInfo.getController();
            if (controller) {
                controller.show(me, me.masterStore, me.masterData, me.editMode);

            }
        }
    },
    bindingInfoFin: function () {
        var me = this, view = me.getView(),
            tabInfoFin = Ext.ComponentQuery.query("#projectinfofinID", view)[0];
        if (tabInfoFin) {
            var controller = tabInfoFin.getController();
            if (controller) {
                controller.show(me, me.masterStore, me.masterData, me.editMode);

            }
        }
    },


    /*
    * Load dữ liệu cho form ProjectAcceptanceBasicDetail
    * Create by: manh:06.02.2018
    */
    bindingAcceptanceBasicDetail: function () {
        var me = this, view = me.getView(),
            tabProjectAcceptanceBasic = Ext.ComponentQuery.query("#projectacceptancebasicdetailID", view)[0];
        if (tabProjectAcceptanceBasic) {
            var controller = tabProjectAcceptanceBasic.getController();
            if (controller && me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                //
                var store = me.getViewModel().getStore("projectAcceptanceBasicStore");
                store.load({
                    params: { ProjectID: me.masterData.get("ProjectID") },
                    callback: function (records, operation, success) {
                        if (success) {
                            var editMode = QLDT.common.Enumaration.EditMode.Add,
                                createdBy = me.masterData.get("CreatedBy"),
                                masterData = null;
                            if (Ext.isArray(records) && records.length > 0) {
                                editMode = QLDT.common.Enumaration.EditMode.Edit;
                                masterData = records[0];
                            }
                            controller.show(me, store, masterData, editMode, createdBy);
                        }
                    }
                });
            }
        }
    },


    /*
    * Load dữ liệu cho form ProjectAcceptanceManageDetail
    * Create by: manh:06.02.2018
    */
    bindingAcceptanceManageDetail: function () {
        var me = this, view = me.getView(),
            tabAcceptanceBasic = Ext.ComponentQuery.query("#projectacceptancemanagedetailID", view)[0];
        if (tabAcceptanceBasic) {
            var controller = tabAcceptanceBasic.getController();
            if (controller && me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                //store nhiệm thu cấp quản lý
                var store = me.getViewModel().getStore("projectAcceptanceManageStore");
                store.load({
                    params: { projectId: me.masterData.get("ProjectID") },
                    callback: function (records, operation, success) {
                        if (success) {
                            var editMode = QLDT.common.Enumaration.EditMode.Add,
                                createdBy = me.masterData.get("CreatedBy"),
                                masterData = null;
                            if (Ext.isArray(records) && records.length > 0) {
                                editMode = QLDT.common.Enumaration.EditMode.Edit;
                                masterData = records[0];
                            }
                            controller.show(me, store, masterData, editMode, createdBy);
                        }
                    }
                });

            }
        }

    },

    /*
    * Load dữ liệu cho form ProjectCloseDetail
    * Create by: manh:06.02.2018
    */
    bindingCloseDetail: function () {
        var projectclosedetaiItemId = Ext.ComponentQuery.query("#projectclosedetaiItemId", view)[0];
        if (projectclosedetaiItemId) {
            var controller = projectclosedetaiItemId.getController();
            if (controller && me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                controller.show(me.masterData.get("ProjectID"));
            }
        }
    },
    /*
    * Load dữ liệu cho form ProjectPlanperFormDetail
    * Create by: truongnm:11.02.2018
    * EditBy: truongnm 25.02.2018
    */
    bindingPlanPerformDetail: function () {
        var me = this, view = me.getView(),
            tabProjectPlanPerform = Ext.ComponentQuery.query("#projectplanperformdetailID", view)[0];
        if (tabProjectPlanPerform) {
            var controller = tabProjectPlanPerform.getController();
            if (controller && me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                //
                var store = me.getViewModel().getStore("projectPlanPerformStore");
                store.load({
                    params: {
                        masterID: me.masterData.get("ProjectID"),
                    },
                    callback: function (records, operation, success) {
                        if (success) {
                            var editMode = QLDT.common.Enumaration.EditMode.Add,
                                createdBy = me.masterData.get("CreatedBy"),
                                masterData = null;
                            if (Ext.isArray(records) && records.length > 0) {
                                editMode = QLDT.common.Enumaration.EditMode.Edit;
                                masterData = records[0];
                            }
                            controller.show(me, store, masterData, editMode, createdBy);
                        }
                    }
                });
            }
        }
    },
    /*
    * Load dữ liệu cho form ProjectPlanExpenseDetail
    * Create by: truongnm:11.02.2018
    */
    bindingPlanExpenseDetail: function () {
        var me = this, view = me.getView(),
            tabProjectPlanExpense = Ext.ComponentQuery.query("#projectplanexpensedetailID", view)[0];
        if (tabProjectPlanExpense) {
            var controller = tabProjectPlanExpense.getController();
            if (controller && me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                //
                var store = me.getViewModel().getStore("projectPlanExpenseStore");
                store.load({
                    params: { masterID: me.masterData.get("ProjectID") },
                    callback: function (records, operation, success) {
                        if (success) {
                            var editMode = QLDT.common.Enumaration.EditMode.Add,
                                createdBy = me.masterData.get("CreatedBy"),
                                masterData = null;
                            if (Ext.isArray(records) && records.length > 0) {
                                editMode = QLDT.common.Enumaration.EditMode.Edit;
                                masterData = records[0];
                            }
                            controller.show(me, store, masterData, editMode, createdBy);
                        }
                    }
                });
            }
        }
    },


    /*
    * Bắt event tab change của form chi tiết
    * Create by: dvthang:28.01.2018
    */
    tabchangeProject: function (tabPanel, tab) {
        var me = this, view = me.getView();
        try {
            switch (tab.name) {
                case "projectinfodetail":
                    me.bindingInfoDetail();
                    break;
                case "projectinfofin":
                    me.bindingInfoFin();
                    break;
                case "projectplanperformdetail":
                    me.bindingPlanPerformDetail();
                    break;
                case "projectplanexpensedetail":
                    me.bindingPlanExpenseDetail();
                    break;
                case "projectworkshopdetail":
                    break;
                case "projecttaskdetail":
                    var tabInfo = Ext.ComponentQuery.query("#projecttaskID", view)[0];
                    if (tabInfo) {
                        var controller = tabInfo.getController();
                        if (controller && me.editMode == QLDT.common.Enumaration.EditMode.Edit) {

                            controller.loadData(me.masterData.get("ProjectID"));
                        }
                    }
                    break;
                case "projectmember":
                    var tabProjectMember = Ext.ComponentQuery.query("#projectmemberID", view)[0];
                    if (tabProjectMember) {
                        var controller = tabProjectMember.getController();
                        if (controller && me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                            controller.loadData(me.masterData.get("ProjectID"));
                            //Truyền giá trị xuống con
                            controller.masterData = me.masterData;
                        }
                    }
                    break;

                case "projectworkshop":
                    var tabProjectWorkshop = Ext.ComponentQuery.query("#projectworkshopID", view)[0];
                    if (tabProjectWorkshop) {
                        var controller = tabProjectWorkshop.getController();
                        if (controller && me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                            controller.loadData(me.masterData.get("ProjectID"));
                            //Truyền giá trị xuống con
                            controller.masterData = me.masterData;
                        }
                    }
                    break;
                case "projectprogressreport":
                    var tabProjectProgressReport = Ext.ComponentQuery.query("#projectprogressreportID", view)[0];
                    if (tabProjectProgressReport) {
                        var controller = tabProjectProgressReport.getController();
                        if (controller && me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                            controller.loadData(me.masterData.get("ProjectID"));
                            //Truyền giá trị xuống con
                            controller.masterData = me.masterData;
                        }
                    }
                    break;
                case "projectplanexpensedetail":
                    break;
                case "projectacceptancebasicdetail":
                    me.bindingAcceptanceBasicDetail();
                    break;
                case "projectacceptancemanagedetail":
                    me.bindingAcceptanceManageDetail();
                    break;
                case "projectclosedetail":
                    var me = this, view = me.getView(),
                    tabProjectClose = Ext.ComponentQuery.query("#projectclosedetailItemId", view)[0];
                    if (tabProjectClose) {
                        var controller = tabProjectClose.getController();
                        if (controller && me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                            //
                            var store = me.getViewModel().getStore("projectCloseStore");
                            store.load({
                                params: { masterID: me.masterData.get("ProjectID") },
                                callback: function (records, operation, success) {
                                    if (success) {
                                        var editMode = QLDT.common.Enumaration.EditMode.Add,
                                            createdBy = me.masterData.get("CreatedBy"),
                                            masterData = null;
                                        if (Ext.isArray(records) && records.length > 0) {
                                            editMode = QLDT.common.Enumaration.EditMode.Edit;
                                            masterData = records[0];
                                        }
                                        //
                                        controller.show(me, store, masterData, editMode, createdBy);
                                    }
                                }
                            });
                        }
                    }
                    break;
                case "projectsurvey":
                    var projectsurveyItemId = Ext.ComponentQuery.query("#projectsurveyItemId", view)[0];
                    if (projectsurveyItemId) {
                        var controller = projectsurveyItemId.getController();
                        if (controller && me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                            controller.show(me.masterData.get("ProjectID"));
                        }
                    }
                    break;
                case "projectexperiment":
                    var projectexperimentItemId = Ext.ComponentQuery.query("#projectexperimentItemId", view)[0];
                    if (projectexperimentItemId) {
                        var controller = projectexperimentItemId.getController();
                        if (controller && me.editMode == QLDT.common.Enumaration.EditMode.Edit) {
                            controller.show(me.masterData.get("ProjectID"));
                        }
                    }
                    break;


            }
        } catch (e) {
            QLDT.utility.Utility.handleException(e);
        }
    },
    /*
    * Thiết title cho window
    * Create by: laipv:26.02.2018
    * Edit by Manh:08.03.2018
    */
    setTitleWindow: function () {
        var me = this, view = me.getView(),
            gridMaster = me.masterController.gridMaster,
            treeExecutable = me.masterController.treeExecutable
        title = '';
        switch (me.editMode) {
            case QLDT.common.Enumaration.EditMode.Add:
            case QLDT.common.Enumaration.EditMode.Duplicate:
                if (gridMaster) {
                    title = Ext.String.format("{0} đề tài", QLDT.GlobalResource.Add);
                    break;
                }
                else {
                    title = Ext.String.format("{0} đề tài", QLDT.GlobalResource.Add);
                    break;
                }
            default:
                if (gridMaster) {
                    title = Ext.String.format("{0} đề tài: {1}", QLDT.GlobalResource.Edit, gridMaster.selection.get("ProjectName"));
                    break;
                }
                else {
                    title = Ext.String.format("{0} đề tài: {1}", QLDT.GlobalResource.Edit, treeExecutable.selection.get("ProjectName"));
                    break;
                }
        }
        view.setTitle(title);
    },

});
