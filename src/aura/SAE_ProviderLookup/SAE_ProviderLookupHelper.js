({
    getProviderSearchResults: function (cmp, event) {
        var prvLookupInputs = cmp.get("v.prvLookupInputs");
        var policyDetails = cmp.get("v.policyDetails");
        prvLookupInputs.memType = '';
        if(!$A.util.isEmpty(policyDetails) && !$A.util.isEmpty(policyDetails.resultWrapper)){
            prvLookupInputs.memType = policyDetails.resultWrapper.policyRes.isMedicarePlan ? 'MR' : policyDetails.resultWrapper.policyRes.isComPlan ? 'EI' : policyDetails.resultWrapper.policyRes.isMedicaidPlan ? 'CS': '';
        }
        // US1965220 - Thanish - 17th Jan 2020
        if (this.validateInputs(cmp, event)) {
            if (!cmp.get("v.isSearchEnabled")) {
                //US2573718 - Auto Doc When No Results Are Displayed - Sravan
                cmp.set("v.policyChange",true);
                // US2718112 - Thanish - 2nd Jul 2020
                var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
                if(!caseNotSavedTopics.includes("Provider Lookup")){
                    caseNotSavedTopics.push("Provider Lookup");
                }
                cmp.set("v.caseNotSavedTopics", caseNotSavedTopics);
                
                cmp.find("providerResultsId").set("v.isTrue", true);
                
                setTimeout(function () {
                    //US2670819: Provider Lookup - Fixes Praveen
                    //cmp.find("providersearch").getElement().scrollIntoView(false);
                    cmp.find("providersearch").getElement().scrollIntoView({
                        behavior: 'smooth',
                        block: 'center'
                    });
                    cmp.set("v.isSearchEnabled", true);
                }, 100);
            } else {
                //US2573718 - Auto Doc When No Results Are Displayed - Sravan
                cmp.set("v.policyChange",false);
                var childComp = cmp.find("searchResults");
                childComp.searchLookups();
                //US2670819: Provider Lookup - Fixes Praveen
                cmp.find("providerlookupsearchresults").getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'center'
                });
            }
        }
    },
    getProviderTypeOptions: function (cmp) {
        var TypeOptionsArray = ["Facility", "Physician"];
        var TypeOptions = [];
        TypeOptions.push({
            label: '--None--',
            value: ''
        });
        for (var i = 0; i < TypeOptionsArray.length; i++) {
            TypeOptions.push({
                label: TypeOptionsArray[i],
                value: TypeOptionsArray[i]
            });
        }
        cmp.set('v.providerTypeOptions',TypeOptions);
    },
    
    getGenderOptions: function (cmp) {
        var genOptionsArray = ["Male", "Female"];
        var genOptions = [];
        genOptions.push({
            label: '--None--',
            value: ''
        });
        for (var i = 0; i < genOptionsArray.length; i++) {
            genOptions.push({
                label: genOptionsArray[i],
                value: genOptionsArray[i]
            });
        }
        cmp.set('v.genderOptions',genOptions);
    },
    getRatingOptions: function (cmp) {
        var ratingOptionsArray = ["5 Stars", "4 Stars and Above", "3 Stars and Above", "2 Stars and Above", "1 Star and Above"];
        var ratingOptions = [];
        ratingOptions.push({
            label: '--None--',
            value: ''
        });
        for (var i = 0; i < ratingOptionsArray.length; i++) {
            ratingOptions.push({
                label: ratingOptionsArray[i],
                value: ratingOptionsArray[i]
            });
        }
        cmp.set('v.ratingOptions',ratingOptions);
    },
    
    getRadiusOptions: function (cmp) {
        var radiusOptionsArray = ["1","2","5","10","20","30","50"];
        var radiusOptions = [];
        radiusOptions.push({
            label: '--None--',
            value: ''
        });
        for (var i = 0; i < radiusOptionsArray.length; i++) {
            radiusOptions.push({
                label: radiusOptionsArray[i],
                value: radiusOptionsArray[i]
            });
        }
        cmp.set('v.radiusOptions',radiusOptions);
    },
    
    
    getBenefitLevelOptions: function (cmp) {
        // Sanka US2344866
        var benefitLevelArray = ["All","Tier 1","INN"];
        var benefitOptions = [];
        // benefitOptions.push({
        //     label: 'select',
        //     value: ''
        // });
        for (var i = 0; i < benefitLevelArray.length; i++) {
            benefitOptions.push({
                label: benefitLevelArray[i],
                value: benefitLevelArray[i]
            });
        }
        cmp.set('v.benefitLevelValues',benefitOptions);
    },
    
    clearLookupDetails : function(cmp){
        debugger;
        var prvLookupInputs = cmp.get("v.prvLookupInputs");
        prvLookupInputs.memType = '';
        prvLookupInputs.speciality = "Select";
        prvLookupInputs.planType = "Select";
        
        cmp.set("v.prvLookupInputs",prvLookupInputs);
        var hospAffilId = cmp.find("hospAffilId");
        var genderId = cmp.find("genderId");
        var deaId = cmp.find("deaId");
        var languageId = cmp.find("languageId");
        var patientReviewId = cmp.find("patientReviewId");
        var careGroupId = cmp.find("careGroupId");
        var grpPacticeId = cmp.find("grpPacticeId");
        //var benefitLevelId = cmp.find("benefitLevelId");
        var acceptNewPatentId = cmp.find("acceptNewPatentId");
        var AcceptExistPatientId = cmp.find("AcceptExistPatientId");
        var FreeStandFacilityId = cmp.find("FreeStandFacilityId");
        var preferredLabId = cmp.find("preferredLabId");
        var includeInacProvId = cmp.find("includeInacProvId");
        
        /*if(benefitLevelId != undefined){
 benefitLevelId.set("v.value","");
}*/
        this.populateDefaultValues(cmp);
        
        if (hospAffilId != undefined || genderId != undefined || deaId != undefined ||
            patientReviewId != undefined || careGroupId != undefined || grpPacticeId != undefined ||
            acceptNewPatentId != undefined || AcceptExistPatientId != undefined || FreeStandFacilityId != undefined || preferredLabId != undefined ||
            includeInacProvId != undefined) {
            hospAffilId.set("v.value", "");
            genderId.set("v.value", "");
            deaId.set("v.value", "");
            patientReviewId.set("v.value", "");
            careGroupId.set("v.value", "");
            grpPacticeId.set("v.value", "");
        }
        if (acceptNewPatentId != undefined)
            acceptNewPatentId.set("v.checked", false);
        
        if (AcceptExistPatientId != undefined)
            AcceptExistPatientId.set("v.checked",false);
        
        if (FreeStandFacilityId != undefined)
            FreeStandFacilityId.set("v.checked",false);
        
        if (preferredLabId != undefined)
            preferredLabId.set("v.checked",false);
        
        if (includeInacProvId != undefined) {
            includeInacProvId.set("v.checked", false);
        }
        if (!$A.util.isEmpty(languageId)) {
            languageId.resetField();
        }
        
        cmp.find('taxId').set("v.value", "");
        cmp.find('lastNameId').set("v.value", "");
        cmp.find('npiId').set("v.value", "");
        cmp.find('firstNameId').set("v.value", "");
        cmp.find('providerId').set("v.value", "");
        cmp.find('phoneId').set("v.value", "");
        cmp.find('providerTypeId').set("v.value", "");
        cmp.find('zipCodeId').set("v.value", "");
        cmp.find('radiusId').set("v.value", "");
        cmp.find('specialityId').resetField();
        cmp.set('v.prvLookupInputs.state','');
        //cmp.find('stateId').resetField();
        //cmp.find('planTypeId').resetField();
        
        // US1965220 - Vinay
        cmp.set("v.showErrorMessage", false);
        
        // US1965220 - Thanish - 23rd Jan 2020
        // remove error messages when clear button clicked ...
        cmp.find('taxId').reportValidity();
        cmp.find('npiId').reportValidity();
        cmp.find("providerId").reportValidity();
        cmp.find("zipCodeId").reportValidity();
        cmp.find("phoneId").reportValidity();
        cmp.set("v.disableRadius",true);
        
        var childComp = cmp.find("searchResults");
        if (childComp != null && childComp != undefined) {
            // childComp.searchLookups();
            // US2931847
            childComp.clearTable();
        }
        
        cmp.set("v.selectedRadioValue",'Basic');
        cmp.set('v.disableFields',true);
        cmp.set('v.languageDisable',false);
        cmp.set("v.checked", !cmp.get("v.checked")); //DE411244
        
    },
    populateDefaultValues: function (cmp) {
        debugger;
        var coverageData = cmp.get("v.policyDetails");
        var policies = cmp.get("v.policyList");
        var policySelectedIndex = cmp.get("v.policySelectedIndex");
        var selectedpolicy = policies[policySelectedIndex];
        var benefitValue = '';
        var sourceCode = '';
        var uhcProduct = '';

        //US2973232
        var isTier1 = false;
        if(!$A.util.isUndefinedOrNull(cmp.get("v.isTierOne")) && cmp.get("v.isTierOne")){
            cmp.set("v.prvLookupInputs.benefitLevel", 'Tier 1');
            isTier1 = true;
        }
        if(!$A.util.isEmpty(coverageData)){
            if(!$A.util.isEmpty(coverageData.resultWrapper.policyRes.sourceCode)){
                sourceCode = coverageData.resultWrapper.policyRes.sourceCode;
            }
            if(!isTier1){//US2973232
            if(!$A.util.isEmpty(selectedpolicy) && !$A.util.isEmpty(coverageData.resultWrapper)){
                if(coverageData.resultWrapper.policyRes.coverageLevel == '1'){
                    if((!$A.util.isEmpty(selectedpolicy.deductibleInfo) && selectedpolicy.deductibleInfo.individual.inNetworkTier1.customerNetworkTier1) || (!$A.util.isEmpty(selectedpolicy.outOfPocketInfo) && selectedpolicy.outOfPocketInfo.individual.inNetworkTier1.customerNetworkTier1)) {
                        benefitValue = 'Tier 1';
                    } else if((!$A.util.isEmpty(selectedpolicy.deductibleInfo) && selectedpolicy.deductibleInfo.individual.inNetwork.found) || (!$A.util.isEmpty(selectedpolicy.outOfPocketInfo) && selectedpolicy.outOfPocketInfo.individual.inNetwork.found)) {
                        benefitValue = 'INN';
                    } else {
                        benefitValue = 'All';
                    }
                } else {
                    if((!$A.util.isEmpty(selectedpolicy.deductibleInfo) && selectedpolicy.deductibleInfo.family.inNetworkTier1.customerNetworkTier1) || (!$A.util.isEmpty(selectedpolicy.outOfPocketInfo) && selectedpolicy.outOfPocketInfo.family.inNetworkTier1.customerNetworkTier1)) {
                        benefitValue = 'Tier 1';
                    } else if((!$A.util.isEmpty(selectedpolicy.deductibleInfo) && selectedpolicy.deductibleInfo.family.inNetwork.found) || (!$A.util.isEmpty(selectedpolicy.outOfPocketInfo) && selectedpolicy.outOfPocketInfo.family.inNetwork.found)) {
                        benefitValue = 'INN';
                    } else {
                        benefitValue = 'All';
                    }
                }
            }else{
                benefitValue = 'All';
            }
            cmp.set("v.prvLookupInputs.benefitLevel", benefitValue);
            }



            var stateValue = '';
            var zipValue = '';
            var planType = '';
            if(selectedpolicy != undefined){
                console.log('state::'+selectedpolicy.patientInfo.State);
                stateValue = selectedpolicy.patientInfo.State;
                zipValue = selectedpolicy.patientInfo.Zip;
                planType = selectedpolicy.PolicyName;
                uhcProduct = selectedpolicy.PolicyName +' '+'/'+' '+coverageData.resultWrapper.policyRes.productType;
            }
            cmp.set("v.disablePlanType",true);
            //US2670819 - ProviderLookup Fixes - Sravan - Start
            //cmp.set("v.prvLookupInputs.state",stateValue);
            cmp.set("v.stateValue",stateValue);
            //US2670819 - ProviderLookup Fixes - Sravan - End
            cmp.set("v.zipValue", zipValue);
            cmp.set("v.uhcProduct",uhcProduct);
        }
        if(cmp.get("v.boolIsProviderLookupFromReferral")){
            cmp.set("v.prvLookupInputs.benefitLevel", 'INN');
            cmp.set("v.prvLookupInputs.providerType",'Physician');
        }
        cmp.set("v.sourceCode",sourceCode);
        var appEvent = $A.get("e.c:ACET_SendPolicyDetailsToCS");
        appEvent.setParams({
            "sourceCode" : sourceCode
        });
        appEvent.fire();
        
    },
    
    switchBasicAdvaced : function(cmp,event, radioButtonSelected){

        //ADDED BY RAJESH US2006160 01/14/2021
		if(!cmp.get("v.checked"))
        cmp.set("v.selectedRadioValue",'Basic');
        else
        cmp.set("v.selectedRadioValue",'Advanced');
        var selectRadio = cmp.get("v.selectedRadioValue");
        //ENDED BY RAJESH US2006160 01/14/2021
        //cmp.set("v.selectedRadioValue", selectRadio);
        if(selectRadio == 'Basic'){
            cmp.set('v.disableFields',true);
            cmp.set('v.languageDisable',false);
        }else if(selectRadio == 'Advanced'){
            cmp.set('v.disableFields',false);
            cmp.set('v.languageDisable',true);
        }
        
    },
    showPolicySpinner: function (component) {
        var spinner = component.find("policy-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },     
    hidePolicySpinner: function (component) {
        var spinner = component.find("policy-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    wrapperResults : function(cmp,event,helper){
        var prvLookupInputs = {
            "benefitLevel": "All",
            "taxId": "",
            "lastName": "",
            "hospAffil": "",
            "gender": "",
            "npi": "",
            "firstName": "",
            "dea": "",
            "language": "Select",
            "providerId": "",
            "phone": "",
            "careGroupName": "",
            "ssn": "",
            "patientReview": "",
            "providerType": "",
            "state": "Select",
            "speciality": "Select",
            "zipCode": "",
            "grpPracticeNum": "",
            "planType": "Select",
            "radius": "",
            "memType":""
        };
        cmp.set("v.prvLookupInputs", prvLookupInputs);
    },
    
    // US1965220 - Thanish - 17th Jan 2020
    // returns false if the inputs are invalid and true when inputs are valid
    validateInputs : function(cmp, event) {
        debugger;
        let prvLookupInputs = cmp.get("v.prvLookupInputs");
        var speciality = prvLookupInputs.speciality;
        if(!$A.util.isEmpty(prvLookupInputs.taxId) || !$A.util.isEmpty(prvLookupInputs.npi) || !$A.util.isEmpty(prvLookupInputs.providerId) ||
           !$A.util.isEmpty(prvLookupInputs.lastName) || speciality != "Select") {
            if(speciality != "Select" ) { // && $A.util.isEmpty(prvLookupInputs.zipCode) && $A.util.isEmpty(prvLookupInputs.radius)){
                if($A.util.isEmpty(prvLookupInputs.zipCode) && $A.util.isEmpty(prvLookupInputs.radius) ){
                    
                    // populate error
                    let error = {};
                    error.message = "We hit a snag.";
                    error.topDescription = "Search criteria must include";
                    error.descriptionList = ["Zip Code","Radius"];
                    error.bottomDescription = "";
                    cmp.set("v.error", error);
                    cmp.set("v.showErrorMessage", true);
                    // expand the error popup
                    setTimeout(function() {
                        cmp.find("errorPopup").showPopup();
                    }, 100);
                    return false;                    
                } 
                else{
                    cmp.set("v.showErrorMessage", false);
                    return true;
                }
            }
            else{
                // find bad inputs ... (add any extra inputs needed checking validity here)
                let badInputList = [];
                
                //US2782815 - Avish
                if(!cmp.find("taxId").checkValidity()) { badInputList.push("Tax ID");cmp.find("taxId").reportValidity(); }
                if(!cmp.find("npiId").checkValidity()) { badInputList.push("NPI");cmp.find("npiId").reportValidity() }
                if(!cmp.find("providerId").checkValidity()) { badInputList.push("Provider ID");cmp.find("providerId").reportValidity() }
                if(!cmp.find("zipCodeId").checkValidity()) { badInputList.push("Zip Code");cmp.find("zipCodeId").reportValidity() }
                if(!cmp.find("phoneId").checkValidity()) { badInputList.push("Phone");cmp.find("phoneId").reportValidity() }
                //US2782815 - Ends

                if(badInputList.length == 0) {
                    // inputs are valid ...
                    cmp.set("v.showErrorMessage", false);
                    return true;
                    
                } else {
                    // populate error
                    let error = {};
                    error.message = "We hit a snag.";
                    error.topDescription = "Review the following fields";
                    error.descriptionList = badInputList;
                    error.bottomDescription = "";
                    cmp.set("v.error", error);
                    cmp.set("v.showErrorMessage", true);
                    // expand the error popup
                    setTimeout(function() {
                        cmp.find("errorPopup").showPopup();
                    }, 100);
                    return false;
                }
            }
            // return true;
        }
        // if the function is called from search button, populate the following error message ...
        else if((event.keyCode === 13) || event.getSource().get("v.name") == "searchButtonName") { //US2782815 - Avish
            // populate error
            let error = {};
            error.message = "We hit a snag.";
            error.topDescription = "Search criteria must include either";
            error.descriptionList = ["Tax ID", "NPI", "Provider ID", "Last Name or Facility/Group", "Specialty"];
            error.bottomDescription = "Additional fields may be included to help narrow results";
            cmp.set("v.error", error);
            cmp.set("v.showErrorMessage", true);
            // expand the error popup
            setTimeout(function() {
                cmp.find("errorPopup").showPopup();
            }, 100);
            
            return false;
        }
        // if the function is not called from search button, do not show error message 'Search criteria must include either' ...
            else {
                cmp.set("v.showErrorMessage", false);
                return false;
            }
    },
	
	 getProductCodesRecords: function(component,event,helper){
        debugger;
        var action = component.get("c.getSAEProductCodes");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var productCodeData = response.getReturnValue();
                component.set("v.productCodesMap",productCodeData.productCodeMap);
                component.set("v.productCodesList",productCodeData.productCodesList);  
            }
        });
        $A.enqueueAction(action);   
    },
    
    // US2931847
    refreshDefaultValues: function (cmp, event, helper) {
        if (!$A.util.isEmpty(cmp.get("v.searchObject"))) {
            cmp.set("v.populatedFromHeader", true);
            var searchObject = cmp.get("v.searchObject");
            var prvLookupInputs = cmp.get("v.prvLookupInputs");
            prvLookupInputs.taxId = searchObject.taxId;
            prvLookupInputs.lastName = searchObject.lastName;
            prvLookupInputs.npi = searchObject.npi;
            prvLookupInputs.firstName = searchObject.firstName;
            prvLookupInputs.providerType = searchObject.filterType == 'P' ? 'Physician' : 'Facility';
            cmp.set("v.prvLookupInputs", prvLookupInputs);

            cmp.find("providerResultsId").set("v.isTrue", true);
            var childComp = cmp.find("searchResults");
            childComp.autoLaunch(searchObject.addressId);

        }
    }

})