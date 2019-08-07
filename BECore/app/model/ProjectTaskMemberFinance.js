/// <summary>
/// Model EXTJS ProjectTaskMemberFinance.
/// </summary>
Ext.define('QLDT.model.ProjectTaskMemberFinance', {
    extend: 'Ext.data.Model',
    idProperty: 'ProjectTaskMemberFinanceID',
    idType: 'Guid',
    fields: [
		{ name: "ProjectTaskMemberFinanceID", type: "string" },
		{ name: "ProjectID", type: "string" },
		{ name: "ProjectTaskID", type: "string" },
		{ name: "EmployeeID", type: "string" },
		{ name: "Year", type: "int" },
		{ name: "Month", type: "int" },
		{ name: "Day", type: "date" },
		{ name: "Description", type: "string" },
		{ name: "Hour", type: "float" },
		{ name: "LaborDay", type: "float" },
        { name: "DescriptionFin", type: "string" },
		{ name: "HourFin", type: "float" },
		{ name: "LaborDayFin", type: "float" },
		{ name: "SortOrder", type: "int" },
		{ name: "CreatedDate", type: "date" },
		{ name: "ModifiedDate", type: "date" },
		{ name: "IPAddress", type: "string" },
		{ name: "ModifiedBy", type: "string" },
		{ name: "CreatedBy", type: "string" },
        { name: "DayName", type: "string" },
        { name: "IsAdd", type: "boolean" },
        { name: "DayOff", type: "boolean" },
        { name: "LaborDayMade", type: "float" },
        { name: "DescriptionMade", type: "string" },
        
    ]
});

