/// <summary>
/// Model EXTJS Employee.
/// </summary>
Ext.define('QLDT.model.Employee', {
    extend: 'Ext.data.Model',

    idProperty: 'EmployeeID',
    idType: 'Guid',

    code: 'EmployeeCode',
    name: 'FullName',

    fields: [
        { name: "EmployeeID", type: "string" },
		{ name: "CompanyID", type: "string" },
		{ name: "EmployeeCode", type: "string" },
		{ name: "Password", type: "string" },
        { name: "IsChangedPassword", type: "boolean" },
		{ name: "FirstName", type: "string" },
		{ name: "LastName", type: "string" },
		{ name: "FullName", type: "string" },
		{ name: "RankID", type: "string" },
		{ name: "Gender", type: "int" },
		{ name: "AcademicRankID", type: "string" },
		{ name: "YearOfAcademicRank", type: "int" },
		{ name: "DegreeID", type: "string" },
		{ name: "YearOfDegree", type: "int" },
		{ name: "PositionID", type: "string" },
		{ name: "BirthDay", type: "date" },
		{ name: "BirthPlace", type: "string" },
		{ name: "HomeLand", type: "string" },
		{ name: "NativeAddress", type: "string" },
		{ name: "Tel", type: "string" },
		{ name: "HomeTel", type: "string" },
		{ name: "Mobile", type: "string" },
		{ name: "Fax", type: "string" },
		{ name: "Email", type: "string" },
		{ name: "OfficeAddress", type: "string" },
		{ name: "HomeAddress", type: "string" },
		{ name: "Website", type: "string" },
		{ name: "Description", type: "string" },
		{ name: "FileResourceID", type: "string" },
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
        { name: "IDNumber", type: "string" },
        { name: "IssuedBy", type: "string" },
        { name: "DateBy", type: "date" },
        { name: "AccountNumber", type: "string" },
        { name: "Bank", type: "string" },

    ]
});

