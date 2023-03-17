({
	doinit : function(component, event, helper) {
		helper.fetchContacts(component, event, helper);
	},

    closeEditDialog: function(component,event,helper){
        component.set('v.EditMode',false);
    },
    
    closeRemoveDialog: function(component,event,helper){
        component.set('v.DeleteMode',false);
    },
    
    ClickRemove: function(component,event,helper){
        helper.loadRemoveDialog(component,event,helper);
    },
    
    RemoveContacts: function (component,event,helper){
        helper.RemoveFamilyContact(component,event,helper);
    },
    
    EditContacts: function(component,event,helper){
        helper.checkIfMobileDevice(component,event,helper);
        helper.setupEditDialog(component,event,helper);
    },
    
    SaveUpdateContacts:function(component,event,helper){
        if(helper.validateContacts(component,event,helper)){
            helper.updateContacts(component,event,helper);
        }
        
    }
})