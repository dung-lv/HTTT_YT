/// <summary>
/// Model EXTJS GrantRatio.
/// </summary>
Ext.define('QLDT.model.GrantRatio', {
    extend: 'Ext.data.Model',
    idProperty: 'GrantRatioID',
    idType: 'Guid',

    code: 'GrantRatioCode',
    name: 'GrantRatioName',

    fields: [
		{ name: "GrantRatioID", type: "string" },
		{ name: "GrantRatioCode", type: "string" },
		{ name: "GrantRatioName", type: "string" },
		{ name: "Description", type: "string" },
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
        { name: "Rownum", type: "int" },
    ]
});

