({
    fetchAccounts: function(component, event, helper) {
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
        var action = component.get("c.getAccountList");
        action.setParams({
            "userId": component.get('v.userInfo').Id
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var storeResponse = response.getReturnValue();
                var retAccts = storeResponse.famList;
                var acctList = [];
                var mapKeys = [];
                for(var i = 0; i < retAccts.length; i++){
                	var account = {
            			'Family_ID__c': retAccts[i].FamilyID,
            			'Name': retAccts[i].Name,
            			'Assigned_Advisor__c': retAccts[i].AssignedAdvisor,
            			'Family_Status__c': retAccts[i].FamilyStatus,
                	}
                	acctList.push(account);
                	mapKeys.push(retAccts[i].AccountId);
                }
                component.set('v.accountList', acctList);
                component.set('v.accountMap', storeResponse.accountMap);
                component.set('v.mapKeys', mapKeys);
            }
            $A.util.removeClass(spinner, "slds-show");
        	$A.util.addClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action);
	},
    handleSort: function(component, event, helper) {
        var sortedBy = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');

        var cloneData = component.get('v.accountList').slice(0);
        cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));
        
        component.set('v.accountList', cloneData);
        component.set('v.sortDirection', sortDirection);
        component.set('v.sortedBy', sortedBy);
    },
    sortBy: function(field, reverse, primer) {
        var key = primer
            ? function(x) {
                  return primer(x[field]);
              }
            : function(x) {
                  return x[field];
              };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
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
    },
})