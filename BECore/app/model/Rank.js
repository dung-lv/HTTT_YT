/*
* Danh mục cấp bậc
* Create by: dvthang:09.01.2018
*/
Ext.define('QLDT.model.Rank', {
    extend: 'Ext.data.Model',
    idProperty: 'RankID',
    idType: 'Guid',

    code: 'RankCode',
    name: 'RankName',
    fields: [
		{ name: "RankCode", type: "string" },
		{ name: "RankName", type: "string" },
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
