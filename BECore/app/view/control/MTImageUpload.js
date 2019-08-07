/**
 * Custom MTImageUpload - upload ảnh
 * Create by: dvthang:17.01.2018
 */
Ext.define('QLDT.view.control.MTImageUpload', {
    extend: 'Ext.form.FieldContainer',
    xtype: 'MTImageUpload',
    alias: 'widget.mtimageupload',
    requires: ['Ext.form.FieldContainer'],

    cls: 'cls-mtimageupload-theme',
    appendCls: '',

    FileResourceID: null,

    owner: null,

    isTemp:false,

    /**
     * @cfg {Sting} title of the fieldset which includes this field
     */

    title: QLDT.GlobalResource.ChooseAnImage,

    layout: 'fit',

    /**
     * @cfg {String} text of the button, which is one of the ways to choose image
     */
    buttonText: QLDT.GlobalResource.ChooseImage,

    /**
     * @cfg {String} name of the params which contained the image. This is will be used to process the image in the server side
     */
    name: 'image',

    /**
     * @cfg {String} src of preview image
     */
    previewImageSrc: null,

    /**
     * @cfg {Boolean} width of image
     */
    imageWidth: 100,

    /**
     * @cfg {Boolean} height of image
     */
    imageHeight: 100,

    /**
     * text to be displayed in the drag area
     */
    dragAreaText: "",//QLDT.ControlResource.DropImageHere,

    allowBlank: true,

    initComponent: function () {
        var me = this;

        var upLoadButton = {
            xtype: 'fileuploadfield',
            inputId: 'fileuploadfield_' + me.id,
            layout: me.layout,
            allowBlank: me.allowBlank,
            buttonText: me.buttonText,
            buttonOnly: true,
            listeners: {
                change: function (input, value, opts) {
                    var canvas = Ext.ComponentQuery.query('image[canvas="' + input.inputId + '"]')[0],
                        file = input.getEl().down('input[type=file]').dom.files[0];
                    me.attachImage(file, canvas);
                }
            }
        };

        var previewImage = {
            xtype: 'image',
            frame: true,
            canvas: upLoadButton.inputId,
            width: me.imageWidth,
            height: me.imageHeight,
            animate: 2000,
            hidden: false, // initially hidden
            scope: this
        };

        me.dropTargetId = 'droptaget-' + (me.itemId || Math.random().toString());

        var dropTarget = {
            xtype: 'label',
            html: '<div class="drop-target"' + 'id=' + '\'' + me.dropTargetId + '\'' + '>' + me.dragAreaText + '</div>'
        };
        me.on('afterrender', function (e) {
            var previewImage = me.down('image');
            if (!me.FileResourceID) {
                previewImage.setSrc('');
            }
            me.owner = previewImage;
            var dropWindow = document.getElementById(me.dropTargetId),
                form = me.up('form');
            dropWindow.addEventListener('dragenter', function (e) {
                e.preventDefault();
                e.dataTransfer.dropEffect = 'none';
            }, false);

            dropWindow.addEventListener('dragover', function (e) {
                e.preventDefault();
                dropWindow.classList.add('drop-target-hover');
            });

            dropWindow.addEventListener('drop', function (e) {
                e.preventDefault();
                dropWindow.classList.remove('drop-target-hover');
                var file = e.dataTransfer.files[0],
                    canvas = Ext.ComponentQuery.query('image[canvas="' + previewImage.canvas + '"]')[0];
                me.attachImage(file, canvas);
            }, false);


            dropWindow.addEventListener('dragleave', function (e) {
                dropWindow.classList.remove('drop-target-hover');
            }, false);

        });


        var fileUploadFieldSet = {
            xtype: 'fieldset',
            layout: { type: 'vbox', align: 'center' },
            margin: '4 0 0 0',
            padding: '0 0 0 0',
            items: [
                    {
                        items: [previewImage],
                        margin: '8 0 0 0'
                    },
                    {
                        items: [dropTarget, upLoadButton]
                    }
            ]
        };

        Ext.apply(me, {
            items: [fileUploadFieldSet]
        });
        me.callParent(arguments);
    },

    /*
    * Hiển thị ảnh
    * Create by: dvthang:20.02.2018
    */
    attachImage: function (file, canvas) {

        var me = this,
            form = me.up('form');
        if (file.type == "image/jpeg" ||
            file.type == "image/jpg" ||
            file.type == "image/png" ||
            file.type == "image/gif" ||
            file.type == "image/ico"
            ) {

            if (!form.uploadableImages) {
                form.uploadableImages = [];
            }
            form.uploadableImages.push({ imageKey: me.name, imageFile: file });

            me.uploadImageToServer(file, function (res) {
                if (res.Success && Ext.isArray(res.Data) && res.Data.length>0) {
                    var uri = QLDT.utility.Utility.createUriAPI("Images"),
               token = QLDT.Config.getToken(), data = res.Data[0];
                    me.FileResourceID = data.FileResourceID;
                    me.isTemp = true;
                    canvas.setSrc(Ext.String.format(uri + "?id={0}&width={1}&height={2}&isTemp={3}",
                        me.FileResourceID, me.imageWidth, me.imageHeight, me.isTemp));
                    canvas.show();
                }
            });
        } else {
            Ext.Msg.alert('Lỗi', 'Vui lòng chọn tệp ảnh có định dạng jpeg, jpg, png, gif, ico.');
        }
    },

    /*
    * Thực hiện upload ảnh lên server
    * Create by: dvthang:20.02.2018
    */
    uploadImageToServer: function (file, fnCallBack) {
        var uri = QLDT.utility.Utility.createUriAPI("Images/UploadImg"),
            token = QLDT.Config.getToken();
        formData = new FormData();
        formData.append('file', file);
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
    },

    /*
    * Lấy ID của ảnh được upload
    * Create by: dvthang:20.02.2018
    */
    getValue: function () {
        var me = this;
        return me.FileResourceID;
    },

    /*
    * Binding giá trị cho thuộc tính FileResourceID
    * Create by: dvthang:20.2.2018
    */
    setFileResourceID: function (id) {
        var me = this;
        me.FileResourceID = id;
        if (me.owner && !me.isTemp) {
            var canvas = Ext.ComponentQuery.query('image[canvas="' + me.owner.canvas + '"]')[0];
            if (canvas) {
                if (me.FileResourceID) {
                    var uri = QLDT.utility.Utility.createUriAPI("Images"),
                    src = Ext.String.format(uri + "?id={0}&width={1}&height={2}&isTemp={3}",
                    me.FileResourceID, me.imageWidth, me.imageHeight, false);
                    canvas.setSrc(src);
                    canvas.show();
                } else {
                    canvas.setSrc("");
                }
            }
        }
    }
});
