/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectInfoFin', {
    extend: 'QLDT.view.control.MTPanel',
    xtype: 'app-projectinfofin',
    requires: [
        'QLDT.view.control.MTPanel',
        'QLDT.view.project.ProjectInfoFinController',
        'QLDT.view.project.ProjectInfoFinModel',
        'QLDT.view.control.MTButton'
    ],
    controller: 'ProjectInfoFin',
    viewModel: 'ProjectInfoFin',
    layout: {
        type: 'vbox',
        align: 'stretch'
    },

    /*
    * Vẽ nội dung của form
    * Create by: 17.01.2018
    */
    getContent: function () {
        var me = this;
        return [
                {
                    fieldLabel: 'Tên viết tắt đề tài',
                    name: 'ProjectNameAbbreviation',
                    itemId: 'ProjectNameAbbreviationId',
                    xtype: 'MTTextField',
                    labelWidth: 130,
                    maxLength: 255,
                    bind: '{masterData.ProjectNameAbbreviation}'
                },
                {
                    fieldLabel: 'Áp dụng hstc',
                    itemId: 'GrantRatioId',
                    name: 'GrantRatioID',
                    xtype: 'MTComboBox',
                    labelWidth: 130,
                    displayField: 'GrantRatioName',
                    valueField: 'GrantRatioID',
                    bind: {
                        value: '{masterData.GrantRatioID}',
                        store: '{grantRatioStore}'
                    }
                },
                {
                    fieldLabel: 'Tháng',
                    name: 'MonthFin',
                    xtype: 'MTComboBox',
                    labelWidth: 130,
                    displayField: 'Text',
                    valueField: 'Value',
                    bind: {
                        value: '{masterData.MonthFin}',
                        store: '{monthStore}'
                    }
                },
                {
                    fieldLabel: 'Năm',
                    name: 'YearFin',
                    xtype: 'MTComboBox',
                    labelWidth: 130,
                    displayField: 'Text',
                    valueField: 'Value',
                    bind: {
                        value: '{masterData.YearFin}',
                        store: '{yearStore}'
                    }
                },
        ];
    },


    /*
   * Khởi tạo các thành phần của form
   * Create by: 17.01.2018
   */
    initComponent: function () {
        var me = this;
        Ext.apply(me, {
            layout: 'border',
            flex: 1,
            items: [
                {
                    xtype: 'MTForm',
                    region: 'center',
                    flex: 1,
                    itemId: 'formInfo',
                    layout: {
                        type: 'vbox',
                        align: 'stretch'
                    },
                    items: me.getContent()
                },
                {
                    xtype: 'MTPanel',
                    region: 'south',
                    height: 40,
                    layout: {
                        type: 'hbox',
                        pack: 'end'
                    },
                    defaults: {
                        xtype: 'MTButton',
                        margin: '8 0 0 4',
                    },
                    items: [
                        {
                            text: QLDT.GlobalResource.Save,
                            itemId: 'btnSave',
                            appendCls: 'btn-save',
                            iconCls: 'button-save fa fa-floppy-o',
                        }
                    ]
                }
            ]
        });
        me.callParent(arguments);
    },
});
