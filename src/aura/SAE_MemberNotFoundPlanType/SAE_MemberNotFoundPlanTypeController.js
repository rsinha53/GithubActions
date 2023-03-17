({
    // US3692809 - Krish - 2nd Aug 2021
    doInit: function(cmp, event, helper){
        helper.addDefaultAutodoc(cmp);
    },
    
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
    
    handleKeyup : function(cmp) {
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
    },
    
    handleComboChange: function (component, event, helper) {
        let selectedOptionValue = event.getParam("value");
        let spanCommercial = component.find("Commercial");
        let spanMedicare = component.find("Medicare");
        let spanMedicaid = component.find("Medicaid");
        let spanOther = component.find("Other");
        // US3692809: Krish - 29th July 2021 - Enabling resolve checkbox for all the selected options in dropdown other than '--None--'
        // if(selectedOptionValue == 'Medicaid' || selectedOptionValue == 'Commercial' || selectedOptionValue == 'Other/Unknown' || selectedOptionValue == 'Medicare')
        if(selectedOptionValue != 'None'){ 
            component.set("v.isResolvedDisabled", false);
            component.set("v.isResolved", true);
        } else {
            component.set("v.isResolvedDisabled", true);
        }
        
        component.set("v.selectedPlanType", selectedOptionValue);

        switch (selectedOptionValue) {
            case 'Commercial':
                $A.util.addClass(spanMedicare, "slds-hide");
                $A.util.addClass(spanMedicaid, "slds-hide");
                $A.util.addClass(spanOther, "slds-hide");
                $A.util.toggleClass(spanCommercial, "slds-hide");
                break;
            case 'Medicare':
                $A.util.addClass(spanCommercial, "slds-hide");
                $A.util.addClass(spanMedicaid, "slds-hide");
                $A.util.addClass(spanOther, "slds-hide");
                $A.util.toggleClass(spanMedicare, "slds-hide");
                break;
            case 'Medicaid':
                $A.util.addClass(spanCommercial, "slds-hide");
                $A.util.addClass(spanMedicare, "slds-hide");
                $A.util.addClass(spanOther, "slds-hide");
                $A.util.toggleClass(spanMedicaid, "slds-hide");
                break;
            case 'Other/Unknown':
                $A.util.addClass(spanCommercial, "slds-hide");
                $A.util.addClass(spanMedicare, "slds-hide");
                $A.util.addClass(spanMedicaid, "slds-hide");
                $A.util.toggleClass(spanOther, "slds-hide");
                break;
            default:
                $A.util.addClass(spanCommercial, "slds-hide");
                $A.util.addClass(spanMedicare, "slds-hide");
                $A.util.addClass(spanMedicaid, "slds-hide");
                $A.util.addClass(spanOther, "slds-hide");
        }       
        
        // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda
        component.set('v.planType', selectedOptionValue);

        // US3692809: Krish - 29th July 2021
        helper.validateForAutodocButton(component);
        
    },
    handleRadioChange: function (component, event, helper) {
        let changedValue = event.getParam("value");
        let CommercialSubSection = component.find("Commercial-Sub");
        let CommercialSubSectionNo = component.find("Commercial-Sub-No");
        
        if(changedValue === 'Yes') {
            $A.util.toggleClass(CommercialSubSection, "slds-hide");
            $A.util.addClass(CommercialSubSectionNo, "slds-hide");
        } else {
            $A.util.toggleClass(CommercialSubSectionNo, "slds-hide");
            $A.util.addClass(CommercialSubSection, "slds-hide");
        } 

        // US3692809: Krish - 29th July 2021
        helper.validateForAutodocButton(component); 
    },
    handleCheckChange: function (component, event, helper) {
        let changedValue = component.get('v.NewbornChkValue');
        let MedicadeSubSection = component.find("Medicaid-Sub");
        if(changedValue) {
            $A.util.toggleClass(MedicadeSubSection, "slds-hide");
        } else {
            $A.util.addClass(MedicadeSubSection, "slds-hide");
        }

        // US3692809: Krish - 29th July 2021
        helper.validateForAutodocButton(component);
    },
    // US1875495 - Malinda
    openModal: function(component, event, helper) {
        helper.openSaveCaseHelper(component, event, helper, true);
    },
    
    savecaseWrapper: function(component, event, helper) {
        var isValidationSuccess = helper.openSaveCaseHelper(component, event, helper, false);
        if(!$A.util.isEmpty(isValidationSuccess) && !isValidationSuccess) {
            return false;
        } else {
            return true;
        }
    },
    
    //US1875495 - Malinda
    closeModal: function(component, event, helper) { 
        component.set("v.isModalOpen", false);
    },
    //US1875495 - Malinda : Case Creation MNF
    wrapperChange : function(component, event, helper) {   
        //let val = component.get('v.caseWrapper');
        //console.log('###MNF-PARAMS:',JSON.stringify(val));
    },
    
    // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda
    alphanumericAndNoSpecialCharacters : function(component, event, helper) {   
        var regex = new RegExp("^[a-zA-Z0-9]+$");
        var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        if (regex.test(str)){             
            return true;
        }else{            
            event.preventDefault();
            return false;
        }
    },
    
    // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda
    allowOnlyNumbers : function(component, event, helper) {
        var regex = new RegExp('^[0-9]+$');
        var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        if (regex.test(str)){             
            return true;
        }else{            
            event.preventDefault();
            return false;
        }
    },
    
    openPreview: function (cmp,event, helper) {
        helper.createPreview(cmp);
        cmp.set("v.isPreviewOpen",true);
    },
    
    createCaseWrapper: function(cmp, event, helper) {
        var autodocUniqueId = event.getParam("autodocUniqueId");
        if(autodocUniqueId == cmp.get("v.autodocUniqueId")) {
            helper.addDefaultAutodoc(cmp);
            helper.createPreview(cmp);
        }
    },
    
    handleResolveCheck: function(cmp, event, helper) {
        helper.addDefaultAutodoc(cmp);
        helper.createPreview(cmp);
    },
    
    //US2356260 - Member Not Found Update to Medicaid Gender Options - Sravan
    handleChange : function(component, event, helper){
        var selectedOptionValue = event.getParam("value");
        component.set("v.genderValue",selectedOptionValue);
        var gender = component.find('Gender');
        if(selectedOptionValue == 'None'){
            gender.setCustomValidity('Complete the field.');
            gender.reportValidity();
        }
        else{
            gender.setCustomValidity('');
            gender.reportValidity();
        }
        // US3692809: Krish - 29th July 2021
        helper.validateForAutodocButton(component);
    },

    /* US3692809: Krish - 29th July 2021
       validateForAutodocButton() Function to validate if all fields of the selected plan type are populated and enable/diable autodoc button
    */
   validateForAutodocButton: function(component, event, helper) {
       helper.validateForAutodocButton(component);
   },
   
    /* US3692809: Krish - 29th July 2021
       fireSaveCaseValidations() Function to validate if all required fields on plan type card are populated on click of overall save case button
    */
   fireSaveCaseValidations: function(component, event, helper){
       var isValidationSuccess = false;
       isValidationSuccess = helper.fireSaveCaseValidations(component, event, helper);
       return isValidationSuccess;
   },

    // DE477294 - Regression PreProd: After saving a case for member not found flow the snapshot is not getting defaulted
    handleAutodocRefresh: function(cmp, event, helper){
        _autodoc.deleteAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId"));
        helper.addDefaultAutodoc(cmp);
        var caseWrapper = cmp.get("v.caseWrapper");
        caseWrapper.savedAutodoc = '';
        caseWrapper.caseItems = [];
        cmp.set("v.caseWrapper", caseWrapper);
        
        cmp.set('v.selectedPlanType','None');
        cmp.set('v.planType','None');
        var planType = cmp.find('provStateId');
        if(!$A.util.isUndefinedOrNull(planType)){
            planType.reportValidity('');
        }
        cmp.set('v.selectedRadioOption','');
        cmp.set('v.MedicareId','');
        cmp.set('v.MedicaidId','');
        cmp.set('v.MedicaidAddress','');
        cmp.set('v.MedicaidZipCode','');
        cmp.set('v.GroupId','');
        cmp.set('v.commercialAltID','');
        cmp.set('v.BabyCIN','');
        cmp.set('v.MotherCIN','');
        cmp.set('v.FamilyID','');
        cmp.set('v.Gender','None');
        cmp.set('v.genderValue','');
        cmp.set('v.isResolvedDisabled','true');
        cmp.set('v.isAutodocDisabled','true');
        cmp.set('v.commentsValue','');
        cmp.set('v.isResolved', 'true');
        
        let spanCommercial = cmp.find("Commercial");
        let spanMedicare = cmp.find("Medicare");
        let spanMedicaid = cmp.find("Medicaid");
        let spanOther = cmp.find("Other");
        $A.util.addClass(spanCommercial, "slds-hide");
        $A.util.addClass(spanMedicare, "slds-hide");
        $A.util.addClass(spanMedicaid, "slds-hide");
        $A.util.addClass(spanOther, "slds-hide");
    }
    
})