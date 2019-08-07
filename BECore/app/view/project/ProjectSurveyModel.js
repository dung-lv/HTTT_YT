/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectSurveyModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectSurvey',

    requires:[
        'QLDT.model.ContentServey',
        'QLDT.model.ProjectSurvey'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            model: 'QLDT.model.ContentServey',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('ContentServey/GetByMasterID')
                },
                reader: { type: 'json' }
            }
        },
        planAttachStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectSurvey',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('ProjectSurvey/GetByMasterID')
                },
                reader: { type: 'json' }
            }
        }
    }
});
