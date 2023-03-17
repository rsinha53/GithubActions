({
    
    doInit : function(component, event, helper) {
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        var action1 = component.get("c.getUser");
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('BEO: ' + storeResponse.BEO_Specialty__c);
                console.log('PROFILE: ' + storeResponse.Role_Name__c);
            	var action = component.get("c.getInteractionDetails");
                action.setParams({ 
                    intId : component.get("v.recordId")
                });        
                action.setCallback(this, function(response) {
                    var state = response.getState(); 
                    if (state === "SUCCESS") {
                        var responseData = response.getReturnValue();
                        if(responseData != undefined && responseData != null) {
                        	var currentStatus = responseData.Current_Status__c;
                        	component.set('v.interactionRec', responseData);
                            var toProceedToCreateTheCase = true;
                            var interactionRec = component.get('v.interactionRec');
                            var toProceedToCreateTheCase = true;
                            if(interactionRec != undefined && interactionRec != null) {
                                var interactStatus = interactionRec.Current_Status__c;
                                interactStatus = (interactStatus != undefined && interactStatus != null) ? interactStatus : '';
                                if(interactStatus == 'Closed') {
                                    var interactResDate = interactionRec.Resolution_Date__c;
                                    interactResDate = (interactResDate != undefined && interactResDate != null) ? interactResDate : '';
                                    if(interactResDate != '') {
                                        interactResDate = interactResDate.substring(0, interactResDate.indexOf("T"));
                                        var d = new Date(interactResDate);                            
                                        var compareDate = new Date(d.getFullYear(), d.getMonth(), d.getDate());
                                        var diff = Math.ceil(new Date() - compareDate);
                                        var noOfDays = Math.floor(diff/(1000 * 60 * 60 * 24));
                                        if(noOfDays != undefined && noOfDays != null && noOfDays > 90) {
                                            toProceedToCreateTheCase = false;
                                        }
                                    }                        
                                }
                            }
                            if(toProceedToCreateTheCase) {
                                helper.openBEOExploreTab(component, event, helper);
                            } else {
                                $A.get("e.force:closeQuickAction").fire();
                                helper.fireToastMessage("Error!", "Case can only be opened within 90 days of Interaction Closed", "error", "dismissible", "10000"); 
                            }
                        }                                                
                    } 
                    var spinner2 = component.find("dropdown-spinner");
                    $A.util.addClass(spinner2, "slds-hide");
                });        
                $A.enqueueAction(action);
            }
        });
        $A.enqueueAction(action1);
             
	}
})