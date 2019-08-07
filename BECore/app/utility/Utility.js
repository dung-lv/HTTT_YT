Ext.define('QLDT.utility.Utility', {
    singleton: true,


    /*
    * Hàm thực hiện bắt lỗi
    * Create by: dvthang:08.01.2018
    */
    handleException: function (e) {
        console.log(e.message);
    },

    /*
    * Tạo đường dẫn trỏ lên API
    * Create by: dvthang:08.01.2018
    */
    createUriAPI: function (uri) {
        if (!Ext.String.startsWith(uri, "/")) {
            uri = "/" + uri;
        }
        uri = Ext.String.format("{0}{1}", QLDT.Config.apiBE, uri);
        return uri;
    },

    /*
    * Add header vào request
    * Create by: dvthang:10.01.2018
    */
    getHeaders: function () {
        var me = this;
        var token = QLDT.Config.getToken();
        return {
            Authorization: Ext.String.format("Bearer {0}", token),
            "Content-Type": "application/json; charset=utf-8",
            "CompanyID": QLDT.Config.getUserID(),
            //"PositionID": QLDT.Config.getPositionID(),
            //"EmployeeID": QLDT.Config.getEmployeeID()
        };
    },

    /*
    * Hiển thị warning cảnh báo người dùng
    * Create by: dvthang:08.01.2018
    */
    showWarning: function (msg, config, fn) {
        var icon = Ext.Msg.WARNING;

        Ext.MessageBox.show({
            title: QLDT.common.Constant.Product,
            msg: msg,
            buttons: Ext.MessageBox.OK,
            animateTarget: Ext.getBody(),
            scope: this,
            fn: fn,
            icon: icon,
            //maskClickAction: this.getMaskClickAction()
        });
    },

    /*
    * Hiển thị cảnh báo lỗi PM cho người dùng
    * Create by: dvthang:08.01.2018
    */
    showError: function (msg, config, fn) {
        var icon = Ext.MessageBox[QLDT.common.Enumaration.IconDialog.Error];

        Ext.MessageBox.show({
            title: QLDT.common.Constant.Product,
            msg: msg,
            buttons: Ext.MessageBox.OK,
            animateTarget: Ext.getBody(),
            scope: this,
            fn: fn,
            icon: icon,
        });
    },

    /*
    * Hiển thị thêm thông tin cho người dùng
    * Create by: dvthang:08.01.2018
    */
    showInfo: function (msg, config, fn) {
        var icon = Ext.Msg.INFO;

        Ext.MessageBox.show({
            title: QLDT.common.Constant.Product,
            msg: msg,
            buttons: Ext.MessageBox.OK,
            animateTarget: Ext.getBody(),
            scope: this,
            fn: fn,
            icon: icon,
        });
    },

    /*
    * Hiển thị thêm thông tin cho người dùng
    * Create by: dvthang:08.01.2018
    */
    showQuestion: function (msg, config, fn) {
        var icon = Ext.Msg.QUESTION;

        Ext.MessageBox.show({
            title: QLDT.common.Constant.Product,
            msg: msg,
            buttons: Ext.MessageBox.OK,
            animateTarget: Ext.getBody(),
            scope: this,
            fn: fn,
            icon: icon,
        });
    },

    /*
    * Hiển thị cảnh báo hỏi người dùng muốn làm gì đó
    * Create by: dvthang:08.01.2018
    */
    showConfirm: function (msg, config, fn) {
        Ext.MessageBox.confirm(QLDT.common.Constant.Product, msg, fn, Ext.getBody());
    },

    /*
    * Hiển thị toast
    * Create by: dvthang:29.1.2018
    */
    showToastSaveSuccess: function (target) {
        Ext.toast({
            html: QLDT.GlobalResource.SaveSuccess,
            closable: false,
            align: 't',
            cls: 'toast-custom',
            style: {
                border: '1px solid #00577b',
                background: '#00577b',
                color: 'white'
            },
            centered: true,
            animateTarget: target,
            timeout: 2000,
            width: 160
        });
    },

    /*
    * Hiển thị Yes/No/Cancel
    */
    showDataNoSave: function (btn, msg, config, fn) {
        Ext.MessageBox.show({
            title: QLDT.GlobalResource.QuestionBeforeClose,
            msg: msg,
            buttons: Ext.MessageBox.YESNOCANCEL,
            scope: this,
            fn: fn,
            animateTarget: btn,
            icon: Ext.MessageBox.QUESTION,
        });
    },

    /*
    * Load danh sách store
    * Create by: dvthang:21.01.2018
    */
    loadStores: function (stores, fnParam, fnLoadFinish) {
        var me = this;
        if (stores && stores.length > 0) {
            var count = stores.length, countStoreLoad = 0;
            for (var i = 0; i < count; i++) {
                var store = stores[i];
                if (store) {
                    if (typeof fnParam == 'function') {
                        fnParam(store)
                    }
                    store.load({
                        callback: function (records, operation, success) {
                            countStoreLoad++;
                            if (countStoreLoad == count) {
                                if (typeof fnLoadFinish == 'function') {
                                    fnLoadFinish();
                                }
                            }
                        }
                    });
                }
            }
        } else {
            if (typeof fnLoadFinish == 'function') {
                fnLoadFinish();
            }
        }
    },

    /*
    * Thực hiện dowload file 
    * Create by: dvthang:27.01.2018
    */
    downloadFile: function (data, filename) {
        var me = this,
            uri = QLDT.utility.Utility.createUriAPI('/Download?TokenID={0}&ID={1}&FT={2}&IsTemp={3}');

        uri = Ext.String.format(uri, QLDT.Config.getTokenID(),
           data.ID, data.FT, data.IsTemp);
        var element = document.createElement('a');
        element.setAttribute('href', uri);
        element.setAttribute('target', "_blank");

        element.style.display = 'none';
        document.body.appendChild(element);
        element.click();
        document.body.removeChild(element);
    },

    /*
    * Thực hiện Export Excell
    * Create by: dvthang:10.03.2018
    */
    exportExcel: function (data) {
        var me = this,
          uri = QLDT.utility.Utility.createUriAPI('/ExportExcel');
        if (data) {
            data.TokenID = QLDT.Config.getTokenID();
        }
        uri = QLDT.utility.Utility.createUriAPI(Ext.String.format('/ExportExcel?data={0}', JSON.stringify(data)));
        var element = document.createElement('a');
        element.setAttribute('href', uri);
        element.setAttribute('target', "_blank");

        element.style.display = 'none';
        document.body.appendChild(element);
        element.click();
        document.body.removeChild(element);
    },


    /*
    * Lấy danh sách giá trị guid
    * Create by: dvthang:30.01.2018
    */
    getGuids: function (number) {
        var me = this, uri = QLDT.utility.Utility.createUriAPI('/Common/Guids?number=' + number);
        return new Ext.Promise(function (resolve, reject) {
            QLDT.utility.MTAjax.httpGet(uri, {}, {}, function (res) {
                resolve(res);
            }, function (error) {
                reject(error);
            });
        });
    },

    /*
    * Create edittor column khi sửa grid
    * Create by: dvthang:3.3.2018
    */
    createEditorColumn: function (column) {
        var me = this;
        switch (column.xtype) {
            case 'MTColumn':
                if (!column.readOnly) {
                    Ext.apply(column, {
                        editor: {
                            xtype: 'MTTextField',
                            maxLength: column.maxLength,
                            minLength: column.minLength,
                            allowBlank: column.allowBlank
                        }
                    });
                }
                break;
            case 'MTColumnCombo':
                if (!column.readOnly) {
                    Ext.apply(column, {
                        editor: {
                            completeOnEnter: false,
                            field: {
                                xtype: 'MTComboBox',
                                editable: column.editable,
                                store: column.store,
                                headers: column.headers,
                                displayFields: column.displayFields,
                                valueField: column.valueField,
                                displayField: column.displayField,
                                typeAhead: true,
                                triggerAction: 'all',
                                allowBlank: column.allowBlank
                            }
                        }
                    });
                }
                break;
            case 'MTColumnDateField':
                if (!column.readOnly) {
                    Ext.apply(column, {
                        editor: {
                            xtype: 'MTDateField',
                            allowBlank: column.allowBlank
                        }
                    });
                }
                break;
            case 'MTColumnTime':
                if (!column.readOnly) {
                    Ext.apply(column, {
                        editor: {
                            xtype: 'MTTime',
                            allowBlank: column.allowBlank
                        }
                    });
                }
                break;
            case 'MTColumnNumberField':
                if (!column.readOnly) {
                    var field = { xtype: 'MTNumberField' };
                    if (column.hasOwnProperty("allowBlank")) {
                        field.allowBlank = column.allowBlank;
                    }
                    if (column.hasOwnProperty("decimalPrecision")) {
                        field.decimalPrecision = column.decimalPrecision;
                    }

                    if (column.hasOwnProperty("allowDecimals")) {
                        field.allowDecimals = column.allowDecimals;
                    }
                    if (column.hasOwnProperty("minValue")) {
                        field.minValue = column.minValue;
                    }

                    if (column.hasOwnProperty("maxValue")) {
                        field.maxValue = column.maxValue;
                    }
                    Ext.apply(column, {
                        editor: field
                    });
                }
                break;
            case 'MTColumnCheckBox':
                if (!column.readOnly) {
                    Ext.apply(column, {
                        editor: {
                            xtype: 'MTCheckbox'
                        }
                    });
                }
                break;
            case 'MTColumnBoolean':
                break;

        }
    },

    /*
    * Add filter row vào column grid
    * Create by: dvthang:22.03.2018
    */
    createFilterRow: function (column) {
        var me = this, xtype, checkItems = [], textDefault = '';
        switch (column.xtype) {
            case 'MTColumnDateField':
                xtype = 'MTDateField';
                textDefault = "<=";
                checkItems = [{ text: '= Bằng', cls: 'menu-filter-row', value: "=", operator: QLDT.common.Enumaration.FilterOperations.Equals },
                    { text: '< Nhỏ lơn', cls: 'menu-filter-row', value: "<", operator: QLDT.common.Enumaration.FilterOperations.LessThan },
                    { text: '<= Nhỏ hơn hoặc bằng', cls: 'menu-filter-row', value: "<=", operator: QLDT.common.Enumaration.FilterOperations.LessThanOrEquals },
                    { text: '> Lớn hơn', cls: 'menu-filter-row', value: ">", operator: QLDT.common.Enumaration.FilterOperations.Greater },
                    { text: '>= Lớn hơn hoặc bằng', cls: 'menu-filter-row', value: ">=", operator: QLDT.common.Enumaration.FilterOperations.GreaterOrEquals }];
                break;
            case 'MTColumnTime':
                xtype = 'MTTime';
                textDefault = "<=";
                checkItems = [{ text: '= Bằng', cls: 'menu-filter-row', value: "=", operator: QLDT.common.Enumaration.FilterOperations.Equals },
                    { text: '< Nhỏ lơn', cls: 'menu-filter-row', value: "<", operator: QLDT.common.Enumaration.FilterOperations.LessThan },
                    { text: '<= Nhỏ hơn hoặc bằng', cls: 'menu-filter-row', value: "<=", operator: QLDT.common.Enumaration.FilterOperations.LessThanOrEquals },
                    { text: '> Lớn hơn', cls: 'menu-filter-row', value: ">", operator: QLDT.common.Enumaration.FilterOperations.Greater },
                    { text: '>= Lớn hơn hoặc bằng', cls: 'menu-filter-row', value: ">=", operator: QLDT.common.Enumaration.FilterOperations.GreaterOrEquals }];
                break;
            case 'MTColumnNumberField':
                xtype = 'MTNumberField';
                textDefault = "<=";
                checkItems = [{ text: '= Bằng', cls: 'menu-filter-row', value: "=", operator: QLDT.common.Enumaration.FilterOperations.Equals },
                   { text: '< Nhỏ lơn', cls: 'menu-filter-row', value: "<", operator: QLDT.common.Enumaration.FilterOperations.LessThan },
                   { text: '<= Nhỏ hơn hoặc bằng', cls: 'menu-filter-row', value: "<=", operator: QLDT.common.Enumaration.FilterOperations.LessThanOrEquals },
                   { text: '> Lớn hơn', cls: 'menu-filter-row', value: ">", operator: QLDT.common.Enumaration.FilterOperations.Greater },
                   { text: '>= Lớn hơn hoặc bằng', cls: 'menu-filter-row', value: ">=", operator: QLDT.common.Enumaration.FilterOperations.GreaterOrEquals }];
                break;
            default:
                xtype = 'MTTextField';
                textDefault = "*";
                checkItems = [{ text: '* Chứa', value: "*", cls: 'menu-filter-row', operator: QLDT.common.Enumaration.FilterOperations.Contains },
                    { text: '= Bằng', value: "=", cls: 'menu-filter-row', operator: QLDT.common.Enumaration.FilterOperations.Equals },
                    { text: '+ Bắt đầu bằng', value: "+", cls: 'menu-filter-row', operator: QLDT.common.Enumaration.FilterOperations.StartsWith },
                    { text: '- Kết thúc bằng', cls: 'menu-filter-row', value: "-", operator: QLDT.common.Enumaration.FilterOperations.EndsWith },
                    { text: '! Không chứa', cls: 'menu-filter-row', value: "!", operator: QLDT.common.Enumaration.FilterOperations.NotContains }]
        }
        if (xtype === 'MTTextField' && !column.isFilterCombo) {
            Ext.apply(column, {
                items: [
                        {
                            xtype: 'container',
                            flex: 1,
                           // height: 30,
                            cls: 'filter-row-grid',
                            layout: { type: 'hbox', align: 'stretch' },
                            items: [
                                {
                                    xtype: 'button',
                                    width: 30,
                                    border: '1 1 0 0',
                                    text: textDefault,
                                    menu: {
                                        items: checkItems
                                    },
                                    listeners: {
                                        afterrender: function (sender, eOpts) {
                                            var menu = sender.getMenu();
                                            Ext.each(menu.items.items, function (it) {
                                                it.on("click", function (menuItem) {
                                                    column.operator = menuItem.operator;
                                                    sender.setText(menuItem.value);

                                                    column.filter(column.dataIndex,
                                                     column.inputValue, true);
                                                });
                                            });
                                        }
                                    }
                                },
                                 {
                                     xtype: xtype,
                                     flex: 1,
                                     inputWrapCls: '',
                                     triggerWrapCls: '',
                                     enableKeyEvents: true,
                                     listeners: {
                                         specialkey: function (sender, e, eOpts) {
                                             column.inputValue = sender.getValue();
                                             if (e.getKey() == e.ENTER) {
                                                 column.filter(column.dataIndex,
                                                     sender.getValue());
                                             }
                                         }
                                     }
                                 }
                            ]
                        },
                ]
            });
        } else if (xtype === 'MTTextField' && column.isFilterCombo) {
            //Filter dạng combo
            Ext.apply(column, {
                operator: QLDT.common.Enumaration.FilterOperations.Equals,                
                items: [
                        {
                            xtype: 'container',
                            flex: 1,
                            height: 30,
                            cls: 'filter-row-grid',
                            layout: { type: 'hbox', align: 'stretch' },
                            items: [
                                {
                                    xtype: 'MTComboBox',
                                    flex: 1,
                                    inputWrapCls: '',
                                    store: column.headerFilter.store,
                                    displayField: column.headerFilter.displayField,
                                    valueField: column.headerFilter.valueField,
                                    editable: column.headerFilter.editable,
                                    forceSelection: column.headerFilter.forceSelection,
                                    selectOnFocus: column.headerFilter.selectOnFocus,
                                    value: column.headerFilter.value,
                                    listeners: {
                                        change: function (sender, newValue, oldValue, eOpts) {
                                            if (newValue !== oldValue) {
                                                var filterValue = '';
                                                if (newValue > -1) {
                                                    filterValue = newValue;
                                                }
                                                column.filter(column.dataIndex,
                                                   filterValue);
                                            }
                                        }
                                    }
                                }
                            ]
                        }
                ]
            });
        } else if (xtype === 'MTDateField' || xtype === 'MTTime') {
            Ext.apply(column, {
                items: [
                        {
                            xtype: 'container',
                            flex: 1,
                            // height: 30,
                            cls: 'filter-row-grid',
                            layout: { type: 'hbox', align: 'stretch' },
                            items: [
                                {
                                    xtype: 'button',
                                    width: 30,
                                    border: '1 1 0 0',
                                    text: textDefault,
                                    menu: {
                                        items: checkItems
                                    },
                                    listeners: {
                                        afterrender: function (sender, eOpts) {
                                            var menu = sender.getMenu();
                                            Ext.each(menu.items.items, function (it) {
                                                it.on("click", function (menuItem) {
                                                    column.operator = menuItem.operator;
                                                    sender.setText(menuItem.value);

                                                    column.filter(column.dataIndex,
                                                     column.inputValue, true);
                                                });
                                            });
                                        }
                                    }
                                },
                                 {
                                     xtype: xtype,
                                     flex: 1,
                                     enableKeyEvents: true,
                                     listeners: {
                                         specialkey: function (sender, e, eOpts) {
                                             column.inputValue = sender.getValue();
                                             if (e.getKey() == e.ENTER) {
                                                 column.filter(column.dataIndex,
                                                     sender.getValue());
                                             }
                                         }
                                     }
                                 }
                            ]
                        },
                ]
            });
        }
    }
});