/// <summary>
/// Model EXTJS Customer.
/// </summary>
Ext.define('QLDT.model.Customer', {
    extend: 'Ext.data.Model',
    idProperty: 'CustomerID',
    idType: 'Guid',
    fields: [
        { name: "CustomerID", type: "int" },
        { name: "CustomerCode", type: "string" },
        { name: "CustomerName", type: "string" },
        { name: "CustomerGender", type: "int" },
        { name: "DOB", type: "date" },
        { name: "HealthCareNumber", type: "string" },
        { name: "Tel", type: "string" },
        { name: "Email", type: "string" },
        { name: "Address", type: "string" },
        { name: "CustomerGroup", type: "string" },
        { name: "CustomerDescription", type: "string" },
        { name: "PresenterName", type: "string" },
        { name: "PresenterPhone", type: "string" },
        { name: "PresenterAddress", type: "string" },
        { name: "PresenterIDC", type: "string" },
        { name: "Relationship", type: "string" },
        { name: "CreatedDate", type: "date" },
        { name: "ModifiedDate", type: "date" },
        { name: "IPAddress", type: "string" },
        { name: "ModifiedBy", type: "string" },
        { name: "CreatedBy", type: "string" },
    ]
});

