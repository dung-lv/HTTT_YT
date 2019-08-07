/// <summary>
/// Model EXTJS ProjectMember.
/// </summary>
Ext.define('QLDT.model.ProjectMember', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectMemberID',
    idType: 'Guid',
    fields: [
		{ name: "ProjectID", type: "string" },
		{ name: "EmployeeID", type: "string" },
		{ name: "FullName", type: "string" },
		{ name: "StartDate", type: "date" },
		{ name: "EndDate", type: "date" },
		{ name: "MonthForProject", type: "float" },
		{ name: "ProjectPositionID", type: "string" },
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
        { name: "EmployeeName", type: "string" },
        { name: "ProjectPositionName", type: "string" },
        { name: "Rownum", type: "int" },
        
    ]
});

