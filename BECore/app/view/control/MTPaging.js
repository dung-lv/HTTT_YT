/**
 * Custom Pagging toolbar trên grid
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.MTPaging', {
    extend: 'Ext.toolbar.Paging',
    xtype: 'MTPaging',

    cls: 'cls-mtpaging-theme',

    appendCls: '',

    /**
     * @cfg {String} beforePageText
     * The text displayed before the input item.
     * @locale
     */
    beforePageText: 'Trang',
    /**
     * @cfg {String} afterPageText
     * Customizable piece of the default paging text. Note that this string is formatted using
     * {0} as a token that is replaced by the number of total pages. This token should be preserved when overriding this
     * string if showing the total page count is desired.
     * @locale
     */
    afterPageText: 'trên {0}',
    /**
     * @cfg {String} firstText
     * The quicktip text displayed for the first page button.
     * **Note**: quick tips must be initialized for the quicktip to show.
     * @locale
     */
    firstText: 'Trang đầu',
    /**
     * @cfg {String} prevText
     * The quicktip text displayed for the previous page button.
     * **Note**: quick tips must be initialized for the quicktip to show.
     * @locale
     */
    prevText: 'Trang trước',
    /**
     * @cfg {String} nextText
     * The quicktip text displayed for the next page button.
     * **Note**: quick tips must be initialized for the quicktip to show.
     * @locale
     */
    nextText: 'Trang tiếp',
    /**
     * @cfg {String} lastText
     * The quicktip text displayed for the last page button.
     * **Note**: quick tips must be initialized for the quicktip to show.
     * @locale
     */
    lastText: 'Trang cuối',
    /**
     * @cfg {String} refreshText
     * The quicktip text displayed for the Refresh button.
     * **Note**: quick tips must be initialized for the quicktip to show.
     * @locale
     */
    refreshText: 'Nạp',

    /*
   * Khởi tạo các thành phần của form
   * Create by: dvthang:08.04.2017
   */
    initComponent: function () {
        var me = this;
        me.callParent(arguments);
        if (me.appendCls) {
            me.cls += " " + me.appendCls;
        }
    }
});
