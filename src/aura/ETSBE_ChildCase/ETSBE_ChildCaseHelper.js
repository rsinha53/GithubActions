({
    
    getCaseData : function(component, event, helper) {
        
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        var action = component.get("c.getCaseDetails");
        action.setParams({ 
            caseId : component.get("v.recordId"),
            caseTypeVal : 'ChildCase'
        });        
        action.setCallback(this, function(response) {    
            var state = response.getState();            
            if (state === "SUCCESS") {                
                var wrapperData = response.getReturnValue();
                var caseObjData = wrapperData.caseObj;
                //jangi
                if(!$A.util.isEmpty(caseObjData)){
                    if(!$A.util.isEmpty(caseObjData.SourceCode__c) && caseObjData.SourceCode__c != 'NA'){
                        if(wrapperData != undefined && wrapperData != null && wrapperData.groupData != undefined && wrapperData.groupData != null) {
                            component.set("v.groupData",wrapperData.groupData);
                        }
                    }else{
                        if(wrapperData != undefined && wrapperData != null && wrapperData.internalContact != undefined && wrapperData.internalContact != null) {
                            component.set("v.internalContacts",wrapperData.internalContact);
                        }
                    }
                }
                //jangi
                
                if(caseObjData != undefined && caseObjData != null) {                    
                    var interactionRecData = {
                        "Id" : caseObjData.Interaction__r.Id,
                        "Interaction_Type__c" : caseObjData.Interaction__r.Interaction_Type__c,
                        "Name" : caseObjData.Interaction__r.Name,
                        "Originator_Name__c" : caseObjData.Interaction__r.Originator_Name__c
                        
                    };
                    component.set("v.interactionRec", interactionRecData);
                    component.set("v.contactId", caseObjData.ContactId);
                    component.set("v.caseRec", caseObjData);                    
                }                
                this.openSpecInsTab(component, event, helper);
            } 
            var spinner2 = component.find("dropdown-spinner");
            $A.util.addClass(spinner2, "slds-hide");
        });        
        $A.enqueueAction(action);
        
    },
    
    openSpecInsTab : function(component, event, helper) {
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ETSBE_SpecialInstructions"
                },
                "state": {
                    "c__InteractionRecord": component.get("v.interactionRec"),
                    "c__CaseRecord": component.get("v.caseRec"),
                    "c__ContactId": component.get("v.contactId"),
                    "c__GroupData": component.get("v.groupData"),
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