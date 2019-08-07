/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.changepassword.ChangePasswordModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.changepassword',

    data: {
        OldPassword: '',
        NewPassword: '',
        ConfirmPassword:''
    }
});
