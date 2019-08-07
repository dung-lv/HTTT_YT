/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.base.BasePopupDetail', {
    extend: 'QLDT.view.control.MTWindow',
    xtype: 'app-basepopupdetail',
    requires: [
        'QLDT.view.control.MTWindow',
        'QLDT.view.base.BasePopupDetailController',
    ],

    controller: 'BasePopupDetail',

    layout: 'fit',

    width: 800,

    height: 600,

    hideBottom:false,

    /*
    * Khởi tạo các thành phần của form
    * Create by: dvthang:05.01.2018
    */
    initComponent: function () {
        var me = this, items = [];
        var contentCenter = me.getContent();
        if (contentCenter != null) {
            items.push(contentCenter);
        }
        if (!me.hideBottom) {
            items.push(me.getBottom());
        }        
        Ext.apply(me, {
            items: [{
                xtype: 'MTForm',
                layout: 'border',
                padding: '8 8 4 8',                
                items: items
            }]
        });
        me.callParent(arguments);
    },

    /*
    * Vẽ nội dung của form
    * Create by: dvthang:09.01.2018
    */
    getContent: function () {
        return null
    },

    /*
    * Vẽ button dưới chân form
    * Create by: dvthang:09.01.2018
    */
    getBottom: function () {
        return {
            xtype: 'MTPanel',
            region: 'south',
            height: 40,
            layout:{
                type:'hbox',
                pack:'end'
            },
            defaults: {
                xtype: 'MTButton',
                margin:4,
            },
            items: [
                {
                    text: QLDT.GlobalResource.Save,
                    itemId: 'btnSave',
                    appendCls: 'btn-save',
                    iconCls: 'button-save fa fa-floppy-o',
                },
                {
                    text: QLDT.GlobalResource.SaveNew,
                    itemId: 'btnSaveNew',
                    appendCls: 'btn-savenew',
                    iconCls: 'button-savenew fa fa-floppy-o',
                },
                {
                    text: QLDT.GlobalResource.Cancel,
                    itemId: 'btnCancel',
                    appendCls: 'btn-cancel',
                    iconCls: 'button-cancel fa fa-undo',
                }
            ]
        };
    }
   
});
