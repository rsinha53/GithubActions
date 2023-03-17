({
	getCaseData : function(component, event) {
        
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        var action = component.get("c.getcloneCaseDetails");
        action.setParams({ 
            caseId : component.get("v.recordId"),
            caseTypeVal : 'CloneCase'
        });        
        action.setCallback(this, function(response) {    
            var state = response.getState();            
            if (state === "SUCCESS") {                
                var wrapperData = response.getReturnValue();
                var caseObjData = wrapperData.caseObj;
                component.set("v.relationShip",caseObjData.Member_Relationship__c);
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
                    //jangi
                    if(!$A.util.isEmpty(caseObjData)){
                        
                        if(wrapperData != undefined && wrapperData != null && wrapperData.internalContact != undefined && wrapperData.internalContact != null) {
                            component.set("v.internalContacts",wrapperData.internalContact);
                        }
                        //DE386094 Clone Case component Error
                        if(wrapperData != undefined && wrapperData != null && wrapperData.groupData != undefined && wrapperData.groupData != null) {
                            component.set("v.groupSelected",wrapperData.groupData);
                        }
                         
                    }
                    //jangi
                    
                    if(caseObjData != undefined && caseObjData != null) {
                        var status = caseObjData.Status;
                        status = (status != undefined && status != null) ? status : ''; 
                        var validStatusValues = $A.get("$Label.c.ETSBE_CloneCase_Valid_StatusValues");
                        validStatusValues = (validStatusValues != undefined && validStatusValues != null) ? validStatusValues : '';
                        var validStatusArray = validStatusValues.split(",");
                        if(validStatusArray != undefined && validStatusArray != null && validStatusArray.includes(status)) {                        
                            var interactionRecData = {
                                "Id" : caseObjData.Interaction__r.Id,
                                "Interaction_Type__c" : caseObjData.Interaction__r.Interaction_Type__c,
                                "Name" : caseObjData.Interaction__r.Name,
                                "Originator_Name__c" : caseObjData.Interaction__r.Originator_Name__c                        
                            };
                            component.set("v.interactionRec", interactionRecData);
                            component.set("v.contactId", caseObjData.ContactId);
                            component.set("v.caseRec", caseObjData);
                            this.openSpecInsTab(component, event);    
                        } else {
                            $A.get("e.force:closeQuickAction").fire();
                            this.fireToastMessage("Error!", "No Access to Clone the Case", "error", "dismissible", "10000");   
                        }                                                            
                    }                    
                } else {
                    $A.get("e.force:closeQuickAction").fire();
                    this.fireToastMessage("Error!", "Case can only be opened within 90 days of Interaction Closed", "error", "dismissible", "10000"); 
                }                             
            } 
            var spinner2 = component.find("dropdown-spinner");
            $A.util.addClass(spinner2, "slds-hide");
        });        
        $A.enqueueAction(action);        
    },
    
    openSpecInsTab : function(component, event) {
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ETSBE_SpecialInstructions"
                },
                "state": {
                    "c__InteractionRecord": component.get("v.interactionRec"),
                    "c__CaseRecord":component.get("v.caseRec"),
                    "c__ContactId":component.get("v.contactId"),
                    "c__IsCloneCase":true,
                    "c__GroupData": component.get("v.groupSelected"),
                    "c__MemberRelationship":component.get("v.relationShip"),
                    "c__InternalContacts": component.get("v.internalContacts") //jangi
                }
            },
            focus: true
        }).then(function(response) {
            
            workspaceAPI.getTabInfo({
                tabId: response
                
            }).then(function(tabInfo) {
                
                workspaceAPI.setTabLabel({
                    tabId: tabInfo.tabId,
                    label: 'Special Instructions'
                });
                workspaceAPI.setTabIcon({
                    tabId: tabInfo.tabId,
                    icon: "standard:people",
                    iconAlt: "Member"
                });
                
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    
    fireToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    }
})