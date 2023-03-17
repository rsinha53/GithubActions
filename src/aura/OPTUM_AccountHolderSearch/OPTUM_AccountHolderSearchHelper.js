({  
    // Clear the search details
    clearSearch : function(component, event, helper) {
        component.set("v.SSNValue", "");
        component.set("v.InteractionType", "Phone Call");
        component.set("v.showErrorMessage", "");
      
        var memberFieldsToValidate = component.get("v.memberFieldsToValidate");
        for (var i in memberFieldsToValidate) {
            var fieldElement = component.find(memberFieldsToValidate[i]);
            if (!$A.util.isUndefined(fieldElement)) {
                if (fieldElement.get("v.type") == "date") {
                    if ($A.util.isEmpty(fieldElement.get("v.value"))) {
                        fieldElement.set("v.value", $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
                        fieldElement.setCustomValidity("");
                        fieldElement.reportValidity();
                        fieldElement.set("v.value", null);
                    } else {
                        fieldElement.reportValidity();
                    }
                } else {
                    if ($A.util.isEmpty(fieldElement.get("v.value"))) {
                        fieldElement.set("v.value", "1");
                        fieldElement.setCustomValidity("");
                        fieldElement.reportValidity();
                        fieldElement.set("v.value", null);
                    } else {
                        fieldElement.reportValidity();
                    }
                }
            }
        }
    },
    
    CheckSSNDigits : function(component, event, helper) {
        var inputCmp = component.find("ssn");
        var value = inputCmp.get("v.value");
		if(value != null && value !="undefined" ){
		value = value.trim();
		var valuetrim = value.replace(/-/g, "");
	    component.set("v.SSNValue" ,valuetrim);
		}
        if((valuetrim != null) && !isNaN(valuetrim) && (valuetrim.length > 9)) {
            inputCmp.setCustomValidity("Please provide SSN in correct format (123-45-6789).");
        }
        else if((valuetrim != null) && !isNaN(valuetrim) && (valuetrim.length == 9)) {
            inputCmp.setCustomValidity("");
        }
    },
    
    // Set SSN as per the format
    setSSN : function(component, event, helper) {
        var inputCmp = component.find("ssn");
        var value = inputCmp.get("v.value");
		if(value != null && value !="undefined" ){
		value = value.trim();
		component.set("v.SSNValue" ,value);
		}
         if ((value != null) && isNaN(value)) {
        } else if ((value != null) && !isNaN(value) && (value.length == 9)){
            value = value.substr(0, 3) + '-'+ value.substr(3, 2) + '-'+ value.substr(5, 4);
        }
        component.set("v.SSNValue" ,value);
    },
    
    showResult: function(component ,event, helper){
        component.set("v.showErrorMessage", "");
        helper.setSSN(component, event, helper);
        var action = component.get("c.searchMemberWithSSN");
        var formattedSSN = component.get("v.SSNValue");
        var inputCmp = component.find("ssn");
        
        if(formattedSSN !='' || formattedSSN != null) {
            var ssnPatt=new RegExp("[0-9]{3}-[0-9]{2}-[0-9]{4}");
            if(ssnPatt.test(formattedSSN))
            {
                var SSN = formattedSSN.replace(/-/g, "");
                component.set("v.Spinner", true);
                action.setParams({
                    "ssn": SSN
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
					var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
                    if (component.isValid() && state === "SUCCESS") {
          if(responseValue != null && !($A.util.isUndefinedOrNull(responseValue.result)) && !((Object.keys(responseValue.result).length)==0) && !($A.util.isUndefinedOrNull(responseValue.result.data)) && !((Object.keys(responseValue.result.data).length) == 0)) {
                 component.set("v.Spinner", false);
                 component.set("v.MemberDetails", responseValue.result.data);
                 console.log("Search response", JSON.stringify(response.getReturnValue()));
                 var appEvent = $A.get("e.c:OPTUM_MemberDetailEvent");
                 appEvent.setParams({ "MemberDetails": component.get("v.MemberDetails") });
                 appEvent.fire();
                } else {
                 component.set("v.Spinner", false);
                 component.set("v.MemberDetails", "");
                    if (responseValue != null && !($A.util.isUndefinedOrNull(responseValue.status))) {
                                if (responseValue.status.messages[0].name != 'Success') {
                                    component.set("v.showErrorMessage", responseValue.status.messages[0].description);
                                } else {
                                    var data = responseValue.result.data;
                                    if (Object.keys(data).length === 0) {
                                        component.set("v.showErrorMessage", responseValue.status.messages[0].description);
                                    }
                                }
                    } else {
                            component.set("v.MemberDetails", "");
                            component.set("v.showErrorMessage", "Something went wrong");
                            }
                        }
                    }
                    else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                 component.set("v.Spinner", false); 
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                        alert(errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
                    
                });
                $A.enqueueAction(action);
            }
            
            inputCmp.reportValidity();
        } 
        
        else{
            inputCmp.setCustomValidity("Please provide SSN in correct format (123-45-6789).");
        }
        
    }  
})