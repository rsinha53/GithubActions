({
	onLoad: function(component, event, helper){
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        component.find("isesc").set("v.value", true);
        var stat = component.find("escurntsts").get("v.value");
        var esclaTo = component.find("escto").get("v.value");
        if(stat == "Closed"){
            component.set("v.showError", true);
            component.set("v.disfields", true);
            component.set("v.disClearbutt", true);
        }
        if(!$A.util.isUndefinedOrNull(esclaTo) && !$A.util.isEmpty(esclaTo)){
            component.set("v.disfields", true);
            component.set("v.disClearbutt", true);
        }
		helper.checkIntEsc(component,event,helper);  
        var spinner1 = component.find("dropdown-spinner");
        $A.util.addClass(spinner1, "slds-hide");
    },
    handleOnSubmit : function(component, event, helper) {
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        event.preventDefault();
        var fields = event.getParam("fields");
        component.find("recordViewForm").submit(fields);
        var spinner1 = component.find("dropdown-spinner");
        $A.util.addClass(spinner1, "slds-hide");
        
    },
    CloseQuickaction : function(component, event, helper) {
                $A.get("e.force:closeQuickAction").fire();
    },
    clear: function(component,event,helper){
        component.find("escto").set("v.value", "");
        component.find("escreas").set("v.value", "");
       
    },
    disabutton: function(component,event,helper){
      if (!$A.util.isEmpty(component.find("escto").get("v.value")) && !$A.util.isEmpty(component.find("escreas").get("v.value"))){    
        component.set("v.disbutton",false);
      }
    },
    handleOnSuccess : function(component, event, helper) {
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        var record = event.getParam("response");
        helper.updateinteract(component,event,helper);
        component.find("notificationsLibrary").showToast({
            "title": "Saved",
            "message": "Record Sent Successfully.",
            "variant": "success"
        });
        var spinner1 = component.find("dropdown-spinner");
        $A.util.addClass(spinner1, "slds-hide");
	},
    handleError: function (cmp, event, helper) {
        cmp.find('notificationsLibrary').showToast({
            "title": "",
            "message": event.getParam("message"),
            "variant": "error"
        });
    }

})