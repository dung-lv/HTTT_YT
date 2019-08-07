/**
 * Controller để xử lý router
 * Create by: dvthang:06.01.2018
 */
Ext.define('QLDT.controller.GlobalController', {
    extend: 'Ext.app.Controller',


    requires: [
        'QLDT.view.customer.Customer',
        'QLDT.view.rank.Rank',
        'QLDT.view.position.Position',//Create by: laipv:29.05.2018
        'QLDT.view.partyposition.PartyPosition',//Create by: laipv:29.05.2018
        'QLDT.view.academicrank.AcademicRank', //Create by: truongnm:13.01.2018
        'QLDT.view.level.Level', //Create by: laipv:13.01.2018
        'QLDT.view.company.Company', //Create by: truongnm:13.01.2018
        'QLDT.view.degree.Degree', //Create by: manh:13.01.2018
        'QLDT.view.employee.Employee', //Create by: manh:14.01.2018
        'QLDT.view.dayoff.DayOff', //Create by: truongnm:03.03.2018
        'QLDT.view.projectposition.ProjectPosition', //Create by: manh:14.01.2018
        'QLDT.view.project.ProjectList',
        'QLDT.view.project.ProjectAssistant',//Create by: laipv:26.02.2018
        'QLDT.view.laborday.Laborday',
        'QLDT.view.gantt.basic',
        'QLDT.view.gantt.Task',
        'QLDT.view.salary.Salary', //Create by: manh:26.05.2018
        'QLDT.view.wagecoefficient.WageCoefficient', //Create by: manh:26.05.2018
        'QLDT.view.contractedprofessional.ContractedProfessional', //Create by: manh:30.05.2018
        'QLDT.view.auditlaboday.Auditlaboday',
        'QLDT.view.daysleft.DaysLeft',
        
        'QLDT.view.nguoi_dung.nguoi_dung',
        'QLDT.view.ho_so_kham_benh.ho_so_kham_benh',
        'QLDT.view.ql_nguoi_dung.ql_nguoi_dung'
    ],

    /*
    * Danh sách tham chiếu đến view
    * Create by: dvthang:06.01.2018
    */
    refs: [
        {
            ref: 'viewql_nguoi_dung', xtype: 'app-ql_nguoi_dung', autoCreate: true
        },
        {
            ref: 'viewho_so_kham_benh', xtype: 'app-ho_so_kham_benh', autoCreate: true
        },
        {
            ref: 'viewnguoi_dung', xtype: 'app-nguoi_dung', autoCreate: true
        },
        {
            ref: 'viewCustomer', xtype: 'app-customer', autoCreate: true
        },
        {
            ref: 'viewRank', xtype: 'app-rank', autoCreate: true
        },
        //Create by: laipv:29.05.2018
        {
            ref: 'viewPosition', xtype: 'app-position', autoCreate: true
        },
        //Create by: cuonglp:29.05.2018
        {
            ref: 'viewPartyPosition', xtype: 'app-partyposition', autoCreate: true
        },
        //Create by: laipv:13.01.2018
        {
            ref: 'viewLevel', xtype: 'app-level', autoCreate: true
        },
        //Create by: truongnm:13.01.2018
        {
            ref: 'viewAcademicRank', xtype: 'app-academicrank', autoCreate: true
        },
        //Create by: truongnm:13.01.2018
        {
            ref: 'viewCompany', xtype: 'app-company', autoCreate: true

        },
        //Create by:manh:14.01.2018
        {
            ref: 'viewDegree', xtype: 'app-degree', autoCreate: true
        },
        //Create by: manh:14.01.2018
        {
            ref: 'viewEmployee', xtype: 'app-employee', autoCreate: true
        },
        //Create by: manh:14.01.2018
        {
            ref: 'viewProjectPosition', xtype: 'app-projectposition', autoCreate: true
        },
        {
            ref: 'viewProjectList', xtype: 'app-projectlist', autoCreate: true
        },
        {
            ref: 'viewProjectAssistant', xtype: 'app-projectassistant', autoCreate: true
        },
        //Create by: truongnm:03.03.2018
        {
            ref: 'viewDayOff', xtype: 'app-dayoff', autoCreate: true
        },
        {
            ref: 'viewLaborday', xtype: 'app-laborday', autoCreate: true
        },
        {
            ref: 'viewSalary', xtype: 'app-salary', autoCreate: true
        },
        {
            ref: 'viewGrantRatio', xtype: 'app-grantratio', autoCreate: true
        },
        {
            ref: 'viewWageCoefficient', xtype: 'app-wagecoefficient', autoCreate: true
        },
        {
            ref: 'viewContractedProfessional', xtype: 'app-contractedprofessional', autoCreate: true
        },
        {
            ref: 'viewBasic', xtype: 'basicgantt', autoCreate: true
        },
        {
            ref: 'viewGanttTask', xtype: 'gantt-task', autoCreate: true

        },
        {
            ref: 'viewAuditlaboday', xtype: 'app-auditlaboday', autoCreate: true

        },
        {
            ref: 'viewDaysLeft', xtype: 'app-daysleft', autoCreate: true

        },

    ],



    /*
    * Điều hướng đến trang của mình
    * Create by: dvthang:07.01.2018
    */
    routes: {
        'ql_nguoi_dung': {
            before: function (action) {
                var params = {
                    hash: 'ql_nguoi_dung'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'ql_nguoi_dung'
                }
                this.handleRequest(params);
            }
        },
        'ho_so_kham_benh': {
            before: function (action) {
                var params = {
                    hash: 'ho_so_kham_benh'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'ho_so_kham_benh'
                }
                this.handleRequest(params);
            }
        },
        'nguoi_dung': {
            before: function (action) {
                var params = {
                    hash: 'nguoi_dung'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'nguoi_dung'
                }
                this.handleRequest(params);
            }
        },
        'customer': {
            before: function (action) {
                var params = {
                    hash: 'customer'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'customer'
                }
                this.handleRequest(params);
            }
        },
        'rank': {
            before: function (action) {
                var params = {
                    hash: 'rank'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'rank'
                }
                this.handleRequest(params);
            }
        },
        //Create by: laipv:29.05.2018
        'position': {
            before: function (action) {
                var params = {
                    hash: 'position'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'position'
                }
                this.handleRequest(params);
            }
        },
        //Create by: cuonglp:29.05.2018
        'partyposition': {
            before: function (action) {
                var params = {
                    hash: 'partyposition'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'partyposition'
                }
                this.handleRequest(params);
            }
        },
        //Create by: laipv:13.01.2018
        'level': {
            before: function (action) {
                var params = {
                    hash: 'level'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'level'
                }
                this.handleRequest(params);
            }
        },
        //Create by: truongnm:13.01.2018
        'academicrank': {
            before: function (action) {
                var params = {
                    hash: 'academicrank'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'academicrank'
                }
                this.handleRequest(params);
            }
        },
        //Create by: truongnm:13.01.2018
        'company': {
            before: function (action) {
                var params = {
                    hash: 'company'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'company'
                }
                this.handleRequest(params);
            }
        },
        //Create by: truongnm:13.01.2018
        'dayoff': {
            before: function (action) {
                var params = {
                    hash: 'dayoff'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'dayoff'
                }
                this.handleRequest(params);
            }
        },
        //Create by: manh:13.01.2018
        'degree': {
            before: function (action) {
                var params = {
                    hash: 'degree'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'degree'
                }
                this.handleRequest(params);
            }
        },
        //Create by: laipv:13.01.2018
        'project': {
            before: function (action) {
                var params = {
                    hash: 'project'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'project'
                }
                this.handleRequest(params);
            }

        },
        'projectlist': {
            before: function (action) {
                var params = {
                    hash: 'projectlist'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'projectlist'
                }
                this.handleRequest(params);
            }

        }
        ,
        'projectassistant': {
            before: function (action) {
                var params = {
                    hash: 'projectassistant'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'projectassistant'
                }
                this.handleRequest(params);
            }

        },
        //Create by: manh:14.01.2018
        'employee': {
            before: function (action) {
                var params = {
                    hash: 'employee'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'employee'
                }
                this.handleRequest(params);
            }

        },
        //Create by: manh:14.01.2018
        'projectposition': {
            before: function (action) {
                var params = {
                    hash: 'projectposition'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'projectposition'
                }
                this.handleRequest(params);
            }

        },
        'laborday': {
            before: function (action) {
                var params = {
                    hash: 'laborday'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'laborday'
                }
                this.handleRequest(params);
            }

        },
        'salary': {
            before: function (action) {
                var params = {
                    hash: 'salary'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'salary'
                }
                this.handleRequest(params);
            }
        },
        'grantratio': {
            before: function (action) {
                var params = {
                    hash: 'grantratio'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'grantratio'
                }
                this.handleRequest(params);
            }
        },
        'wagecoefficient': {
            before: function (action) {
                var params = {
                    hash: 'wagecoefficient'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'wagecoefficient'
                }
                this.handleRequest(params);
            }
        },
        'contractedprofessional': {
            before: function (action) {
                var params = {
                    hash: 'contractedprofessional'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'contractedprofessional'
                }
                this.handleRequest(params);
            }
        },
        'gantt-basic': {
            before: function (action) {
                var params = {
                    hash: 'gantt-basic'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'gantt-basic'
                }
                this.handleRequest(params);
            }

        },
        'gantttask': {
            before: function (action) {
                var params = {
                    hash: 'gantttask'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'gantttask'
                }
                this.handleRequest(params);
            }
        },

        'auditlaboday': {
            before: function (action) {
                var params = {
                    hash: 'auditlaboday'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'auditlaboday'
                }
                this.handleRequest(params);
            }
        },
        'daysleft': {
            before: function (action) {
                var params = {
                    hash: 'daysleft'
                }
                this.beforeRequest(params, action);
            },
            action: function () {
                var params = {
                    hash: 'daysleft'
                }
                this.handleRequest(params);
            }
        }
    },

    /*
    * Router không phù hợp
    * Create by: dvthang:06.01.2018
    */
    onUnmatchedRoute: function (token) {

    },

    /*
    * Xử lý request trước khi làm gì tiếp
    * Create by: dvthang:06.01.2018
    */
    beforeRequest: function (params, action) {
        try {

            action.resume();
        } catch (e) {
            action.stop();
        }
    },

    /*
    * Xử lý request theo yêu cầu
    * Create by: dvthang:06.01.2018
    */
    handleRequest: function (params, action) {
        try {
            var me = this,
                view = null;
            switch (params.hash) {
                case 'ql_nguoi_dung':
                    view = me.getViewql_nguoi_dung();
                    break;
                case 'ho_so_kham_benh':
                    view = me.getViewho_so_kham_benh();
                    break;
                case 'nguoi_dung':
                    view = me.getViewnguoi_dung();
                    break;
                case 'customer':
                    view = me.getViewCustomer();
                    break;
                case 'rank':
                    view = me.getViewRank();
                    break;
                case 'partyposition': //Create by: cuonglp:29.05.2018
                    view = me.getViewPartyPosition();
                    break;
                case 'position': //Create by: laipv:29.05.2018
                    view = me.getViewPosition();
                    break;
                case 'level': //Create by: laipv:13.01.2018
                    view = me.getViewLevel();
                    break;
                case 'academicrank': //Create by: truongnm:13.01.2018
                    view = me.getViewAcademicRank();
                    break;
                case 'company': //Create by: truongnm:13.01.2018
                    view = me.getViewCompany();
                    break;

                case 'degree': //Create by: manh:14.01.2018
                    view = me.getViewDegree();
                    break;

                case 'project': //Create by: laipv:13.01.2018
                    view = me.getViewProject();
                    break;
                case 'projectlist': //Create by: laipv:13.01.2018
                    view = me.getViewProjectList();
                    break;
                case 'projectassistant': //Create by: laipv:26.02.2018
                    view = me.getViewProjectAssistant();
                    break;
                case 'employee': //Create by: manh:14.01.2018
                    view = me.getViewEmployee();
                    break;
                case 'projectposition': //Create by: manh:14.01.2018
                    view = me.getViewProjectPosition();
                    break;
                case 'dayoff': //Create by: truongnm:03.03.2018
                    view = me.getViewDayOff();
                    break;
                case 'laborday':
                    view = me.getViewLaborday();
                    break;
                case 'salary':
                    view = me.getViewSalary();
                    break;
                case 'grantratio':
                    view = me.getViewGrantRatio();
                    break;
                case 'wagecoefficient':
                    view = me.getViewWageCoefficient();
                    break;
                case 'contractedprofessional':
                    view = me.getViewContractedProfessional();
                    break;
                case 'gantt-basic':
                    view = me.getViewBasic();
                    break;
                case 'gantttask':
                    view = me.getViewGanttTask();
                    break;
                case 'auditlaboday':
                    view = me.getViewAuditlaboday();
                    break;
                case 'daysleft':
                    view = me.getViewDaysLeft();
                    break;

            }
            if (view) {
                var contentBody = Ext.ComponentQuery.query("[itemId=contentMainBody]")[0];
                if (contentBody) {
                    var lblForm = Ext.ComponentQuery.query("#lblForm")[0];
                    if (lblForm) {
                        var title = me.getTitleForm(params.hash);
                        lblForm.setHtml(title);
                    }

                    contentBody.removeAll(true);
                    contentBody.add(view);
                }
            }
        } catch (e) {
            console.log(e);
        }
    },

    /*
    * Lấy title hiển thị trên form
    * Create by: dvthang:13.01.2018
    */
    getTitleForm: function (hash) {
        var me = this, titleName = '', titleMenus = titleMenus;
        if (QLDT.common.Session.menusVertical !== null && QLDT.common.Session.menusVertical.length > 0) {
            var items = QLDT.common.Session.menusVertical.filter(function (menu) {
                return menu.hash === hash;
            });
            if (items.length > 0) {
                titleName = items[0].title;
            }
        }
        return titleName;
    },

});
