/**
 * include a method submitWithImage for form. This method should be used when a form as xtype: 'imageuploadfield'.
 * it accepts params in the same as submit method, form.submitWithImage({
                                                                          url: 'some url',
                                                                          method: 'POST',
                                                                          params: {
                                                                            param_1: 'some value',
                                                                            param_2: 'some value'
                                                                            },
                                                                            success: onSuccess
                                                                            failure: onFailure
                                                                       });
 */

Ext.define('Ext.overrides.FormPanel', {
    override: 'Ext.FormPanel',
    submitWithImage: function (options) {
        var url = options.url,
            success = options.success,
            failure = options.failure,
            params = Ext.merge(this.getValues(), options.params),
            waitMsg = options.waitMsg,
            formData = new FormData(this);

        for (var attr in params) {
            formData.append(attr, params[attr]);
        }

        Ext.each(this.uploadableImages, function (uploadableImage) {
            formData.append(uploadableImage['imageKey'], uploadableImage['imageFile']);
        });

        // this is to send the authentication_token, change it according to your need
        formData.append('authenticity_token', QLDT.Config.getToken());

        var xhr = new XMLHttpRequest(),
            method = options.method || 'POST';
        xhr.open(method, options.url);

        xhr.addEventListener('loadstart', function (e) {
            Ext.MessageBox.show({
                msg: waitMsg,
                progressText: 'Đang lưu...',
                width: 300,
                wait: true,
                waitConfig: {
                    interval: 200
                }
            });
        }, false);

        xhr.addEventListener('loadend', function (evt) {
            if (evt.target.status === 200) {
                Ext.MessageBox.hide();
                var obj = Ext.decode(evt.target.responseText);
                if (obj.success) {
                    success(obj);
                } else {
                    failure(obj);
                }
            } else {
                Ext.MessageBox.hide();
                failure(obj);
            }

        }, false);

        xhr.send(formData);
    }
});