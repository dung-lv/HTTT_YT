Ext.define('QLDT.store.Gender', {
    extend: 'Ext.data.Store',

    alias: 'store.gender',

    fields: [
         {name: 'Text', type: 'string'},
         {name: 'Value',  type: 'int'},
    ],

    data: [
         { Text: 'Tất cả', Value: -1 },
        { Text: 'Nam', Value: 0 },
        { Text: 'Nữ', Value: 1 }]
    
});
