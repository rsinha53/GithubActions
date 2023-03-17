({
    doInit: function (cmp, event, helper) {
        var providerDetails = {
            "taxIdOrNPI": "",
            "npi": "",
            "taxId": "",
            "contactName": "",
            "contactNumber": "", //US2291039 - Avish
            "contactExt": "",	//US2291039 - Avish
            "filterType": "Both",
            "firstName": "",
            "lastName": "",
            "searchOption": "",
            "state": "",
            "zip": "",
            "phone": "",
            "practicingStatus": "Active"
        };
        cmp.set("v.providerDetails", providerDetails);
        helper.getStateOptions(cmp);
        helper.getFilterTypeOptions(cmp);
        helper.getPracticeStatusOptions(cmp);
    },
    
    openSerProvRecords: function (cmp, event, helper) {
        
    },
    
    closeSerProvRecords: function (cmp, event, helper) {
        cmp.set("v.displayServiceProvider", false);
    },
    
    sendProdToMember: function (cmp, event, helper) {
        var holdContactName = cmp.get("v.holdContactName");
        cmp.set("v.providerSelected", false);
        cmp.set("v.searchPrvResults", "");
        cmp.set("v.providerResults", null);
        helper.sendProviderDetails(cmp);
        cmp.set("v.providerNotFound", false);
        cmp.set("v.isMemSearchDisabledFromPrv", false);
        var appEventProdToMem = $A.get("e.c:SAE_ProviderToMember");
        
        //var conName = cmp.find("contactNameAI");
        //var conNameval = conName.get('v.value');
        var providerDetails = cmp.get("v.providerDetails");
        var conNameval = providerDetails.contactName;
        
        // US416376
        var noProdCheck = cmp.get("v.isProviderSearchDisabled");
        appEventProdToMem.setParams({
            "contactName":conNameval, 
            "isChecked":noProdCheck,
            "contactNumber":providerDetails.contactNumber,
            "contactExt":providerDetails.contactExt,
        });   
        appEventProdToMem.fire();
        cmp.set("v.providerDetails.contactName",holdContactName);

        // US1699139 - Continue button - Sanka
        cmp.set("v.validFlowProvider", noProdCheck);
        //qq
        cmp.set("v.IsValidSearch", true);
    },

    getRowInfoFromResults: function (cmp, event, helper) {
        
        cmp.set("v.providerSelected", true);
        cmp.set("v.searchPrvResults", "");
        
        var selectedProviderDetails = event.getParam('selectedProviderDetails');
        
        var providerDetails = cmp.get("v.providerDetails");
        selectedProviderDetails.contactName = providerDetails.contactName;
        
        cmp.set("v.selectedProviderDetails", selectedProviderDetails);
        var facilityName = selectedProviderDetails.firstName;
        var postalAddress = selectedProviderDetails.postalAddress;
        var taxId = selectedProviderDetails.taxId;
        var totalRow = facilityName + '.,' + postalAddress + '.,' + taxId;
        cmp.set("v.searchPrvResults", totalRow);
        // US1699139 - Continue button - Sanka
        cmp.set("v.validFlowProvider", true);
    },

    sendProviderDetailsToCmps: function (cmp, event, helper) {
        var appEvent = $A.get("e.c:SAE_SetProviderDetailsAE");
        var providerDetails = cmp.get("v.providerDetails");
        var providerNotFound = cmp.get("v.providerNotFound");
        if (providerNotFound) {
            if (providerDetails.taxIdOrNPI.length == 9) {
                providerDetails.taxId = providerDetails.taxIdOrNPI;
                providerDetails.npi = "";
            } else if (providerDetails.taxIdOrNPI.length == 10) {
                providerDetails.npi = providerDetails.taxIdOrNPI;
                providerDetails.taxId = "";
            }
        }
        var selectedProviderDetails = cmp.get("v.selectedProviderDetails");
        if (!$A.util.isEmpty(selectedProviderDetails)) {
            selectedProviderDetails.contactName = providerDetails.contactName;
            selectedProviderDetails.contactNumber = providerDetails.contactNumber;
            selectedProviderDetails.contactExt = providerDetails.contactExt;
        }
        console.log(JSON.parse(JSON.stringify(providerDetails)));
        //providerDetails.contactName = cmp.set("v.providerContactName");
        var providerPhoneNumber = providerDetails.phone;
        var providerPhoneNumberFormat = "";
        if (!$A.util.isEmpty(providerPhoneNumber) && providerPhoneNumber.includes("-")) {
            providerPhoneNumberFormat = providerPhoneNumber.substring(0, 3) + '-' + providerPhoneNumber.substring(3, 6) + '-' + providerPhoneNumber.substring(6, 10);
            providerDetails.phone = providerPhoneNumberFormat;
        }
        if (event.getParam("requestedCmp") == "AuthenticateCall") {
            appEvent.setParams({
                // US1671978 - Sanka
                "providerValidated": helper.checkValidation(cmp, event, helper),
                "providerDetails": providerNotFound ? providerDetails : selectedProviderDetails,
                "searchedProviderDetails": cmp.get("v.providerResults.PhysicianFacilitySummary0002Response"),
                "isProviderSearchDisabled": cmp.get("v.isProviderSearchDisabled"),
                "providerNotFound": providerNotFound,
                "providerSelected": cmp.get("v.providerSelected")
            });
        } else {
            appEvent.setParams({
                "providerDetails": providerNotFound ? providerDetails : selectedProviderDetails,
                "isProviderSearchDisabled": cmp.get("v.isProviderSearchDisabled"),
                "providerSelected": cmp.get("v.providerSelected")
            });
        }
        appEvent.fire();
    },

    checkMandatoryFields: function (cmp, event, helper) {
		if (event.getSource().get("v.label") != "Contact Name") {
            cmp.set("v.providerSelected", false);
            cmp.set("v.searchPrvResults", "");
            cmp.set("v.providerResults", null);
            helper.sendProviderDetails(cmp);
            cmp.set("v.refineSearchCriteria", "");
        }
         // US2039716 - Thanish - 19th Sept 2019
        var providerDetails = cmp.get("v.providerDetails");
        
        //providerDetails.contactName = cmp.get("v.providerContactName");
        
        cmp.set("v.providerDetails", providerDetails);
        
        // US2039716 - Thanish - 23th Sept 2019
        if(!$A.util.isEmpty(cmp.find("filterType"))){
            cmp.set("v.providerType", cmp.find("filterType").get("v.value"));
        } 
        //US2039716 - Thanish - 19th Sept 2019
        
        helper.checkMandatoryFields(cmp, event);
        var fieldName = event.getSource().get("v.name");
        // US1671978 - Sanka
        if (fieldName == "providerPhoneNumber" || fieldName == "providerContactNumber" || fieldName == "contactExt") { //US2291039 - Avish
            helper.keepOnlyDigits(cmp, event);
        }
        if(fieldName == "contactName"){
            helper.keepOnlyText(cmp, event);
        }
        _setandgetvalues.setContactValue('exploreContactData',providerDetails.contactName,providerDetails.contactNumber,providerDetails.contactExt);
    },

    showOrHideAdvancedSearch: function (cmp, event, helper) {
        debugger;
        var eventSource = event.target;
        var linkName = eventSource.innerHTML;
        if (linkName == "Show Advanced Search") {
            eventSource.innerHTML = "Hide Advanced Search";
            cmp.set("v.isAdvancedSearch", true);
            helper.clearFieldValidations(cmp, event);
        } else if (linkName == "Hide Advanced Search") {
            eventSource.innerHTML = "Show Advanced Search";
            cmp.set("v.isAdvancedSearch", false);
        }
    },

    searchProvider: function (cmp, event, helper) {
        // US1671978 - Sanka
        if (helper.checkValidation(cmp, event, helper)) {
            // call web service
            helper.showProviderSpinner(cmp);
            helper.searchProvider(cmp, event,helper);
        }
    },

    clearFieldValidationsAndValues: function (cmp, event, helper) {

        // US1699139 - Continue button - Sanka
        cmp.set("v.validFlowProvider", false);

        helper.clearFieldValues(cmp, event);
        helper.clearFieldValidations(cmp, event);
		cmp.set("v.isAdvancedSearch", false);
        cmp.set("v.providerNotFound", false);
		cmp.set("v.responseProviderNotFound", false);
        cmp.set("v.isMemSearchDisabledFromPrv", false);
        cmp.find("searchTypeAi").getElement().innerHTML = "Show Advanced Search";
        
        cmp.set("v.searchPrvResults", "");
        cmp.set("v.providerResults", null);
        helper.sendProviderDetails(cmp);
        cmp.set("v.refineSearchCriteria", "");
        _setandgetvalues.setContactValue('exploreContactData','','','');
    },

    handleProviderNotFound: function (cmp, event, helper) {

        cmp.set("v.providerSelected", false);
        cmp.set("v.searchPrvResults", "");
        cmp.set("v.providerResults", null);
        helper.sendProviderDetails(cmp);
        cmp.set("v.refineSearchCriteria", "");
        if(cmp.get("v.providerNotFound")){
            cmp.set("v.providerDetails.phone", cmp.get("v.providerDetails.contactNumber"));
        }
        /*if (event.getSource().get("v.checked")) {
            cmp.set("v.isMemSearchDisabledFromPrv", true);
        } else {
            cmp.set("v.isMemSearchDisabledFromPrv", false);
        }*/
        helper.checkMandatoryFields(cmp, event);
    },

    onChangeZip: function (cmp, event, helper) {
       
        cmp.set("v.providerSelected", false);
        cmp.set("v.searchPrvResults", "");
        cmp.set("v.providerResults", null);
        cmp.set("v.refineSearchCriteria", "");
        helper.sendProviderDetails(cmp);
        helper.keepOnlyDigits(cmp, event);
    },

   
    handleOnchange: function (cmp, event, helper) {
        cmp.set("v.providerSelected", false);
        cmp.set("v.searchPrvResults", "");
        cmp.set("v.providerResults", null);
        helper.sendProviderDetails(cmp);
        cmp.set("v.refineSearchCriteria", "");
    },

    onChangeContactName: function (cmp, event, helper) {
        helper.keepOnlyText(cmp, event);
    },

    search: function(component, event, helper) {
     	 var searchResults = component.get("v.providerResults");
        var searchKeyWord = component.get("v.searchPrvResults");
        var timer = component.get('v.timer');
        var appEvent = $A.get("e.c:SAE_ProviderSearchResultsEvent");
        clearTimeout(timer);
        var timer = setTimeout(function () {
            
            appEvent.setParams({
                "searchKeyWord": searchKeyWord,
                "providerResults":searchResults
            });
            appEvent.fire();
            clearTimeout(timer);
            component.set('v.timer', null);
            

        }, 500);
        component.set('v.timer', timer);
         
     },
    enableResultsAfterClear : function(component, event, helper){
        debugger;
        helper.sendProviderDetails(component);
    },
    handleConNameFromMemToProd : function (component, event, helper) {
        debugger;
        component.set("v.holdContactName",event.getParam("value"));
    },

    /**
     * To Handle VCCD Application Event .
     *
     * @param objComponent To access dom elements.
     * @param objEvent To handle events.
     * @param objHelper To handle events.
     */
    handleVCCDEvent : function (objComponent, objEvent, objHelper) {
        let strMessage = objEvent.getParam("message");
        if($A.util.isUndefinedOrNull(strMessage) === false && strMessage !== '') {
            try {
                let objMessage = JSON.parse(strMessage);
                objComponent.set("v.providerDetails.contactNumber",objMessage.objRecordData.Ani__c);
                objComponent.set("v.providerDetails.taxIdOrNPI",objMessage.objRecordData.TaxId__c);
                objEvent.stopPropagation();
            } catch (exception) {
                console.log('Inside VCCD Handle Exception' + exception);
            }
        }
    },

});