/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectSurvey', {
    extend: 'QLDT.view.base.BaseList',
    xtype: 'app-projectsurvey',
    requires: [
        'QLDT.view.base.BaseList',
        'QLDT.view.project.ProjectSurveyController',
        'QLDT.view.project.ProjectSurveyModel',
        'QLDT.view.project.ProjectSurveyDetail'
    ],
    controller: 'ProjectSurvey',
    viewModel: 'ProjectSurvey',

    /*
    * Hàm lấy danh sách cột của lưới
    * Create by: laipv:04.02.2018
    */
    getColumns: function () {
        var me = this;
        return [
            { text: 'Khảo sát ngày', dataIndex: 'ToDate', width: 130, xtype: 'MTColumnDateField' },
            { text: 'Đơn vị', dataIndex: 'CompanyName', width: 200 },
            { text: 'Tại đơn vị', dataIndex: 'AtCompany', width: 180 },
            { text: 'N.dung t.hiện', dataIndex: 'Description', minWidth: 250, flex: 1 },
            {
                text: 'Tải tệp', dataIndex: 'IdFiles', width: 150,align:'center',
                renderer: function (value, metaData, record, row, col, store, gridView) {
                    var strLink = '';
                    if (value) {
                        metaData.tdCls = 'wrap-text-of-row';
                        var strFileInfo=value.split('|');
                        strFileInfo.forEach(function (s,index) {
                            if(s){
                                var strIDs=s.split(',')
                                strLink += Ext.String.format('<a class="file-download" href="javascript:void(0)" fileid="{0}" filetype="{1}">Tệp {2}</a>', strIDs[0], strIDs[1],
                                    (index+1));
                            }
                        });
                    }
                    if (!strLink) {
                        strLink = '<a class="file-download" href="javascript:void(0)">Không có</a>';
                    }
                    return strLink;
                }
            },
        ];
    },

    /*
    * Vẽ thanh top bar menu
    * Create by: dvthang:24.02.2018
    */
    getTopBar: function () {
        return {
            xtype: 'MTPanel',
            region: 'north',
            padding: '8 0 4 0',
            items: [
                   {
                       xtype: 'MTForm',
                       layout: {
                           type: 'vbox',
                           align: 'stretch',
                       },                       
                       itemId: 'uploadFile',
                       items: [
                               {
                                   xtype: 'MTFilefield',
                                   itemId: 'fileItemID',
                                   labelWidth: 120,
                                   flex: 1,
                                   emptyText: 'Chọn tệp đính kèm',
                                   fieldLabel: 'Kế hoạch khảo sát',
                                   name: 'planServey',
                                   buttonText: '',
                                   buttonConfig: {
                                       iconCls: 'fa fa-cloud-upload'
                                   }
                               },
                               {
                                   xtype: 'MTPanel',
                                   itemId: 'linkDowloadFile',
                                   html: 'Tải tệp đính kèm',
                                   margin: '4 0 8 0',
                                   hidden: true,
                               },
                       ]
                   }]
        };
    },

    /*
    * Vẽ nội dung của form
    * Create by: laipv:04.02.2018
    */
    getCenter: function () {
        var me = this, store = me.getStoreMaster();
        return {
            xtype: 'MTPanel',
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            items: [
                {
                    xtype: 'MTGrid',
                    store: store,
                    appendCls:'grid-file-servey',
                    itemId: 'grdMaster',
                    columns: me.getColumns(),
                    flex: 1,
                    layout: 'fit',
                    contextMenu: me.getContextMenu()
                }
            ]
        };
    },

    /*
    * Lấy về store của form
    * Create by: dvthang:24.02.2018
    */
    getStoreMaster: function () {
        var me = this;
        return me.getViewModel().getStore("masterStore");
    }
});
