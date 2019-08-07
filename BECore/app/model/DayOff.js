/// <summary>
/// Model EXTJS DayOff.
/// </summary>
Ext.define('QLDT.model.DayOff', {
    extend: 'Ext.data.Model',
    idProperty: 'DayOffID',
    idType: 'Guid',

    fields: [
		{ name: "DayOffID", type: "string" },
		{ name: "Date", type: "date" },
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

