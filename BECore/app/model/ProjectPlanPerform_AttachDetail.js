/// <summary>
/// Model EXTJS ProjectPlanPerform_AttachDetail.
/// </summary>
Ext.define('QLDT.model.ProjectPlanPerform_AttachDetail', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectPlanPerform_AttachDetailID',
    idType: 'Guid',
    fields: [
        { name: "ProjectPlanPerform_AttachDetailID", type: "string" },
		{ name:"ProjectPlanPerformID", type:"string" },
		{ name:"FileName", type:"string" },
		{ name: "FileType", type: "string" },
        { name: "Description", type: "string" },
		{ name:"FileSize", type:"string" },
		{ name:"Inactive", type:"boolean" },
		{ name:"SortOrder", type:"int" },
		{ name:"CreatedDate", type:"date" },
		{ name:"ModifiedDate", type:"date" },
		{ name:"IPAddress", type:"string" },
		{ name:"ModifiedBy", type:"string" },
		{ name: "CreatedBy", type: "string" },
        { name: "IsTemp", type: "boolean" },
     ]
});

