/// <summary>
/// Model EXTJS ProjectSurvey.
/// </summary>
Ext.define('QLDT.model.ProjectSurvey', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectSurveyID',
    idType: 'Guid',
    fields: [
        { name: "ProjectSurveyID", type: "string" },
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

