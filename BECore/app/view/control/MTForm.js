/**
 * Custom MTForm
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.MTForm', {
    extend: 'Ext.form.Panel',
    xtype: 'MTForm',

    cls: 'cls-mtform-theme',
    appendCls: '',

    editMode: null,

    PKValue: null,

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
    },

    /*
    * Submit form với file đính kèm
    * Create by: dvthang:26.01.2018
    */
    submitWithFile: function (fnCallBack) {
        var me = this;
        var form = me.getForm();
        if (form.isValid()) {
            var uri = QLDT.utility.Utility.createUriAPI("Upload/Files"),
            token = QLDT.Config.getToken();

            var files = Ext.ComponentQuery.query('[xtype=MTFilefield]', me),
            formData = new FormData();
            var keyPairs = form.getValues();

            formData.append("EditMode", me.editMode);
            if (me.editMode == QLDT.common.Enumaration.Edit) {
                formData.append("PKValue", me.PKValue);
            }
            for (var field in keyPairs) {

                formData.append(field, keyPairs[field]);
            }
            var exists = false;
            Ext.each(files, function (file) {
                var f = file.fileInputEl.dom.files;
                if (f.length == 1) {
                    exists = true;
                    var uploadFile = f[0];
                    formData.append('file', uploadFile);
                }
            });
            if (exists) {
                $.ajax({
                    url: uri,
                    type: 'POST',
                    headers: {
                        Authorization: Ext.String.format("Bearer {0}", token)
                    },
                    data: formData,
                    processData: false,  // tell jQuery not to process the data
                    contentType: false,  // tell jQuery not to set contentType
                    success: function (data) {
                        if (typeof fnCallBack == 'function') {
                            fnCallBack(data);
                        }
                    }
                });
            } else {
                if (typeof fnCallBack == 'function') {
                    fnCallBack({ Success: true,Data:[] });
                }
            }
        }
    },


});
