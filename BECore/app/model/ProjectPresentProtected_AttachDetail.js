/// <summary>
/// Model EXTJS ProjectPresentProtected_AttachDetail.
/// </summary>
Ext.define('QLDT.model.ProjectPresentProtected_AttachDetail', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectPresentProtectedID',
    idType: 'Guid',
    fields: [	
		{ name:"ProjectPresentProtectedID", type:"string" },
		{ name:"FileName", type:"string" },
		{ name:"FileType", type:"string" },
		{ name:"FileSize", type:"string" },
		{ name:"Inactive", type:"boolean" },
		{ name:"SortOrder", type:"int" },
		{ name:"CreatedDate", type:"date" },
		{ name:"ModifiedDate", type:"date" },
		{ name:"IPAddress", type:"string" },
		{ name:"ModifiedBy", type:"string" },
		{ name:"CreatedBy", type:"string" },
     ]
});

