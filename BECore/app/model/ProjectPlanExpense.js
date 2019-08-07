/// <summary>
/// Model EXTJS ProjectPlanExpense.
/// </summary>
Ext.define('QLDT.model.ProjectPlanExpense', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectPlanExpenseID',
    idType: 'Guid',
    fields: [	
		{ name:"ProjectID", type:"string" },
		{ name:"Number", type:"string" },
		{ name:"Date", type:"date" },
		{ name:"Amount", type:"float" },
		{ name:"Inactive", type:"boolean" },
		{ name:"SortOrder", type:"int" },
		{ name:"CreatedDate", type:"date" },
		{ name:"ModifiedDate", type:"date" },
		{ name:"IPAddress", type:"string" },
		{ name:"ModifiedBy", type:"string" },
		{ name: "CreatedBy", type: "string" },
        { name: 'IdFiles', type: 'string' }
     ]
});

