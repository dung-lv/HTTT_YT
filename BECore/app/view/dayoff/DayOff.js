/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.dayoff.DayOff', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-dayoff',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.dayoff.DayOffController',
        'QLDT.view.dayoff.DayOffModel',
        'QLDT.view.dayoff.DayOffDetail'
    ],

    controller: 'DayOff',
    viewModel: 'DayOff',
    /*
    * Trả về nội dung của form
    * Create by: dvthang:06.01.2017
    */
    getColumns: function () {
        var me = this;
        return [
                {
                    text: 'STT', dataIndex: 'SortOrder', width: 80, align: 'center',
                },
                {
                    text: 'Ngày', dataIndex: 'Date', width: 130, xtype: 'MTColumnDateField'
                },
                { text: 'Diễn giải', dataIndex: 'Description', width: 250, flex: 1, xtype: 'MTColumn', }
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
