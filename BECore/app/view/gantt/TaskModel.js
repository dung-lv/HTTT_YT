/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.gantt.TaskModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.gantttask',

    requires: [
        'QLDT.model.GanttTask'
    ],
    
});
