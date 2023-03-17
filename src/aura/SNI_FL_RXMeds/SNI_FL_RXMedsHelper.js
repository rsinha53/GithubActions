({
	fetchRxMeds :  function(component, event, helper) {

        var action = component.get("c.FetchRXMed");
       action.setParams({
            familyId: component.get("v.familyId")
        });
        action.setCallback(this, function(actionResult) {
            var stateResponse = actionResult.getState();
            
            if (stateResponse == "SUCCESS") {
                var result = actionResult.getReturnValue();
                
                result.lstRxMedWrap.forEach(function(record){
                      if (record.PharmacyPhoneNumber != undefined && record.PharmacyPhoneNumber != null && record.PharmacyPhoneNumber != ''){
                    	record.formattedPhone = (record.PharmacyPhoneNumber.length == 10) ? record.PharmacyPhoneNumber.replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3'):record.PharmacyPhoneNumber;
                    }
                    if(record.RefillDate != undefined && record.RefillDate != null){                                             
                        record.formatDate = record.RefillDate.toString();
                        record.formatDate = record.formatDate.split('-')[1] + '/' + record.formatDate.split('-')[2] + '/' + record.formatDate.split('-')[0];
                    }
            
                    
                });
                if(result.DebugMessage != null){ 
                 }
                if (!result.ErrorOccured) {
                    component.set("v.rxMedWrapperList", result.lstRxMedWrap);
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
    setupRxMedsDialog : function(component, event, helper){
        var dataEle = event.target.getAttribute("data-selected-Index");
        var RxMeds = component.get("v.rxMedWrapperList");
       if(RxMeds.length > 0){
            component.set('v.SelectedRxMedID', RxMeds[dataEle].RxMedID);
            var action = component.get("c.getRxMedsBySelectedID");
            var RxMedID = component.get("v.SelectedRxMedID");
           	if(RxMedID != undefined && RxMedID != null){
                action.setParams({
                    "familyRxID": RxMedID
                    
                });
                action.setCallback(this, function (r) {
                    if(r.getState() === 'SUCCESS') {
                        var storedResponse = r.getReturnValue();
                        if(storedResponse!=null) {
                            if(!storedResponse.ErrorOccured){
                                component.set("v.SelectedRxMedName",storedResponse.selectedRxMed);
                                var RxMedRecord = component.get("v.SelectedRxMedName");
                               	component.set("v.selectedRxMed",RxMedRecord.RxName);
                                component.set('v.EditMode', true);
                                component.find("EditRxMedName").set("v.value", RxMedRecord.RxName);
                               	component.find("EditRxMedPillSize").set("v.value", RxMedRecord.PillSize);
                                component.find("EditRxMedDirections").set("v.value", RxMedRecord.Directions);
                               	component.find("EditRxMedRxNumber").set("v.value", RxMedRecord.RxNumber);
                                component.find("EditRxMedRefillDate").set("v.value", RxMedRecord.RefillDate);
                                component.find("EditRxMedPharmacy").set("v.value", RxMedRecord.Pharmacy);
                                component.find("EditRxMedPharmacyPhone").set("v.value", RxMedRecord.PharmacyPhoneNumber);
                                
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
    
    validateRxMedsFields: function(component, event, helper){
         
        var isNoErrors = true;
    	var nameCmp = component.find('RxMedName');
        var strName= nameCmp.get('v.value');
        var phoneCmp= component.find('RxMedPharmacyPhone');
     
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
                //set the custom error message
                phoneCmp.setCustomValidity("Please enter valid phone number.");
                isNoErrors = false;
            } else{
                //reset the error message
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
    updateRxMeds: function(component,event,helper){
        var RXID = component.get("v.SelectedRxMedID");
        var action = component.get("c.updateRxMedsByID");
       	if(RXID != undefined && RXID != null){
            action.setParams({
                "rxID": RXID,
                "RxName" : component.find("RxMedName").get("v.value"),
                "RxPillSize" : component.find("RxMedPillSize").get("v.value"),
                "rxDirections" : component.find("RxMedDirections").get("v.value"),
                "rxNum" : component.find("RxMedRxNumber").get("v.value"),
                "rxRefillDate" : component.find("RxMedRefillDate").get("v.value"),
                "rxPharmacyAdd" : component.find("RxMedPharmacy").get("v.value"),
                "RxPharmacyPhone" : component.find("RxMedPharmacyPhone").get("v.value")
            });
            action.setCallback(this, function (r) {
                if(r.getState() === 'SUCCESS') {
                    var storedResponse = r.getReturnValue();
                    if(storedResponse!=null) {
                        if(!storedResponse.ErrorOccured){
                            component.set('v.isUpdated',storedResponse);
                            if(component.get('v.isUpdated') === true){
                                component.set('v.EditMode',false);
                                helper.fetchRxMeds(component,event,helper);
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
    loadRemoveDialog : function(component,event,helper){
         var dataEle = event.target.getAttribute("data-selected-Index");
        var RxMeds = component.get("v.rxMedWrapperList");
       if(RxMeds.length > 0){
            component.set('v.SelectedRxMedID', RxMeds[dataEle].RxMedID);
            var action = component.get("c.getRxMedsBySelectedID");
            var RxMedID = component.get("v.SelectedRxMedID");
           	if(RxMedID != undefined && RxMedID != null){
                action.setParams({
                    "familyRxID": RxMedID
                    
                });
                
           action.setCallback(this, function (r) {
                if(r.getState() === 'SUCCESS') {
                    var storedResponse = r.getReturnValue();
                    if(storedResponse!=null) {
                        if(!storedResponse.ErrorOccured){
                             component.set("v.SelectedRxMedName",storedResponse.selectedRxMed);
                            var RxMedRecord = component.get("v.SelectedRxMedName");
                            component.set("v.selectedRxMed",RxMedRecord.RxName);
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
    },
    RemoveRxMed :function(component,event, helper){
        var action = component.get("c.deleteRxMedByID");
       var RXID = component.get("v.SelectedRxMedID");
        if(RXID != undefined && RXID != null){
            action.setParams({
                "rxID": RXID
                });
            action.setCallback(this, function (r) {
                if(r.getState() === 'SUCCESS') {
                    var storedResponse = r.getReturnValue();
                    if(storedResponse!=null) {
                        if(!storedResponse.ErrorOccured){
                            component.set('v.isDeleted',storedResponse);
                            if(component.get('v.isDeleted') === true){
                                component.set('v.DeleteMode',false);
                                helper.fetchRxMeds(component,event,helper);
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
    
});