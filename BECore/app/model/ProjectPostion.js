/// <summary>
/// Model EXTJS ProjectPostion.
/// </summary>
Ext.define('QLDT.model.ProjectPostion', {
    extend: 'Ext.data.Model',
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

