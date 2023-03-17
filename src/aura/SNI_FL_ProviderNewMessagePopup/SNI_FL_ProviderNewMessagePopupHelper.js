({
	//Sameera - ACDC  US3128774
	createMessage : function(component,event,dataObject) {
		let spinner = component.find("mySpinner");
		let action = component.get('c.createProviderMessage');
		let toastEvent = $A.get("e.force:showToast");
		let cmpEvent = component.getEvent("retrieveAllMessages");
		
		action.setParams({
			'inObjectParameters' :dataObject
		});
		action.setCallback(this,function(response){
			if(response.getState() === 'SUCCESS') {
				
				$A.util.addClass(spinner, "slds-hide");
				component.set("v.IsOpenNewMsg",false);
				
				cmpEvent.setParams({
					"isNewMessageCreated" : true
					});
				cmpEvent.fire();

			} else {
				
				toastEvent.setParams({
					"title": "Error!",
					"message": "error Send Message",
					"type": "error"
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	}
})