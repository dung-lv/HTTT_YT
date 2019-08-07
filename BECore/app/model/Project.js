/*
* Danh sách đề tài
* Create by: laipv:13.01.2018
*/
/// <summary>
/// Model EXTJS Project.
/// </summary>
Ext.define('QLDT.model.Project', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectID',
    idType: 'Guid',
    fields: [
        { name: "ProjectID", type: "string" },
		{ name: "ProjectCode", type: "string" },
		{ name: "ProjectName", type: "string" },
        { name: "ProjectNameAbbreviation", type: "string" },
		{ name: "StartDate", type: "date" },
		{ name: "EndDate", type: "date" },
		{ name: "CompanyID", type: "string" },
		{ name: "EmployeeID", type: "string" },
        { name: "EmployeeName", type: "string" },
		{ name: "Amount", type: "float" },
		{ name: "Amount_Level1", type: "float" },
		{ name: "Amount_Level2", type: "float" },
		{ name: "Amount_Other", type: "float" },
		{ name: "Program", type: "boolean" },
		{ name: "ProgramName", type: "string" },
		{ name: "ProjectScience", type: "boolean" },
		{ name: "ProjectScienceName", type: "string" },
		{ name: "IndependentTopic", type: "boolean" },
		{ name: "Nature", type: "boolean" },
		{ name: "AFF", type: "boolean" },
		{ name: "Technical", type: "boolean" },
		{ name: "Pharmacy", type: "boolean" },
		{ name: "Result", type: "string" },
		{ name: "CompanyApply", type: "string" },
		{ name: "Description", type: "string" },
		{ name: "Status", type: "int" },
		{ name: "LevelID", type: "int" },
		{ name: "GrantRatioID", type: "string" },
		{ name: "ProjectChairman", type: "string" },
		{ name: "ProjectSecretary", type: "string" },
		{ name: "ProjectCompanyChair", type: "string" },
		{ name: "ProjectMember", type: "string" },
		{ name: "ProjectCompanyCombination", type: "string" },
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
        { name: 'IsProject', type: 'boolean' },
        { name: "MonthFin", type: "int" },
        { name: "YearFin", type: "int" },
    ]
});
