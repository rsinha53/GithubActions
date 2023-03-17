({
	doInit: function(component, event, helper) {
        component.set('v.accountColumns',[
            {label: 'Family ID', fieldName: 'Family_ID__c', type: 'text', sortable: true},
            {label: 'Account Name', fieldName: 'Name', type: 'text', sortable: true},
            {label: 'Account Owner', fieldName: 'Assigned_Advisor__c', type: 'text', sortable: true},
            {label: 'Status', fieldName: 'Family_Status__c', type: 'text', sortable: true}
        ]);
		var action = component.get("c.getUser");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var storeResponse = response.getReturnValue();
                component.set('v.userInfo', storeResponse);
                helper.fetchAccounts(component, event, helper);
            }
        });
        $A.enqueueAction(action);
	},
    handleAccountSort: function(component, event, helper) {
        helper.handleSort(component, event, helper)
    },
    updateEHUB: function(component, event, helper){
    	component.set('v.displayMessageBool', false);
    	var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    	var counter = 0;
    	var successes = 0;
    	var keys = component.get('v.mapKeys');
        var acctMap = component.get('v.accountMap');
        if(keys != undefined && keys != null){
            if(keys.length == 0){
                $A.util.removeClass(spinner, "slds-show");
                $A.util.addClass(spinner, "slds-hide");
            } else {
                for(var i = 0; i < keys.length; i++){
                    var designation = '';
                    var item = acctMap[keys[i]];
                    if(item.acctInfo != undefined && item.acctInfo != null && item.acctInfo.Family_Overview__r != undefined 
                       && item.acctInfo.Family_Overview__r != null && item.acctInfo.Family_Overview__r.length > 0 
                       && item.acctInfo.Family_Overview__r[0].Designation__c != undefined && item.acctInfo.Family_Overview__r[0].Designation__c != null){
                        designation = item.acctInfo.Family_Overview__r[0].Designation__c;
                    }
                    var action = component.get("c.sendToEHUB");
                    action.setParams({
                        "acctWrap": acctMap[keys[i]],
                        "famOverDesignation": designation
                    });
                    action.setCallback(this,function(response){
                        var state = response.getState();
                        if(state == 'SUCCESS'){
                            var storeResponse = response.getReturnValue();
                            if(storeResponse.statusCode == 200 || storeResponse.statusCode == 201){
                                successes = successes + 1;
                            }
                        }
                        counter = counter + 1;
                        if(counter == keys.length){
                            component.set('v.displayMessageBool', true);
                            var displayMsg = '';
                            if(successes == 0){
                                displayMsg = 'Update unsuccessful. ' + successes + ' out of ' + keys.length + ' records transferred to EHUB.';
                            } else {
                                displayMsg = 'Update successful. ' + successes + ' out of ' + keys.length + ' records transferred to EHUB.'
                            }
                            component.set('v.displayMessage', displayMsg);
                            $A.util.removeClass(spinner, "slds-show");
                            $A.util.addClass(spinner, "slds-hide");
                            if(successes == counter){
                                helper.fireToastMessage("Success!", 'Records successfully synced with EHUB.', "success", "dismissible", "10000");
                            } else {
                                helper.fireToastMessage("Error!", 'EHUB Update failed. Please refresh the page and try again.', "error", "dismissible", "10000");
                            }
                            helper.fetchAccounts(component, event, helper);
                        }
                        
                    });
                    $A.enqueueAction(action);
                }
            }
    	}
    },
    refreshAccountList: function(component, event, helper){
    	component.set('v.displayMessageBool', false);
		helper.fetchAccounts(component, event, helper);
    },
})