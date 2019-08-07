/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.base.BaseList', {
    extend: 'Ext.panel.Panel',
    xtype: 'app-baselist',
    requires: [
        'QLDT.view.base.BaseListController',
    ],

    controller: 'baselist',

    layout: 'border',

    /*Thuộc tính ẩn header trên grid*/
    hideHeader: false,

    filterable: true,

    /*
    * Đánh dấu hiển thị pagging trên grid
    * Create by: dvthang:07.01.2018
    */
    showPaging: true,

    /*
    * Khởi tạo các thành phần của form
    * Create by: dvthang:05.01.2018
    */
    initComponent: function () {
        debugger;
        var me = this, items = [], top = me.getTopBar();
        if (top) {
            items.push(top);
        }
        if (!me.hideHeader) {
            items.push(me.getHeader());
        }
        var center = me.getCenter(),
            bottom = me.getBottom();
        if (center && center.hasOwnProperty('xtype')) {
            items.push(center);
        }
        if (bottom && bottom.hasOwnProperty('xtype')) {
            items.push(bottom);
        }
        if (typeof me.getContentDisabled == 'function') {
            me.getContentDisabled(items);
        }
        else {
            Ext.apply(me, {
                items: items
            });

        }
        me.callParent(arguments);
    },

    /*
    * Vẽ top bar
    * Create by: dvthang:24.02.2018
    */
    getTopBar: function () {
        return null;
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
    * Lấy danh sách menu của toolbar phân quyền theo form và người dùng
    * Create by: dvthang:24.1.2018
    * Modify by: laipv:04.03.2018 - Thêm nút sắp xếp
    */
    getToolbarMenuUser: function (temp) {
        var me = this, item;
        if (temp != 2) {
            return [
                {
                    iconCls: 'button-add menu-button-item fa fa-plus',
                    cls: 'menu-button-item',
                    text: 'Thêm',
                    itemId: 'mnAdd',
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
                {
                    iconCls: 'button-add menu-button-item fa fa-copy',
                    cls: 'menu-button-item',
                    text: 'Nhân bản',
                    itemId: 'mnDuplicate',
                },
                '-',
                {
                    iconCls: 'button-refresh menu-button-item fa fa-refresh',
                    cls: 'menu-button-item',
                    text: 'Nạp',
                    itemId: 'mnRefresh',
                },
            ];
        }
        else {
            return [
                {
                    iconCls: 'button-refresh menu-button-item fa fa-refresh',
                    cls: 'menu-button-item',
                    text: 'Nạp',
                    itemId: 'mnRefresh',
                },
            ];
        }
    },
    /*
    * Tạo context menu cho grid
    * Create by: dvthang:07.01.2018
    * Modify by: laipv:04.03.2018 - Thêm menu sắp xếp
    */
    getContextMenuUser: function (temp) {
        var me = this;
        if (temp != 2) {
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
                //{
                //    iconCls: 'button-excel menu-button-item fa fa-download',
                //    cls: 'menu-button-item',
                //    text: 'Xuất Excel',
                //    itemId: 'mnExcel',
                //    handler: function (sender) {
                //        var controller = me.getController();
                //        if (controller) {
                //            controller.toolbar_OnClick(sender);
                //        }
                //    }
                //},
                '-',
                {
                    iconCls: 'button-refresh menu-button-item fa fa-refresh',
                    cls: 'menu-button-item',
                    text: 'Làm mới',
                    itemId: 'mnRefresh',
                    handler: function (sender) {
                        var controller = me.getController();
                        if (controller) {
                            controller.toolbar_OnClick(sender);
                        }
                    }
                },
            ];
        }
        else {
            return [
                {
                    iconCls: 'button-refresh menu-button-item fa fa-refresh',
                    cls: 'menu-button-item',
                    text: 'Làm mới',
                    itemId: 'mnRefresh',
                    handler: function (sender) {
                        var controller = me.getController();
                        if (controller) {
                            controller.toolbar_OnClick(sender);
                        }
                    }
                },
            ];
        }
    },

    /*
   * Lấy danh sách menu của toolbar doanh nghiệp
   * Create by: dvthang:24.1.2018
   * Modify by: laipv:04.03.2018 - Thêm nút sắp xếp
   */
    getToolbarMenuCompany: function (item, a) {
        var me = this, groupID = QLDT.Config.getGroupID();
        if (groupID != 8) {
            if (item != 2) {
                if (a == 0) {
                    return [
                        {
                            iconCls: 'button-add menu-button-item fa fa-plus',
                            cls: 'menu-button-item',
                            text: 'Thêm',
                            itemId: 'mnAdd',
                        },

                        {
                            iconCls: 'button-edit menu-button-item fa fa-info',
                            cls: 'menu-button-item',
                            text: 'Xem chi tiết',
                            name: 'mnRead',
                            itemId: 'mnRead',
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
                        //{
                        //    iconCls: 'button-add menu-button-item fa fa-level-down',
                        //    cls: 'menu-button-item',
                        //    text: 'Lấy dữ liệu từ năm ngoái',
                        //    itemId: 'mnDuplicate',
                        //},
                        {
                            iconCls: 'button-add menu-button-item fa fa-copy',
                            cls: 'menu-button-item',
                            text: 'Sao chép & Sửa',
                            itemId: 'mnCopy',
                        },
                        '-',
                        {
                            iconCls: 'button-refresh menu-button-item fa fa-refresh',
                            cls: 'menu-button-item',
                            text: 'Nạp',
                            itemId: 'mnRefresh',
                        },
                    ];
                }
                else {
                    return [
                        {
                            iconCls: 'button-add menu-button-item fa fa-plus',
                            cls: 'menu-button-item',
                            text: 'Thêm',
                            itemId: 'mnAdd',
                        },
                        {
                            iconCls: 'button-edit menu-button-item fa fa-info',
                            cls: 'menu-button-item',
                            text: 'Xem chi tiết',
                            name: 'mnRead',
                            itemId: 'mnRead',
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
                        {
                            iconCls: 'button-add menu-button-item fa fa-level-down',
                            cls: 'menu-button-item',
                            text: 'Lấy dữ liệu từ năm ngoái',
                            itemId: 'mnDuplicate',
                        },
                        {
                            iconCls: 'button-add menu-button-item fa fa-copy',
                            cls: 'menu-button-item',
                            text: 'Sao chép & Sửa',
                            itemId: 'mnCopy',
                        },
                        '-',
                        {
                            iconCls: 'button-refresh menu-button-item fa fa-refresh',
                            cls: 'menu-button-item',
                            text: 'Nạp',
                            itemId: 'mnRefresh',
                        },
                        '->',
                        {
                            iconCls: 'button-save menu-button-item fa fa-file-text-o',
                            cls: 'menu-button-item',
                            text: 'Tổng hợp',
                            itemId: 'mnSyncReport',
                            name: 'mnSyncReport',
                            disabled: true,
                        },
                    ];
                }
            }
            else {
                return [
                    {
                        iconCls: 'button-edit menu-button-item fa fa-info',
                        cls: 'menu-button-item',
                        text: 'Xem chi tiết',
                        name: 'mnRead',
                        itemId: 'mnRead',
                    },
                    '-',
                    {
                        iconCls: 'button-refresh menu-button-item fa fa-refresh',
                        cls: 'menu-button-item',
                        text: 'Nạp',
                        itemId: 'mnRefresh',
                    },
                ];
            }
        }
        else {
            if (a == 0) {
                return [
                    {
                        iconCls: 'button-edit menu-button-item fa fa-info',
                        cls: 'menu-button-item',
                        text: 'Xem chi tiết',
                        name: 'mnRead',
                        itemId: 'mnRead',
                    },
                    {
                        iconCls: 'button-add menu-button-item fa fa-copy',
                        cls: 'menu-button-item',
                        text: 'Sao chép & Sửa',
                        itemId: 'mnCopy',
                    },
                    '-',
                    {
                        iconCls: 'button-refresh menu-button-item fa fa-refresh',
                        cls: 'menu-button-item',
                        text: 'Nạp',
                        itemId: 'mnRefresh',
                    },
                ];
            }
            else {
                return [
                    {
                        iconCls: 'button-edit menu-button-item fa fa-info',
                        cls: 'menu-button-item',
                        text: 'Xem chi tiết',
                        name: 'mnRead',
                        itemId: 'mnRead',
                    },
                    {
                        iconCls: 'button-add menu-button-item fa fa-copy',
                        cls: 'menu-button-item',
                        text: 'Sao chép & Sửa',
                        itemId: 'mnCopy',
                    },
                    '-',
                    {
                        iconCls: 'button-refresh menu-button-item fa fa-refresh',
                        cls: 'menu-button-item',
                        text: 'Nạp',
                        itemId: 'mnRefresh',
                    },
                    '->',
                    {
                        iconCls: 'button-save menu-button-item fa fa-file-text-o',
                        cls: 'menu-button-item',
                        text: 'Tổng hợp',
                        itemId: 'mnSyncReport',
                        name: 'mnSyncReport',
                        disabled: true,
                    },
                ];
            }
        }
    },
    /*
    * Tạo context menu cho grid doanh nghiệp
    * Create by: dvthang:07.01.2018
    * Modify by: laipv:04.03.2018 - Thêm menu sắp xếp
    */
    getContextCompany: function (item, a) {
        var me = this, groupID = QLDT.Config.getGroupID();
        if (groupID != 8) {
            if (item != 2) {
                if (a == 0) {
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
                            iconCls: 'button-edit menu-button-item fa fa-info',
                            cls: 'menu-button-item',
                            text: 'Xem chi tiết',
                            itemId: 'mnRead',
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
                        //{
                        //    iconCls: 'button-excel menu-button-item fa fa-download',
                        //    cls: 'menu-button-item',
                        //    text: 'Xuất Excel',
                        //    itemId: 'mnExcel',
                        //    handler: function (sender) {
                        //        var controller = me.getController();
                        //        if (controller) {
                        //            controller.toolbar_OnClick(sender);
                        //        }
                        //    }
                        //},
                        '-',
                        {
                            iconCls: 'button-refresh menu-button-item fa fa-refresh',
                            cls: 'menu-button-item',
                            text: 'Làm mới',
                            itemId: 'mnRefresh',
                            handler: function (sender) {
                                var controller = me.getController();
                                if (controller) {
                                    controller.toolbar_OnClick(sender);
                                }
                            }
                        },
                    ];
                }
                else {
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
                            iconCls: 'button-edit menu-button-item fa fa-info',
                            cls: 'menu-button-item',
                            text: 'Xem chi tiết',
                            itemId: 'mnRead',
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
                        {
                            iconCls: 'button-add menu-button-item fa fa-level-down',
                            cls: 'menu-button-item',
                            text: 'Lấy dữ liệu từ năm ngoái',
                            itemId: 'mnDuplicate',
                            handler: function (sender) {
                                var controller = me.getController();
                                if (controller) {
                                    controller.toolbar_OnClick(sender);
                                }
                            }
                        },
                        //{
                        //    iconCls: 'button-excel menu-button-item fa fa-download',
                        //    cls: 'menu-button-item',
                        //    text: 'Xuất Excel',
                        //    itemId: 'mnExcel',
                        //    handler: function (sender) {
                        //        var controller = me.getController();
                        //        if (controller) {
                        //            controller.toolbar_OnClick(sender);
                        //        }
                        //    }
                        //},
                        '-',
                        {
                            iconCls: 'button-refresh menu-button-item fa fa-refresh',
                            cls: 'menu-button-item',
                            text: 'Làm mới',
                            itemId: 'mnRefresh',
                            handler: function (sender) {
                                var controller = me.getController();
                                if (controller) {
                                    controller.toolbar_OnClick(sender);
                                }
                            }
                        },
                        {
                            iconCls: 'button-save menu-button-item fa fa-file-text-o',
                            cls: 'menu-button-item',
                            text: 'Tổng hợp',
                            itemId: 'mnSyncReport',
                            disabled: true,
                            handler: function (sender) {
                                var controller = me.getController();
                                if (controller) {
                                    controller.toolbar_OnClick(sender);
                                }
                            }
                        },
                    ];
                }
            }
            else {
                return [
                    {
                        iconCls: 'button-edit menu-button-item fa fa-info',
                        cls: 'menu-button-item',
                        text: 'Xem chi tiết',
                        itemId: 'mnRead',
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
                        text: 'Làm mới',
                        itemId: 'mnRefresh',
                        handler: function (sender) {
                            var controller = me.getController();
                            if (controller) {
                                controller.toolbar_OnClick(sender);
                            }
                        }
                    },
                ];
            }
        }
        else {
            if (a == 0) {
                return [
                    {
                        iconCls: 'button-edit menu-button-item fa fa-info',
                        cls: 'menu-button-item',
                        text: 'Xem chi tiết',
                        itemId: 'mnRead',
                        handler: function (sender) {
                            var controller = me.getController();
                            if (controller) {
                                controller.toolbar_OnClick(sender);
                            }
                        }
                    },
                    //{
                    //    iconCls: 'button-excel menu-button-item fa fa-download',
                    //    cls: 'menu-button-item',
                    //    text: 'Xuất Excel',
                    //    itemId: 'mnExcel',
                    //    handler: function (sender) {
                    //        var controller = me.getController();
                    //        if (controller) {
                    //            controller.toolbar_OnClick(sender);
                    //        }
                    //    }
                    //},
                    '-',
                    {
                        iconCls: 'button-refresh menu-button-item fa fa-refresh',
                        cls: 'menu-button-item',
                        text: 'Làm mới',
                        itemId: 'mnRefresh',
                        handler: function (sender) {
                            var controller = me.getController();
                            if (controller) {
                                controller.toolbar_OnClick(sender);
                            }
                        }
                    },
                ];
            }
            else {
                return [
                    {
                        iconCls: 'button-edit menu-button-item fa fa-info',
                        cls: 'menu-button-item',
                        text: 'Xem chi tiết',
                        itemId: 'mnRead',
                        handler: function (sender) {
                            var controller = me.getController();
                            if (controller) {
                                controller.toolbar_OnClick(sender);
                            }
                        }
                    },
                    //{
                    //    iconCls: 'button-excel menu-button-item fa fa-download',
                    //    cls: 'menu-button-item',
                    //    text: 'Xuất Excel',
                    //    itemId: 'mnExcel',
                    //    handler: function (sender) {
                    //        var controller = me.getController();
                    //        if (controller) {
                    //            controller.toolbar_OnClick(sender);
                    //        }
                    //    }
                    //},
                    '-',
                    {
                        iconCls: 'button-refresh menu-button-item fa fa-refresh',
                        cls: 'menu-button-item',
                        text: 'Làm mới',
                        itemId: 'mnRefresh',
                        handler: function (sender) {
                            var controller = me.getController();
                            if (controller) {
                                controller.toolbar_OnClick(sender);
                            }
                        }
                    },
                    {
                        iconCls: 'button-save menu-button-item fa fa-file-text-o',
                        cls: 'menu-button-item',
                        text: 'Tổng hợp',
                        itemId: 'mnSyncReport',
                        disabled: true,
                        handler: function (sender) {
                            var controller = me.getController();
                            if (controller) {
                                controller.toolbar_OnClick(sender);
                            }
                        }
                    },
                ];
            }
        }
    },
    /*
    * Lấy danh sách menu của toolbar
    * Create by: dvthang:24.1.2018
    * Modify by: laipv:04.03.2018 - Thêm nút sắp xếp
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
            {
                iconCls: 'button-add menu-button-item fa fa-copy',
                cls: 'menu-button-item',
                text: 'Nhân bản',
                itemId: 'mnDuplicate',
            },
            //{
            //    iconCls: 'button-add menu-button-item fa fa-copy',
            //    cls: 'menu-button-item',
            //    text: 'Xuất Excel',
            //    itemId: 'mnExcel',
            //},
            '-',
            {
                iconCls: 'button-refresh menu-button-item fa fa-refresh',
                cls: 'menu-button-item',
                text: 'Nạp',
                itemId: 'mnRefresh',
            },
        ];
    },

    /*
    * Tạo context menu cho grid
    * Create by: dvthang:07.01.2018
    * Modify by: laipv:04.03.2018 - Thêm menu sắp xếp
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
            //{
            //    iconCls: 'button-excel menu-button-item fa fa-download',
            //    cls: 'menu-button-item',
            //    text: 'Xuất Excel',
            //    itemId: 'mnExcel',
            //    handler: function (sender) {
            //        var controller = me.getController();
            //        if (controller) {
            //            controller.toolbar_OnClick(sender);
            //        }
            //    }
            //},
            '-',
            {
                iconCls: 'button-refresh menu-button-item fa fa-refresh',
                cls: 'menu-button-item',
                text: 'Làm mới',
                itemId: 'mnRefresh',
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
    * Trả về nội dung của form
    * Create by: dvthang:06.01.2017
    */
    getCenter: function () {
        var me = this, store = me.getStoreMaster();
        return {
            xtype: 'MTPanel',
            region: 'center',
            layout: 'fit',
            items: [
                {
                    xtype: 'MTGrid',
                    store: store,
                    filterable: me.filterable,
                    itemId: 'grdMaster',
                    columns: me.getColumns(),
                    layout: 'fit',
                    showPaging: me.showPaging,
                    contextMenu: me.getContextMenu(),
                    viewConfig: me.getViewConfig()
                }
            ]
        };

    },

    /*
    * Laays thong tin config cua grid neu co
    */
    getViewConfig: function (record, index) {
        return {};
    },

    /*
    * Trả về nội dung vùng center
    * Create by: dvthang:07.01.2018
    */
    getColumns: function () {
        return [];
    },

    /*
    * Store để load dữ liệu cho grid
    * Create by: dvthang:07.01.2018
    */
    getStoreMaster: function () {
        return null;
    },

    /*
    * Vẽ chân của footter
    * Create by: dvthang:07.01.2018
    */
    getBottom: function () {
        return {

        };
    }
});
