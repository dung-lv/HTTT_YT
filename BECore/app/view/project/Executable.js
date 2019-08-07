/** 
 * Tab đang thực hiện đề tài
 */
Ext.define('QLDT.view.project.Executable', {
    extend: 'Ext.panel.Panel',
    xtype: 'app-executable',
    requires: [
        'QLDT.view.project.ExecutableController',
        'QLDT.view.project.ExecutableModel',
        'QLDT.view.control.MTTree'
    ],

    controller: 'Executable',
    viewModel: 'Executable',
    layout: 'border',

    filterable: false,
    showPaging: false,

    /*
    * Trả về nội dung của form
    * Nếu người dùng là BTC thì danh sách trả về Tên đề tài viết tắt và tooltip hiện Tên đề tài đầy đủ
    * Create by: dvthang:04.02.2018
    * Modify by:manh: 04.05.18
    */
    getColumns: function () {
        var me = this,
            UserName = QLDT.Config.getUserName(),
            CompanyID = QLDT.Config.getCompanyID(),
            column = [
            {
                xtype: 'MTTreeColumn', text: 'Tên đề tài', dataIndex: 'ProjectName', flex: 1,
            }, {
                text: 'Chủ nhiệm', dataIndex: 'EmployeeName', width: 110, flex: 1,
                renderer: function (value, metaData, record, rowIndex) {
                    if (record.get("Status") == 12) { // Đã hoàn thành
                        return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
                    }
                    return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                }
            }, {
                text: 'B.đầu', dataIndex: 'StartDate', width: 110,
                //xtype: 'MTColumnDateField',
                renderer: function (value, metaData, record, rowIndex) {
                    if (value) {
                        value = Ext.Date.format(value, 'd/m/Y');
                    }
                    if (record.get("Status") == 12) { // Đã hoàn thành
                        return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
                    }
                    return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                }
            },
         {
             text: 'K.thúc', dataIndex: 'EndDate', width: 110,
             //xtype: 'MTColumnDateField',
             renderer: function (value, metaData, record, rowIndex) {
                 if (value) {
                     value = Ext.Date.format(value, 'd/m/Y');
                 }
                 if (record.get("Status") == 12) { // Đã hoàn thành
                     return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
                 }
                 return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
             }
         }
         ,
         {
             text: 'Sản phẩm', dataIndex: 'Result', width: 110,
             //xtype: 'MTColumn',
             renderer: function (value, metaData, record, rowIndex) {
                 if (record.get("Status") == 12) { // Đã hoàn thành
                     return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
                 }
                 return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
             }
         }
         ,
         {
             text: 'Trạng thái',
             //xtype: 'MTColumn',
             dataIndex: 'StatusName',
             width: 110,
         }
            ];
        if (CompanyID === QLDT.common.Constant.Company_BTC) {
            column = [
            {
                xtype: 'MTTreeColumn', text: 'Tên đề tài', dataIndex: 'ProjectName', flex: 1,
                renderer: function (value, metaData, record, rowIndex) {
                    var me = this, isProject = record.get("IsProject"), val = '';
                    if (isProject) {
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
            }, {
                text: 'Chủ nhiệm', dataIndex: 'EmployeeName', width: 110, flex: 1,
                renderer: function (value, metaData, record, rowIndex) {
                    if (record.get("Status") == 12) { // Đã hoàn thành
                        return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
                    }
                    return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                }
            }, {
                text: 'B.đầu', dataIndex: 'StartDate', width: 110,
                //xtype: 'MTColumnDateField',
                renderer: function (value, metaData, record, rowIndex) {
                    if (value) {
                        value = Ext.Date.format(value, 'd/m/Y');
                    }
                    if (record.get("Status") == 12) { // Đã hoàn thành
                        return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
                    }
                    return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
                }
            },
         {
             text: 'K.thúc', dataIndex: 'EndDate', width: 110,
             //xtype: 'MTColumnDateField',
             renderer: function (value, metaData, record, rowIndex) {
                 if (value) {
                     value = Ext.Date.format(value, 'd/m/Y');
                 }
                 if (record.get("Status") == 12) { // Đã hoàn thành
                     return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
                 }
                 return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
             }
         }
         ,
         {
             text: 'Sản phẩm', dataIndex: 'Result', width: 110,
             //xtype: 'MTColumn',
             renderer: function (value, metaData, record, rowIndex) {
                 if (record.get("Status") == 12) { // Đã hoàn thành
                     return Ext.String.format("<div style = 'color:#33FF33;'>{0}</div>", value);
                 }
                 return Ext.String.format("<div style = 'color:#DD0000;'>{0}</div>", value);
             }
         }
         ,
         {
             text: 'Trạng thái',
             //xtype: 'MTColumn',
             dataIndex: 'StatusName',
             width: 110,
         }
            ];
        }
        return column;
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
    * Lấy nội dung đề tài
    * Create by: dvthang:04.02.2018
    */
    getContent: function () {
        var me = this, masterTreeStore = me.getViewModel().getStore('masterTreeStore');
        return [
            me.getHeader(),
            {
                xtype: 'MTTree',
                region: 'center',
                itemId: 'treeExecutable',
                columns: me.getColumns(),
                store: masterTreeStore,
                reserveScrollbar: true,
                useArrows: true,
                rootVisible: false,
                multiSelect: false,
                viewConfig: {
                    getRowClass: function (record, index) {
                        var cls = '';
                        if (record.get("Status") == 11) // 11: Đã hoàn thành (mầu xang); 12: Chưa hoàn thành (mầu vàng); 13: Chậm tiến độ (mầu đỏ) nhé
                            cls = "cls-executable-finish";
                        else if (record.get("Status") == 12) // 11: Đã hoàn thành (mầu xang); 12: Chưa hoàn thành (mầu vàng); 13: Chậm tiến độ (mầu đỏ) nhé
                            cls = "cls-executable-unfinished";
                        else if (record.get("Status") == 13) // 11: Đã hoàn thành (mầu xang); 12: Chưa hoàn thành (mầu vàng); 13: Chậm tiến độ (mầu đỏ) nhé
                            cls = "cls-executable-slowprogress";
                        return cls;
                    }
                },
                contextMenu: me.getContextMenu()
            }
        ]
    },

    /*
    * Tạo context menu cho grid
    * Create by: dvthang:07.01.2018
    */
    getContextMenu: function () {
        var me = this;
        return [
               {
                   iconCls: 'button-edit menu-button-item fa fa-pencil-square-o',
                   cls: 'menu-button-item',
                   text: 'Sửa',
                   name: 'mnEdit',
                   itemId: 'mnEdit',
                   handler: function (sender) {
                       var controller = me.getController();
                       if (controller) {
                           controller.toolbar_OnClick(sender);
                       }
                   }
               },
        ];
    },

    /*
    * Lấy danh sách menu của toolbar
    * Create by: dvthang:24.1.2018
    */
    getToolbarMenu: function () {
        var me = this;
        return [
                 {
                     iconCls: 'button-edit menu-button-item fa fa-pencil-square-o',
                     cls: 'menu-button-item',
                     text: 'Sửa',
                     name: 'mnEdit',
                     disabled: true,
                     itemId: 'mnEdit',
                 }
        ];
    },


    /*
   * Khởi tạo các thành phần của form
   * Create by: dvthang:04.02.2018
   */
    initComponent: function () {
        var me = this;
        Ext.apply(me, {
            items: me.getContent()
        });
        me.callParent(arguments);
    },
});
