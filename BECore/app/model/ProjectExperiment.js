/// <summary>
/// Model EXTJS ProjectExperiment.
/// </summary>
Ext.define('QLDT.model.ProjectExperiment', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectExperimentID',
    idType: 'Guid',
    fields: [
        { name: "ProjectExperimentID", type: "string" },
		{ name: "ProjectID", type: "string" },
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
    ]
});

