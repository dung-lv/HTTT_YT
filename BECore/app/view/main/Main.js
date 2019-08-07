/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.main.Main', {
    extend: 'Ext.container.Viewport',
    xtype: 'app-main',

    requires: [
        'Ext.container.Viewport',
        'Ext.plugin.Viewport',
        'Ext.window.MessageBox',

        'QLDT.view.main.MainController',
        'QLDT.view.main.MainModel',
        'QLDT.view.changepassword.ChangePassword'
    ],

    controller: 'main',
    viewModel: 'main',

    layout: 'border',

    cls: 'main-view-port',

    menuItems: [

    ],

    /*
    * Khởi tạo các thành phần của form
    * Create by: dvthang:05.01.2018
    */
    initComponent: function () {
        var me = this, viewModel = me.getViewModel(),
            groupID = QLDT.Config.getGroupID(),
            menu;

        if (groupID == -1) {
            menus = viewModel.menus;
        }
        else {
            menus = viewModel.menusNotBTC;
        }

        me.menuItems = [];

        Ext.each(menus, function (menuItem) {
            if (menuItem.show) {
                var item = {
                    text: menuItem.text, cls: menuItem.cls, textAlign: 'left', name: menuItem.name,
                    group: menuItem.group, title: menuItem.title, iconCls: '', textAlign: 'center'
                };
                if (menuItem.hasOwnProperty('hash') && menuItem.hash) {
                    item.href = Ext.String.format('#{0}', menuItem.hash);
                    item.hrefTarget = "_self";
                }
                if (menuItem.hasOwnProperty('iconCls') && menuItem.iconCls) {
                    item.iconCls = menuItem.iconCls;
                    item.iconAlign = 'top';
                }
                if (menuItem.hasOwnProperty('group') && menuItem.group) {
                    item.group = Ext.String.format('{0}', menuItem.group);
                }
                me.menuItems.push(item);
            }
        });

        Ext.apply(me, {
            items: [
                {
                    region: 'north',
                    borders: false,
                    xtype: 'container',
                    layout: 'anchor',
                    items: [{
                        xtype: 'panel',
                        height: 56,
                        layout: {
                            type: 'hbox',
                            align: 'stretch'
                        },
                        items: [
                            {
                                xtype: 'panel',
                                html: '<a href="javascript:void(0)" id="logoApp" class="logo fa fa-align-justify">HTTTYT.VN</a>',
                                bodyCls: 'left-header-topmenu',
                                width: 140
                            },
                            {
                                xtype: 'panel',
                                flex: 1,
                                padding: 8,
                                bodyCls: 'top-menu-content',
                                layout: {
                                    type: 'hbox',
                                    align: 'middle',
                                    pack: 'end'
                                },

                                items: [
                                    {
                                        xtype: 'panel',
                                        width: 300,
                                        layout: {
                                            type: 'hbox',
                                            align: 'middle',
                                            pack: 'end'
                                        },
                                        defaults: {
                                            xtype: 'button',
                                            margin: '1',
                                            anchor: '100%'
                                        },
                                        items: [
                                            {
                                                xtype: 'button',
                                                text: QLDT.Config.getUserName(),
                                                cls: 'user-info',
                                                menu: [
                                                    {
                                                        text: 'Thay đổi mật khẩu', iconCls: 'fa fa-key',
                                                        listeners: {
                                                            click: function (sender) {
                                                                var frm = Ext.create('QLDT.view.changepassword.ChangePassword');
                                                                if (frm) {
                                                                    var controller = frm.getController();
                                                                    if (controller) {
                                                                        controller.show();
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    },
                                                    {
                                                        text: 'Đăng xuất', iconCls: 'fa fa-sign-out',
                                                        listeners: {
                                                            click: function (sender) {
                                                                window.location.href = "Account/Logout";
                                                            }
                                                        }
                                                    }
                                                ]
                                            }
                                        ]
                                    }
                                ]
                            }
                        ]
                    }, {
                        xtype: 'button',
                        itemId: 'naviMinimizedButton',
                        text: 'Menu',
                        hidden: false,
                        anchor: '100%',
                        menu: me.menuItems
                    }]
                },
            {
                xtype: 'panel',
                itemId: 'naviPanel',
                region: 'west',
                layout: 'anchor',

                autoScroll: true,
                width: 140,
                bodyCls: 'left-menu',
                defaults: {
                    xtype: 'button',
                    margin: '0',
                    anchor: '100%',
                    handler: function () { }
                },
                items: me.menuItems
            },
            {
                region: 'center',
                xtype: 'MTPanel',
                itemId: 'contentMainBody',
                layout: {
                    type: 'fit',
                    align: 'stretch'
                },
                items: [

                ],
                bodyCls: 'main-content',
                padding: 8
            }
            ]
        });
        me.callParent(arguments);
    }
});
