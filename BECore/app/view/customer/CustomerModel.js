/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.customer.CustomerModel', {
    extend: 'Ext.app.ViewModel',
    alias: 'viewmodel.customer',

    stores: {
        master: {
            fields: ['name', 'email', 'phone'],
            data: [
                { name: 'Đỗ Văn Thắng', email: 'thangdo@gmail.com', phone: '0989485929' },
                { name: 'Nguyễn Thị Hồng', email: 'hongnguyen@gmail.com', phone: '01649595949' }
            ]
        }
    }
});
