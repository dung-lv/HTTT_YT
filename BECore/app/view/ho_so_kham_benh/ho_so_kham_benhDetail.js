/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.ho_so_kham_benh.ho_so_kham_benhDetail', {
    extend: 'QLDT.view.base.BasePopupDetail',
    xtype: 'app-ho_so_kham_benhdetail',
    requires: [
        'QLDT.view.base.BasePopupDetail',
        'QLDT.view.ho_so_kham_benh.ho_so_kham_benhDetailController',
        'QLDT.view.ho_so_kham_benh.ho_so_kham_benhDetailModel',
        'QLDT.view.control.MTCheckbox'
    ],

    controller: 'ho_so_kham_benhDetail',
    viewModel: 'ho_so_kham_benhDetail',

    height: 420,
    width: 500,
    getContent: function () {
        return {
            xtype: 'MTPanel',
            region: 'center',
            bodyPadding: 8,
            items: [{
                columnWidth: 0.5,
                layout: {
                    type: 'vbox',
                    align: 'stretch'
                },
                items: [
                    {
                        fieldLabel: 'MedicalRecordID',
                        name: 'MedicalRecordID',
                        xtype: 'MTTextField',
                        allowBlank: true,
                        readOnly: true,
                        margin: '0 8 10 0',
                        maxLength: 1500,
                        bind: '{masterData.MedicalRecordID}'
                    },
                    {
                        fieldLabel: 'Bệnh nhân',
                        name: 'CustomerID',
                        xtype: 'MTComboBox',
                        allowBlank: false,
                        maxLength: 50,
                        margin: '8 8 10 0',
                        displayField: 'CustomerName',
                        valueField: 'CustomerID',
                        bind: {
                            value: '{masterData.CustomerID}',
                            store: '{Customer}'
                        }
                    },
                    //{
                    //    fieldLabel: 'Tên bệnh nhân',
                    //    name: 'DocumentNumber',
                    //    xtype: 'MTTextField',
                    //    allowBlank: false,
                    //    maxLength: 50,
                    //    margin: '8 8 10 0',
                    //    bind: '{masterData.DocumentNumber}'
                    //},
                    {
                        fieldLabel: 'Hình thức khám',
                        name: 'AppliedStandardID',
                        xtype: 'MTComboBox',
                        allowBlank: false,
                        margin: '0 8 10 0',
                        maxLength: 1500,
                        displayField: 'FullName',
                        valueField: 'MeasurementStandardID',
                        bind: {
                            value: '{masterData.AppliedStandardID}',
                            store: '{MeasurementStandardStore}'
                        }
                    },
                     {
                        fieldLabel: 'Mô tả',
                         name: 'MedicalRecordDescription',
                        xtype: 'MTTextField',
                        allowBlank: false,
                        margin: '0 8 10 0',
                        maxLength: 1500,
                         bind: '{masterData.MedicalRecordDescription}'
                    },
                    {
                        fieldLabel: 'Nơi tiếp nhận',
                        name: 'MedicalRecordLocation',
                        xtype: 'MTTextField',
                        allowBlank: false,
                        margin: '0 8 10 0',
                        maxLength: 1500,
                        bind: '{masterData.MedicalRecordLocation}'
                    },
                    {
                        fieldLabel: 'Ngày khám',
                        name: 'MedicalRecordDate',
                        xtype: 'MTDateField',
                        allowBlank: false,
                        margin: '0 8 10 0',
                        maxLength: 1500,
                        bind: '{masterData.MedicalRecordDate}'
                    },
                    {
                        fieldLabel: 'Kết quả',
                        name: 'FinalResult',
                        xtype: 'MTTextField',
                        allowBlank: false,
                        margin: '0 8 10 0',
                        maxLength: 1500,
                        bind: '{masterData.FinalResult}'
                    }
                ]
            }
            ]
        };
    }
});
