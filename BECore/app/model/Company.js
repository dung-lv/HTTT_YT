/// <summary>
/// Model EXTJS Company.
/// </summary>
Ext.define('QLDT.model.Company', {
    extend: 'Ext.data.Model',

    idProperty: 'CompanyID',
    idType: 'Guid',

    code: 'CompanyCode',
    name: 'CompanyName',

    fields: [
		{ name: "CompanyID", type: "string" },
		{ name: "CompanyCode", type: "string" },
		{ name: "CompanyName", type: "string" },
		{ name: "CompanyShortName", type: "string" },
		{ name: "Tel", type: "string" },
		{ name: "Fax", type: "string" },
		{ name: "Email", type: "string" },
		{ name: "Address", type: "string" },
		{ name: "Website", type: "string" },
		{ name: "Director", type: "string" },
		{ name: "AccountNumber", type: "string" },
		{ name: "BankName", type: "string" },
		{ name: "Description", type: "string" },
		{ name: "IsLeaf", type: "boolean" },
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
        { name: "Owned", type: "boolean" },
    ]
});

