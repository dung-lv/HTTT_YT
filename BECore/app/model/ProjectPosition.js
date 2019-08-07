/// <summary>
/// Model EXTJS ProjectPosition.
/// </summary>
Ext.define('QLDT.model.ProjectPosition', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectPositionID',
    idType: 'Guid',

    code: 'ProjectPositionCode',
    name: 'ProjectPositionName',
    fields: [	
		{ name:"ProjectPositionCode", type:"string" },
		{ name:"ProjectPositionName", type:"string" },
		{ name:"ProjectPositionShortName", type:"string" },
		{ name:"Coefficient", type:"float" },
		{ name:"Description", type:"string" },
		{ name:"Inactive", type:"boolean" },
		{ name:"SortOrder", type:"int" }
     ]
});

