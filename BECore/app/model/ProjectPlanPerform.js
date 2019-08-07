/// <summary>
/// Model EXTJS ProjectPlanPerform.
/// </summary>
Ext.define('QLDT.model.ProjectPlanPerform', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectPlanPerformID',
    idType: 'Guid',
    fields: [
		{ name: "ProjectID", type: "string" },
		{ name: "EmployeeName", type: "string" },
        { name: "ProjectName", type: "string" },
		{ name: "Date", type: "date" },
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
        { name: 'IdFiles', type: 'string' }
    ]
});

