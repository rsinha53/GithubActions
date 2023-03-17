({
    init: function (component, event, helper) {
        var actions = [
            { label: 'Delete', name: 'delete' }
        ];
         component.set('v.relatedListcolumns', [
            { label: 'Case Number', fieldName: 'linkName', type: 'url', typeAttributes: { label: { fieldName: 'CaseNumber' }, target: '_blank' } },
            { label: 'Case Name', fieldName: 'CaseName', type: 'text' },
            { label: 'Case Origin', fieldName: 'CaseOrigin', type: 'text' },
            { label: 'Status', fieldName: 'CaseStatus', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions } }     
        ]);
               
        var action = component.get("c.showAssociatedCasesRelatedList");
        action.setParams({
            "thisCaseId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                resultData.forEach(function (record1) {             
                    record1.linkName = '/' + record1.CaseId;
                });
                component.set("v.data", resultData);
            }
        });
        $A.enqueueAction(action);
    },
    openModel: function (component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
        component.set("v.disableAddBtn", true);
        component.set('v.columns', [
            { label: 'Case Number', fieldName: 'linkName', type: 'url', typeAttributes: { label: { fieldName: 'CaseNumber' }, target: '_blank' } },
            { label: 'Case Name', fieldName: 'Case_Name__c', type: 'text' },
            { label: 'Case Origin', fieldName: 'Origin', type: 'text' },
            { label: 'Status', fieldName: 'Status', type: 'text' }
        ]);
        var action = component.get("c.fetchMemberCases");
        action.setParams({
            caseId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                records.forEach(function (record) {
                    record.linkName = '/' + record.Id;
                });
                component.set("v.caseLst", records);
                if (records.length === 0) {
                    component.set("v.disableAddBtn", true);
                }
            } else {
                console.log("error");
            }
        });
        $A.enqueueAction(action);
    },

    closeModel: function (component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },

    submitDetails: function (component, event, helper) {
        // Set isModalOpen attribute to false
        component.set("v.isModalOpen", false);
        component.set("v.isLoading", true);// this line added by Ravi teja 
        var selectedRows = component.get('v.selectedRows');
        if (selectedRows == null) {
            component.set("v.disableAddBtn", true);
        } else {
            component.set("v.disableAddBtn", false);
            var action = component.get("c.addAssociatedCase");
            action.setParams({
                csLst: selectedRows,
                thisCaseId: component.get("v.recordId")
            });
            action.setCallback(this, function (response) {
                component.set("v.isLoading", false);// this line added by Ravi teja 
                var state = response.getState();
                if (state === "SUCCESS") {
                    var message = response.getReturnValue();
                    if (message == 'success') {
                        helper.showSuccess(component, event, helper);
                        $A.get('e.force:refreshView').fire();
                    } else {
                        helper.showError(component, event, helper);
                    }
                } else {
                    helper.showError(component, event, helper);
                }
            });
            $A.enqueueAction(action);
        }
    },

    updateSelectedText: function (component, event) {
		var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedRows', selectedRows);
        component.set('v.selectedRowsCount', selectedRows.length);
        if(selectedRows.length > 0){
            component.set("v.disableAddBtn", false);
        }else{
            component.set("v.disableAddBtn", true);
        }
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var recId = row.id;
        switch (action.name) {
            case 'delete':
                helper.deleteRecord(component, event);
                break;
        }
    }
})