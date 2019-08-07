/// <summary>
/// Model EXTJS ProjectWorkshop_AttachDetail.
/// </summary>
Ext.define('QLDT.model.ProjectWorkshop_AttachDetail', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectWorkshop_AttachDetailID',
    idType: 'Guid',
    fields: [
        { name: "ProjectWorkshop_AttachDetailID", type: "string" },
		{ name: "ProjectWorkshopID", type: "string" },
        { name: "Description", type: "string" },
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
        { name: "IsTemp", type: "boolean" },
    ]
});

