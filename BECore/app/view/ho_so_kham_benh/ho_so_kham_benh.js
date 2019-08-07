/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.ho_so_kham_benh.ho_so_kham_benh', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-ho_so_kham_benh',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.ho_so_kham_benh.ho_so_kham_benhController',
        'QLDT.view.ho_so_kham_benh.ho_so_kham_benhModel',
        'QLDT.view.ho_so_kham_benh.ho_so_kham_benhDetail'
    ],

    controller: 'ho_so_kham_benh',
    viewModel: 'ho_so_kham_benh',

    filterable: true,
    showPaging: true,

    getColumns: function () {
        var me = this,
            store = me.getViewModel().getStore('master');
        return [
            { text: 'Mã bệnh nhân', dataIndex: 'CustomerID', minWidth: 150, xtype: 'MTColumn' },
            { text: 'Tên bệnh nhân', dataIndex: 'CustomerName', minWidth: 150, xtype: 'MTColumn' },
            { text: 'Hình thức khám', dataIndex: 'AppliedStandardID', width: 80, xtype: 'MTColumn' },
            { text: 'Mô tả', dataIndex:'MedicalRecordDescription', width: 120, flex: 1, xtype: 'MTColumn' },
            { text: 'Nơi khám', dataIndex: 'MedicalRecordLocation', width: 150, xtype: 'MTColumn' },
            { text: 'Ngày khám', dataIndex: 'MedicalRecordDate', width: 120, xtype: 'MTColumnDateField' },
            { text: 'Kết quả', dataIndex: 'FinalResult', width: 120, xtype: 'MTColumn' }
        ];
    },

    getStoreMaster: function () {
        var me = this,
            store = me.getViewModel().getStore('masterStore');
        return store;
    }
});
