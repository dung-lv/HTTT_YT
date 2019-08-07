/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.dayoff.DayOffModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.DayOff',

    requires: [
        'QLDT.model.DayOff',
        'QLDT.view.control.MTStore'
    ],
    stores: {
        masterStore: {
            type:'mtstore',
            model: 'QLDT.model.DayOff',
            proxy: {
                type: 'mtproxy',
                isRemovePaging: false,
                actionMethods:{
                    read:'GET'
                },
                api:{
                    read: QLDT.utility.Utility.createUriAPI('/DayOffs')
                },
                reader: { type: 'json' }
            }
        }
    }
});
