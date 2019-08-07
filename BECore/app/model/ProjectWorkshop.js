/// <summary>
/// Model EXTJS ProjectWorkshop.
/// </summary>
Ext.define('QLDT.model.ProjectWorkshop', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectWorkshopID',
    idType: 'Guid',
    fields: [
        { name: "ProjectWorkshopID", type: "string" },
		{ name: "ProjectID", type: "string" },
		{ name: "Date", type: "date" },
		{ name: "Time", type: "date" },
		{ name: "Adderess", type: "string" },
		{ name: "Contents", type: "string" },
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
        { name: 'IdFiles',type:'string' }
    ]
});

