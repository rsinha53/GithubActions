({
    
    doInit : function(component, event, helper) {
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        var actionUser = component.get("c.getUser"); 
        actionUser.setCallback(this, function(response) {
            var state = response.getState(); 
            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                if(responseData.Profile_Name__c != null &&  responseData.Profile_Name__c == 'FPS OST' ){
                    component.set("v.businessType",'FPS');
                }
                else{
                    component.set("v.businessType",'BEO');
                }
                var action = component.get("c.getCaseDetails");
                action.setParams({ 
                    caseId : component.get("v.recordId"),
                    caseTypeVal : ''
                });        
                action.setCallback(this, function(response) {
                    var state = response.getState(); 
                    if (state === "SUCCESS") {
                        var responseDataVal = response.getReturnValue();
                        var caseObjData = responseDataVal.caseObj;
                        if(caseObjData != undefined && caseObjData != null) {
                            var eventType = caseObjData.Event_Type__c;
                            eventType = (eventType != undefined && eventType != null) ? eventType : ''
                            var status = caseObjData.Status;
                            status = (status != undefined && status != null) ? status : '';
                            var origin = caseObjData.Origin;
                            console.log(caseObjData);
                            origin = (origin != undefined && origin != null) ? origin : '';
                            //For FPS Profile
                            if(responseData.Profile_Name__c != null &&  responseData.Profile_Name__c == 'FPS OST' || responseData.Profile_Name__c == 'PT1'){
                                var recId = component.get("v.recordId");
                                var urlEvent = $A.get("e.force:navigateToURL");
                                urlEvent.setParams({
                                    "url": "/lightning/n/FPS_Explore?c__recordId="+recId+"&c__origin="+origin+"&c__isUpdateCase=true"
                                });
                                urlEvent.fire();
                                
                            }
                            else if(responseData.Profile_Name__c != null && responseData.Profile_Name__c != 'FPS OST'){
                                
                                if(status == 'BOT' || status == 'Open') {
                                    
                                    var interactionRecData = {
                                        "Id" : caseObjData.Interaction__r.Id,
                                        "Interaction_Type__c" : caseObjData.Interaction__r.Interaction_Type__c,
                                        "Name" : caseObjData.Interaction__r.Name,
                                        "Originator_SFID__c" : caseObjData.Interaction__r.Originator_SFID__c
                                    };
                                    component.set("v.interactionRec", interactionRecData);
                                    component.set("v.caseRec", caseObjData);
                                    helper.openBEOExploreTab(component, event, helper);                            
                                    
                                } else {
                                    
                                    $A.get("e.force:closeQuickAction").fire();
                                    helper.fireToastMessage("Error!", "No Access to Update Case", "error", "dismissible", "10000");                       
                                } 
                            }
                            }
                            
                            
                        } 
                        var spinner2 = component.find("dropdown-spinner");
                        $A.util.addClass(spinner2, "slds-hide");
                    });        
                    $A.enqueueAction(action);  
                    
                }
                                   
                                  // }
                                   });
                $A.enqueueAction(actionUser);  
            }
        })