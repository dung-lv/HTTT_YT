/// <summary>
/// Model EXTJS WageCoefficient.
/// </summary>
Ext.define('QLDT.model.WageCoefficient', {
    extend: 'Ext.data.Model',
    idProperty: 'WageCoefficientID',
    idType: 'Guid',
    fields: [
		{ name: "WageCoefficientID", type: "string" },
		{ name: "GrantRatioID", type: "string" },
		{ name: "ProjectPositionID", type: "string" },
        { name: "ProjectPositionName", type: "string" },
		{ name: "Month", type: "int" },
		{ name: "Year", type: "int" },
		{ name: "Coefficient", type: "float" },
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
        { name: "Edit", type: "boolean" },
    ]
});

