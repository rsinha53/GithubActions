({
	fetchPIRRPRefs : function( component ) {  
        var pirRPRecId = component.get("v.recordId")  
        var action = component.get( "c.fetchPIRRPReferences" ); 
        action.setParams({
            'pirRPId' : pirRPRecId
        });
        action.setCallback(this, function( response ) {    
              
            var state = response.getState();    
            if (state === "SUCCESS")     
                component.set( "v.pirRPRefList", response.getReturnValue() );                
            	component.set( "v.sizeOfRPRef", response.getReturnValue().length ); 
        });    
        $A.enqueueAction(action);   
          
    },  
      
    toastMsg : function( strType, strMessage ) {  
          
        var showToast = $A.get( "e.force:showToast" );   
        showToast.setParams({   
              
            message : strMessage,  
            type : strType,  
            mode : 'sticky'  
              
        });   
        showToast.fire();   
          
    },
    removeRec: function (cmp, row) {
        /*var rows = cmp.get('v.pirRPRefList');
        var rowIndex = rows.indexOf(row);

        rows.splice(rowIndex, 1);
        cmp.set('v.pirRPRefList', rows);*/
        var action = cmp.get( "c.deletePIRRPRef" ); 
        action.setParams({
            'pirRPRefId' : row.Id
        });
        action.setCallback(this, function( response ) {    
              
            var state = response.getState();    
            if (state === "SUCCESS")  {
                this.toastMsg( 'success', 'record deleted successfully.' );
                this.fetchPIRRPRefs(cmp);
                //$A.get('e.force:refreshView').fire();
            }   
        });    
        $A.enqueueAction(action); 
    }
})