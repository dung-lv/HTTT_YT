/// <summary>
/// Model EXTJS AuditLaboday.
/// </summary>
Ext.define('QLDT.model.AuditLaboday', {
    extend: 'Ext.data.Model',

    idProperty: 'EmployeeID',
    idType: 'Guid',
    fields: [
        { name: "EmployeeID", type: "string" },
		{ name: "FullName", type: "string" }

    ]
});

