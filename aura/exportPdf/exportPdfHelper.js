({
    exportToPDFHelper : function(component, event, helper) {
        alert("I am from JS Helper ");
        var selectedRows = component.find("listView").getSelectedRows();
        console.log('Selected Rows: '+ selectedRows);
        // Perform action on selectedRows
        
        
    }
})