({
	setComponent : function(component,event,helper,value, componentName) {
      	component.set("v.displayedTab", value);
	},
    validateContactFields: function(component, event, helper){
    	var isNoErrors = true;
    	var selectedCon = component.get('v.selectedContact');
    	var phoneCmp = component.find('contactPhone');
		var nameCmp = component.find('contactName');
    	phoneCmp.setCustomValidity("");
    	phoneCmp.reportValidity(); 
    	nameCmp.setCustomValidity("");
    	nameCmp.reportValidity(); 
    	if(selectedCon.Name != undefined && selectedCon.Name != null && selectedCon.Name.trim() != '') {
    		//Explicitly checking the custom validation: 
            var phoneCmp = component.find('contactPhone');
            var phoneCmpValue = phoneCmp.get("v.value");
            //Custom regular expression for phone number
            var phoneRegexFormat = "^[0-9]*$";
            //Check for regular expression match with the field value
            if(!phoneCmpValue.match(phoneRegexFormat)) {
                //set the custom error message
                phoneCmp.setCustomValidity("Please enter valid phone number.");
                isNoErrors = false;
            } else{
                //reset the error message
                phoneCmp.setCustomValidity("");
            }
            phoneCmp.reportValidity();
    	} else {
    		isNoErrors = false;
    		nameCmp.setCustomValidity("Complete this field.");
    		nameCmp.reportValidity();
    	}
    	return isNoErrors;
    },
    validateRxMedsFields: function(component, event, helper){
        
        
        var isNoErrors = true;
    	var selectedRxMed = component.get('v.selectedRxMed');
    	var phoneCmp = component.find('RxMedPharmacyPhone');
		var nameCmp = component.find('RxMedName');
    	phoneCmp.setCustomValidity("");
    	phoneCmp.reportValidity(); 
    	nameCmp.setCustomValidity("");
    	nameCmp.reportValidity(); 
        if(selectedRxMed.Name != undefined && selectedRxMed.Name != null && selectedRxMed.Name.trim() != '') {
           
    		//Explicitly checking the custom validation: 
            var phoneCmp = component.find('RxMedPharmacyPhone');
            var phoneCmpValue = phoneCmp.get("v.value");
            //Custom regular expression for phone number
            var phoneRegexFormat = "^[0-9]*$";
            //Check for regular expression match with the field value
            if(!phoneCmpValue.match(phoneRegexFormat)) {
                //set the custom error message
                phoneCmp.setCustomValidity("Please enter valid phone number.");
                isNoErrors = false;
            } else{
                //reset the error message
                phoneCmp.setCustomValidity("");
            }
            phoneCmp.reportValidity();
    	} else {
    		isNoErrors = false;
    		nameCmp.setCustomValidity("Complete this field.");
    		nameCmp.reportValidity();
    	}
    
    	return isNoErrors;
    },
    checkIfMobileDevice: function(component, event, helper){
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
                 //console.log(result.DebugMessage);
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
    fetchRxMed :function(component, event, helper) {
        console.log('in fetch rx meds function');
        var action = component.get("c.FetchRXMed");
        action.setParams({
          familyId: component.get("v.familyId")
        });
        action.setCallback(this, function(actionResult) {
          var stateResponse = actionResult.getState();
          console.log(stateResponse);
          if (stateResponse == "SUCCESS") {
            var result = actionResult.getReturnValue();
            result.lstRxMedWrap.forEach(function(record){
                 if (record.PharmacyPhoneNumber != undefined && record.PharmacyPhoneNumber != null && record.PharmacyPhoneNumber != ''){
                    	record.formattedPhone = record.PharmacyPhoneNumber.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
                    }
                    if(record.RefillDate != undefined && record.RefillDate != null){                                             
                        record.formatDate = record.RefillDate.toString();
                        record.formatDate = record.formatDate.split('-')[1] + '/' + record.formatDate.split('-')[2] + '/' + record.formatDate.split('-')[0];
                    }
            });
              if(result.DebugMessage != null){ 
                 console.log(result.DebugMessage);
              }
            if (!result.ErrorOccured) {
              component.set("v.RxMedWrapperList", result.lstRxMedWrap);
            } else {
              console.log(result.ErrorMessage);
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
    fetchmembers : function(component, event, helper) {
        var action = component.get("c.getMembers");
        action.setParams({
            familyId: component.get("v.familyId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                    var lables= [];
                     result.forEach(function(key) {
                         lables.push({"label":key.membName ,"value":key.membId});
                     });
                     component.set("v.options", lables);
                     component.set("v.recursiveCheck", false);
            }else {
                  var urlEvent = $A.get("e.force:navigateToURL");
                  urlEvent.setParams({
                    url: "/error"
                  });
                  urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
	},
    UploadFinished: function(component, event, helper) {
        var uploadedFiles = event.getParam("files");  
        var ids=new Array();
        for (var i= 0 ; i < uploadedFiles.length ; i++){
            ids.push(uploadedFiles[i].documentId);
        }
        var idListJSON=JSON.stringify(ids);
        var familyId = component.get("v.familyId");
        var action = component.get("c.getUpdatedDocs");
        action.setParams({  
            "uploadedFilesIds": idListJSON,
            "familyId": familyId,
            "RecordID":component.get('v.recordId'),
            "selectedName" : component.get('v.recordName')
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();
            if(state=='SUCCESS'){  
                var result = response.getReturnValue(); 
                component.set("v.familydocwrap", result);
            }else {
                  var urlEvent = $A.get("e.force:navigateToURL");
                  urlEvent.setParams({
                    url: "/error"
                  });
                  urlEvent.fire();
            }
        });  
        $A.enqueueAction(action);
    }
})