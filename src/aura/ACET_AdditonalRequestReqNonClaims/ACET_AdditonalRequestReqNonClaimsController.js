({
    onLoad : function(component, event, helper) {

    },

	handleDoesNotChange : function(component, event, helper) {
		let objEvent = event.getParams();
		if(objEvent && objEvent.checked) {
            component.set("v.isPaymentAmountDisabled", true);
            component.set("v.isDoesNotKnowChecked", true);
            component.find('idPaymentAmount').checkValidity();
            component.find('idPaymentAmount').reportValidity();
		} else {
            component.set("v.isPaymentAmountDisabled", false);
            component.set("v.isDoesNotKnowChecked", false);
		}

	},

    handleTatChange : function(component, event, helper) {
        component.find('tatId').checkValidity();
        component.find('tatId').reportValidity();

	},

	handleKeyup : function(cmp) {
        cmp.set("v.showDefaultLength",false);
        var inputCmp = cmp.find("commentsBoxId");
        var value = inputCmp.get("v.value");
        var max = 2000;
        var remaining = max - value.length;
        cmp.set('v.charsRemaining', remaining);
        var errorMessage = 'Error!  You have reached the maximum character limit.  Add additional comments in Case Details as a new case comment.';
        if (value.length >= 2000) {
            inputCmp.setCustomValidity(errorMessage);
            inputCmp.reportValidity();
        } else {
            inputCmp.setCustomValidity('');
            inputCmp.reportValidity();
        }
        /*if($A.util.isEmpty(inputCmp.get('v.value'))){            
            inputCmp.setCustomValidity("This field is required");
            inputCmp.reportValidity();
        }*/
    },

    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },

    handlePaymentAmount : function(cmp, event) {
        if(cmp.get("v.strPaymentAmount") != '' && cmp.get("v.strPaymentAmount") != undefined && cmp.get("v.strPaymentAmount") != null){
            let amount = Number(cmp.get("v.strPaymentAmount"));
            cmp.set("v.strPaymentAmount", (amount/100));
        }
    },

    createCase : function(cmp, event) {
        //Validating Additional Request Fields
        //US3182779 - Sravan - Start
       
        var tat=cmp.find("tatId");
        var Comment=cmp.find("commentsBoxId");
        if($A.util.isEmpty(tat.get('v.value'))){            
            tat.setCustomValidity("This field is required");
            tat.reportValidity();
        }
        if($A.util.isEmpty(Comment.get('v.value'))){            
            Comment.setCustomValidity("This field is required");
            Comment.reportValidity();
        }
        
        var subType = cmp.get("v.facetsReasonCategory");
        var pholder = cmp.get("v.objCOBInfo");
        if(subType == 'COB Request'){
            if(!$A.util.isEmpty(pholder) && !$A.util.isEmpty(pholder.phDOB) && !$A.util.isEmpty(pholder.OthEffDate2)){
                
                if(pholder.phDOB >= pholder.OthEffDate2){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "We hit a snag.",
                        "message": "Policy Holder DOB must be before the policy term date",
                        "type": "error",
                        "mode": "dismissible",
                        "duration": "10000"
                    });
                    toastEvent.fire();
                    return true;
                }else{
                    cmp.set("v.showSpinnerForFacetsSubmit",true);
                    var cmpEvent = cmp.getEvent("createFacetsCase");
                    cmpEvent.fire();   
                }
               
            } 
            
        }else{
           
            var cmpEvent = cmp.getEvent("createFacetsCase");
            cmpEvent.fire();
        }
        
        
        
        /*var tatValue = cmp.get("v.strTatProvided");
        var commentsValue = cmp.get("v.strComments");
        var tatCmp = cmp.find('tatId');
        var commentsCmp = cmp.find('commentsBoxId');
        if($A.util.isUndefinedOrNull(tatValue) || $A.util.isEmpty(tatValue)){
            tatCmp.setCustomValidity("Complete this field.");
            tatCmp.reportValidity();
            cmp.set("v.showSpinnerForFacetsSubmit",false);
            cmp.set("v.additionalFieldsValidation",true);
        }
        else{
            cmp.set("v.additionalFieldsValidation",false);
        }

        if($A.util.isUndefinedOrNull(commentsValue) || $A.util.isEmpty(commentsValue)){
            commentsCmp.setCustomValidity("Complete this field.");
            commentsCmp.reportValidity();
            cmp.set("v.showSpinnerForFacetsSubmit",false);
            cmp.set("v.additionalFieldsValidation",true);
        }
        else{
            cmp.set("v.additionalFieldsValidation",false);
        }*/
        //US3182779 - Sravan - End
        //var cmpEvent = cmp.getEvent("createFacetsCase");
        //cmpEvent.fire();
    },

    onchngValue : function(cmp, event, helper) {
        var ID=event.getSource().getLocalId();
             var auraID=cmp.find(ID);
              if(!$A.util.isEmpty(auraID.get('v.value'))){
                 auraID.setCustomValidity("  ");
                  auraID.setCustomValidity("");
                }
               else
                  auraID.setCustomValidity("This field is required");
               auraID.reportValidity();
               if(ID=="idPaymentAmount"){
               if( auraID.get('v.value') <= 0)
                   cmp.set('v.strPaymentAmount','');
               }
    },
    
    checkValue : function(cmp, event, helper) {
        var field=cmp.find("idPaymentAmount");
        var expectedAmount = field.get('v.value');
        if(!$A.util.isEmpty(expectedAmount)){
            var charcount = (expectedAmount.split(".").length - 1);
            if(charcount > 1){
                field.setCustomValidity("Enter a valid value.");
            }else{
                field.setCustomValidity("  ");
                field.setCustomValidity("");
            }
            field.reportValidity();
        }
        
    },

    allowOnlyNumbers: function(component, event, helper){
        var dateCode = (event.which) ? event.which : event.keyCode;
         if(dateCode !=46 && dateCode > 31 && (dateCode < 48 || dateCode > 57)){
            if(event.preventDefault){
                event.preventDefault();
            }else{
                event.returnValue = false;
            }
        }
    },
})