/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.nguoi_dung.nguoi_dung', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-nguoi_dung',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.nguoi_dung.nguoi_dungController',
        'QLDT.view.nguoi_dung.nguoi_dungModel',
        'QLDT.view.nguoi_dung.nguoi_dungDetail'
    ],

    controller: 'nguoi_dung',
    viewModel: 'nguoi_dung',

    filterable: true,
    showPaging: true,

    getColumns: function () {
        var me = this,
            store = me.getViewModel().getStore('master');
        return [
            { text: 'Mã bệnh nhân', dataIndex: 'CustomerID', width: 120, xtype: 'MTColumn' },
            { text: 'Tên bệnh nhân', dataIndex: 'CustomerName', minWidth: 150, flex: 1, xtype: 'MTColumn'},
            {
                text: 'Giới tính', dataIndex: 'CustomerGender', width: 120, xtype: 'MTColumn',
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
            { text: 'Ngày sinh', dataIndex: 'DOB', width: 120, xtype: 'MTColumnDateField'},
            { text: 'Số bảo hiểm YT', dataIndex: 'HealthCareNumber', width: 120, xtype: 'MTColumn'},
            { text: 'SĐT cá nhân', dataIndex: 'Tel', width: 120, xtype: 'MTColumn'},
            { text: 'Email', dataIndex: 'Email', width: 120, xtype: 'MTColumn'},
            { text: 'Địa chỉ', dataIndex: 'Address', width: 120, xtype: 'MTColumn'},
            { text: 'Nhóm bệnh nhân', dataIndex: 'CustomerGroup', width: 120, xtype: 'MTColumn'},
            { text: 'Mô tả', dataIndex: 'CustomerDescription', width: 120, xtype: 'MTColumn'},
            { text: 'Người đại diện', dataIndex: 'PresenterName', width: 120, xtype: 'MTColumn'},
            { text: 'SĐT người dại diện', dataIndex: 'PresenterPhone', width: 120, xtype: 'MTColumn'},
            { text: 'Địa chỉ người đại diện', dataIndex: 'PresenterAddress', width: 120, xtype: 'MTColumn'},
            { text: 'CMT người đại diện', dataIndex: 'PresenterIDC', width: 120, xtype: 'MTColumn'},
            { text: 'Là gì của bệnh nhân', dataIndex: 'Relationship', width: 120, xtype: 'MTColumn'}
        ];
    },

    getStoreMaster: function () {
        var me = this,
            store = me.getViewModel().getStore('masterStore');
        return store;
    }
});
