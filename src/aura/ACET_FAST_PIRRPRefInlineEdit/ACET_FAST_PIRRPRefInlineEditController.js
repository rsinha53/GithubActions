({
	onInit : function( component, event, helper ) {    
         var actions = [
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' },
            { label: 'View', name: 'view' } ];
        component.set( 'v.mycolumns', [    
            {label: 'Reference', fieldName: 'Reference__c', type: 'text', editable:'true'},    
            {label: 'Completed', fieldName: 'Completed__c', type: 'boolean', editable:'true'},  
         	{ type: 'action', typeAttributes: { rowActions: actions } } ] );   
        helper.fetchPIRRPRefs(component);  
          
    },  
      
    onSave : function( component, event, helper ) {   
          
        var updatedRecords = component.find( "pirRPRefTable" ).get( "v.draftValues" );  
        var action = component.get( "c.updatePIRRPReferences" );  
        action.setParams({  
              
            'updatedPIRRPRefs' : updatedRecords  
              
        });  
        action.setCallback( this, function( response ) {  
              
            var state = response.getState();   
            if ( state === "SUCCESS" ) {  
  
                if ( response.getReturnValue() === true ) {  
                      
                    helper.toastMsg( 'success', 'Records Saved Successfully.' );  
                    component.find( "pirRPRefTable" ).set( "v.draftValues", null ); 
                    $A.get('e.force:refreshView').fire();
                      
                } else {   
                      
                    helper.toastMsg( 'error', 'Something went wrong. Contact your system administrator.' );  
                      
                }  
                  
            } else {  
                  
                helper.toastMsg( 'error', 'Something went wrong. Contact your system administrator.' );  
                  
            }  
              
        });  
        $A.enqueueAction( action );  
          
    },
    handleRowAction: function ( cmp, event, helper ) {
       
        var action = event.getParam( 'action' );
        var row = event.getParam( 'row' );
        var recId = row.Id;

        switch ( action.name ) {
            case 'edit':
                var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({
                    "recordId": recId
                });
                editRecordEvent.fire();
                break;
            case 'view':
                var viewRecordEvent = $A.get("e.force:navigateToURL");
                viewRecordEvent.setParams({
                    "url": "/" + recId
                });
                viewRecordEvent.fire();
                break;
            case 'delete':
                helper.removeRec(cmp, row);
                break;
        }
    }
})