/// <summary>
/// Model EXTJS PartyPosition.
/// </summary>
Ext.define('QLDT.model.PartyPosition', {
    extend: 'Ext.data.Model',
    idProperty: 'PartyPositionID',
    idType: 'Guid',

    code: 'PartyPositionCode',
    name: 'PartyPositionName',
    fields: [
		{ name: "PartyPositionID", type: "string" },
		{ name: "PartyPositionCode", type: "string" },
		{ name: "PartyPositionName", type: "string" },
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

