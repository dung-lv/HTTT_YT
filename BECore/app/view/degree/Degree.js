/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.degree.Degree', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-degree',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.degree.DegreeController',
        'QLDT.view.degree.DegreeModel',
        'QLDT.view.degree.DegreeDetail'
    ],

    controller: 'Degree',
    viewModel: 'Degree',
    /*
    * Trả về nội dung của form
    * Create by: dvthang:06.01.2017
    */
    getColumns: function () {
        var me = this, statusStore = me.getViewModel().getStore('statusStore');
        return [
                { text: 'Kí hiệu', dataIndex: 'DegreeCode', width: 250, xtype: 'MTColumn' },
                { text: 'Tên học vị', dataIndex: 'DegreeName', minWidth: 250, flex: 1, xtype: 'MTColumn' },
                { text: 'Diễn giải', dataIndex: 'Description', width: 250, xtype: 'MTColumn' },
                {
                    text: 'Trạng thái', dataIndex: 'Inactive', width: 150, xtype: 'MTColumn',
                    dataType: QLDT.common.Enumaration.DataType.Int,
                    headerFilter:{
                        store: statusStore,
                        valueField: 'Value',
                        displayField: 'Text',
                        editable: false,
                        selectOnFocus: false
                    },
                    isFilterCombo: true,
                    renderer: function (value, metaData, record, rowIndex) {
                        var strText = 'Đang theo dõi';
                        if (value === true) {
                            strText = "Ngừng theo dõi";
                        }
                        return strText;
                    },
                },
        ];
    },

    /*
    * Khai báo store load dữ liệu cho grid
    * Create by: dvthang:07.01.2018
    */
    getStoreMaster: function () {
        var me = this,
            store = me.getViewModel().getStore('masterStore');
        return store;
    }

});
