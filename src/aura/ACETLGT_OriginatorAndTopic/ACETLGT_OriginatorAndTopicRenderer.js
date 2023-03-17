({
	rerender : function(component, helper) {
   		this.superRerender();
        
        var showOriginatorErrorFired = component.get("v.showOriginatorErrorFired");
        if(showOriginatorErrorFired != undefined && showOriginatorErrorFired == true){
            var isOFProfile = component.get("v.isOFProfile");// Added as part of US3329760 by OF team
            if(isOFProfile == false){
            document.getElementById("originatorlocationscroll").scrollIntoView(true);
            }
            // show the error message of originator combobox
            var selOrginator = component.find("selOrginator");
            if(selOrginator.get("v.value") != undefined && selOrginator.get("v.value").length < 10)
            	selOrginator.set("v.value",null);
            selOrginator.set('v.validity', {valid:false, badInput :true});
             
            selOrginator.showHelpMessageIfInvalid();
        }
        
	}
})