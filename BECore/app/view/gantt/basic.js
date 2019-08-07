/**
 * Simple example with editable titles and task drag/drop + resize.
 */
Ext.define('QLDT.view.gantt.basic', {
    extend : 'Gnt.panel.Gantt',
    xtype  : 'basicgantt',

    requires : [
        'Sch.util.Date',
        'Sch.preset.Manager',
        'Gnt.column.Name',
        'Gnt.plugin.taskeditor.TaskEditor',
        'Gnt.plugin.TaskContextMenu',
        'Gnt.plugin.DependencyEditor',
        'Sch.plugin.TreeCellEditing'
    ],

    plugins : [
        // enables task editing by double clicking, displays a window with fields to edit
       // 'gantt_taskeditor',
        // enables double click dependency editing
       // 'gantt_dependencyeditor',
        // shows a context menu when right clicking a task
       // 'gantt_taskcontextmenu',
        // column editing
        //'scheduler_treecellediting'
    ],

    dependencyViewConfig     : {
        overCls : 'dependency-over'
    },

    title                    : 'Basic demo',

    // height of each row
    rowHeight                : 35,

    // startDate and endDate determine the date interval visible in the gantt chart.
    // endDate is set in initComponent, because it is calculated from startDate.
    // when startDate and endDate are omitted, these dates will be determined by the loaded data
    // startDate                : new Date(2017, 0, 11),

    // give weekends a contrasting color
    highlightWeekends        : true,

    // enable setting PercentDone for a task by dragging a percentage handle
    enableProgressBarResize  : true,

    // allow creating/editing of dependencies by dragging with the mouse
    //enableDependencyDragDrop : true,

    // change to true to allow user to resize static column area
    split                    : false,

    // define your columns
    columns : [
        {
            xtype : 'namecolumn',
            width : 250
        }
    ],

    // demonstrates customization of the preset by specifing column width and removing the days-row
    viewPreset : {
        timeColumnWidth : 100,
        name            : 'weekAndDayLetter',
        headerConfig    : {
            middle : {
                unit       : 'w',
                dateFormat : 'D d M Y'
            }
        }
    },

    //resizeConfig     : {
    //    showDuration: false
    //},

    //viewConfig              : {
    //    trackOver: false
    //},
    //snapToIncrement : true,

    //eventRenderer: function (taskRecord) {
    //    return {
    //        ctcls: "Id-" + taskRecord.get('Id') // Add a CSS class to the task container element
    //    };
    //},

    // a gantt chart requires a taskStore, which holds the tasks to display
    taskStore : {
        type  : 'gantt_taskstore',
        proxy : {
            type : 'ajax',
            url  : 'app/data/tasks.json'
        }
    },

    // a gantt chart also requires a dependency store, which defines the connections between the tasks
    //dependencyStore : {
    //    type                   : 'gantt_dependencystore',
    //    allowedDependencyTypes : ['EndToStart'],
    //    autoLoad               : true,
    //    proxy                  : {
    //        type : 'ajax',
    //        url  : 'app/data/dependencies.json'
    //    }
    //},

    initComponent : function() {
        var me = this;

        Ext.apply(me, {
            
            header : {
                items: [
                    {
                        xtype  : 'button',
                        text   : 'Add new task',
                        iconCls: 'x-fa fa-plus-circle',
                        handler: 'onAddTaskClick',
                        scope  : me
                    },
                    {
                        xtype       : 'button',
                        style       : 'margin-left: 10px',
                        enableToggle: true,
                        itemId      : 'demo-readonlybutton',
                        text        : 'Read only mode',
                        iconCls     : 'x-fa fa-ban',
                        pressed     : false,
                        handler     : function () {
                            me.setReadOnly(this.pressed);
                        }
                    }
                ]
            }
        });

        me.callParent();
    },

    onAddTaskClick : function(btn) {
        var me = this,
            taskStore = me.getTaskStore();

        // create empty ask
        var newTask = new taskStore.model({
            Name        : 'New task',
            leaf        : true,
            PercentDone : 0
        });
        // add and scroll to it
        taskStore.getRoot().appendChild(newTask);
        me.getSchedulingView().scrollEventIntoView(newTask);

        Ext.toast('Click and drag on row to plan task', 'New task added');
    }
});
