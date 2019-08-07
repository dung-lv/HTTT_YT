/// <summary>
/// Model EXTJS ContentExperiment.
/// </summary>
Ext.define('QLDT.model.ContentExperiment', {
    extend: 'Ext.data.Model',
    idProperty: 'ID',
    idType: 'Guid',
    fields: [
        { name: "ID", type: "string" },
		{ name: "CompanyID", type: "string" },
		{ name: "AtCompany", type: "string" },
		{ name: "Description", type: "string" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
        { name: 'ToDate', type: 'date', defaultValue: new Date() },
        { name: 'ProjectID', type: 'string' },
        { name: 'CompanyName', type: 'string' },
        { name: 'IdFiles', type: 'string' }
    ]
});

