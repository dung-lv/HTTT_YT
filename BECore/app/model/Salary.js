/// <summary>
/// Model EXTJS Salary.
/// </summary>
Ext.define('QLDT.model.Salary', {
    extend: 'Ext.data.Model',
    idProperty: 'SalaryID',
    idType: 'Guid',
    fields: [
		{ name: "SalaryID", type: "string" },
		{ name: "SalaryCode", type: "string" },
		{ name: "SalaryName", type: "string" },
		{ name: "Month", type: "int" },
		{ name: "Year", type: "int" },
		{ name: "Money", type: "int" },
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
    ]
});

