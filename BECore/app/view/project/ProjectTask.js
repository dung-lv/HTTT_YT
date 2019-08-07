/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectTask', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-projecttask',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.project.ProjectTaskController',
        'QLDT.view.project.ProjectTaskModel',
        'QLDT.view.project.ProjectTaskMember',
        'QLDT.view.project.ProjectTaskSort'
    ],
    controller: 'ProjectTask',
    viewModel: 'ProjectTask',

    /*
    * Đánh dấu hiển thị paginf trên grid
    * Create by: manh:26.03.2018
    */
    showPaging: false,

    /*
    * Đánh dấu hiển thị filter trên grid
    * Create by: manh:26.03.2018
    */
    filterable: false,

    cls: 'wrap-projecttask',

    /*
    * Hàm lấy danh sách cột của lưới
    * Create by: laipv:14.01.2018
    * Edit by: truongnm:28.02.2018
    */
    getColumns: function () {
        var me = this, CompanyID = QLDT.Config.getCompanyID();
        if (CompanyID === QLDT.common.Constant.Company_BTC) {
            item = [
           {
               text: 'N.dung t.hiện', dataIndex: 'Contents', minWidth: 180, flex: 1,
               renderer: function (value, meta, record, rowIndex) {
                   var grade = record.get("Grade"), val = '';
                   for (var i = 0; i < grade; i++) {
                       val += "&nbsp;&nbsp;";
                   }
                   meta.tdAttr = 'data-qtip="' + Ext.String.htmlEncode(value) + '"';
                   return Ext.String.format("{0}{1}", val, value);

               }
           },
           {
               xtype: 'MTColumnDateField', text: 'B.đầu', dataIndex: 'StartDate', width: 110,
               renderer: function (value, metaData, record, rowIndex) {
                   if (value) {
                       value = Ext.Date.format(value, 'd/m/Y');
                   }
                   if (record.get("Status") == 12) { // Đã hoàn thành
                       return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                   }
                   return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
               }

           },
           {
               xtype: 'MTColumnDateField', text: 'K.thúc', dataIndex: 'EndDate', width: 110,
               renderer: function (value, metaData, record, rowIndex) {
                   if (value) {
                       value = Ext.Date.format(value, 'd/m/Y');
                   }
                   if (record.get("Status") == 12) { // Đã hoàn thành
                       return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                   }
                   return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
               }
           },
           {
               text: 'Sản phẩm', dataIndex: 'Result', width: 180,
               renderer: function (value, metaData, record, rowIndex) {
                   if (record.get("Status") == 12) { // Đã hoàn thành
                       return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                   }
                   return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
               }
           },
           //{
           //    text: 'Đã hoàn thành', dataIndex: 'StatusName', width: 150, align: 'center',
           //    renderer: function (value, metaData, record, rowIndex) {
           //        var statusName = "Chưa hoàn thành",
           //            cls = "projecttask-status fa fa-times-circle unfisnish", status = 12;
           //        if (record.get("Status") == 11) {
           //            statusName = "Đã hoàn thành";
           //            cls = "projecttask-status fa fa-check-circle fisnish";
           //            status = 11;
           //        }
           //        return Ext.String.format("<div class='{0}' title='{1}' projecttaskid='{2}' status='{3}' ></div>", cls,
           //            statusName, record.get("ProjectTaskID"), status);
           //    }
           //},

           {
               text: 'Đã hoàn thành', dataIndex: 'Inactive', width: 130, xtype: 'MTColumnCheckBox',
               listeners: {
                   checkchange: function (sender, rowIndex, checked, record, e, eOpts) {
                       var projecttaskid = record.get("ProjectTaskID"),
                           inactive = record.get("Inactive"),
                           status = record.get("Status"),
                           controller = me.getController();
                       controller.updateStatusTask(projecttaskid, status);
                   }
               }
           },
            {
                xtype: 'MTColumnAction',
                text: 'Danh sách cán bộ',
                width: 130,
                align: 'center',
                items: [{
                    iconCls: 'add-user-participation fa fa-user-plus',
                    handler: function (grid, rowIndex, colIndex) {
                        var rec = grid.getStore().getAt(rowIndex), projecttaskid = rec.get("ProjectTaskID"),
                            controller = me.getController();
                        controller.showFormProjectTaskMember(projecttaskid);
                    }
                }
                ]
            }
            ];
        }
        else {
            item = [
           {
               text: 'N.dung t.hiện', dataIndex: 'Contents', minWidth: 180, flex: 1,
               renderer: function (value, meta, record, rowIndex) {
                   var grade = record.get("Grade"), val = '';
                   for (var i = 0; i < grade; i++) {
                       val += "&nbsp;&nbsp;";
                   }
                   meta.tdAttr = 'data-qtip="' + Ext.String.htmlEncode(value) + '"';
                   return Ext.String.format("{0}{1}", val, value);

               }
           },
           {
               xtype: 'MTColumnDateField', text: 'B.đầu', dataIndex: 'StartDate', width: 110,
               renderer: function (value, metaData, record, rowIndex) {
                   if (value) {
                       value = Ext.Date.format(value, 'd/m/Y');
                   }
                   if (record.get("Status") == 12) { // Đã hoàn thành
                       return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                   }
                   return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
               }

           },
           {
               xtype: 'MTColumnDateField', text: 'K.thúc', dataIndex: 'EndDate', width: 110,
               renderer: function (value, metaData, record, rowIndex) {
                   if (value) {
                       value = Ext.Date.format(value, 'd/m/Y');
                   }
                   if (record.get("Status") == 12) { // Đã hoàn thành
                       return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                   }
                   return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
               }
           },
           {
               text: 'Sản phẩm', dataIndex: 'Result', width: 180,
               renderer: function (value, metaData, record, rowIndex) {
                   if (record.get("Status") == 12) { // Đã hoàn thành
                       return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                   }
                   return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
               }
           },
            {
                xtype: 'MTColumnAction',
                text: 'Danh sách cán bộ',
                width: 130,
                align: 'center',
                items: [{
                    iconCls: 'add-user-participation fa fa-user-plus',
                    handler: function (grid, rowIndex, colIndex) {
                        var rec = grid.getStore().getAt(rowIndex), projecttaskid = rec.get("ProjectTaskID"),
                            controller = me.getController();
                        controller.showFormProjectTaskMember(projecttaskid);
                    }
                }
                ]
            }
            ];
        }
        return item;
    },

    /*
    * Khai báo store load dữ liệu cho grid
    * Create by: laipv:14.01.2018
    */
    getStoreMaster: function () {
        var me = this,
            store = me.getViewModel().getStore('masterStore');
        return store;
    },

    /*
   * Laays thong tin config cua grid neu co
   */
    getViewConfig: function (record, index) {
        var me = this;
        return {
            getRowClass: function (record, index) {
                if (!record.get('Leaf')) {
                    return 'cls-bold';
                }
                return '';
            }
        };
    },
    /*
    * Override lại hàm lấy thanh công cụ lên
    * Lấy danh sách menu của toolbar
    * Create by: dvthang:24.1.2018
    * Modify by: laipv:08.03.2018 - Thêm nút sắp xếp
    */
    getToolbarMenu: function () {
        var me = this;
        return [
                {
                    iconCls: 'button-add menu-button-item fa fa-plus',
                    cls: 'menu-button-item',
                    text: 'Thêm',
                    itemId: 'mnAdd',
                },
                {
                    iconCls: 'button-add menu-button-item fa fa-copy',
                    cls: 'menu-button-item',
                    text: 'Nhân bản',
                    itemId: 'mnDuplicate',
                },
                 {
                     iconCls: 'button-edit menu-button-item fa fa-pencil-square-o',
                     cls: 'menu-button-item',
                     text: 'Sửa',
                     itemId: 'mnEdit',
                 },
                 {
                     iconCls: 'button-delete menu-button-item fa fa-trash-o',
                     cls: 'menu-button-item',
                     text: 'Xóa',
                     itemId: 'mnDelete',
                 },
                 '-',
                 {
                     iconCls: 'button-refresh menu-button-item fa fa-refresh',
                     cls: 'menu-button-item',
                     text: 'Nạp',
                     itemId: 'mnRefresh',
                 },
                 {
                     iconCls: 'button-sort menu-button-item fa fa-sort',
                     cls: 'menu-button-item',
                     text: 'Sắp xếp',
                     itemId: 'mnSort',
                 },
        ];
    },
    /*
    * Override lại hàm lấy thanh công cụ lên
    * Tạo context menu cho grid
    * Create by: dvthang:07.01.2018
    * Modify by: laipv:08.03.2018 - Thêm menu sắp xếp
    */
    getContextMenu: function () {
        var me = this;
        return [
                {
                    iconCls: 'button-add menu-button-item fa fa-plus',
                    cls: 'menu-button-item',
                    text: 'Thêm',
                    itemId: 'mnAdd',
                    handler: function (sender) {
                        var controller = me.getController();
                        if (controller) {
                            controller.toolbar_OnClick(sender);
                        }
                    }
                },
                {
                    iconCls: 'button-add menu-button-item fa fa-copy',
                    cls: 'menu-button-item',
                    text: 'Nhân bản',
                    itemId: 'mnDuplicate',
                    handler: function (sender) {
                        var controller = me.getController();
                        if (controller) {
                            controller.toolbar_OnClick(sender);
                        }
                    }
                },
                 {
                     iconCls: 'button-edit menu-button-item fa fa-pencil-square-o',
                     cls: 'menu-button-item',
                     text: 'Sửa',
                     itemId: 'mnEdit',
                     handler: function (sender) {
                         var controller = me.getController();
                         if (controller) {
                             controller.toolbar_OnClick(sender);
                         }
                     }
                 },
                 {
                     iconCls: 'button-delete menu-button-item fa fa-trash-o',
                     cls: 'menu-button-item',
                     text: 'Xóa',
                     itemId: 'mnDelete',
                     handler: function (sender) {
                         var controller = me.getController();
                         if (controller) {
                             controller.toolbar_OnClick(sender);
                         }
                     }
                 },
                 '-',
                 {
                     iconCls: 'button-refresh menu-button-item fa fa-refresh',
                     cls: 'menu-button-item',
                     text: 'Nạp',
                     itemId: 'mnRefresh',
                     handler: function (sender) {
                         var controller = me.getController();
                         if (controller) {
                             controller.toolbar_OnClick(sender);
                         }
                     }
                 },
                 {
                     iconCls: 'button-sort menu-button-item fa fa-sort',
                     cls: 'menu-button-item',
                     text: 'Sắp xếp',
                     itemId: 'mnSort',
                     handler: function (sender) {
                         var controller = me.getController();
                         if (controller) {
                             controller.toolbar_OnClick(sender);
                         }
                     }
                 },
        ];
    },
});

