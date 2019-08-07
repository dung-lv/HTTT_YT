/// <summary>
/// Model EXTJS ProjectAcceptanceBasic_AttachDetail.
/// </summary>
Ext.define('QLDT.model.ProjectAcceptanceBasic_AttachDetail', {
    extend: 'Ext.data.Model',

    idProperty: 'ProjectAcceptanceBasic_AttachDetailID',
    idType: 'Guid',

    fields: [
        { name: "ProjectAcceptanceBasic_AttachDetailID", type: "string" },
		{ name: "ProjectAcceptanceBasicID", type: "string" },
		{ name: "Contents", type: "string" },
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