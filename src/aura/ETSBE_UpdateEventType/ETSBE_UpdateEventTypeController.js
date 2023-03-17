({
    
    doInit : function(component, event, helper) {
		
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        var action = component.get("c.getCaseDetails");
        action.setParams({ 
            caseId : component.get("v.recordId"),
            caseTypeVal : ''
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS") {
                
                var responseData = response.getReturnValue();
                var caseObjData = responseData.caseObj;                
                var toProceedToCreateTheCase = true;
                
                if(caseObjData != undefined && caseObjData != null) {
                    var interactStatus = caseObjData.Interaction__r.Current_Status__c;
                    interactStatus = (interactStatus != undefined && interactStatus != null) ? interactStatus : '';
                    if(interactStatus == 'Closed') {
                        var interactResDate = caseObjData.Interaction__r.Resolution_Date__c;
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
                   // component.set("v.groupSelected",responseData.groupData);
                    //jangi
                    if(!$A.util.isEmpty(caseObjData)){
                        if(!$A.util.isEmpty(caseObjData.SourceCode__c) && caseObjData.SourceCode__c != 'NA'){
                            if(responseData != undefined && responseData != null && responseData.groupData != undefined && responseData.groupData != null) {
                                component.set("v.groupData",responseData.groupData);
                            }
                        }else{
                            if(responseData != undefined && responseData != null && responseData.internalContact != undefined && responseData.internalContact != null) {
                                component.set("v.internalContacts",responseData.internalContact);
                            }
                        }
                    }
                    //jangi
                    if(caseObjData != undefined && caseObjData != null) {
                        
                        var eventType = caseObjData.Event_Type__c;
                        eventType = (eventType != undefined && eventType != null) ? eventType : ''
                        var status = caseObjData.Status;
                        status = (status != undefined && status != null) ? status : '';
                        
                        if(status == 'Closed' && eventType == 'One & Done') {
                            
                            var interactionRecData = {
                                "Id" : caseObjData.Interaction__r.Id,
                                "Interaction_Type__c" : caseObjData.Interaction__r.Interaction_Type__c,
                                "Name" : caseObjData.Interaction__r.Name
                            };
                            component.set("v.interactionRec", interactionRecData);
                            component.set("v.caseRec", caseObjData);
                            helper.openSpecInsTab(component, event, helper);                            
                            
                        } else {
                            
                            $A.get("e.force:closeQuickAction").fire();
                            helper.fireToastMessage("Error!", "No Access to Change to Standard", "error", "dismissible", "10000");                       
                        }                                         
                    }
                } else {
                    $A.get("e.force:closeQuickAction").fire();
                    helper.fireToastMessage("Error!", "Case can only be opened within 90 days of Interaction Closed", "error", "dismissible", "10000"); 
                }                
                
            } 
            var spinner2 = component.find("dropdown-spinner");
            $A.util.addClass(spinner2, "slds-hide");
        });        
        $A.enqueueAction(action);     
	}
})