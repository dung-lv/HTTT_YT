/// <summary>
/// Model EXTJS ProjectPlanExpense_AttachDetail.
/// </summary>
Ext.define('QLDT.model.ProjectPlanExpense_AttachDetail', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectPlanExpense_AttachDetailID',
    idType: 'Guid',
    fields: [	
        { name: "ProjectPlanExpense_AttachDetailID", type: "string" },
        { name: "ProjectPlanExpenseID", type: "string" },
		{ name:"FileName", type:"string" },
		{ name: "FileType", type: "string" },
        { name: "Description", type: "string" },
		{ name:"FileSize", type:"string" },
		{ name:"Inactive", type:"boolean" },
		{ name:"SortOrder", type:"int" },
		{ name:"CreatedDate", type:"date" },
		{ name:"ModifiedDate", type:"date" },
		{ name:"IPAddress", type:"string" },
		{ name:"ModifiedBy", type:"string" },
		{ name: "CreatedBy", type: "string" },
        { name: "IsTemp", type: "boolean" },
     ]
});

