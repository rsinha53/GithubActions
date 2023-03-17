({
    
    doInit: function (component, event, helper) {
        var accountDetail = Object.values(component.get("v.memberDetails.accountDetails"));
        helper.callManualAlertApi(component, event, helper);
        helper.getorgInfo(component, event, helper);
        component.set('v.Columns', [
            {label: 'Type', fieldName: 'accountType', type: 'text',initialWidth: 90, cellAttributes : {class : { fieldName : 'customCssClass'}}},
            {label: 'Account No.', fieldName: 'accountId', type: 'text',initialWidth: 120, cellAttributes : {class : { fieldName : 'customCssClass'}}},
            {label: 'Status', fieldName: 'accountStatus', type: 'text',initialWidth: 80},
            {label: 'Available Balance', fieldName: 'availableBalance', type: 'currency',initialWidth: 155, cellAttributes: { alignment: 'left' }},
            {label: 'Investment Total', fieldName: 'investmentTotal', type: 'currency', initialWidth: 145, cellAttributes: { alignment: 'left' }},
            {label: 'Total Balance', fieldName: 'calculatedTotal', type: 'currency',initialWidth: 135, cellAttributes: { alignment: 'left' }},
			{label: ''},
        ]);
            
            helper.updatedAccountList(component, event, helper, accountDetail);
            helper.pushData(component, event, helper);
            component.set("v.data",component.get("v.sortedList"));
            },
            
            
            
            selectRow: function (component, event, helper) {
            var selectedRows = event.getParam("selectedRows");
            component.set("v.SelectedRow",selectedRows);
            helper.fireEventToUpdateAccount(component, event, helper, selectedRows);
            },
            
            FireEvent: function (component, event, helper) {
            helper.fireEventToUpdateAccount(component, event, helper, component.get("v.SelectedRow"));
            },
	//Added by Dimpy for freeze issue		   
	onTabFocused : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
		var dataNew = component.get("v.data");
		component.set("v.data", "");
		component.set("v.data",component.get("v.sortedList"));       
    }
			   
            })