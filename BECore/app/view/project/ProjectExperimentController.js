/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.project.ProjectExperimentController', {
    extend: 'QLDT.view.base.BaseListController',

    requires: ['QLDT.view.base.BaseListController'],

    alias: 'controller.ProjectExperiment',
    apiController: 'ContentExperiment',

    /*Lưu ID của project*/
    projectID: null,
    /*Mask của form*/
    elementMask: null,

    /*
    * Hàm khởi tạo của controller
    * Create by: laipv:04.02.2018
    */
    init: function () {
        var me = this, view = me.getView();
        me.callParent(arguments);
        me.control({
            "#fileItemID": {
                change: 'uploadFile_OnChange',
                scope: me
            }
        });
    },

    /*
    * Gán ID của project cho form
    * Create by: dvthang:24.02.2018
    */
    show: function (projectID) {
        var me = this;
        me.projectID = projectID;

        me.checkShowLinkPlanAttach(projectID);

        me.loadData(projectID);
    },

    /*
   * Thực hiện overrides lại - để không load dữ liệu mặc định mà sẽ tự load
   * Create by: dvthang:04.02.2018
   */
    afterrender: function () {
        //todo

    },

    /*
    * Lấy về link thông tin thử nghiệm
    * Create by: dvthang:24.02.2018
    */
    checkShowLinkPlanAttach: function (masterID) {
        var me = this, store = me.getViewModel().getStore("planAttachStore");
        if (store) {
            try {
                var proxy = store.getProxy();
                if (proxy) {
                    proxy.setExtraParams({ masterId: masterID });
                    store.load({
                        callback: function (records, operation, success) {
                            //Focus vào row đầu tiên trên grid
                            if (Ext.isArray(records) && records.length > 0) {
                                me.showLinkDownloadPlanAttach(records[0].data.ProjectExperimentID, me.projectID, records[0].data.FileType);
                            }
                        }
                    });
                }
            } catch (e) {
                QLDT.utility.Utility.handleException(e);
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
                me.projectID = masterID;
                var proxy = store.getProxy();
                if (proxy) {
                    proxy.setExtraParams({ masterId: masterID });
                    store.load({
                        callback: function (records, operation, success) {
                            var enable = false;
                            //Focus vào row đầu tiên trên grid
                            if (Ext.isArray(records) && records.length > 0) {
                                me.setFocusRowFirst(records[0]);
                                enable = true;
                            }

                            me.setStatusButtonToolBar(enable);

                            //Bắt event click vào lick file để download
                            Ext.each(Ext.select(".grid-file-experiment .file-download").elements, function (element) {
                                element.onclick = function (e) {
                                    e.preventDefault();
                                    var id = e.target.getAttribute("fileid"),
                                        filetype = e.target.getAttribute("filetype");
                                    if (id && filetype) {
                                        QLDT.utility.Utility.downloadFile({
                                            ID: id,
                                            FT: filetype,
                                            IsTemp: false
                                        });
                                    }
                                };
                            });
                        }
                    });
                }
            } catch (e) {
                QLDT.utility.Utility.handleException(e);
            }

        }
    },

    /*
  * Hiển thị mask khi show form
  * Create by: dvthang:24.02.2018
  */
    showMask: function () {
        var me = this,
            view = me.getView();
        if (!me.elementMask) {
            var el = view.getEl();
            me.elementMask = el;
        }
        me.elementMask.mask(QLDT.GlobalResource.Saving);
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
    * Bắt event upload file thành công
    * Create by: dvthang:24.02.2018
    */
    uploadFile_OnChange: function (sender, value, eOpts) {
        var me = this;
        var uri = QLDT.utility.Utility.createUriAPI("Upload/Files"),
             token = QLDT.Config.getToken();
        var form = Ext.ComponentQuery.query('#uploadFile', me.getView())[0];
        if (form) {
            me.showMask();
            form.submitWithFile(function (rep) {
                if (rep && rep.Success && Ext.isArray(rep.Data) && rep.Data.length > 0) {
                    var data = rep.Data[0],
                        objData = {
                            ProjectID: me.projectID, FileName: data.FileName, FileType: data.FileType, FileSize: data.FileSize,
                            FileResourceID: data.FileResourceID, EditMode: QLDT.common.Enumaration.EditMode.Add
                        };
                    var uri = QLDT.utility.Utility.createUriAPI("ProjectExperiment");
                    QLDT.utility.MTAjax.request(uri, "POST", {}, objData, function (respone) {
                        if (respone && respone.Success) {
                            QLDT.utility.Utility.showInfo("Tải tệp thành công.");
                            me.showLinkDownloadPlanAttach(respone["PKValue"], me.projectID, data.FileType);
                        } else {
                            QLDT.utility.Utility.showInfo("Tải tệp thất bại.");
                        }
                        me.hideMask();
                    }, function (error) {
                        me.hideMask();
                        QLDT.utility.Utility.handleException(error);
                    });
                } else {
                    me.hideMask();
                    QLDT.utility.Utility.showInfo("Tải tệp thất bại.");
                }
            });
        }
    },
    /*
    * Hiển thị link download file thông tin thử nghiệm
    * Create by: dvthang:24.02.2018
    */
    showLinkDownloadPlanAttach: function (id, projectID, fileType) {
        var me = this,
        linkDowload = Ext.ComponentQuery.query('#linkDowloadFile', me.getView())[0];
        if (linkDowload) {
            var uriDownload = Ext.String.format(QLDT.utility.Utility.createUriAPI('/Download?TokenID={0}&ID={1}&FT={2}&IsTemp={3}&DF={4}'),
                QLDT.Config.getTokenID(), projectID, fileType, false, QLDT.common.Enumaration.DownLoadFrom.ProjectExperiment),
             strLink = Ext.String.format('<a class="link-download" target="_blank" href="{0}">Tải tệp thông tin thử nghiệm</a><a id="deleteFileProjectExperiment" class="cls-delete-file fa fa-trash-o" projectexperimentid="{1}" href="javascript:void(0)">Xóa tệp</a>', uriDownload, id);
            linkDowload.setHtml(strLink);
            linkDowload.setHidden(false);
            Ext.get('deleteFileProjectExperiment').on('click', function (e) {
                var projectexperimentid = e.target.getAttribute("projectexperimentid");
                if (projectexperimentid) {
                    var uri = QLDT.utility.Utility.createUriAPI("ProjectExperiment");
                    QLDT.utility.MTAjax.request(uri, "DELETE", {}, [projectexperimentid], function (respone) {
                        if (respone && respone.Success) {
                            linkDowload.setHidden(true);
                            QLDT.utility.Utility.showInfo("Xóa thành công");
                        } else {
                            QLDT.utility.Utility.showInfo("Xóa thất bại.");
                        }
                    }, function (error) {
                        QLDT.utility.Utility.handleException(error);
                    });
                }
            });
        }
    },

    /*
   * Trả về tên của form detail
   * Create by: dvthang:09.01.2018
   */
    getPageDetail: function () {
        return 'QLDT.view.project.ProjectExperimentDetail';
    },

    /*
   * Hàm thực hiện load lại dữ liệu trên grid
   * Create by: dvthang:09.01.2018
   */
    refreshData: function (sender) {
        var me = this;
        if (me.projectID) {
            me.loadData(me.projectID);
        }

    },

});
