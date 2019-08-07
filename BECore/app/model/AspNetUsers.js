/// <summary>
/// Model EXTJS AspNetUsers.
/// </summary>
Ext.define('QLDT.model.AspNetUsers', {
    extend: 'Ext.data.Model',
    idProperty: 'Id',
    idType: 'Guid',
    fields: [
        { name: "Id", type: "int" },
        { name: "Email", type: "string" },
        { name: "EmailConfirmed", type: "boolean" },
        { name: "PasswordHash", type: "string" },
        { name: "SecurityStamp", type: "string" },
        { name: "PhoneNumber", type: "string" },
        { name: "PhoneNumberConfirmed", type: "boolean" },
        { name: "TwoFactorEnabled", type: "boolean" },
        { name: "LockoutEndDateUtc", type: "date" },
        { name: "LockoutEnabled", type: "boolean" },
        { name: "AccessFailedCount", type: "int" },
        { name: "UserName", type: "string" },
        { name: "GroupID", type: "int" },
        { name: "UserID", type: "int" },
        { name: "FullName", type: "string" },
        { name: "Address", type: "string" },
        { name: "ModifiedDate", type: "date" },
        { name: "CreatedDate", type: "date" },
        { name: "IPAddress", type: "string" },
        { name: "ModifiedBy", type: "string" },
        { name: "CreatedBy", type: "string" },
        { name: "oId", type: "int" },
    ]
});

