/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectAcceptanceManageDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectAcceptanceManageDetail',

    requires: [
        'QLDT.model.ProjectAcceptanceManage',
        'QLDT.view.control.MTStore',
        'QLDT.model.ProjectAcceptanceManage_AttachDetail',
    ],

    stores: {
        detail: {
            xtype: 'mtstore',
            setField: 'Details',
            model: 'QLDT.model.ProjectAcceptanceManage_AttachDetail',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('/ProjectAcceptanceManage_AttachDetail/GetByMasterID')
                },
                reader: { type: 'json' }
            }
        },


        statusStore: {
            fields: [{
                name: 'text', type: 'string'
            },
            {
                name: 'value', type: 'int'
            }
            ],
            data: [
                {
                    text: 'Đạt', value: 11
                },
                {
                    text: 'Không đạt', value: 12
                }

            ]
        }

    }
});
