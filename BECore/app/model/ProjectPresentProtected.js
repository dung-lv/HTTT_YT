/// <summary>
/// Model EXTJS ProjectPresentProtected.
/// </summary>
Ext.define('QLDT.model.ProjectPresentProtected', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectID',
    idType: 'Guid',
    fields: [	
		{ name:"ProjectID", type:"string" },
		{ name:"DecisionNumber", type:"string" },
		{ name:"DecisionDate", type:"date" },
		{ name:"ProtectedDate", type:"date" },
		{ name:"Status", type:"int" },
		{ name:"Inactive", type:"boolean" },
		{ name:"SortOrder", type:"int" },
		{ name:"CreatedDate", type:"date" },
		{ name:"ModifiedDate", type:"date" },
		{ name:"IPAddress", type:"string" },
		{ name:"ModifiedBy", type:"string" },
		{ name:"CreatedBy", type:"string" },
     ]
});

