/// <summary>
/// Model EXTJS Position.
/// </summary>
Ext.define('QLDT.model.Position', {
    extend: 'Ext.data.Model',
    idProperty: 'PositionID',
    idType: 'Guid',

    code: 'PositionCode',
    name: 'PositionName',
    fields: [
        { name: "PositionID", type: "string" },
		{ name: "PositionCode", type: "string" },
		{ name: "PositionName", type: "string" },
		{ name: "Description", type: "string" },
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
    ]
});

