/// <summary>
/// Model EXTJS ProjectTask.
/// </summary>
Ext.define('QLDT.model.ProjectTask', {
    extend: 'Ext.data.Model',

    idProperty: 'ProjectTaskID',

    fields: [
        { name: "ProjectTaskID", type: "string" },
		{ name: "ParentID", type: "string",nullable:true },
		{ name: "ProjectID", type: "string" },
		{ name: "Contents", type: "string" },
		{ name: "Result", type: "string" },
		{ name: "StartDate", type: "date" },
        { name: "Grade", type: "int" },
        { name: "Leaf", type: "boolean" },
		{ name: "EndDate", type: "date" },
		{ name: "EmployeeID", type: "string" },
		{ name: "Status", type: "int" },		
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
    ]
});

