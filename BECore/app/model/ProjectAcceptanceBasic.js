/// <summary>
/// Model EXTJS ProjectAcceptanceBasic.
/// </summary>
Ext.define('QLDT.model.ProjectAcceptanceBasic', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectAcceptanceBasicID',
    idType: 'Guid',
    fields: [
		{ name: "ProjectID", type: "string" },
		{ name: "EstablishedDate", type: "date" },
		{ name: "MeetingDate", type: "date" },
		{ name: "Status", type: "int" },
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
    ]
});

