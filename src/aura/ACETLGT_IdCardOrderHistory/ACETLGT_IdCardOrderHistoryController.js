({   
	onInit : function(component, event, helper) {


		var memid = component.get("v.memid");
		var idValue = component.get("v.idValue");

		if(memid === idValue){
			component.set("v.icon", memid === idValue ? "utility:chevrondown":"utility:chevronright");
			component.set("v.toggleName", "slds-show");
            
            helper.getOrderHistory(component, event, helper);   
            
		}else{
			component.set("v.toggleName", "slds-hide");
            component.set("v.orderHistoryMap", "");
		}

	},

    chevToggle : function(component, event, helper) {
		
        //alert(JSON.stringify(component.get("v.orderHistoryMap")));
		
        var iconName = component.find("chevInactive").get("v.iconName"); 

		if(iconName === "utility:chevrondown"){
			component.set("v.icon", "utility:chevronright");
			component.set("v.toggleName", "slds-hide");
            component.set("v.orderHistoryMap", "");
            
		}else{
            
            
            helper.getOrderHistory(component, event, helper);
            
            
			component.set("v.icon", "utility:chevrondown");
			component.set("v.toggleName", "slds-show");
		}


	},
     loadIdCard : function(component, event, helper) {
        helper.loadDocument(component, helper);
        var selectedItem = event.currentTarget;
        var reqDate = selectedItem.dataset.reqdate;
        helper.loadDocument(component, helper,reqDate);
    }
})