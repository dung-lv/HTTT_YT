/**
 * This class is the controller for the main view for the application. It is specified as
 * the "controller" of the Main view class.
 */
Ext.define('QLDT.view.main.MainController', {
    extend: 'Ext.app.ViewController',

    alias: 'controller.main',
    minViewportWidth: 300,
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
            '[group=menu-item]': {
                click: 'showPopupSubmenu',
                scope: me,
            }
        });


        //Event responsive
        view.on({
            resize: function (sender, width, height, oldWidth, oldHeight, eOpts) {
                me.responsiveFunction(width);
            }
        });

    },

    /*
    * Hiển thị menu con
    * Create by: dvthang:05.01.2017
    */
    showPopupSubmenu: function (sender, e) {
        var me = this, view = me.getView(), size = Ext.dom.Element.getViewSize(),
            viewModel = me.getViewModel(),
        menus = viewModel.menus;

        var name = menus.find(m=>m.name == sender.name);

        var menuSubItems = [];
        Ext.each(name.children, function (menuItem) {
            if (menuItem.show) {
                var item = { text: menuItem.text, cls: menuItem.cls, textAlign: 'left', name: menuItem.name, title: menuItem.title };
                if (menuItem.hasOwnProperty('hash') && menuItem.hash) {
                    item.href = Ext.String.format('#{0}', menuItem.hash);
                }

                menuSubItems.push(item);
            }
        });
        var secondValue = new Date().getMilliseconds();
        var menu = Ext.create('Ext.menu.Menu', {
            bodyCls: 'submenu-item',
            cls: 'submenu-slidebar',
            itemId: ('submenu_' + secondValue),
            width: 180,
            height: (size.height - 56),
            margin: '0 0 10 0',
            border: '0 0 0 0',
            renderTo: Ext.getBody(),
            items: menuSubItems
        });

        menu.showAt(140, 56);
    },

    /*
    * Sau khi render form xong thì hiển thị responsive cho menu
    * Create by: dvthang:05.01.2018
    */
    afterrender: function () {
        var me = this, view = me.getView();
        me.responsiveFunction(view.getWidth());

        Ext.get("logoApp").on("click", function (e) {
            e.preventDefault();
            var naviPanel = Ext.ComponentQuery.query('#naviPanel', view)[0];
            if (naviPanel) {
                if (naviPanel.isHidden()) {
                    naviPanel.show();
                } else {
                    naviPanel.hide();
                }
            }
        });
    },

    /*
    * Responsive menu
    * Create by: dvthang:05.01.2018
    */
    responsiveFunction: function (viewportWidth) {
        var me = this, view = me.getView(),
            minimizeMenu = viewportWidth < me.minViewportWidth,
            naviPanel = Ext.ComponentQuery.query('#naviPanel', view)[0],
            naviMinimizedButton = Ext.ComponentQuery.query('#naviMinimizedButton', view)[0];
        if (minimizeMenu) {
            naviPanel.hide();
            naviMinimizedButton.show();
        }
        else {
            naviMinimizedButton.hide();
            naviPanel.show();
        }
    },

});
