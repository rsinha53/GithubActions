({
    doInit: function (cmp, event, helper) {
        helper.initializeMemberDetails(cmp);
    },
    
    enableButton: function (cmp, event, helper) {        
        var providerContact = cmp.get("v.providerContactDetails.Provider_Contact__c");
        var providerPreference = cmp.get("v.providerContactDetails.Provider_Contact_Preference__c");
        var providerPhone = cmp.get("v.providerContactDetails.Provider_Contact_Phone__c");
        var providerEmail = cmp.get("v.providerContactDetails.Provider_Contact_Email__c");
        var parProvider = cmp.get("v.providerContactDetails.Par_Provider__c");
        var caseRecordType = cmp.get("v.caseRecordType");
        var eventTriggeredValue = cmp.get("v.dataFromTrigger");
        if(caseRecordType == 'Reactive Resolution'){
            if((providerContact != "" && providerContact != null && providerContact != 'undefined') && 
               (providerPreference != "" && providerPreference != null && providerPreference != 'undefined') && 
               (providerPhone != "" && providerPhone != null && providerPhone != 'undefined') && 
               (providerPhone.length == 10) &&
               (providerEmail != "" && providerEmail != null && providerEmail != 'undefined') &&
               (parProvider != "" && parProvider != null && parProvider != 'undefined') &&
               (caseRecordType != "" && caseRecordType != null && caseRecordType != 'undefined')){
                cmp.set("v.contactValues",true);
                var isContactValues = cmp.get("v.contactValues");
                if(eventTriggeredValue == true && isContactValues == true){
                    cmp.set("v.enableContinue",true);
                }
            }else{
                cmp.set("v.enableContinue",false); 
            } 
        }else{
            cmp.set("v.enableContinue",true); 
        }
    },
    
    
    appEventTriggMethod: function(cmp, event, helper){ 
        var providerData = event.getParam("selectedProviderDetails");
       var noProviderFlowData = event.getParam("providerFlowDetails");
       cmp.set("v.providerDataVar",providerData);
        cmp.set("v.noProviderDataVar",noProviderFlowData);
        var recType = noProviderFlowData.caseRecordType;
        cmp.set("v.caseRecordType", recType);
        console.log('recType==>'+recType);
        //-----Tech Story - Disable Continue button when the check box is unchecked in happy path for PIP---//
        if(recType == 'Proactive Action' && providerData == null){
           cmp.set("v.enableContinuebutton",false);
        }
        //-----Tech Story - Disable Continue button when the check box is unchecked in happy path for PIP---//
        if(recType == 'Reactive Resolution' && providerData == null){
           cmp.set("v.dataFromTrigger",false);
        }
        //Tech Story - PIP - added null condition to avoid errors when validating fields inside 'providerData' object
        if(providerData != null){
        if(recType == 'Proactive Action' && (noProviderFlowData.taxIdOrNPI != null  || providerData.taxidornpi != null || noProviderFlowData.isNoProviderToSearch == true || providerData.isProviderNotFound == true)){
           cmp.set("v.enableContinuebutton",true);
        }else{
              //TA9370099 - PIP – When user deselects “No Provider to Search”, continue button is enabledg
        if(recType == 'Proactive Action' && noProviderFlowData.isNoProviderToSearch == false){
           cmp.set("v.enableContinuebutton",false);
        }
        }
        }
        
        //Tech Story - PIP - added null condition to avoid errors when validating fields inside 'providerData' object
         if(providerData != null){
         if(recType == 'Reactive Resolution' && (noProviderFlowData.taxIdOrNPI != null  || providerData.taxidornpi != null || noProviderFlowData.isNoProviderToSearch == true || providerData.isProviderNotFound == true )){
          cmp.set("v.dataFromTrigger",true);
        }
         }
       // US3128839 - FAST/E2E - Clear Button on Explore Page
        var clearvalues = noProviderFlowData.clearValues;
       if(clearvalues == true){
           if(recType == 'Reactive Resolution')
            {
               cmp.set("v.enableContinue",false); 
            }else{
                cmp.set("v.enableContinuebutton",false);
            }
             var providerContactDetails = {
            "providerContactName": "",
            "providerContactPreference": "",
            "providerContactPhone": "",
            "providerContactEmail": "",
            "parProvider": ""
        };
             cmp.set("v.providerContactDetails", providerContactDetails);
         }
    },
    
    validatePhone: function(component, event, helper){
        var phoneNumber = event.getSource().get('v.value');
        if(isNaN(phoneNumber)){
            event.getSource().set('v.value','');
        }
        var action = component.get('c.enableButton');
        $A.enqueueAction(action);
    },
    
    validatePIPPhone: function(component, event, helper){
        var phoneNo = event.getSource();
        var phoneNumber = phoneNo.get('v.value');
        if(phoneNumber != undefined && phoneNumber.toString().length){
            var s = (""+phoneNumber).replace(/\D/g, '');
            var m = s.match(/^(\d{3})(\d{3})(\d{4})$/);
            var formattedPhone = (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];
            phoneNo.set('v.value',formattedPhone);   
        }       
    },

    
    openInteractionOverview : function (cmp, event, helper) {
        var providerData = cmp.get("v.providerDataVar");
        var noProviderFlowData = cmp.get("v.noProviderDataVar");
        var caseRecordType = cmp.get("v.caseRecordType");
        var providerFinalJSON = {
            accountRec: cmp.get("v.providerContactDetails"),
            accountInteractionWrap: providerData,
            noAccountInteractionWrap: noProviderFlowData,
            noAccountTaxId: noProviderFlowData.taxIdOrNPI,
            caseRecordType : cmp.get("v.caseRecordType")
        };
        var wrapJSONVar = JSON.stringify(providerFinalJSON);
        var action = cmp.get("c.saveProviderContact");
        action.setParams({
            "wrapperStringJSON" : wrapJSONVar
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                cmp.set("v.contacts", result);
                var workspaceAPI = cmp.find("workspace");
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        
                        "attributes": {
                            "componentName": "c__ACET_FAST_InteractionCmp"
                        },
                        "state": {
                            "c__personAccountId": result.accountRecordId,
                            "c__interactionRecordId": result.interctionRecordId,
                            "c__caseRecordType": cmp.get("v.caseRecordType")
                        }
                    },
                    focus: true
                }).then(function (response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function (tabInfo) {
                        var focusedTabId = tabInfo.tabId;
                        var tabName = "Interaction Overview";
                        workspaceAPI.setTabLabel({
                            tabId: focusedTabId,
                            label: tabName
                        });
                        workspaceAPI.setTabIcon({
                            tabId: focusedTabId,
                            icon: "standard:contact_list",
                            iconAlt: "Interaction Overview"
                        });
                    });
                }).catch(function (error) {
                    console.log(error);
                });         
            }
        });
        $A.enqueueAction(action);
    }
})