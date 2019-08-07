/// <summary>
/// Model EXTJS ContractedProfessional.
/// </summary>
Ext.define('QLDT.model.ContractedProfessional', {
    extend: 'Ext.data.Model',
    idProperty: 'ContractedProfessionalID',
    idType: 'Guid',
    fields: [
		{ name: "ContractedProfessionalID", type: "string" },
		{ name: "ProjectID", type: "string" },
		{ name: "ProjectTaskID", type: "string" },
		{ name: "EmployeeID", type: "string" },
        { name: "Contents", type: "string" },
        { name: "Inactive", type: "boolean" },
        { name: "FullName", type: "string" },
		{ name: "SortOrder", type: "int" },
        { name: "MonthForTask", type: "int" },
        { name: "MonthForTaskLaborday", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
        { name: "Edit", type: "boolean" },
        { name: "RowNum", type: "int" },
        { name: "Verify", type: "boolean" },
    ]
});

