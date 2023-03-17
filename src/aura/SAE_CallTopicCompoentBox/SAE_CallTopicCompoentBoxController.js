({
    	doInit : function(component, event, helper) {
            //alert('child compoennt');
            var selectedRecordLists = component.get("v.selectedListRecords");
            console.log('selectedRecordLists>>> ' + selectedRecordLists)
            var getSelectRecord = component.get("v.oRecord");
            console.log('getSelectRecord>>> ' + getSelectRecord);
            for(var i = 0; i < selectedRecordLists.length; i++) {
                if(selectedRecordLists[i].Name == getSelectRecord.Name){
                    component.set('v.disabled',true);
                    break;
                }
            }
            
        },
	    selectRecord : function(component, event, helper){ 
            
            console.log('key check'+ event.ctrlKey+event.metaKey);
            var keyPressed = event.ctrlKey || event.metaKey;
            // get the selected record from list  
            var getSelectRecord = component.get("v.oRecord");
            // call the event   
            var compEvent = component.getEvent("oSelectedRecordEvent");
            // set the Selected sObject Record to the event attribute.  
            compEvent.setParams({
                "recordByEvent" : getSelectRecord ,
                "ctrlPressed" : keyPressed
            });  
            // fire the event  
            compEvent.fire();
            component.set('v.disabled',!component.get('v.disabled'));
    },
})