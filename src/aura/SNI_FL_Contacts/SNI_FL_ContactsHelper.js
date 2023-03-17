({
    fetchContacts: function(component, event, helper) {
        var action = component.get("c.getContacts");
        action.setParams({
            familyId: component.get("v.familyId")
        });
        action.setCallback(this, function(actionResult) {
            var stateResponse = actionResult.getState();
            
            if (stateResponse == "SUCCESS") {
                var result = actionResult.getReturnValue();
                result.lstcontactWrap.forEach(function(contact){
                    if (contact.contactPhone != undefined && contact.contactPhone != null && contact.contactPhone != ''){
                        contact.contactFormattedPhone = (contact.contactPhone.length == 10) ? contact.contactPhone.replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3'):contact.contactPhone;
                    }
                });
                if(result.DebugMessage != null){ 
                   
                }
                if (!result.ErrorOccured) {
                    component.set("v.contactWrapperList", result.lstcontactWrap);
                } else {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        url: "/error"
                    });
                    urlEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
        },
    
    RemoveFamilyContact : function(component,event, helper){
        var action = component.get("c.deleteContactsByID");
        var fcID = component.get("v.SelectedFamilyContactID");
        if(fcID != undefined && fcID != null){
            action.setParams({
                "familyContactID": fcID
            });
            action.setCallback(this, function (r) {
                if(r.getState() === 'SUCCESS') {
                    var storedResponse = r.getReturnValue();
                    if(storedResponse!=null) {
                        if(!storedResponse.ErrorOccured){
                            component.set('v.isDeleted',storedResponse);
                            if(component.get('v.isDeleted') === true){
                                component.set('v.DeleteMode',false);
                                helper.fetchContacts(component,event,helper);
                            }
                            
                        }else {
                            var urlEvent = $A.get("e.force:navigateToURL");
                            urlEvent.setParams({
                                url: "/error"
                            });
                            urlEvent.fire();
                        }
                    }
                }
            });
            $A.enqueueAction(action);
        }
        
    },
    
    setupEditDialog: function(component, event, helper){
        var dataEle = event.target.getAttribute("data-selected-Index");
        var familyContacts = component.get("v.contactWrapperList");
        if(familyContacts.length > 0){
            component.set('v.SelectedFamilyContactID', familyContacts[dataEle].contactID);
            var action = component.get("c.getContactsBySelectedID");
            var fcID = component.get("v.SelectedFamilyContactID");
            if(fcID != undefined && fcID != null){
                action.setParams({
                    "familyContactID": fcID
                });
                action.setCallback(this, function (r) {
                    if(r.getState() === 'SUCCESS') {
                        var storedResponse = r.getReturnValue();
                        if(storedResponse!=null) {
                            if(!storedResponse.ErrorOccured){
                                component.set("v.SelectedFamilyContact",storedResponse.selectedFamilyContacts);
                                var familyContact = component.get("v.SelectedFamilyContact");
                                component.set("v.SelectedFamilyName",familyContact.contactName);
                                component.set('v.EditMode', true);
                                component.find("EditcontactName").set("v.value", familyContact.contactName);
                                component.find("EditcontactPhone").set("v.value", familyContact.contactPhone);
                                component.find("EditcontactEmail").set("v.value", familyContact.contactEmail);
                                component.find("EditcontactRelationship").set("v.value", familyContact.contactRelationship);
                                component.find("EditcontactAddress").set("v.value", familyContact.contactAddress);
                                
                            }else {
                                var urlEvent = $A.get("e.force:navigateToURL");
                                urlEvent.setParams({
                                    url: "/error"
                                });
                                urlEvent.fire();
                            }
                        }
                    }
                });
                $A.enqueueAction(action);
            }
            
        }
    },
    
    validateContacts: function(component,event,helper){
        var isNoErrors = true;
        var nameCmp = component.find('contactName');
        var strName = nameCmp.get('v.value');
 		var phoneCmp= component.find('contactPhone');        
       
        phoneCmp.setCustomValidity("");
        phoneCmp.reportValidity(); 
        nameCmp.setCustomValidity("");
        nameCmp.reportValidity(); 
        if(strName != undefined && strName != null && strName.trim() != '') {
            var phoneCmpValue = phoneCmp.get("v.value");
          if(phoneCmpValue !=null)
            {
            var phoneRegexFormat = "^[0-9]*$";
            if(!phoneCmpValue.match(phoneRegexFormat)) {
                phoneCmp.setCustomValidity("Please enter valid phone number.");
                isNoErrors = false;
            } else{
                phoneCmp.setCustomValidity("");
            }
            phoneCmp.reportValidity();
            } 
    	} else {
            isNoErrors = false;
            nameCmp.setCustomValidity("Complete this field.");
            nameCmp.reportValidity();
        }
        return isNoErrors;
    },
    
    updateContacts: function(component,event,helper){
        var action = component.get("c.updateContactsByID");
        var fcID = component.get("v.SelectedFamilyContactID");
        if(fcID != undefined && fcID != null){
            action.setParams({
                "familyContactID": fcID,
                "contactName" : component.find("contactName").get("v.value"),
                "contactEmail" : component.find("contactEmail").get("v.value"),
                "contactRelationship" : component.find("contactRelationship").get("v.value"),
                "contactAddress" : component.find("contactAddress").get("v.value"),
                "contactPhone" : component.find("contactPhone").get("v.value")
            });
            action.setCallback(this, function (r) {
                if(r.getState() === 'SUCCESS') {
                    var storedResponse = r.getReturnValue();
                    if(storedResponse!=null) {
                        if(!storedResponse.ErrorOccured){
                            component.set('v.isUpdated',storedResponse);
                            if(component.get('v.isUpdated') === true){
                                component.set('v.EditMode',false);
                                helper.fetchContacts(component,event,helper);
                            }
                        }else {
                            var urlEvent = $A.get("e.force:navigateToURL");
                            urlEvent.setParams({
                                url: "/error"
                            });
                            urlEvent.fire();
                        }
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    checkIfMobileDevice : function(component, event, helper){
        var isMobile = false;
        if (navigator.userAgent.match(/Android/i) 
            || navigator.userAgent.match(/webOS/i) 
            || navigator.userAgent.match(/iPhone/i)  
            || navigator.userAgent.match(/iPad/i)  
            || navigator.userAgent.match(/iPod/i) 
            || navigator.userAgent.match(/BlackBerry/i) 
            || navigator.userAgent.match(/Windows Phone/i)) { 
            isMobile = true; 
        } else {
            isMobile = false; 
        }
        component.set('v.isMobileDevice', isMobile);
    },
    
    loadRemoveDialog : function(component,event,helper){
        var dataEle = event.target.getAttribute("data-selected-Index");
        var familyContacts = component.get("v.contactWrapperList");
        if(familyContacts.length > 0){
            component.set('v.SelectedFamilyContactID', familyContacts[dataEle].contactID);
            var action = component.get("c.getContactsBySelectedID");
            var fcID = component.get("v.SelectedFamilyContactID");
                if(fcID != undefined && fcID != null){
            action.setParams({
                "familyContactID": fcID
            });
            action.setCallback(this, function (r) {
                if(r.getState() === 'SUCCESS') {
                    var storedResponse = r.getReturnValue();
                    if(storedResponse!=null) {
                        if(!storedResponse.ErrorOccured){
                            component.set("v.SelectedFamilyContact",storedResponse.selectedFamilyContacts);
                            var familyContact = component.get("v.SelectedFamilyContact");
                            component.set("v.SelectedFamilyName",familyContact.contactName);
                            component.set('v.DeleteMode',true);                            
                        }else {
                            var urlEvent = $A.get("e.force:navigateToURL");
                            urlEvent.setParams({
                                url: "/error"
                            });
                            urlEvent.fire();
                        }
                    }
                }
            });
            $A.enqueueAction(action);    
                }
        }
    }
});