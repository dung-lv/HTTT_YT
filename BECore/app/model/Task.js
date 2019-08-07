
Ext.define('QLDT.model.Task', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectID',
    type:'Guid',
    fields: [{
        name: 'ProjectID',
        type: 'string'
    }, {
        name: 'ProjectName',
        type: 'string'
    }, {
        name: 'EmployeeName',
        type: 'string'
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
        }
    ]
}); 