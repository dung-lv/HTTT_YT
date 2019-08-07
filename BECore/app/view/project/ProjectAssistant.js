/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectAssistant', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-projectassistant',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.project.ProjectAssistantController',
        'QLDT.view.project.ProjectAssistantModel',
        'QLDT.view.project.ProjectDetail'
    ],

    controller: 'ProjectAssistant',
    viewModel: 'ProjectAssistant',
    /*
    * Trả về nội dung của form
    * Create by: laipv:26.02.2018
    */
    getColumns: function () {
        var me = this;
        return [
                {
                    xtype:'MTColumn', text: 'Tên đề tài', dataIndex: 'ProjectName', width: 250, flex: 1,
                    renderer: function (value, meta, record, rowIndex) {
                        var IsProject = record.get("IsProject"), val = '';
                        if (IsProject) {
                            val += "&nbsp;&nbsp;&nbsp;&nbsp;";
                        }
                        meta.tdAttr = 'data-qtip="' + Ext.String.htmlEncode(value) + '"';
                        return Ext.String.format("{0}{1}", val, value);
                    }
                },
                { text: 'Chủ nhiệm', dataIndex: 'EmployeeName', minWidth: 150},
                {
                    xtype: 'MTColumnDateField', text: 'B.đầu', dataIndex: 'StartDate', width: 100,
                    renderer: function (value, metaData, record, rowIndex) {
                        if (value) {
                            value = Ext.Date.format(value, 'd/m/Y');
                        }
                        return Ext.String.format("<div>{0}</div>", value);
                    }
                },
                {
                    xtype: 'MTColumnDateField', text: 'K.thúc', dataIndex: 'EndDate', width: 100,
                    renderer: function (value, metaData, record, rowIndex) {
                        if (value) {
                            value = Ext.Date.format(value, 'd/m/Y');
                        }
                        return Ext.String.format("<div>{0}</div>", value);
                    }
                }
        ];
    },

    /*
    * Khai báo store load dữ liệu cho grid
    * Create by: laipv:26.02.2018
    */
    getStoreMaster: function () {
        var me = this,
            store = me.getViewModel().getStore('masterStore');
        return store;
    }

});
