/**
 * Custom MTGrid
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.MTGrid', {
    extend: 'Ext.grid.Panel',
    xtype: 'MTGrid',

    requires: [
        'Ext.grid.Panel',
        'QLDT.view.control.column.*',
        'QLDT.view.control.MTPaging'
    ],
    cls: 'cls-mtgrid-theme',

    tdClsReadOnly: 'cell-editor-readonly',

    editGrid: false,

    /*Disabled sort trên grid*/
    sortable: false,

    columnStartEdit: 0,

    selModel: { selType: 'rowmodel', mode: 'MULTI' },
    editCell: false,

    filterable:false,

    columnLines: true,
    autoscroll: true,
    viewConfig: {
        emptyText: 'Không có bản ghi nào',
        stripeRows: true
    },

    /*Disabled sort trên grid*/
    sortable: false,
    appendCls: '',

    contextMenu: [],

    /*
    * Đánh dấu có hiển thị phân trang trên grid không
    * Create by: dvthang:07.01.2018
    */
    showPaging: false,

    style: 'border: solid #c1c1c1 1px',

    /*Vị trí focus hiện tại trên row*/
    curIndex:-1,

    /*
   * Khởi tạo các thành phần của form
   * Create by: dvthang:08.04.2017
   */
    initComponent: function () {
        var me = this;
        if (me.editCell) {
            Ext.apply(me, {
                selModel: { selType: 'cellmodel', mode: 'SIMPLE' },
            });
        }

        var columnMg = me.columns;
        Ext.each(columnMg, function (col) {
            Ext.apply(col, {
                filterable: me.filterable
            });
        });

        me.callParent(arguments);
        if (me.appendCls) {
            me.cls += " " + me.appendCls;
        }

        /*Sửa trên grid*/
        if (me.editGrid) {
            me.addPlugin(Ext.create('Ext.grid.plugin.CellEditing', {
                clicksToEdit: 2
            }));

            me.on('beforeedit', function (editor, e) {
                if (e.column.readOnly) {
                    return false;
                }
                e.IsCancel = false;
                me.fireEvent('beforeeditCell', me, editor, e);
                return !e.IsCancel;
            });
            Ext.each(columnMg, function (col) {
                if (col.readOnly) {
                    Ext.apply(col, {
                        tdCls: me.tdClsReadOnly                      
                    });
                }
            });
          
        }
        
        if (me.contextMenu && me.contextMenu.length > 0) {
            me.on("itemcontextmenu", function (grid, record, item, index, e, eOpts) {
                var menu_grid = new Ext.menu.Menu({
                    items: me.contextMenu, cls: 'context-menu-grid',
                    itemId: Ext.String.format(me.itemId + "_{0}", "ContextMenu"),
                    listeners: {
                        beforeshow: function (sender) {
                            me.fireEvent('beforeshowContextMenu', me, menu_grid, record);
                        }
                    }
                });
                var position = e.getXY();
                e.stopEvent();
                menu_grid.showAt(position);
            });

            me.on("containercontextmenu", function (grid, e) {
                var menu_grid = new Ext.menu.Menu({
                    items: me.contextMenu, cls: 'context-menu-grid',
                    itemId: Ext.String.format(me.itemId + "_{0}", "ContextMenu"),
                    listeners: {
                        beforeshow: function (sender) {
                            me.fireEvent('beforeshowContextMenu', me, menu_grid);
                        }
                    }
                });
                var position = e.getXY();
                e.stopEvent();
                menu_grid.showAt(position);
            });
        }
        if (me.showPaging) {
            var store = me.getStore(), pageSize = store.pageSize;
            var pagingBar = Ext.create('QLDT.view.control.MTPaging', {
                store: store, pageSize: pageSize,
                dock: 'bottom',
                displayInfo: true,
                displayMsg: 'Hiển thị từ {0} đến {1} của {2} bản ghi ',
                emptyMsg: "Không có bản ghi nào."
            });


            me.removeDocked(me.getDockedItems()[1]);
            me.addDocked(pagingBar);

        }

        me.curIndex = -1;
    },

    validate: function(){
        var me = this, view = me.getView(),isValid = true;
        var columnLength = me.columns.length;
        me.getStore().each(function(record,idx){
            for (var j = 0; j < columnLength; j++) {
                var cell = view.getCellByPosition({row: idx, column: j});
                cell.removeCls("x-form-invalid-field");
                cell.set({ 'data-errorqtip': '' });
            }
            var validationResult = record.validate();
            if(!validationResult.isValid()){
                isValid= false;
                for(var i =0;i < validationResult.items.length;i++){
                    for (var j = 0; j < columnLength; j++) {
                        var cell = view.getCellByPosition({ row: idx, column: j });
                        if(validationResult.items[i].field == me.columns[j].dataIndex){
                            //cell.addCls("x-form-invalid-field");
                            //cell.set({'data-errorqtip': validationResult.items[i].message});
                            me.startEditByPosition(idx, j);
                            return false;
                        }
                    }
                }
            }
        })
        return isValid;
    },

    /**
   * @private
   * Returns a map from column index to column's field name
   */
    getColumnIndexes: function () {
        var me, columnIndexes;

        me = this;
        columnIndexes = [];
        Ext.Array.each(me.columns, function (column) {
            if (Ext.isDefined(column.getEditor())) {
                columnIndexes.push(column.dataIndex);
            } else {
                columnIndexes.push(undefined);
            }
        });

        return columnIndexes;
    },

    /**
    * Validate a record row
    */
    validateRow: function (columnIndexes, record, y) {
        var me, view, errors;

        me = this;
        view = me.getView();

        errors = record.validate();
        if (errors.isValid()) {
            return true;
        }

        Ext.each(columnIndexes, function (columnIndex, x) {
            var cellErrors, cell, messages;

            cellErrors = errors.getByField(columnIndex);
            if (!Ext.isEmpty(cellErrors)) {
                cell = view.getCellByPosition({ row: y, column: x });
                messages = [];
                Ext.each(cellErrors, function (cellError) {
                    messages.push(cellError.message);
                });

                cell.addCls("x-form-invalid-field");
                cell.set({ 'data-errorqtip': Ext.String.format('<ul><li class="last">{0}</li></ul>', messages.join('<br/>')) });
            }
        });

        return false;
    },

    /*
   * Focus contror vào cell nhập liệu 
   * Create by: dvthang:3.3.2018
   */
    startEditByPosition: function (rowIndex, columnIndex) {
        var me = this,
        edit = me.editingPlugin;
        if (edit) {
            edit.startEditByPosition({
                row: rowIndex,
                column: columnIndex
            });
        }
    },


    /*
    * Focus contror vào cell nhập liệu 
    * Create by: dvthang:3.3.2018
    */
    startEditByColumnName: function (newIndex, columnName) {
        var me = this,
        edit = me.editingPlugin;
        if (edit) {
            edit.startEditByPosition({
                row: newIndex,
                column: me.getColumnIndex(me, columnName)
            });
        }
    },

    /*
    * Thiết lập readonly cho grid
    * Create by: dvthang:3.3.2018
    */
    setReadOnly: function (isReadOnly) {
        var me = this;
        Ext.each(me.columns, function (col) {
            if (!col.tdCls || col.tdCls.indexOf(me.tdClsReadOnly) == -1) {
                col.readOnly = isReadOnly;
            }
        });
    },

    /*
    * Bắt event phím trên edittor grid dùng để next dòng , next cell
    * Create by: dvthang:04.03.2018
    */
    specialkeyFn: function (sender, e) {
        var code = e.getCharCode();
        var rowSelected = me.view.getSelectionModel().getCurrentPosition().row;
        var colSelected = me.view.getSelectionModel().getCurrentPosition().column,
            maxColumns = 0, maxRows = 0;
        if (code == "37") {
            if (colSelected > 1)
                me.plugins[0].startEditByPosition({ row: rowSelected, column: colSelected - 1 });
        }
        else if (code == "39") {
            if (colSelected < (maxColumns - 1))
                me.plugins[0].startEditByPosition({ row: rowSelected, column: colSelected + 1 });
        }
        else if (code == "38") {
            if (rowSelected > 0)
                me.plugins[0].startEditByPosition({ row: rowSelected - 1, column: colSelected });
        }
        else if (code == "40") {
            if (rowSelected < (maxRows - 1))
                me.plugins[0].startEditByPosition({ row: rowSelected + 1, column: colSelected });
        }
    },

    /*
    * Thực hiện di chuyển row lên trên
    * Create by: dvthang:16.03.2018
    */
    upRow:function () {
        var index=this.getCurrentIndex();
        if (index==-1){
            var max_i=this.getMaxIndex();
            this.setCurrentIndex(max_i,true);
            return;
        }
        if (index==0){
            return;
        }
        this.swapRow(index,index-1,false);
        this.setCurrentIndex(index-1,true);
    },

    /*
    * Thực hiện di chuyển row xuống dưới
    * Create by: dvthang:16.03.2018
    */
    downRow:function () {
        var index=this.getCurrentIndex()
        if (index==-1){
            this.setCurrentIndex(0,true);
            return;
        }
        if (index==this.getMaxIndex()){
            return;
        }
        this.swapRow(index,index+1,true);
        this.setCurrentIndex(index+1,true);
    },

    /*
    * Lấy về dòng hiện tại của grid
    * Create by: dvthang:16.03.2018
    */
    getCurrentIndex: function () {
        var me = this,
        sm = me.getSelectionModel().getSelection();
        if (sm && sm.length > 0) {
            this.curIndex = me.getStore().indexOf(sm[0]);
        } else {
            this.curIndex = -1;
        }
        return this.curIndex;
    },

    /*
    * Thiết focus vào row hiện tại của grid
    * Create by: dvthang:16.03.2018
    */
    setCurrentIndex:function (index,visual) {
        if (visual){
            this.getSelectionModel().select(index);
        }
        this.curIndex = index;
    },

    /*
    * Lấy về số bản ghi lớn nhất của grid
    * Create by: dvthang:16.03.2018
    */
    getMaxIndex:function () {
        var store=this.getStore();
        return store.count()-1;
    },

    /*
    * Hoán đổi vị trí giữa 2 dòng
    * Create by: dvthang:16.03.2018
    */
    swapRow:function (cur_index,new_index,isDown){
        var store=this.getStore(),
         rec=store.getAt(cur_index).copy();

        store.removeAt(cur_index);

        store.insert(new_index, [rec]);

        this.fireEvent('afterWhenSwapRow', this, isDown, new_index, rec);

    }
});
