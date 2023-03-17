({

    doInit: function(component, event, helper) {
        component.set("v.InteractionType", "Phone Call");
        component.set("v.options", $A.get("$Label.c.ACETMemberSearchInteractionTypes").split(','));
       },
    
    clear: function(component, event, helper) {
        helper.clearSearch(component, event, helper);
    },
    
    onChange: function(component, event, helper) {
        helper.CheckSSNDigits(component, event, helper);
    },
    
    formatSSN: function(component, event, helper) {
        helper.setSSN(component, event, helper);
    },
    
    showResults:function(component, event,helper){
      helper.showResult(component, event,helper);
    },
    
    keyCheck : function(component, event, helper){
    if (event.which == 13){
        event.preventDefault();
        helper.showResult(component, event, helper);
    }},
    selectChange : function(component, event, helper) {
        var inputField= component.get("v.enableID");
        var appEvent= $A.get("e.c:OPTUM_RefreshAdvanceSearch")
        
        if(inputField){
            component.set("v.ShowID",true);
            component.set("v.buttonsHide",true);
            component.set("v.enableID",false);
            helper.clearSearch(component,event,helper);
            
        }else  {
            component.set("v.ShowID",false);
            component.set("v.buttonsHide",false);
            component.set("v.enableID",true);
			helper.clearSearch(component,event,helper);
            appEvent.fire(); 
            
        }
        // first get the div element. by using aura:id
        var changeElement = component.find("DivID");
        // by using $A.util.toggleClass add-remove slds-hide class
        $A.util.toggleClass(changeElement, "slds-hide");
        
    },

    handleAdvanceSearchEvent: function (component, event, helper) {
        var data = event.getParam("MemberDetails");
        component.set("v.MemberDetails", data);
        var appEvent = $A.get("e.c:OPTUM_MemberDetailEvent");
        appEvent.setParams({ "SearchType": "Advance" });
        appEvent.setParams({ "MemberDetails": data });

        appEvent.fire();
    },
    handleError: function (component, event, helper) {
        var error = event.getParam("error");
        var clear = event.getParam("clearType")
        component.set("v.showErrorMessage", error);
        if(clear == "api"){
		var appEvent = $A.get("e.c:OPTUM_MemberDetailEvent"); 
        appEvent.setParams({"SearchType":"Advance"}); 
        appEvent.setParams({"MemberDetails":""});
        appEvent.fire();
		}
    }	
})