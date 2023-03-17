({
	onLoad : function(component, event, helper) {
		helper.getProductCodesRecords(component, event, helper);
        helper.wrapperResults(component, event, helper);
		helper.getProviderTypeOptions(component, event, helper);
        helper.getGenderOptions(component, event, helper);
        helper.getRatingOptions(component, event, helper);
        helper.getRadiusOptions(component, event, helper);
        helper.getBenefitLevelOptions(component, event, helper);
        //US2931847
		if (!component.get("v.isProviderSnapshot")) {
            helper.populateDefaultValues(component);
            //Sanka
            component.set("v.policyChange", true);
        }
        if (component.get("v.isProviderSnapshot")) {
            component.set('v.showAndHideBenefitLevelSec', true);
        }

        // US2931847 - Sanka
        if (component.get("v.populatedFromHeader") && !component.get("v.isProviderSnapshot")) {
            helper.refreshDefaultValues(component, event, helper);
        }

        // US1965220 - Thanish - 24th Jan 2020
        // initializing error object ...
        let error = new Object();
        error.message = "";
        error.topDescription = "";
        error.bottomDescription = "";
        error.descriptionList = [];
        component.set("v.error", error);
    },
	
	refreshProviderLookupDetails: function (cmp, event, helper) {
        cmp.find("providerResultsId").set("v.isTrue", false); // US2718112 - Thanish - 2nd Jul 2020
        cmp.set("v.isSearchEnabled", false); // US2718112 - Thanish - 2nd Jul 2020
        helper.clearLookupDetails(cmp);
        //Sanka -US2931847
        cmp.set("v.policyChange", true);

        helper.populateDefaultValues(cmp);
        cmp.set("v.selectedRadioValue", 'Basic');
        cmp.set('v.disableFields', true);
        cmp.set('v.languageDisable', false);
        cmp.set("v.checked", false);//	DE411244
        // US2718112 - Thanish - 2nd Jul 2020
        var openedLookupDetails = cmp.get("v.openedLookupDetails");
        var workspaceAPI = cmp.find("workspace");
        openedLookupDetails.forEach(function(subtabId){
            workspaceAPI.closeTab({tabId: subtabId});
        });
        cmp.set("v.openedLookupDetails", []);
    },
	
    // US1965220 - Thanish - 24th Jan 2020
    validateInputOnChange: function (cmp, event, helper) {
    	var checkVal = helper.validateInputs(cmp, event);
        //helper.validateInputs(cmp, event);
    },
    setBenefitLevel : function(cmp,event,helper){
       console.log('=@#ProviderLookupTierOne'+JSON.stringify(cmp.get("v.isTierOne")));
        //US2973232
        if(!$A.util.isUndefinedOrNull(cmp.get("v.isTierOne")) && cmp.get("v.isTierOne")){
             cmp.set("v.prvLookupInputs.benefitLevel", 'Tier 1');
        }
    },
    changeRadiusVal: function (component, event, helper) {
        var zipVal = component.find("zipCodeId").get("v.value");
        var allInput = component.get("v.prvLookupInputs");
        var radVal = allInput.radius;
        radVal = "5";

        if (!$A.util.isEmpty(zipVal)) {
            component.find("radiusId").set("v.value", radVal);
            component.set("v.disableRadius", false);
        } else {
            component.set("v.disableRadius", true);
            component.find("radiusId").set("v.value", "");
        }
    },
    changeZipValue : function(component, event, helper){
          var allInput = component.get("v.prvLookupInputs");
         
          var radVal = allInput.radius;
          radVal = "5"; 
         var zipVal = component.get("v.zipValue");
         component.set("v.prvLookupInputs.zipCode",zipVal);
          component.find("radiusId").set("v.value", radVal);
         component.set("v.disableRadius", false);
    },
    //US2670819 - ProviderLookup Fixes - Sravan
    changeStateValue: function(component, event, helper){
        let stateCmp = component.find("idStateId");
        stateCmp.updateSelectedValue(component.get("v.stateValue"));
    },   
    
    changeBasicAndAdvanced : function(cmp,event,helper){
        cmp.set("v.checked", !cmp.get("v.checked"));//Rajesh US2006160 Changes 01/14/2021
        helper.switchBasicAdvaced(cmp,event,helper);
    },
    
    clearLookupValues : function(cmp,event,helper){
        // US2931847 - Sanka
        if (!cmp.get("v.policyChange") && !cmp.get("v.isProviderSnapshot")) {
        cmp.set("v.isSearchEnabled", true);
        }
        helper.clearLookupDetails(cmp);
    },

    // US2718112 - Thanish - 2nd Jul 2020
    handleACETCaseCreated : function(cmp, event){
        var caseNotSavedTopics = cmp.get("v.caseNotSavedTopics");
        var index = caseNotSavedTopics.indexOf("Provider Lookup");
        if(index >= 0){
            caseNotSavedTopics.splice(index, 1);
    }
        cmp.set("v.caseNotSavedTopics", caseNotSavedTopics);
    },


    //US2782815 - Avish
    onClickOfEnter : function(cmp,event, helper) {
        if(event.key == 'Enter' && event.keyCode === 13 && event.target.className != 'btnClass') {           
            helper.getProviderSearchResults(cmp, event);
        }
    },
    searchProvider : function(cmp,event, helper) {
        //Fix search not invoking - US2931847
        if (!cmp.get("v.policyChange") && !cmp.get("v.isProviderSnapshot")) {
            cmp.set("v.isSearchEnabled", true);
        }
        helper.getProviderSearchResults(cmp, event);
    },
    setFocusToSearchBtn : function(cmp,event, helper) {
        var btn = cmp.find("searchBtnID");
        btn.focus();
    },
    handleSelectedDropdownVal : function(cmp,event, helper) {
        var btn = cmp.find("searchBtnID");
        btn.focus();
    },
    //US2782815 - Ends

    // US2931847 - Sanka
    refreshDefaultValues: function (cmp, event, helper) {
        var tabId;
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (ctabId) {
                tabId = ctabId;
                // DE432212
                if (tabId == event.getParam("tabId")) {
                    helper.clearLookupDetails(cmp);
                    helper.refreshDefaultValues(cmp, event, helper);
                }
            })
            .catch(function (error) {
                console.log(error);
            });


    }

})