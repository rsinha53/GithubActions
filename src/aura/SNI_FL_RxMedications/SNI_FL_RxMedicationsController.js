//US2841187: controller for RxMedications
//Author Name: Derek DuChene
({
    doinit : function(component, event, helper) {
        
        helper.fetchRxMeds(component, event, helper);
        
        var action = component.get("c.getUserProfile");
        action.setCallback(this, function(response){
            var stateResponse = response.getState();
            if(stateResponse == 'SUCCESS') {
                var result = response.getReturnValue();
                if((result != undefined && result != '' && result) ){
                    if(result == 'Family Engagement Center - Read Only'){
                        component.set("v.checkReadOnly",false);
                        component.set('v.rxMColumns', [
                            {label: 'Name', fieldName: 'linkName', type: 'url',
                             typeAttributes: {label: { fieldName: 'Name' }, target: '_self'}
                            },
                            {label: 'Directions', fieldName: 'Directions__c', type: 'text'},
                            {label: 'Refill Date', fieldName: 'formatDate', type: 'Date'} 
                        ]);
                    }
                    else if(result != 'Family Engagement Center - Read Only'){
                        component.set("v.checkReadOnly",true);
                        var actions = [
                            { label: 'Edit', name: 'Edit' },
                            { label: 'Remove', name: 'Remove' }
                        ]
                        component.set('v.rxMColumns', [
                            {label: 'Name', fieldName: 'linkName', type: 'url',
                             typeAttributes: {label: { fieldName: 'Name' }, target: '_self'}
                            },
                            {label: 'Directions', fieldName: 'Directions__c', type: 'text'},
                            {label: 'Refill Date', fieldName: 'formatDate', type: 'Date'}, 
                            
                            { type: 'action', typeAttributes: { rowActions: actions } }
                            
                        ]);
                    }   
                }
                
            }
        });
        $A.enqueueAction(action);
        
    },
    // Handles the Click on the new button to route to the New Family Contact Page
    clickNew : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getTabInfo().then(function (tabInfo) {
            var focusedTabId = tabInfo.tabId;
            workspaceAPI.openSubtab({
                parentTabId: focusedTabId,
                url: '/lightning/o/Family_Link_Rx_Medication__c/new?defaultFieldValues=Family__c=' + component.get("v.recordId") + ',Status__c=Active',
                focus: true
            });
        });
    },
    
    handleContactRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        switch (action.name) {
            case 'Edit':
                component.set("v.SelectedRxMedName", row.Name);
                component.set("v.showEditModal",true);
                component.set("v.selectedRxMed",row);
                break;
            case 'Remove':
                component.set("v.showRemoveModal", true);
                component.set("v.selectedRxMed",row);
                break;
        }
    },
    
    closeEditModal : function(component,event,helper) {
        component.set("v.showEditModal",false);
        helper.fetchRxMeds(component,event,helper);
    },
    
    closeRemoveModal: function(component, event, helper){
        component.set("v.showRemoveModal", false);
        helper.fetchRxMeds(component,event,helper);
    },
    
    editRxMedInfo : function(component, event, helper) {
        try {
            var selectedRxMed = component.get("v.selectedRxMed");
            if (selectedRxMed.Pill_Size__c == undefined ){
                selectedRxMed.Pill_Size__c = '';
            }
            if (selectedRxMed.Directions__c == undefined ){
                selectedRxMed.Directions__c = '';
            }
            if (selectedRxMed.Rx_Number__c == undefined ){
                selectedRxMed.Rx_Number__c = '';
            }
            if (selectedRxMed.Pharmacy__c == undefined ){
                selectedRxMed.Pharmacy__c = '';
            }
            if (selectedRxMed.Refill_Date__c == undefined ){
                selectedRxMed.Refill_Date__c = '';
            }
            if (selectedRxMed.Pharmacy_Phone_Number__c == undefined ){
                selectedRxMed.Pharmacy_Phone_Number__c = '';
            }
            if (selectedRxMed.Name != undefined && selectedRxMed.Name != null && selectedRxMed.Name != '') {
                var action = component.get("c.editRxMed");
                action.setParams({
                    "selRxMed": selectedRxMed
                });
                action.setCallback(this, function (r) {
                    if(r.getState() === 'SUCCESS') {
                        var storedResponse = r.getReturnValue();
                        
                        if(storedResponse!=null) {                           
                            component.set("v.selectedRxMed",storedResponse);
                            helper.fetchRxMeds(component,event,helper);
                            component.set("v.showEditModal",false);
                        }
                    } else {
                       
                        helper.onChangePhoneValidation(component, event, helper);
                        
                    }
                });
                $A.enqueueAction(action);
            }
        } catch (ex) {
           
        }
    },
    
    clickRemoveRxMed: function(component, event, helper){
        var selectedRxMed = component.get("v.selectedRxMed");
        var action = component.get("c.removeRxMed");
        action.setParams({
            "selRxMed": selectedRxMed
        });
        action.setCallback(this, function (r) {
            if(r.getState() === 'SUCCESS') {
                var storedResponse = r.getReturnValue();
                
                if(storedResponse!=null) {
                    helper.fetchRxMeds(component,event,helper);
                    component.set("v.showRemoveModal",false);
                }
            } else {
              
            }
        });
        $A.enqueueAction(action);
    },
    
    showRxMeds: function(component, event, helper){
    	component.set("v.showAllRxM", true);
    	component.set("v.lstRxM", component.get("v.fullLstRxM"));
    },
    
    hideRxMeds: function(component, event, helper){
    	component.set("v.showAllRxM", false);
    	component.set("v.lstRxM", component.get("v.shortLstRxM"));
    },
})