

/*
 * This file launches the application by asking Ext JS to create
 * and launch() the Application class.
 */
Ext.application({
    extend: 'QLDT.Application',

    name: 'QLDT',

    requires: [
        // This will automatically load all classes in the QLDT namespace
        // so that application classes do not need to require each other.
        'QLDT.*'
    ],

    // The name of the initial view to create.
    //mainView: 'QLDT.view.main.Main'
});
