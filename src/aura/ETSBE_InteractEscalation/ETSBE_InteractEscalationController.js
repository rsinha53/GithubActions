({
	onLoad: function(component, event, helper){
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
       helper.checkCaseEsc(component,event,helper);  
    },
    handleOnSubmit : function(component, event, helper) {
        event.preventDefault();
        var fields = event.getParam("fields");
        component.find("recordViewForm").submit(fields);
        
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
        var record = event.getParam("response");
        helper.updatecaserec(component,event,helper);
        component.find("notificationsLibrary").showToast({
            "title": "Saved",
            "message": "Record Sent Successfully.",
            "variant": "success"
        });   
        
	},
    handleError: function (cmp, event, helper) {
        cmp.find('notificationsLibrary').showToast({
            "title": "",
            "message": event.getParam("message"),
            "variant": "error"
        });
    }

})