/// <summary>
/// Model EXTJS Degree.
/// </summary>
Ext.define('QLDT.model.Degree', {
    extend: 'Ext.data.Model',

    idProperty: 'DegreeID',
    idType: 'Guid',

    code: 'DegreeCode',
    name: 'DegreeName',

    fields: [
        { name: "DegreeID", type: "string" },
		{ name:"DegreeCode", type:"string" },
		{ name:"DegreeName", type:"string" },
		{ name:"DegreeShortName", type:"string" },
		{ name:"Description", type:"string" },
		{ name:"Inactive", type:"boolean" },
		{ name:"SortOrder", type:"int" }
     ]
});

