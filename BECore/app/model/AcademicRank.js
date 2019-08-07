/// <summary>
/// Model EXTJS AcademicRank.
/// </summary>
Ext.define('QLDT.model.AcademicRank', {
    extend: 'Ext.data.Model',
    idProperty: 'AcademicRankID',
    idType: 'Guid',

    code: 'AcademicRankCode',
    name: 'AcademicRankName',

    fields: [
        { name: "AcademicRankID", type: "string" },
		{ name: "AcademicRankCode", type: "string" },
		{ name: "AcademicRankName", type: "string" },
		{ name: "AcademicRankShortName", type: "string" },
		{ name: "Description", type: "string" },
		{ name: "Inactive", type: "boolean" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "string" },
		{ name: "ModifiedDate", type: "string" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
    ]
});

