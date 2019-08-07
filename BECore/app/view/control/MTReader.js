/**
 * MTReader
 * Create by: dvthang:01.04.2017
 */
Ext.define('QLDT.view.control.MTReader', {
    extend: 'Ext.data.reader.Json',
    xtype: 'MTReader',
    alias: 'reader.mtreader',

    /**
     * @method readRecords
     * Reads a JSON object and returns a ResultSet. Uses the internal getTotal and getSuccess extractors to
     * retrieve meta data from the response, and extractData to turn the JSON data into model instances.
     * @param {Object} data The raw JSON data
     * @param {Object} [readOptions] See {@link #read} for details.
     * @return {Ext.data.ResultSet} A ResultSet containing model instances and meta data about the results
     */
    getResponseData: function (response) {
        var error;
        try {
            return Ext.decode(response.responseText);
        } catch (ex) {
            error = this.createReadError(ex.message);
            Ext.Logger.warn('Unable to parse the JSON returned by the server');
            this.fireEvent('exception', this, response, error);
            return error;
        }
    },
});
