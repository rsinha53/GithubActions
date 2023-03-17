({
    doInit: function (component, event, helper) {
        var originators = [
            
            { value:  (component.get("v.md.member.firstName"))+' '+(component.get("v.md.member.lastName")), label: (component.get("v.md.member.firstName"))+' '+(component.get("v.md.member.lastName")) },
            { value: $A.get("$Label.c.ACETThirdParty"), label: $A.get("$Label.c.ACETThirdParty") }
         ];
         component.set("v.options", originators);
    },
    
    openNewTab: function(component, event, helper){
      helper.openTab(component , event ,helper);
    },
    
    //Added by Dimpy US2904971: Create New Case
     handleShowOriginatorError: function(component,event,helper){
        var selOrginator = component.find("selOrginator");
        selOrginator.set('v.validity', {valid:false, badInput :true});
        selOrginator.showHelpMessageIfInvalid();
        component.set("v.showOriginatorErrorFired",true);
    },
    
    //Added by Dimpy US2904971: Create New Case
    handleOptionSelected: function(cmp,event,helper){
        var originatorId = cmp.get("v.selectedValue");
       //Fire App Event to Select the button
        var appEvent = $A.get("e.c:OPTUM_FocusTopicTextEvent");        
        appEvent.setParams({"valueSelected" : originatorId });
        console.log("Check app Event" +appEvent);
        appEvent.fire();

    },
	handleClaimEvent : function(component, event, helper) {
        console.log("in originator" + event.getParam("data"));
         var appEvent = $A.get("e.c:OPTUM_SelectedClaimRowEventChild");        
        appEvent.setParams({"data" : event.getParam("data") });
        
        appEvent.fire();
    }
})