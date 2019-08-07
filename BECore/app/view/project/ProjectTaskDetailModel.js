/**
 * Thêm tệp đính kèm
 * Create by: laipv:29.01.2018
 */
Ext.define('QLDT.view.project.ProjectTaskDetailModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectTaskDetail',

    stores:
        {
            projecttaskstatusStore: {
                fields:
                [
                    { name: 'text', type: 'string' },
                    {name: 'value', type: 'int'},
                ],
                data:
                [
                    { text: 'Hoàn thành', value: 11 },
                    { text: 'Chưa hoàn thành', value: 12 },
                    { text: 'Chậm tiến độ', value: 13 },
                ]
            },
            projecttaskStore: {
                type: 'mtstore',
                model: 'QLDT.model.ProjectTask',
                proxy: {
                    type: 'mtproxy',
                    actionMethods: {
                        read: 'GET'
                    },
                    api: {
                        read: QLDT.utility.Utility.createUriAPI('/ProjectTasks/ByMasterIDAndEditMode')
                    },
                    reader: { type: 'json' }
                }
            },
        }
});
