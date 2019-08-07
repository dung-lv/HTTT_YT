/// <summary>
/// Model EXTJS MeasurementStandard.
/// </summary>
Ext.define('QLDT.model.MeasurementStandard', {
    extend: 'Ext.data.Model',
    idProperty: 'MeasurementStandardID',
    idType: 'Guid',
    fields: [
        { name: "MeasurementStandardID", type: "int" },
        { name: "Code", type: "string" },
        { name: "FullName", type: "string" },
        { name: "ShortName", type: "string" },
        { name: "Description", type: "string" },
        { name: "CreatedDate", type: "date" },
        { name: "ModifiedDate", type: "date" },
        { name: "IPAddress", type: "string" },
        { name: "ModifiedBy", type: "string" },
        { name: "CreatedBy", type: "string" },
    ]
});

