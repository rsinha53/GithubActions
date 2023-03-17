({
    createNewMessage : function(component, event, helper) {
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        if(component.get("v.isFamilyLevel")){
            if(component.get("v.accountOwner") == userId){
                component.set("v.IsOpenNewMsg",true);
            } else{
                var action = component.get("c.checkPartnerforFamily");
                  action.setParams({
                    "familyId":component.get("v.familyId")
                 });
                action.setCallback(this,function(response){
                    console.log('res in header---'+response.getState());
                    if(response.getState()=='SUCCESS'){
                        var val = response.getReturnValue();
                        if(val){ 
                           component.set("v.IsOpenNewMsg",true);   
                        }
                        else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                type: 'info',
                                key: 'info_alt',
                                message: "You must be engaged with the Family to send them messages.",
                                mode: 'dismissible'
                            });
                            toastEvent.fire();  
                       }  
                   }
               });
                $A.enqueueAction(action);        
            }
        } else{
            component.set("v.IsOpenNewMsg",true);
        }
       
    },
    
    createNewProviderMessage : function(component, event, helper) {
        helper.validateProviderAfliations(component,event);//Sameera
        component.set("v.isFamilyLevel",false); 
    },
    
    openBackupAdvisorModal : function(component, event, helper) {
        component.set("v.openBackupAgentModal", true);
	},
    
    selectFilterOption :function(component,event,helper){      
        var selectedItem= component.find("select").get("v.value");
        if(selectedItem === 'Flagged'){
            component.set("v.isFlagged", true);
            component.set("v.isProvider", false);
        }
        else if(selectedItem === 'Provider'){
            component.set("v.isProvider", true);
            component.set("v.isFlagged", false);
        }else{
            component.set("v.isFlagged", false);
            component.set("v.isProvider", false);
        }
        helper.loadDirectMessageList(component,event,helper);
    },
    
    //US3241339/US3244597 - Ashley Winden/Charnkiat Sukpanichnant
    launchOlderMessagesTab : function(component, event, helper) {
        if(component.get('v.requestType') == 'family'){
            helper.NavigateOlderMessage(component, event, "family",component.get("v.familyId"));
        }
        else if(component.get('v.requestType') == 'provider')
        {
            var action = component.get("c.getMemberAffiliationCount");
            action.setParams({
                "accountID": component.get("v.familyId")
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state == 'SUCCESS'){
                    var memberAffiliationResponse = response.getReturnValue();
                    if(memberAffiliationResponse == 1){
                        component.set("v.showAffiliationPopup", false);
                        component.set("v.isSingleMA", true);
                        helper.getMAID(component,event,helper);
                    }
                    else{
                        component.set("v.showAffiliationPopup", true); 
                    }
                }
                
            });
            $A.enqueueAction(action);
        }
    },
 
 doInit : function(component, event, helper) {
    component.set("v.showAffiliationPopup", component.get("v.CloseMemberAffiliationPopup"));
    var action = component.get("c.getFamilyHistoricalMessagesFlag");
    action.setParams({
        "familyId": component.get("v.familyId")
    });
    action.setCallback(this,function(response){
        var state = response.getState();
        if(state == 'SUCCESS'){
            var historicalMessagesFlagResponse = response.getReturnValue().HistoricalMessage;
            var requestTypeResponse = response.getReturnValue().requestType;
            component.set('v.historicalMessagesFlag', historicalMessagesFlagResponse);
            component.set('v.requestType', requestTypeResponse);
        }
    });
    $A.enqueueAction(action);
},
    closeAffiliation: function(component, event, helper){
        component.set("v.showAffiliationPopup", false);
    },
    //US3241339 - Ashley Winden
    handleHistProvider: function(component,event,helper){
        setTimeout(function() {
            var element = component.get("v.isHistProvider");
            if(element){
                var action = component.get("c.getProviderHistoricalMessageFlag");
                action.setParams({
                    "familyId": component.get("v.familyId")
                });
                action.setCallback(this,function(response){
                    var state = response.getState();
                    if(state == 'SUCCESS'){
                        var historicalMessagesFlagResponse = response.getReturnValue().HistoricalMessage;
                        var requestTypeResponse = response.getReturnValue().requestType;
                        component.set('v.historicalMessagesFlag', historicalMessagesFlagResponse);
                        component.set('v.requestType', requestTypeResponse);
                    }
                });
                $A.enqueueAction(action); 
            }
            var element1 = component.get("v.isFamilyLevel");
            if(element1){
                component.set("v.showAffiliationPopup", component.get("v.CloseMemberAffiliationPopup"));
                var action = component.get("c.getFamilyHistoricalMessagesFlag");
                action.setParams({
                    "familyId": component.get("v.familyId")
                });
                action.setCallback(this,function(response){
                    var state = response.getState();
                    if(state == 'SUCCESS'){
                        var historicalMessagesFlagResponse = response.getReturnValue().HistoricalMessage;
                        var requestTypeResponse = response.getReturnValue().requestType;
                        component.set('v.historicalMessagesFlag', historicalMessagesFlagResponse);
                        component.set('v.requestType', requestTypeResponse);
                    }
                });
                $A.enqueueAction(action);
            }
        }, 200);
    }
})