/// <summary>
/// Model EXTJS DaysLeft.
/// </summary>
Ext.define('QLDT.model.DaysLeft', {
    extend: 'Ext.data.Model',

    idProperty: 'EmployeeID',
    idType: 'Guid',
    fields: [
        { name: "EmployeeID", type: "string" },
		{ name: "FullName", type: "string" },
        { name: "Month_1", type: "string" },
		{ name: "DayTimeKeep_1", type: "string" },
        { name: "DayLeft_1", type: "string" },
        { name: "Month_2", type: "string" },
		{ name: "DayTimeKeep_2", type: "string" },
        { name: "DayLeft_2", type: "string" },
        { name: "Month_3", type: "string" },
		{ name: "DayTimeKeep_3", type: "string" },
        { name: "DayLeft_3", type: "string" },
        { name: "Month_4", type: "string" },
		{ name: "DayTimeKeep_4", type: "string" },
        { name: "DayLeft_4", type: "string" },
		{ name: "Month_5", type: "string" },
		{ name: "DayTimeKeep_5", type: "string" },
        { name: "DayLeft_5", type: "string" },
		{ name: "Month_6", type: "string" },
		{ name: "DayTimeKeep_6", type: "string" },
        { name: "DayLeft_6", type: "string" },
		{ name: "Month_7", type: "string" },
		{ name: "DayTimeKeep_7", type: "string" },
        { name: "DayLeft_7", type: "string" },
		{ name: "Month_8", type: "string" },
		{ name: "DayTimeKeep_8", type: "string" },
        { name: "DayLeft_8", type: "string" },
		{ name: "Month_9", type: "string" },
		{ name: "DayTimeKeep_9", type: "string" },
        { name: "DayLeft_9", type: "string" },
		{ name: "Month_10", type: "string" },
		{ name: "DayTimeKeep_10", type: "string" },
        { name: "DayLeft_10", type: "string" },
		{ name: "Month_11", type: "string" },
		{ name: "DayTimeKeep_11", type: "string" },
        { name: "DayLeft_11", type: "string" },
		{ name: "Month_12", type: "string" },
		{ name: "DayTimeKeep_12", type: "string" },
        { name: "DayLeft_12", type: "string" },
    ]
});
