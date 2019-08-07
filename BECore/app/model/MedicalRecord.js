/// <summary>
/// Model EXTJS MedicalRecord.
/// </summary>
Ext.define('QLDT.model.MedicalRecord', {
    extend: 'Ext.data.Model',
    idProperty: 'MedicalRecordID',
    idType: 'Guid',
    fields: [	
		{ name:"MedicalRecordID", type:"int" },
        { name: "CustomerID", type: "int" },
        { name: "CustomerName", type: "string" },
		{ name:"AppliedStandardID", type:"int" },
        { name:"MedicalRecordDescription", type:"string" },
		{ name:"MedicalRecordLocation", type:"string" },
        { name: "MedicalRecordDate", type:"date" },
		{ name:"FinalResult", type:"string" },
		{ name:"CreatedBy", type:"string" },
		{ name:"ModifiedBy", type:"string" },
		{ name:"IPAddress", type:"string" },
		{ name:"CreatedDate", type:"date" },
		{ name:"ModifiedDate", type:"date" },
     ]
});

