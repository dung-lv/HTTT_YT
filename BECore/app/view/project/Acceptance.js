/** 
 * Tab đang đã nghiệm thu
 */
Ext.define('QLDT.view.project.Acceptance', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-acceptance',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.project.AcceptanceController',
        'QLDT.view.project.AcceptanceModel',
    ],

    controller: 'Acceptance',
    viewModel: 'Acceptance',
    /*
   * Không lọc dữ liệu
   * Create by: laipv:28.03.2018
   */
    filterable: false,
    /*
    * Đánh dấu hiển thị pagging trên grid
    * Create by: laipv:28.03.2018
    */
    showPaging: false,

    /*
    * Trả về nội dung của form
    * Nếu người dùng là BTC thì danh sách trả về Tên đề tài viết tắt và tooltip hiện Tên đề tài đầy đủ
    * Create by: laipv:14.01.2018
    * Modify by:manh: 04.05.18
    */
    getColumns: function () {
        var me = this,
            CompanyID = QLDT.Config.getCompanyID();
        var vColumns = [
                {
                    xtype: 'MTColumn', text: 'Tên đề tài', dataIndex: 'ProjectName', width: 250, flex: 1,
                    renderer: function (value, metaData, record, rowIndex) {
                        var IsProject = record.get("IsProject"), val = '';
                        if (!(CompanyID == QLDT.common.Constant.Company_BTC)) {
                            if (IsProject) {
                                val += "&nbsp;&nbsp;&nbsp;&nbsp;";
                            }
                            value = Ext.String.htmlEncode(value);

                            metaData.tdAttr = 'data-qtip="' + Ext.String.htmlEncode(value) + '"';
                            return Ext.String.format("{0}{1}", val, value);
                        }
                        else {
                            if (IsProject) {
                                val += "&nbsp;&nbsp;&nbsp;&nbsp;";
                                value = record.get("ProjectNameAbbreviation");
                                var projectName = record.get("ProjectName");
                                metaData.tdAttr = 'data-qtip="' + Ext.String.htmlEncode(projectName) + '"';
                            }
                            else {
                                value = Ext.String.htmlEncode(value);
                                metaData.tdAttr = 'data-qtip="' + Ext.String.htmlEncode(value) + '"';
                            }
                            return Ext.String.format("{0}{1}", val, value);
                        }
                    }
                },
                {
                    text: 'Chủ nhiệm', dataIndex: 'EmployeeName', minWidth: 150, xtype: 'MTColumn',
                },
                { xtype: 'MTColumnDateField', text: 'B.đầu', dataIndex: 'StartDate', width: 100 },
                { xtype: 'MTColumnDateField', text: 'K.thúc', dataIndex: 'EndDate', width: 100 },
                { text: 'Sản phẩm', dataIndex: 'Result', minWidth: 150, xtype: 'MTColumn' },
                { xtype: 'MTColumnDateField', text: 'Ngày N.Thu', dataIndex: 'CloseDate', width: 100 },
                { text: 'Trạng thái', dataIndex: 'StatusName', minWidth: 150, xtype: 'MTColumn' },
        ];
        //Khi là trợ lý thì hiện các thành phần của trợ lý lên xem
        //1. Nếu là nhóm Thủ Trưởng viện + Ban Kế hoạch + Ban Tài chính + Ban Chính trị --> Được xem tất cả

        var PositionID = QLDT.Config.getPositionID();
        var EmployeeID = QLDT.Config.getEmployeeID();
        //
        if (!(
                CompanyID == QLDT.common.Constant.Company_TTV_B ||
                CompanyID == QLDT.common.Constant.Company_TTV_N ||
                CompanyID == QLDT.common.Constant.Company_BKH ||
                CompanyID == QLDT.common.Constant.Company_BCT ||
                CompanyID == QLDT.common.Constant.Company_BHCHC ||
                CompanyID == QLDT.common.Constant.Company_BTC
          )) {
            vColumns = [
                {
                    xtype: 'MTColumn', text: 'Tên đề tài', dataIndex: 'ProjectName', width: 250, flex: 1,
                    renderer: function (value, metaData, record, rowIndex) {
                        var IsProject = record.get("IsProject"), val = '';
                        if (IsProject) {
                            val += "&nbsp;&nbsp;&nbsp;&nbsp;";
                        }
                        value = Ext.String.htmlEncode(value);

                        metaData.tdAttr = 'data-qtip="' + Ext.String.htmlEncode(value) + '"';
                        return Ext.String.format("{0}{1}", val, value);
                    }
                },
                { text: 'Chủ nhiệm', dataIndex: 'EmployeeName', minWidth: 150 },
                { xtype: 'MTColumnDateField', text: 'B.đầu', dataIndex: 'StartDate', width: 100 },
                { xtype: 'MTColumnDateField', text: 'K.thúc', dataIndex: 'EndDate', width: 100 },
                { text: 'Trạng thái', dataIndex: 'StatusName', minWidth: 150, xtype: 'MTColumn' },
            ];
        }
        //
        return vColumns;
    },

    /*
    * Tạo context menu cho grid
    * Create by: dvthang:07.01.2018
    */
    getContextMenu: function () {
        var me = this,
            vContextMenu = [
            {
                iconCls: 'button-edit menu-button-item fa fa-pencil-square-o',
                cls: 'menu-button-item',
                text: 'Sửa',
                itemId: 'mnEdit',
                name: 'mnEdit',
                handler: function (sender) {
                    var controller = me.getController();
                    if (controller) {
                        controller.toolbar_OnClick(sender);
                    }
                }
            },
            ];
        //Khi là trợ lý thì hiện các thành phần của trợ lý lên xem
        //1. Nếu là nhóm Thủ Trưởng viện + Ban Kế hoạch + Ban Tài chính + Ban Chính trị --> Được xem tất cả
        var CompanyID = QLDT.Config.getCompanyID();
        var PositionID = QLDT.Config.getPositionID();
        var EmployeeID = QLDT.Config.getEmployeeID();
        //
        if (!(
                CompanyID == QLDT.common.Constant.Company_TTV_B ||
                CompanyID == QLDT.common.Constant.Company_TTV_N ||
                CompanyID == QLDT.common.Constant.Company_BKH ||
                CompanyID == QLDT.common.Constant.Company_BCT ||
                CompanyID == QLDT.common.Constant.Company_BHCHC ||
                CompanyID == QLDT.common.Constant.Company_BTC
          )) {
            vContextMenu = [
                {
                    iconCls: 'button-add menu-button-item fa fa-plus',
                    cls: 'menu-button-item',
                    text: 'Thêm',
                    itemId: 'mnAdd',
                    name: 'mnAdd',
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
                name: 'mnDuplicate',
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
                name: 'mnEdit',
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
                name: 'mnDelete',
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
                name: 'mnRefresh',
                handler: function (sender) {
                    var controller = me.getController();
                    if (controller) {
                        controller.toolbar_OnClick(sender);
                    }
                }
            },
            ];
        }
        return vContextMenu;
    },



    /*
    * Khai báo store load dữ liệu cho grid
    * Create by: dvthang:04.02.2018
    */
    getStoreMaster: function () {
        var me = this,
            store = me.getViewModel().getStore('masterStore');
        return store;
    },

    /*
    * Vẽ nội dung header của form danh sách
    * Create by: dvthang:07.01.2018
    */
    getHeader: function () {
        var me = this;
        return {
            xtype: 'MTToolbar',
            region: 'north',
            itemId: 'toolbarGrid',
            cls: 'toolbar-menu-list',
            items: me.getToolbarMenu()
        };
    },

    /*
    * Lấy danh sách menu của toolbar
    * Create by: dvthang:24.1.2018
    */
    getToolbarMenu: function () {
        var me = this,
            vToolbarMenu = [
                 {
                     iconCls: 'button-edit menu-button-item fa fa-pencil-square-o',
                     cls: 'menu-button-item',
                     text: 'Sửa',
                     name: 'mnEdit',
                     disabled: true,
                     itemId: 'mnEdit',
                 }
            ]
        //Khi là trợ lý thì hiện các thành phần của trợ lý lên xem
        //1. Nếu là nhóm Thủ Trưởng viện + Ban Kế hoạch + Ban Tài chính + Ban Chính trị --> Được xem tất cả
        var CompanyID = QLDT.Config.getCompanyID();
        var PositionID = QLDT.Config.getPositionID();
        var EmployeeID = QLDT.Config.getEmployeeID();
        //
        if (!(
                CompanyID == QLDT.common.Constant.Company_TTV_B ||
                CompanyID == QLDT.common.Constant.Company_TTV_N ||
                CompanyID == QLDT.common.Constant.Company_BKH ||
                CompanyID == QLDT.common.Constant.Company_BCT ||
                CompanyID == QLDT.common.Constant.Company_BHCHC ||
                CompanyID == QLDT.common.Constant.Company_BTC
          )) {
            vToolbarMenu = [
                {
                    iconCls: 'button-add menu-button-item fa fa-plus',
                    cls: 'menu-button-item',
                    text: 'Thêm',
                    itemId: 'mnAdd',
                    name: 'mnAdd',
                    disabled: true,
                },
                {
                    iconCls: 'button-add menu-button-item fa fa-copy',
                    cls: 'menu-button-item',
                    text: 'Nhân bản',
                    itemId: 'mnDuplicate',
                    name: 'mnDuplicate',
                    disabled: true,
                },
                 {
                     iconCls: 'button-edit menu-button-item fa fa-pencil-square-o',
                     cls: 'menu-button-item',
                     text: 'Sửa',
                     name: 'mnEdit',
                     disabled: true,
                     itemId: 'mnEdit',
                 },
                 {
                     iconCls: 'button-delete menu-button-item fa fa-trash-o',
                     cls: 'menu-button-item',
                     text: 'Xóa',
                     itemId: 'mnDelete',
                     name: 'mnDelete',
                     disabled: true,
                 },
                 '-',
                 {
                     iconCls: 'button-refresh menu-button-item fa fa-refresh',
                     cls: 'menu-button-item',
                     text: 'Nạp',
                     itemId: 'mnRefresh',
                     name: 'mnRefresh',
                     disabled: true,
                 },
            ];
        }
        return vToolbarMenu;
    },

    /*
    * Thực hiện bol row không phải project
    * Create by: dvthang:27.02.2018
    */
    getViewConfig: function (record, index) {
        return {
            getRowClass: function (record, index) {
                if (!record.get('IsProject')) {
                    return 'cls-bold';
                }
                return '';
            }
        }
    },
});
