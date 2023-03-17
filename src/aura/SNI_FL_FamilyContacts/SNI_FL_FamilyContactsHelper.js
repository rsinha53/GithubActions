///US2798609: Helper js - Family Contacts.
//Author Name : Aarti garg

({
	fetchContacts : function(component, event, intLimit) {

        var action = component.get("c.fetchFamilyContacts");
        action.setParams({
            'recordID':	component.get("v.recordId"),
              "intLimit" : intLimit
            
        });
        
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                    if (record.Phone__c != undefined && record.Phone__c != null && record.Phone__c != ''){
                        record.formattedPhone = (record.Phone__c.length == 10) ? record.Phone__c.replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3'):record.Phone__c;
                    }
                });
                if(records.length > 5){
                	var recordList = [];
                	for(var i = 0; i < 5;i++){
                		recordList.push(records[i]);
                	}
                	component.set('v.lstFC', recordList);
                	component.set('v.shortLstFC', recordList);
                	component.set('v.showAllFC', false);
                } else {
                	component.set('v.lstFC', records);
                }
                component.set("v.File_count",records.length);
                component.set("v.fullLstFC", records);
            }
        });
        
        
        $A.enqueueAction(action);
    }, 
     onChangePhoneValidation: function(component, event, helper){
        //Explicitly checking the custom validation: 
        var phoneCmp = component.find('phone');
        var phoneCmpValue = phoneCmp.get("v.value");
        //Custom regular expression for phone number
        var phoneRegexFormat = "^[0-9]*$";
        //Check for regular expression match with the field value
        if(!phoneCmpValue.match(phoneRegexFormat)) {
            //set the custom error message
            phoneCmp.setCustomValidity("Please enter a valid phone number.");
        } else{
            //reset the error message
            phoneCmp.setCustomValidity("");
        }
        phoneCmp.reportValidity(); 
    },
    fetchCaregivers : function(component, event, helper) {
        var action = component.get("c.fetchFamilyNPCGContacts");
        action.setParams({
            'recordId':	component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                    records.forEach(function(record){
                        record.linkName = '/'+record.Id;
                        if (record.Phone__c != undefined && record.Phone__c != null && record.Phone__c != ''){
                            record.formattedPhone = (record.Phone__c.length == 10) ? record.Phone__c.replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3'):record.Phone__c;
                        }
                    });
                    if(records.length > 5){
                        var recordList = [];
                        for(var i = 0; i < 5;i++){
                            recordList.push(records[i]);
                        }
                        component.set('v.lstFC', recordList);
                        component.set('v.shortLstFC', recordList);
                        component.set('v.showAllFC', false);
                    } else {
                        component.set('v.lstFC', records);
                    }
                    component.set("v.File_count",records.length);
                    component.set("v.fullLstFC", records);
                }
        });
        $A.enqueueAction(action);
    }, 
    createNewContact: function(component,event,buttontype){
        component.set('v.newCont.Family_Account__c',component.get('v.recordId'));
        var action = component.get('c.addNewcareContact');
        action.setParams({
            "caregiver": component.get('v.newCont')
        });
        action.setCallback(this, function (r) {
            let self=this;
            if(r.getState() === 'SUCCESS') {
                var rec = r.getReturnValue();
                var message = 'Family contact "'+rec.Name+'" is created';
                if(buttontype == 'save'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": message
                    });
                    toastEvent.fire();
                    component.set('v.showNewCaregiverModal',false);
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": rec.Id,
                        "slideDevName": "record"
                    });
                    navEvt.fire();
                    self.initialization(component,event);
                    $A.get('e.force:refreshView').fire();
                }
                if(buttontype == 'saveandnew'){
                    self.initialization(component,event);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": message
                    });
                    toastEvent.fire();
                    component.set('v.cgsaved','saved');
                    component.set('v.showNewCaregiverModal',false);
                    setTimeout( function() { 
                        component.set('v.showNewCaregiverModal',true);
                    },100);
                }
            } else {
                self.onChangePhoneValidation(component, event, 'helper');
            }
        });
        $A.enqueueAction(action);
    },
    getPickListValues: function(component, dropDown){
        var action;
        if(dropDown == 'preferredMethods'){
            action = component.get("c.getPreferredMethods");
        }
        var options = [];
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var receivedValues = response.getReturnValue();
                console.log('receivedValues: '+receivedValues);
                if(receivedValues != undefined && receivedValues.length > 0){
                    options.push({
                            label: '--None--',
                            value: ''
                        })
                    for(var i = 0; i < receivedValues.length; i++){
                        options.push({
                            label: receivedValues[i],
                            value: receivedValues[i]
                    	})
                    } 
                }
                if(dropDown == 'preferredMethods'){
                    component.set("v.preferredMethods", options);
                }
            }
        });
        $A.enqueueAction(action);
    },
    initialization: function(component, event){
        component.set('v.newCont.Name','');
        component.set('v.newCont.Email__c','');
        component.set('v.newCont.Phone__c','');
        component.set('v.newCont.Address__c','');
        component.set('v.newCont.Communications__c','');
        component.set('v.newCont.Family_Account__c','');
        component.set('v.newCont.Preferred_Method__c','');
        component.set('v.newCont.Preferred_Name__c','');
        component.set('v.newCont.Primary_caregiver__c',false);
        component.set('v.newCont.Relationship__c','Non-Policy Caregiver');
    }
})