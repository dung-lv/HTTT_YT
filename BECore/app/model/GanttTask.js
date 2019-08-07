
Ext.define('QLDT.model.GanttTask', {
    extend: 'Ext.data.Model',
    idProperty: 'Id',
    type: 'Guid',
    fields: [{
        name: 'Id',
        type: 'string'
    }, {
        name: 'ProjectID',
        type: 'string'
    }, {
        name: 'Duration',
        type: 'float'
    }, {
        name: 'StartDate',
        type: 'date'
    }, {
        name: 'EndDate',
        type: 'date'
    },
    {
        name: 'IsProject',
        type: 'boolean'
    },
    {
        name: 'PercentDone',
        type: 'float'
    },
    {
        name: 'Name',
        type: 'string'
    },
    {
        name: 'ParentID',
        type: 'string',
        nullable: true
    },
    {
        name: 'ParentID',
        type: 'string',
        nullable: true
    },
    {
        name: 'Data',
        nullable: true
    },
    {
        name: 'leaf',
        type: 'boolean',
        nullable: true
    },
    {
        name: 'expanded',
        type: 'boolean',
        nullable: true
    },
     {
         name: 'Grade',
         type: 'int'
     }
    ]
});