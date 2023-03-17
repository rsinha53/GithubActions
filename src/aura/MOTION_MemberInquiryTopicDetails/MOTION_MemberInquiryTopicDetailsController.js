({
    doInit : function(cmp, event, helper) {
	
        helper.tabOpenDetails(cmp, event, helper);  
		helper.validationLogicInit(cmp, event, helper);
    },
    getSelectedRecords:function(component,event,helper){
          var selectedRows = event.getParam("selectedRows");
		  var selectedtable=event.getParam("tableuniqueId");
      	 var selesize=selectedRows.length;
         if(selectedtable === 'Console Inquiry'){
            component.set("v.consoleSelectedRows", selesize);
		  
			 
												 
        }
        if(selectedtable === 'DERM Inquiry'){
            component.set("v.dermSelectedRows", selesize);
        }
        	
        if(component.get("v.dermSelectedRows") || component.get("v.consoleSelectedRows"))
        {    
         	component.set("v.validateSelectRow", true);   
        }else{
            component.set("v.validateSelectRow", false);
        }
        helper.validatesave(component,event,helper);
    },
    validateComments: function(component,event,helper){
        var cmnt = component.get("v.comments");
        console.log('Comment Size: '+cmnt.length);
        var charCount=2900-cmnt.length;
        component.set('v.commentlength',charCount);
        if(cmnt !== ''){
            if(cmnt.length > 2899){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({ 
                    "type": "info",
                    "message": "Info: You cannot enter any more characters in the Comments field because the character limit (2900) has been reached.", 
                    "duration": "10000",
                    "mode": "dismissible"
                });
                toastEvent.fire();
            }
            component.set("v.validatecomments", true);
        }
        else{
            component.set("v.validatecomments", false);
        }
        helper.validatesave(component,event,helper);
        }
    
})