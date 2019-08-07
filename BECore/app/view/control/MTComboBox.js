/**
 * Custom MTComboBox
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.MTComboBox', {
    extend: 'Ext.form.field.ComboBox',
    xtype: 'MTComboBox',

    cls: 'cls-mtcombofield-theme',
    blankText: QLDT.ControlResource.BlankText,
    appendCls: '',

    /*Chặn load dữ liệu khi nhấn vào trigger icon*/
    disableTrigger: true,

    selectOnFocus: true,

    queryMode: 'local',

    forceSelection: true,

    isComboTree:false,

    /*
   * Khởi tạo các thành phần của form
   * Create by: dvthang:08.04.2017
   */
    initComponent: function () {
        var me = this;      

        if (me.isComboTree) {
            Ext.apply(me,{
                tpl:Ext.create('Ext.XTemplate',
                  '<tpl for=".">',
                   Ext.String.format('<div class="x-boundlist-item">{[this.getValue(values.Grade,values.{0})]}</div>', me.displayField),
                  '</tpl>',
                   {
                       getValue: function (grade, text) {
                           var space = "";
                           if (grade > 0) {
                               for (var i = 1; i < grade; i++) {
                                   space += "&nbsp;&nbsp;";
                               }
                           }
                           return space+text;
                       }
                   }
                ),
                displayTpl: Ext.create('Ext.XTemplate',
                  '<tpl for=".">',
                    Ext.String.format('{{0}}', me.displayField),
                  '</tpl>'
                )
            });
        }

        me.callParent(arguments);
        
        if (me.appendCls) {
            me.cls += " " + me.appendCls;
        }
    }
});
