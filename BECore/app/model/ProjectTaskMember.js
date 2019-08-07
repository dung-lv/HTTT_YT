/// <summary>
/// Model EXTJS ProjectTaskMember.
/// </summary>
Ext.define('QLDT.model.ProjectTaskMember', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectTaskMemberID',
    idType: 'Guid',
    fields: [	
		{ name: "ProjectTaskMemberID", type: "string" },
		{ name:"ProjectTaskID", type:"string" },
		{ name:"EmployeeID", type:"string" },
		{ name:"StartDate", type:"date" },
		{ name:"EndDate", type:"date" },
		{ name:"MonthForTask", type:"float" },
		{ name:"SortOrder", type:"int" },
		{ name:"CreatedDate", type:"date" },
		{ name:"ModifiedDate", type:"date" },
		{ name:"IPAddress", type:"string" },
		{ name:"ModifiedBy", type:"string" },
		{ name: "CreatedBy", type: "string" },
        { name: "EmployeeName", type: "string" },
        { name: "FullName", type: "string" },
        { name: "Rownum", type: "int" },
    ],

    validations: [
           {
               type: 'presence',
               field: 'EmployeeID',
               message:"Trường này không được bỏ trống"
           },
            {
                type: 'presence',
                field: 'StartDate',
                message: "Trường này không được bỏ trống"
            },
             {
                 type: 'presence',
                 field: 'EndDate',
                 message: "Trường này không được bỏ trống"
             }
    ]
});

