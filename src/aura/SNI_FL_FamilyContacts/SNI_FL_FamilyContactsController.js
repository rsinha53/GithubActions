//US2798609_US2798673: Controller for Family Contact
//Author Name : Aarti garg, Vishal Yelisetti
//
({
    doinit : function(component, event, helper) {
        var compType = component.get("v.compType");
        if(compType == "contacts"){
        helper.fetchContacts(component, event, helper);
        
        var action = component.get("c.getUserProfile");
        action.setCallback(this, function(response){
            var stateResponse = response.getState();
            if(stateResponse == 'SUCCESS') {
                var result = response.getReturnValue();
                if((result != undefined && result != '' && result) ){
                    if(result == 'Family Engagement Center - Read Only'){
                        component.set("v.checkReadOnly",false);
                        component.set('v.contactColumns', [
                            {label: 'Name', fieldName: 'linkName', type: 'url',
                             typeAttributes: {label: { fieldName: 'Name' }, target: '_self'}
                            },
                            {label: 'Email', fieldName: 'Email__c', type: 'text'},
                            {label: 'Phone', fieldName: 'formattedPhone', type: 'Phone'} 
                        ]);
                    }
                    else if(result != 'Family Engagement Center - Read Only'){
                        component.set("v.checkReadOnly",true);
                        var actions = [
                            { label: 'Edit', name: 'Edit' },
                            { label: 'Remove', name: 'Remove' }
                        ]
                        component.set('v.contactColumns', [
                            {label: 'Name', fieldName: 'linkName', type: 'url',
                             typeAttributes: {label: { fieldName: 'Name' }, target: '_self'}
                            },
                            {label: 'Email', fieldName: 'Email__c', type: 'text'},
                            {label: 'Phone', fieldName: 'formattedPhone', type: 'Phone'}, 
                            
                            { type: 'action', typeAttributes: { rowActions: actions } }
                            
                        ]);
                    }   
                }
                
            }
        });
        $A.enqueueAction(action);
        }    
        if(compType == "careGiver"){
            helper.fetchCaregivers(component, event, helper);
            var action = component.get("c.getUserProfile");
            action.setCallback(this, function(response){
                var stateResponse = response.getState();
                if(stateResponse == 'SUCCESS') {
                    var result = response.getReturnValue();
                    if((result != undefined && result != '' && result) ){
                        if(result == 'Family Engagement Center - Read Only'){
                            component.set("v.checkReadOnly",false);
                            component.set('v.contactColumns', [
                                {label: 'Name', fieldName: 'linkName', type: 'url',
                                 typeAttributes: {label: { fieldName: 'Name' }, target: '_self'}},
                                {label: 'Preferred Method', fieldName:'Preferred_Method__c' , type: 'text'},
                                {label: 'Email', fieldName: 'Email__c', type: 'text'},
                                {label: 'Phone', fieldName: 'formattedPhone', type: 'Phone'} 
                            ]);
                        }
                        else if(result != 'Family Engagement Center - Read Only'){
                            component.set("v.checkReadOnly",true);
                            var actions = [
                                { label: 'Edit', name: 'Edit' },
                                { label: 'Remove', name: 'Remove' }]
                            component.set('v.contactColumns', [
                                {label: 'Name', fieldName: 'linkName', type: 'url',
                                 typeAttributes: {label: { fieldName: 'Name' }, target: '_self'}},
                                {label: 'Preferred Method', fieldName:'Preferred_Method__c' , type: 'text'},
                                {label: 'Email', fieldName: 'Email__c', type: 'text'},
                                {label: 'Phone', fieldName: 'formattedPhone', type: 'Phone'}, 
                                { type: 'action', typeAttributes: { rowActions: actions } }
                            ]);
                        }   
                    }
                }
            });
            $A.enqueueAction(action);
        }        
    },
    // Handles the Click on the new button to route to the New Family Contact Page
    clickNew : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getTabInfo().then(function (tabInfo) {
            var focusedTabId = tabInfo.tabId;
            workspaceAPI.openSubtab({
                parentTabId: focusedTabId,
                url: '/lightning/o/Family_Contact__c/new?defaultFieldValues=Family__c=' + component.get("v.recordId") + ',Status__c=Active',
                focus: true
            });
        });
    },
    
    handleContactRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        switch (action.name) {
            case 'Edit':
                component.set("v.SelectedFamilyName", row.Name);
                component.set("v.showEditModal",true);
                component.set("v.selectedContact",row);
                break;
            case 'Remove':
                component.set("v.showRemoveModal", true);
                component.set("v.selectedContact",row);
                break;
        }
    },
    
    closeEditModal : function(component,event,helper) {
        component.set("v.showEditModal",false);
        var compType = component.get("v.compType");
        if(compType == 'careGiver'){
            helper.fetchCaregivers(component,event,helper);
        } else {
            helper.fetchContacts(component,event,helper);
        }
    },
    
    closeRemoveModal: function(component, event, helper){
        component.set("v.showRemoveModal", false);
        var compType = component.get("v.compType");
        if(compType == 'careGiver'){
            helper.fetchCaregivers(component,event,helper);
        } else {
            helper.fetchContacts(component,event,helper);
        }
    },
    
    editContactInfo : function(component, event, helper) {
        try {
            var selectedCon = component.get("v.selectedContact");
            if (selectedCon.Phone__c == undefined ){
                selectedCon.Phone__c = '';
            }
            if (selectedCon.Address__c == undefined ){
                selectedCon.Address__c = '';
            }
            if (selectedCon.Relationship__c == undefined ){
                selectedCon.Relationship__c = '';
            }
            if (selectedCon.Email__c == undefined ){
                selectedCon.Email__c = '';
            }
            if(selectedCon.Preferred_Name__c == undefined){
                selectedCon.Preferred_Name__c = '';
            }
            if(selectedCon.Communications__c == undefined){
                selectedCon.Communications__c = '';
            }
            if (selectedCon.Name != undefined && selectedCon.Name != null && selectedCon.Name != '') {
                var action = component.get("c.editContacts");
                action.setParams({
                    "selContact": selectedCon
                });
                action.setCallback(this, function (r) {
                    if(r.getState() === 'SUCCESS') {
                        var storedResponse = r.getReturnValue();
                        if(storedResponse!=null) {
                            component.set("v.selectedContact",storedResponse);
                            if(component.get("v.compType") == 'careGiver'){
                                helper.fetchCaregivers(component,event,helper);
                            } else{
                                helper.fetchContacts(component,event,helper);
                            }
                            component.set("v.showEditModal",false);
                        }
                    } else {
                        helper.onChangePhoneValidation(component, event, helper);
                    }
                });
                $A.enqueueAction(action);
            }
        } catch (ex) {
            //console.log(ex);
        }
    },
    
    clickRemoveContact: function(component, event, helper){
        var selectedCon = component.get("v.selectedContact");
        var action = component.get("c.removeContact");
        action.setParams({
            "selContact": selectedCon
        });
        action.setCallback(this, function (r) {
            if(r.getState() === 'SUCCESS') {
                var storedResponse = r.getReturnValue();
                
                if(storedResponse!=null) {
                    if(component.get("v.compType") == 'careGiver'){
                        helper.fetchCaregivers(component,event,helper);
                    } else{
                        helper.fetchContacts(component,event,helper);
                    }
                    component.set("v.showRemoveModal",false);
                }
            } else {
                //console.log('ERROR');
                //console.log(r.getError());
            }
        });
        $A.enqueueAction(action);
    },
    
    showFamilyContacts: function(component, event, helper){
    	component.set("v.showAllFC", true);
    	component.set("v.lstFC", component.get("v.fullLstFC"));
    },
    
    hideFamilyContacts: function(component, event, helper){
    	component.set("v.showAllFC", false);
    	component.set("v.lstFC", component.get("v.shortLstFC"));
    },
    clickNewCaregiver: function(component, event, helper){
        component.set('v.cgsaved','');
        helper.initialization(component,event);
        component.set("v.showNewCaregiverModal",true);
    },
    closeCareModel: function(component,event,helper){
        component.set("v.showNewCaregiverModal",false);
        if(component.get('v.cgsaved') === 'saved'){
           $A.get('e.force:refreshView').fire(); 
        }
    },
    saveCareModal: function(component,event,helper){
        var nameCmp = component.find('name');
        if(component.get('v.newCont.Name')){
            var buttontype = 'save';
            helper.createNewContact(component,event,buttontype);
        }else{
            nameCmp.setCustomValidity("Complete this field.");
            nameCmp.reportValidity();
        }
    },
    saveNewCareModal: function(component,event,helper){
        var nameCmp = component.find('name');
        nameCmp.setCustomValidity("");
        if(component.get('v.newCont.Name')){
            var buttontype = 'saveandnew';
            helper.createNewContact(component,event,buttontype);
        }else{
            nameCmp.setCustomValidity("Complete this field.");
            nameCmp.reportValidity();
        }
    },
    getDropDowns: function(component, event, helper){
        var isEdit = component.get("v.showEditModal");
        if(isEdit == true){
            helper.getPickListValues(component, 'preferredMethods');
        }
    }
})