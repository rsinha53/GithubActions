({
    // handle hover text  
    handleMouseOver :function(component, event, helper) {
        component.set("v.hoverRow", parseInt(event.target.dataset.index));
    },
    
	 // DE321368: added below line for hover issue -  Saikolluru [04/23/2020] 																		 
    handleAvlMouseOver :function(component, event, helper) {
        component.set("v.AvlhoverRow", parseInt(event.target.dataset.index));
    },
    // handle hover text 
    handleMouseOut : function(component,event,helper){
        component.set("v.hoverRow",-1);
        component.set("v.AvlhoverRow",-1);
    },
    getmemberWellnessHASummary : function (component, event, helper) {
        helper.openWellnessHASummaryUrl(component, event, helper);
    },
    getmemberWellnessDefaultAction : function (component, event, helper) {
        helper.openWellnessDefaultUrl(component, event, helper);
    },
	
    // Show Health Incentives Card
    showHealthInsCard : function(component, event, helper) {
        component.set("v.isHealthInsShow","false");
        component.set("v.isLoaded","true");
        
        var val = component.get("v.calloutStatus");
        if(val == undefined){
        	helper.getcompletionDate(component, event, helper); 
        	helper.getIncentiveDetails(component, event, helper);
            component.set("v.calloutStatus","Active");
    	}
    },
    
    // Hide Health Incentives Card
    hideHealthInsCardCard : function(component, event, helper) {
        component.set("v.isHealthInsShow","true");
        component.set("v.isLoaded","false");
    }
})