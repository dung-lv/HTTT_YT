/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.employee.Employee', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-employee',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.employee.EmployeeController',
        'QLDT.view.employee.EmployeeModel',
        'QLDT.view.employee.EmployeeDetail',
        'QLDT.store.Gender'
    ],

    controller: 'Employee',
    viewModel: 'Employee',
    /*
    * Trả về nội dung của form
    * Create by: dvthang:06.01.2017
    */
    getColumns: function () {
        var me = this;
        return [
                {
                    text: 'Mã cán bộ', dataIndex: 'EmployeeCode', width: 140,xtype: 'MTColumn'
                },
                { text: 'Tên đầy đủ', dataIndex: 'FullName', minWidth: 250, flex: 1, xtype: 'MTColumn' },
                {
                    text: 'Giới tính', dataIndex: 'Gender', width: 120, xtype: 'MTColumn',
                    dataType: QLDT.common.Enumaration.DataType.Int,
                    headerFilter: {
                        store: {
                            type: 'gender'
                        },
                        valueField: 'Value',
                        displayField: 'Text',
                        editable: false,
                        selectOnFocus: false
                    },
                    isFilterCombo: true,
                    renderer: function (value, metaData, record, rowIndex) {
                        var strText = 'Nam';
                        if (value === 1) {
                            strText = "Nữ";
                        }
                        return strText;
                    },
                },
                { text: 'Ngày sinh', dataIndex: 'BirthDay', width: 130, xtype: 'MTColumnDateField' },
                { text: 'Nơi sinh', dataIndex: 'BirthPlace', width: 120, xtype: 'MTColumn' },
                { text: 'Fax', dataIndex: 'Fax', width: 120, xtype: 'MTColumn' },
                { text: 'Email', dataIndex: 'Email', width: 120, xtype: 'MTColumn' },
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
