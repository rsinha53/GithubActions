({
	onInit : function(component, event, helper) {
		component.set("v.toggleGov", "slds-hide");
	},

    chevToggle : function(component, event, helper) {
        var iconName = component.find("chevInactive").get("v.iconName"); 

		if(iconName === "utility:chevrondown"){
			component.set("v.icon", "utility:chevronright");
			component.set("v.toggleName", "slds-hide");
            
		}else{
			component.set("v.icon", "utility:chevrondown");
			component.set("v.toggleName", "slds-show");
		}
	},

	SubmitCOBUpdate : function(component, event, helper) {
		
		var val = component.get("v.toggleGov"); 
		component.set("v.showHide","show");
        var firstClickCheck = component.get('v.firstClickCheck');
		if(firstClickCheck){
            component.set('v.firstClickCheck',false);
            component.set('v.validationError',true);
            component.set('v.disableProcessBtn',false);            
			component.set("v.toggleGov", "slds-show");
            component.set("v.toggleGovNo", "slds-hide");
        }
		else if(val === "slds-hide"){
            
			component.set("v.toggleGov", "slds-show");
		}else{
            var govOtherInsuranceCarrierName = document.getElementById('govOtherInsuranceCarrierName').value;
            var govRadio = component.get('v.govRadioChange');
            if(/*!govOtherInsuranceCarrierName && */govRadio!='No'){
                //component.set('v.govOtherInsuranceCarrierNameErrorMessage',true);
                component.set('v.validationError',true);
                component.set('v.disableProcessBtn',false);
                component.set("v.toggleGovNo", "slds-show");
            }
            else{
                //component.set('v.govOtherInsuranceCarrierNameErrorMessage',false);
                component.set("v.toggleGov", "slds-hide");
                component.set("v.toggleGovNo", "slds-hide");;
                component.set('v.validationError',false);
                component.set('v.disableProcessBtn',true);
            }
		}
	},
    
    onClear : function(component, event, helper) {
      
		  var radioYeselement  = document.getElementById('rYes');
         if(!$A.util.isEmpty(radioYeselement)){
       radioYeselement.checked = false;
        }
                var radioNoelement  = document.getElementById('rNo');
        if(!$A.util.isEmpty(radioNoelement)){
           radioNoelement.checked = false; 
        }
        // Modify by Hasara 19/07/2021
        component.set("v.toggleGovNo", "slds-hide");
        var govOtherInsuranceCarrierName = document.getElementById("govOtherInsuranceCarrierName");
		govOtherInsuranceCarrierName.value = "";
        
        var govCovType = document.getElementById("govCovType");
		govCovType.value = "None";

		var entitlementReason = document.getElementById("entitlementReason");
		entitlementReason.value = "None";

		//component.set("v.otherInsuranceCarrierName","");
        //component.set("v.covType","None");
        component.set("v.entitlementReason","None");
        component.set("v.effectiveDate","");
        component.set("v.endDate","");
        var tabKey ='#'+component.get("v.AutodocKey")+component.get("v.idValue");
		    $(tabKey).find("input.autodoc").prop("checked", false);
         $(tabKey).find("input.autodoc-case-item-resolved").prop("checked", false);
		var selected = component.get("v.govRadioChange");
        if(selected!='No'){
            component.set('v.validationError',true);
            component.set('v.disableProcessBtn',false);
            //component.set('v.govOtherInsuranceCarrierNameErrorMessage',true);
        }

	},
	
	
	effectiveDateChange : function(component, event, helper) {
		try{
		var ov = component.get("v.effectiveDate");
		const RegExpNumberedCaptureGroups = /([0-9]{4})-([0-9]{2})-([0-9]{2})/

		const matchObj = RegExpNumberedCaptureGroups.exec(ov)

		console.log(matchObj[0]) // "2019-12-31"
		const year = matchObj[1] // 2019
		const month = matchObj[2] // 12
		const day = matchObj[3] // 31

		//alert(`${month}/${day}/${year}`) // "12/31/2019"
		var neweffdate = month+'/'+day+'/'+year;
		component.set("v.newEffectiveDate",neweffdate);
		}catch (error){
		console.log("");

		}
	},

	endDateDateChange : function(component, event, helper) {
		try{
		var ov = component.get("v.endDate");
		const RegExpNumberedCaptureGroups = /([0-9]{4})-([0-9]{2})-([0-9]{2})/

		const matchObj = RegExpNumberedCaptureGroups.exec(ov)

		console.log(matchObj[0]) // "2019-12-31"
		const year = matchObj[1] // 2019
		const month = matchObj[2] // 12
		const day = matchObj[3] // 31

		//alert(`${month}/${day}/${year}`) // "12/31/2019"
		var neweffdate = month+'/'+day+'/'+year;
		component.set("v.newendDate",neweffdate);
		}catch (error){
		console.log("");

		}
	},
    
    onGovRadioChange : function(cmp, evt, helper) {
        var selected = evt.currentTarget.value;
    	cmp.set("v.govRadioChange", selected);
        var govOtherInsuranceCarrierName = document.getElementById('govOtherInsuranceCarrierName').value;
        if(/*!govOtherInsuranceCarrierName && */selected!='No'){
            cmp.set('v.validationError',true);
            cmp.set('v.disableProcessBtn',false);
            //cmp.set('v.govOtherInsuranceCarrierNameErrorMessage',true);
            cmp.set("v.toggleGovNo", "slds-show");
            cmp.set("v.toggleEntitle", "slds-hide");
            //cmp.set('v.disableProcessBtn',false);
        }
        else{
            cmp.set('v.validationError',false);
            cmp.set('v.disableProcessBtn',true);
            //cmp.set('v.govOtherInsuranceCarrierNameErrorMessage',false);
            cmp.set("v.toggleGovNo", "slds-hide");
            
            //cmp.set('v.disableProcessBtn',true);
        }
    } ,
    checkValidation: function(cmp, evt, helper) {
        var selected = cmp.get("v.govRadioChange");
        var govOtherInsuranceCarrierName = document.getElementById('govOtherInsuranceCarrierName').value;
        var govCovType = document.getElementById('govCovType').value;
        var entitlementReason = document.getElementById('entitlementReason').value;
        var primIndicator = document.getElementById('primIndicator').value;
        var effectiveDate = cmp.get("v.effectiveDate");
        
        if(govCovType =='MedicareA' || govCovType =='MedicareAB' || govCovType =='MedicareB'){
            cmp.set("v.toggleEntitle", "slds-show");
            cmp.set('v.benDisable',true);
            document.getElementById('benifitType').value = 'MD';
        }else if(govCovType =='MedicareD'){
            cmp.set("v.toggleEntitle", "slds-show");
            cmp.set('v.benDisable',true);
            document.getElementById('benifitType').value = 'RX';
        }else{
            cmp.set("v.toggleEntitle", "slds-hide");
            cmp.set('v.benDisable',false);
            document.getElementById('benifitType').value = 'None';
            document.getElementById('entitlementReason').value = 'None';
        }
        var tog = cmp.get("v.toggleEntitle");
        console.log('-->'+govOtherInsuranceCarrierName+'-->'+govCovType+'-->'+entitlementReason+'-->'+primIndicator+'-->'+effectiveDate+'--->');
        if(($A.util.isEmpty(govOtherInsuranceCarrierName) || $A.util.isEmpty(govCovType) || $A.util.isEmpty(entitlementReason) || $A.util.isEmpty(primIndicator) || $A.util.isEmpty(effectiveDate) || govCovType =='None' || (tog == 'slds-show' && entitlementReason =='None') || primIndicator =='None' ) && selected!='No'){
            cmp.set('v.validationError',true);
            cmp.set('v.disableProcessBtn',false);
            //cmp.set('v.govOtherInsuranceCarrierNameErrorMessage',true);
        }
        else{
            cmp.set('v.validationError',false);
            cmp.set('v.disableProcessBtn',true);
            //cmp.set('v.govOtherInsuranceCarrierNameErrorMessage',false);
        }
    },
    onsubmitCOBUpdate: function(cmp, evt, helper) {
        var data = cmp.get("v.cobUpData");
        console.log('-->cobData12345--->'+JSON.stringify(data));
        var govOtherInsuranceCarrierName = document.getElementById('govOtherInsuranceCarrierName').value;
        var govCovType = document.getElementById('govCovType').value;
        var entitlementReason = document.getElementById('entitlementReason').value;
        var primIndicator = document.getElementById('primIndicator').value;
        var benifitType = document.getElementById('benifitType').value;
        var effectiveDate = cmp.get("v.effectiveDate");
        var enddate = cmp.find("enddate").get("v.value");
        
        let updateCOBWrapper = {};
        updateCOBWrapper.cobData = true;
        updateCOBWrapper.otherInsuranceIndicator = 'N'; //This is Mandatory
        updateCOBWrapper.otherInsuranceCoverageType = '2'; //This is Mandatory we add 2 because it is goverment type
        updateCOBWrapper.otherInsuranceEffectiveStartDate = effectiveDate;      
        updateCOBWrapper.otherInsuranceEndDate = enddate;
        updateCOBWrapper.otherInsurancePolicyNumber = govOtherInsuranceCarrierName;
        updateCOBWrapper.primacyIndicator = primIndicator;
        updateCOBWrapper.otherInsuranceType = benifitType;
        updateCOBWrapper.entitlementType = govCovType;
        updateCOBWrapper.entitlementTypeReason = entitlementReason;
		
		updateCOBWrapper.memberId = data.memberId;
        updateCOBWrapper.scrId = data.scrId;
        updateCOBWrapper.groupNumber = data.groupNumber;
        updateCOBWrapper.lastName = data.lastName;
        updateCOBWrapper.firstname = data.firstName;
        updateCOBWrapper.middleName = data.mName;
        updateCOBWrapper.nameSuffix = data.suffixName;
        updateCOBWrapper.ssn = window.atob(data.SSN);
        updateCOBWrapper.gender = data.gender;
        updateCOBWrapper.dob = data.dob;
        updateCOBWrapper.relationshipcode = data.relationshipCode;
        console.log('updateCOBWrapper '+JSON.stringify(updateCOBWrapper));
        var action = cmp.get("c.updateMembers");
        
        action.setParams({
            cobData: JSON.stringify(updateCOBWrapper)
        });
        action.setCallback(this,function(a){
            console.log('~~~~----state---'+a);
            var state = a.getState();
            
            if (state == "SUCCESS") {
                var resp = a.getReturnValue();
                var jsonresponse = JSON.parse(resp);
                if(jsonresponse.Success){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Updated successfully.",
                        "type": "success"
                    });
                    toastEvent.fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "We hit a snag.",
                        "message": jsonresponse.Message,
                        "type": "error"
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    }
    
})