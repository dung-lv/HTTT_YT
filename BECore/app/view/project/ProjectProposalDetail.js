/**
 * This class is the main view for the application. It is specified in app.js as the
 * "mainView" property. That setting automatically applies the "viewport"
 * plugin causing this view to become the body element (i.e., the viewport).
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('QLDT.view.project.ProjectProposalDetail', {
    extend: 'QLDT.view.base.BasePopupDetail',
    xtype: 'app-projectproposaldetail',
    requires: [
        'QLDT.view.project.ProjectProposalDetailController', // Controller
        'QLDT.view.project.ProjectProposalDetailModel',     // Model
        'QLDT.view.project.ProjectProposalInfoDetail',     //Tab - Thông tin đề xuất
        'QLDT.view.project.ProjectPresentProtectedDetail', //Tab - Bảo vệ thuyết minh
        'QLDT.view.project.ProjectExpenseProtectedDetail', //Tab - Bảo vệ kinh phí
    ],
    controller: 'ProjectProposalDetail',
    viewModel: 'ProjectProposalDetail',

    width: 800,
    height: 600,
    /*
    * Vẽ nội dung của form
    * Create by: laipv:17.01.2018
    */
    getContent: function () {
        return {
            xtype: 'MTTabPanel',
            flex: 1,
            bodyPadding: 8,
            items: [
                {
                    title: 'T.tin đề xuất',
                    layout: 'fit',
                    flex: 1,
                    items:[
                        {
                            xtype: 'app-projectproposalinfodetail',
                        }
                    ]
                },
                {
                    title: 'Lịch bảo vệ t.minh',
                    layout: 'fit',
                    flex: 1,
                    items:[
                         {
                             xtype: 'app-projectpresentprotecteddetail',
                         }
                    ]
                },
                {
                    title: 'Lịch bảo vệ k.phí',
                    layout: 'fit',
                    flex: 1,
                    items: [
                         {
                             xtype: 'app-projectexpenseprotecteddetail',
                         }
                    ]
                },
            ],
           
        };
    },
});
