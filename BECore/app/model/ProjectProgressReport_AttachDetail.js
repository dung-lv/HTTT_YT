/// <summary>
/// Model EXTJS ProjectProgressReport_AttachDetail. 
/// </summary>
Ext.define('QLDT.model.ProjectProgressReport_AttachDetail', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectProgressReport_AttachDetailID',
    idType: 'Guid',
    fields: [
		{ name: "ProjectProgressReportID", type: "string" },
		{ name: "FileName", type: "string" },
		{ name: "FileType", type: "string" },
		{ name: "FileSize", type: "string" },
        { name: "Description", type: "string" },
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

