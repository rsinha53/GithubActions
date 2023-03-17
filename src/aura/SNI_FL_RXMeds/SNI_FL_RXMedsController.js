({
	doinit : function(component, event, helper) {
        helper.fetchRxMeds(component, event, helper);
    },
    EditRxMeds : function(component,event,helper){
        
        helper.checkIfMobileDevice(component,event,helper);
        helper.setupRxMedsDialog(component,event,helper);
    },
    
    closeRxMedModal: function(component,event,helper){
        component.set('v.EditMode',false);
    },
    closeRemoveDialog : function(component,event,helper){
        component.set('v.DeleteMode',false);
    },
    saveRxMedRecords:function(component,event,helper){
        if(helper.validateRxMedsFields(component,event,helper)){
            helper.updateRxMeds(component,event,helper);
        }
        
    },
     ClickRemove: function(component,event,helper){
        helper.loadRemoveDialog(component,event,helper);
    },
    RemoveRxMeds : function (component,event,helper){
        helper.RemoveRxMed(component,event,helper);
    },
    
   
})