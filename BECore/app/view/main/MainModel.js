/**
 * This class is the view model for the Main view of the application.
 */
Ext.define('QLDT.view.main.MainModel', {
    extend: 'Ext.app.ViewModel',

    alias: 'viewmodel.main',

    /*
    * Hiển thị title của menu
    */
    titleMenus: [
        { hash: 'nguoi_dung', title: 'Danh sách quân hàm' },
        { hash: 'nhom_nguoi_dung', title: 'Danh sách quân hàm' },
        { hash: 'ql_nguoi_dung', title: 'Danh sách quân hàm' },
        { hash: 'phong_benh', title: 'Phòng bệnh' },
        { hash: 'tham_so', title: 'Danh sách quân hàm' },
        { hash: 'hinh_thuc_kham', title: 'Danh sách quân hàm' },
        { hash: 'chi_tiet_hinh_thuc_kham', title: 'Danh sách quân hàm' },
        { hash: 'bac_si', title: 'Danh sách quân hàm' },
        { hash: 'dat_lich', title: 'Danh sách quân hàm' },
        { hash: 'ho_so_kham_benh', title: 'Danh sách quân hàm' },
        { hash: 'ket_xuat_ho_so', title: 'Danh sách quân hàm' }
    ],


    menus: [
        {
            name: 'Tài khoản', text: 'Tài khoản', iconCls: 'fa fa-cog', cls: 'menu-item-custom', hash: 'ql_nguoi_dung', show: true, children: [

            ]
        },
         {
             name: 'hospital', text: 'D.mục bệnh viện...', group: 'menu-item', cls: 'menu-item-custom', iconCls: 'fa fa-university', show: true, children: [
                { name: 'Bác sĩ', text: 'Bác sĩ', cls: 'sub-menu-item-child', hash: 'bac_si', show: true },
                { name: 'Đặt lịch', text: 'Đặt lịch', cls: 'sub-menu-item-child', hash: 'dat_lich', show: true }
            ]
        },
         {
            name: 'Bệnh nhân', text: 'Bệnh nhân', cls: 'menu-item-custom', iconCls: 'fa fa-users', hash: 'nguoi_dung', show: true, children: [

            ]
        },
          {
             name: 'Hồ sơ khám bệnh', text: 'Hồ sơ khám bệnh', cls: 'menu-item-custom', iconCls: 'fa fa-calculator', hash: 'ho_so_kham_benh', show: true, children: [

             ]
        },
           {
            name: 'Kết xuất hồ sơ', text: 'Kết xuất hồ sơ',  cls: 'menu-item-custom ', iconCls: "fa fa-pie-chart", hash: 'ket_xuat_ho_so', show: true, children: [
                
            ]
        }
    ],
    menusNotBTC: [
        {
            name: 'hospital', text: 'D.mục bệnh viện', group: 'menu-item', cls: 'menu-item-custom', iconCls: 'fa fa-university', show: true, children: [
                { name: 'Bác sĩ', text: 'Bác sĩ', cls: 'sub-menu-item-child', hash: 'bac_si', show: true },
                { name: 'Đặt lịch', text: 'Đặt lịch', cls: 'sub-menu-item-child', hash: 'dat_lich', show: true }
            ]
        },
        {
            name: 'Bệnh nhân', text: 'Bệnh nhân', cls: 'menu-item-custom', iconCls: 'fa fa-users', hash: 'nguoi_dung', show: true, children: [

            ]
        },
        {
            name: 'Hồ sơ khám bệnh', text: 'Hồ sơ khám bệnh', cls: 'menu-item-custom', iconCls: 'fa fa-calculator', hash: 'ho_so_kham_benh', show: true, children: [

            ]
        },
        {
            name: 'Kết xuất hồ sơ', text: 'Kết xuất hồ sơ', cls: 'menu-item-custom ', iconCls: "fa fa-pie-chart", hash: 'ket_xuat_ho_so', show: true, children: [

            ]
        }
    ]

});
