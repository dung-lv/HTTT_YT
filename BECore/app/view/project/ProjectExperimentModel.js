/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.project.ProjectExperimentModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.ProjectExperiment',

    requires: [
        'QLDT.model.ContentExperiment',
        'QLDT.model.ProjectExperiment'
    ],
    stores: {
        masterStore: {
            type: 'mtstore',
            model: 'QLDT.model.ContentExperiment',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('ContentExperiment/GetByMasterID')
                },
                reader: { type: 'json' }
            }
        },
        planAttachStore: {
            type: 'mtstore',
            model: 'QLDT.model.ProjectExperiment',
            proxy: {
                type: 'mtproxy',
                actionMethods: {
                    read: 'GET'
                },
                api: {
                    read: QLDT.utility.Utility.createUriAPI('ProjectExperiment/GetByMasterID')
                },
                reader: { type: 'json' }
            }
        }
    }
});
