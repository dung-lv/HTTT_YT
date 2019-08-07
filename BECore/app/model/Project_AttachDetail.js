/// <summary>
/// Model EXTJS Project_AttachDetail.
/// </summary>
Ext.define('QLDT.model.Project_AttachDetail', {
    extend: 'Ext.data.Model',

    idProperty: 'Project_AttachDetailID',
    idType: 'Guid',

    fields: [
        { name: "Project_AttachDetailID", type:"string" },
		{ name: "ProjectID", type: "string" },
		{ name: "FileName", type: "string" },
		{ name: "FileType", type: "string" },
		{ name: "FileSize", type: "string" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
        { name: "IsTemp", type: "boolean" },
        { name: "Description", type: "string" },
        { name: "FileResourceID", type: "string" },
        
    ]
});

