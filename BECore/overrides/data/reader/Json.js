Ext.define('Ext.overrides.data.reader.Json', {
    override: 'Ext.data.reader.Json',
    rootProperty: 'Data',

    totalProperty: 'Total',

    successProperty: 'Success',

    messageProperty: 'ErrorMessage',
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
            var result = Ext.decode(response.responseText);
            return result;
        } catch (ex) {
            error = this.createReadError(ex.message);
            Ext.Logger.warn('Unable to parse the JSON returned by the server');
            this.fireEvent('exception', this, response, error);
            return error;
        }
    },
});