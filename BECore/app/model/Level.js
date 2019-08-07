/*
* Danh mục cấp quản lý đề tài
* Create by: laipv:13.01.2018
*/
Ext.define('QLDT.model.Level', {
    extend: 'Ext.data.Model',
    idProperty: 'LevelID',
    idType: 'Guid',
    
    code: 'LevelCode',
    name: 'LevelName',

    fields: [
        { name: "LevelID", type: "string" },
		{ name: "LevelCode", type: "string" },
		{ name: "LevelName", type: "string" },
		{ name: "Description", type: "string" },
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
    ]
});
