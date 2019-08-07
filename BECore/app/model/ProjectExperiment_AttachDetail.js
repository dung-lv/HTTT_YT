﻿/// <summary>
/// Model EXTJS ProjectExperiment_AttachDetail.
/// </summary>
Ext.define('QLDT.model.ProjectExperiment_AttachDetail', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectExperiment_AttachDetailID',
    idType: 'Guid',
    fields: [
		{ name: "ID", type: "string" },
        { name: "Description", type: "string" },
		{ name: "FileName", type: "string" },
		{ name: "FileType", type: "string" },
		{ name: "FileSize", type: "string" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
        { name: 'FileResourceID', type: "string" },
        { name: 'IsTemp',type:'boolean' }
    ]
});

