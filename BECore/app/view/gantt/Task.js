/**
 * Simple example with editable titles and task drag/drop + resize.
 */
Ext.define('QLDT.view.gantt.Task', {
    extend : 'Gnt.panel.Gantt',
    xtype  : 'gantttask',

    requires : [
        'Sch.util.Date',
        'Sch.preset.Manager',
        'Gnt.column.Name',
        'QLDT.view.gantt.TaskController',
        'QLDT.view.gantt.TaskModel'
    ],

    controller: 'gantttask',
    viewModel: 'gantttask',

    title: 'Tiến độ đề tài',

    readOnly:true,

    // height of each row
    rowHeight                : 35,

    tooltipTpl: new Ext.XTemplate(
               '<ul class="taskTip">',
                   '<li><strong>Nội dung: </strong>{Name}</li>',
                   '<li><strong>Ngày bắt đầu: </strong>{[Ext.Date.format(values.StartDate, "d/m/Y")]}</li>',
                   '<li><strong>Thời gian còn lại: </strong> {Duration}</li>',
                   '<li><strong>Hoàn thành: </strong>{PercentDone}%</li>',
               '</ul>'
           ).compile(),


    // define your columns
    columns : [
        {
            xtype: 'namecolumn',
            text:'Task',
            width: 300,
            renderer: function (value, metaData, record, rowIndex) {
                value = Ext.String.htmlEncode(value);
                // "double-encode" before adding it as a data-qtip attribute
                metaData.tdAttr = 'data-qtip="' + Ext.String.htmlEncode(value) + '"';

                return value;
            }
        }
    ],
    split:false,

    viewPreset: {
        timeColumnWidth: 60,
        name: 'weekAndDayLetter',
        headerConfig: {
            middle: {
                unit: 'DAY',
                align: 'center',
                dateFormat: 'D'
            },
            top: {
                unit: 'WEEK',
                align:'center',
                dateFormat: 'D, d/m/Y'
            }
        }
    },
    bodyBorder: false,

    viewConfig              : {
        trackOver: false,
        getRowClass: function (record, index) {
            var cls = '';
            if (!record.get('leaf')) {
                cls = 'cls-bold';
            }
            return cls;
        }
    },

    initComponent : function() {
        var me = this;
        Ext.apply(me, {
            taskStore: new Gnt.data.TaskStore({
                sortOnLoad: false,
                rootVisible:true,
                proxy: {
                    type: 'memory'
                }
            })
        });
        me.callParent();
    },

});
