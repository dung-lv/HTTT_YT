/// <summary>
/// Model EXTJS ProjectProgressReport.
/// </summary>
Ext.define('QLDT.model.ProjectProgressReport', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectProgressReportID',
    idType: 'Guid',
    fields: [
		{ name: "ProjectProgressReportID", type: "string" },
		{ name: "ProjectID", type: "string" },
		{ name: "TermID", type: "int" },
		{ name: "TermName", type: "string" },
		{ name: "DateReport", type: "date" },
		{ name: "DateCheck", type: "date" },
		{ name: "Result", type: "int" },
        { name: "Result_sTen", type: "string" },
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
        { name: 'IdFiles', type: 'string' }
    ]
});

