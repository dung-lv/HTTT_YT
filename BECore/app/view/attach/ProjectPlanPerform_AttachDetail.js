/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.attach.ProjectPlanPerform_AttachDetail', {
    extend: 'QLDT.view.control.MTWindow',
    xtype: 'app-projectplanperform_attachdetail',
    requires: [
        'QLDT.view.control.MTWindow',
        'QLDT.view.attach.ProjectPlanPerform_AttachDetailController',
        'QLDT.view.attach.ProjectPlanPerform_AttachDetailModel',
        'QLDT.view.control.MTFilefield'

    ],

    controller: 'ProjectPlanPerform_AttachDetail',
    viewModel: 'ProjectPlanPerform_AttachDetail',

    width: 400,
    height: 200,

    /*
    * Khởi tạo các thành phần của form
    * Create by: dvthang:21.01.2018
    */
    initComponent: function () {
        var me = this, items = [];
        Ext.apply(me, {
            items: [{
                xtype: 'MTForm',
                itemId: 'uploadFileID',
                layout: { type: 'vbox', align: 'stretch' },
                flex: 1,
                padding: '16 8 4 8',
                items: me.getContent()
            }]
        });
        me.callParent(arguments);
    },

    /*
    * Vẽ nội dung của form
    * Create by: dvthang:21.01.2018
    */
    getContent: function () {
        var me = this;
        return [
            {
                xtype: 'MTTextField',
                flex: 1,
                itemId: 'txtDescription',
                allowBlank: false,
                fieldLabel: 'Mô tả'
            }, {
                xtype: 'MTFilefield',
                itemId: 'fileItemID',
                allowBlank: false,
                emptyText: 'Chọn tệp đính kèm',
                fieldLabel: 'Tệp',
                name: 'photo-path',
                buttonText: '',
                buttonConfig: {
                    iconCls: 'fa fa-cloud-upload'
                }
            }]

    },

    buttons: [
            {
                text: 'Đồng ý',
                appendCls: 'btn-save',
                iconCls: 'button-accept fa fa-check',
                itemId: 'btnSave',
                xtype: 'MTButton',
            }, {
                text: 'Hủy bỏ',
                appendCls: 'btn-cancel',
                iconCls: 'button-cancel fa fa-undo',
                xtype: 'MTButton',
                itemId: 'btnCancel'

            }
    ]


});
