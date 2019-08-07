/// <summary>
/// Model EXTJS Degree.
/// </summary>
Ext.define('QLDT.model.Term', {
    extend: 'Ext.data.Model',

    idProperty: 'TermID',
    idType: 'int',

    code: 'TermCode',
    name: 'TermName',

    fields: [
        { name:"TermCode", type:"string" },
        { name:"TermName", type:"string" },
        { name:"Description", type:"string" },
        { name:"Inactive", type:"boolean" },
        { name:"SortOrder", type:"int" }
     ]
});

