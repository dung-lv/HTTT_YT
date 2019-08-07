/// <summary>
/// Model EXTJS ProjectClose.
/// </summary>
Ext.define('QLDT.model.ProjectClose', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectCloseID',
    idType: 'Guid',
    fields: [
		{ name: "ProjectID", type: "string" },
		{ name: "Date", type: "date" },
		{ name: "LiquidationDate", type: "date" },
		{ name: "FileName", type: "string" },
		{ name: "FileType", type: "string" },
		{ name: "FileSize", type: "string" },
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

