({
	   getProviderData: function (component, event, helper, offset) {
        var action = component.get("c.getProviderLookupResults");
        var lookupInputs = component.get("v.providerDetails");
        var policyDetails = component.get("v.policyDetails");
        var cosmosDiv = '';
        var cosmosPanelNum = '';
        var tciTableNum = '';
        var lineofBusiness = '';
        var memType = ''; 
        var marketSite = '';
        var entityType = '';
        var marketType = '';
        var sharedArrangement = '';
        var obligorID = '';
        var productCode = '';
        var eligibilitySourceSystemCode = '';
        var claimSourceSystemCode = '';
        var sourceCode = '';
        // US3452064
        var coverage = new Object();
        coverage.coverageStartDate = '';
        coverage.coverageEndDate = '';
        coverage.providerDiv = ''; //US3574032
        if(!$A.util.isEmpty(policyDetails) && !$A.util.isEmpty(policyDetails.resultWrapper)){
            cosmosDiv = policyDetails.resultWrapper.policyRes.cosmosDivision;
            cosmosPanelNum = policyDetails.resultWrapper.policyRes.groupPanelNumber;
            tciTableNum = policyDetails.resultWrapper.policyRes.tciTableNumber;
            lineofBusiness = policyDetails.resultWrapper.policyRes.lineofBusiness;
            memType = lookupInputs.memType;
            marketSite = policyDetails.resultWrapper.policyRes.marketSite;
            marketType = policyDetails.resultWrapper.policyRes.marketType;
            entityType =  policyDetails.resultWrapper.policyRes.entityType;
            sharedArrangement = policyDetails.resultWrapper.policyRes.sharedArrangement;
    	    obligorID = policyDetails.resultWrapper.policyRes.obligorID;
    	    productCode = policyDetails.resultWrapper.policyRes.productCode;
            eligibilitySourceSystemCode = policyDetails.resultWrapper.policyRes.eligibilitySourceSystemCode;
    		claimSourceSystemCode = policyDetails.resultWrapper.policyRes.claimSourceSystemCode;
            sourceCode = policyDetails.resultWrapper.policyRes.sourceCode;
            coverage.coverageStartDate = policyDetails.resultWrapper.policyRes.coverageStartDate; // US3452064
            coverage.coverageEndDate = policyDetails.resultWrapper.policyRes.coverageEndDate; // US3452064
            coverage.providerDiv  =  policyDetails.resultWrapper.policyRes.providerDiv; //US3574032
        }
        var pcMap = component.get("v.productCodesMap");
        if(sourceCode == 'CS' && claimSourceSystemCode == '01' && eligibilitySourceSystemCode == '03'){
            if(productCode == 'M'){
                component.set("v.convertedProductCodes",'HM8');
            }else if(productCode == 'D'){
                component.set("v.convertedProductCodes",'HM9');
            }
        }else{           
            if(!$A.util.isEmpty(productCode)){
                for(var i in pcMap) {
                    if(pcMap[i].From_CDB__c == productCode) {
                        component.set("v.convertedProductCodes",pcMap[i].Send_To_NDB__c);
                    }
                }
            }
            
        }
        action.setParams({
            taxId: lookupInputs.taxId,
            npi: lookupInputs.npi,
            providerId: lookupInputs.providerId,
            providerType: lookupInputs.providerType == 'Facility' ? 'O' : (lookupInputs.providerType == 'Physician' ? 'P' : ''),
            speciality: lookupInputs.speciality != 'Select' ? lookupInputs.speciality : '',
            lastNameOrFacility: lookupInputs.lastName,
            firstName: lookupInputs.firstName,
            state: lookupInputs.state != 'Select' ? lookupInputs.state : '',
            zipCode: lookupInputs.zipCode,
            radius: lookupInputs.radius,
            acceptNewPatients: (lookupInputs.acceptingNewPatients || lookupInputs.acceptingExistingPatients) ? 'Y' : '',
            prefferedLab: lookupInputs.preferredLab ? 'Y' : '',
            inactiveProvs: lookupInputs.includeInactiveProviders ? 'Y' : '',
            freestandingFac: lookupInputs.freeStandingFacility ? 'Y' : '',
            cosmosDiv: cosmosDiv,
            cosmosPanelNum: cosmosPanelNum,
            tciTableNum: tciTableNum,
            lineofBusiness: lineofBusiness,
            memType: memType,
            start: component.get("v.pageNumber"),
            endCount: 50,
            filtered : component.get("v.isOnlyActive"),
	    	benefitLevel : lookupInputs.benefitLevel,
            marketSite:marketSite,
            entityType:entityType,
            sharedArrangement : sharedArrangement,
            obligorID : obligorID,
            productCode : component.get("v.convertedProductCodes"),
            marketType : marketType,
            isDetailOpened : false,
            sourceCode : sourceCode, // US3452064
            coverageDates : coverage // US3452064
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result.statusCode == 200) {

                    var responseCount= component.get("v.responseCount");
            		responseCount++;
            		component.set("v.responseCount",responseCount);

                    if(responseCount > 1){
                        //change the message

                     	if (!$A.util.isUndefinedOrNull(result.selectedRows) && !$A.util.isEmpty(result.selectedRows) &&
                            result.selectedRows[0].caseItemsExtId == "No Matching Provider Lookup Results Found"){

                            result.selectedRows[0].caseItemsExtId = "No Additional Provider Lookup Results Found" ;
                            result.tableBody[0].rowColumnData[0].fieldValue = "No Additional Provider Lookup Results Found" ;
                            result.tableBody[0].caseItemsExtId = "No Additional Provider Lookup Results Found" ;
                        }
                    }



                    if (!$A.util.isUndefinedOrNull(result.recordCount)) {
                        //US2573718 - Auto Doc When No Results Are Displayed - Sravan - Start
                        if (result.recordCount == 0) {
                           // helper.showToast(component, event, helper);
                            // US3192316 - Thanish - 27th Jan 2021 - removed auto check
                        }
                        // US2917371 - Thanish - 7th Dec 2020
                        else if (result.recordCount == 1) {
                            var rDetails = result.tableBody[0].rowDetails.split(',');
                            if (rDetails.length > 0 && !$A.util.isEmpty(rDetails[2])) {
                                component.set("v.autoLaunchAddrId", rDetails[2]);
                            }
                        }
                        // US3192316 - Thanish - 27th Jan 2021 - removed auto check
                    }
                    var existingAutodocTable = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), 'Provider Lookup Results');
                    let existingSelectedRows = [];
                    let preSelectedRecords = [];
                    var noRecordFound = false;
                    let noRecordsFoundRow = [];
                    let selectedExternalIds = [];
                    for(var currentRow of result.tableBody) {
                        if(currentRow.isResolvedDisabled) {
                            noRecordFound = true;
                        }
                    }
                    // US3516065: Enable Route Button: Provider Snapshot - Krish - 9th June 2021
                    if (!$A.util.isEmpty(existingAutodocTable) && !$A.util.isEmpty(existingAutodocTable.selectedRows)) {
                        existingSelectedRows = existingAutodocTable.selectedRows;
                        for(var row of existingSelectedRows) {
                            if(row.isResolvedDisabled) {
                                noRecordsFoundRow.push(row);
                            } else {
                                preSelectedRecords.push(row);
                                selectedExternalIds.push(row.caseItemsExtId);
                            }
                        }
                    }
                    
                    let existingRows = [];
                    for(var currentRow of result.tableBody) {
                        if(!selectedExternalIds.includes(currentRow.caseItemsExtId)) {
                            existingRows.push(currentRow);
                        }
                    }
                    result.tableBody = existingRows;
                    var enabled = [];
                    var disabled = [];
                    preSelectedRecords.forEach(element => {
                        if (element.linkDisabled) {
                        disabled.push(element);
                    } else {
                       enabled.push(element);
                }
            });
            preSelectedRecords = disabled.concat(enabled);
            if(!noRecordFound && preSelectedRecords.length > 0) {
                        result.tableBody = preSelectedRecords.concat(existingRows);
                        result.selectedRows = preSelectedRecords.concat(existingRows);
                    }
                    else if(noRecordFound ) {
                        result.tableBody =existingRows.concat(preSelectedRecords);
                        result.selectedRows = existingRows.concat(preSelectedRecords);
                        component.set("v.selectedRows",result.selectedRows);
                    }
                    var selectedDetailRecords = component.get('v.selectedDetailRecords');
                    /* if (!$A.util.isEmpty(selectedDetailRecords)) {
                        if (!(result.tableBody)) {
                            result.tableBody = [];
                        }
                        result.tableBody = selectedDetailRecords.concat(result.tableBody);

                    }
                                  */
                    //US2573718 - Auto Doc When No Results Are Displayed - Sravan - Start
                    if (component.get("v.policyChange")) {
                        _autodoc.setAutodoc(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), result); // Thanish - 2nd Nov 2020 - added autodocUniqueIdCmp
                        component.set("v.policyChange", false);
                    }

                    //US2573718 - Auto Doc When No Results Are Displayed - Sravan -End

                    //US3020001 - Remove Duplicates
                    if (selectedDetailRecords.length > 0) {
                        var filteredItems = result.tableBody.reduce((pvd, current) => {
                            var found = pvd.find(item => item.uniqueKey === current.uniqueKey);
                            if (!found) {
                                return pvd.concat([current]);
                            } else {
                                return pvd;
                            }
                        }, []);
                        result.tableBody = filteredItems;
                    }

                    // Save Case Consolidation - US3424763
                    result.callTopic = 'Provider Lookup';

                    component.set("v.searchResults", result);
            		// DE492618 - Thanish - 23rd Sept 2021
                    if(result.selectedRows.length > 0){
                        helper.setDefaultAutodoc(component, false);
                    }
                    // US3516065: Enable Route Button: Provider Snapshot - Krish - 9th June 2021
                    // If the results lenght is 1 and it is a no records found for only no records coming
                    if(result.selectedRows.length > 0 && noRecordFound){
                            _autodoc.setAutodoc(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), result);
                    }

                    // US2931847
                    if (component.get("v.autoLaunched") && result.recordCount > 0) {
                        for (let index = 0; index < result.tableBody.length; index++) {
                            const element = result.tableBody[index];
                            if (!$A.util.isEmpty(element.rowDetails)) {
                                var pDetails = element.rowDetails.split(',');
                                if (pDetails[2] == component.get("v.autoLaunchAddrId")) {
                                    this.invokeRowClick(component, index);
                                    break;
                                }else if(pDetails[3] == component.get("v.autoLaunchAddrId")){
                                    // Accomodate addr sequence
                                    this.invokeRowClick(component, index);
                                    break;
                                }
                            }
                        }
                    }
                } else {
                    this.showToastMessage("We hit a snag.", (result != null) ? result.errorMessage : '', "error", "dismissible", "30000");
                }
            } else {
                // US3551763 - Thanish - 24th May 2021
                var retError = response.getError();
                if((retError.length > 0) && (retError[0].exceptionType == "System.LimitException")){
                    this.showToastMessage("We hit a snag.", "Criteria has yielded too many results to display. Refine your search criteria by adding State & Zip Code.", "error", "dismissible", "30000");
            } else {
                    this.showToastMessage("We hit a snag.", "Unexpected Error Occurred in the Provider Lookup Results card. Please try again. If problem persists please contact the help desk.", "error", "dismissible", "30000");
                }
                console.log('FAIL## ' + JSON.stringify(response.getReturnValue()));
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
        //US2573718 - Auto Doc When No Results Are Displayed - Sravan - Start
        //if(!component.get("v.policyChange")){
        var autodocSubId = component.get("v.autodocUniqueIdCmp"); // Thanish - 2nd Nov 2020 - added autodocUniqueIdCmp
        var extProviderTable = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"), autodocSubId, 'Provider Lookup Results');
        console.log('Old Results' + JSON.stringify(extProviderTable));
        if (!$A.util.isEmpty(extProviderTable)) {
            var selectedR = extProviderTable.selectedRows;
            if (!component.get("v.boolIsProviderLookupFromReferral") && !component.get("v.isCreateSrnComponent")) { // DE438149 - adding new condition or create auth scenario
                component.set("v.selectedRows", selectedR);
            }

        } else {
            component.set("v.selectedRows", []);
        }
        //}
        //US2573718 - Auto Doc When No Results Are Displayed - Sravan -End
        //US3068299 - Sravan - Start
        helper.deleteAutoDoc(component);
        //US3068299 - Sravan - End

    },
    
    openedDetailPages : function (cmp){
        var tempArry = [];
        var tableDetails = cmp.get("v.searchResults");
        if(!$A.util.isEmpty(tableDetails)){
            var tableRows = tableDetails.tableBody;
            for(var i in tableRows){
                var tableRow = tableRows[i];
                if(tableRow.linkDisabled){
                    tempArry.push(tableRow);
                }
            }       
        }
		 
        cmp.set("v.selectedDetailRecords",tempArry);
        var isOpenedDetail = cmp.get("v.selectedDetailRecords");
        if(isOpenedDetail.length > 0){
            cmp.set("v.isOpenDetail",true);
        }else{
            cmp.set("v.isOpenDetail",false);
        }
    },
    
    showToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Information!",
            "type": "warning",
            "message": "Update your search criteria and try your search again."
        });
        toastEvent.fire();
    },

    showToastMessage: function (title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode,
            "duration": duration
        });
        toastEvent.fire();
    },

    showSpinner: function (cmp) {
        var spinner = cmp.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideSpinner: function (cmp) {
        var spinner = cmp.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },

    // US3125332 - Thanish - 11th Jan 2021
    setDefaultAutodoc: function(cmp, hideInPreview){ // DE492618 - Thanish - 23rd Sept 2021
        if(!cmp.get("v.isProviderSnapshot")){
            var defaultAutoDocPolicy = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Policies');
            var defaultAutoDocMember = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Member Details');
            var memberAutodoc = new Object();
            memberAutodoc.type = 'card';
            memberAutodoc.componentName = "Member Details";
            memberAutodoc.autodocHeaderName = "Member Details";
            memberAutodoc.noOfColumns = "slds-size_6-of-12";
            memberAutodoc.componentOrder = 0.5;
            memberAutodoc.hideInPreview = hideInPreview; // DE492618 - Thanish - 23rd Sept 2021
            var cardData = [];
            if(!$A.util.isUndefinedOrNull(defaultAutoDocMember)){ // US3476452 - adding null check
            cardData = defaultAutoDocMember.cardData.filter(function(el){
                if(!$A.util.isEmpty(el.defaultChecked) && el.defaultChecked) {
                    return el;
                }
            });
            }

            memberAutodoc.cardData = cardData;
            memberAutodoc.ignoreAutodocWarningMsg = true;
            // DE456923 - Thanish - 30th Jun 2021
            var policyAutodoc = new Object();
            policyAutodoc.type = "table";
            policyAutodoc.autodocHeaderName = "Policies";
            policyAutodoc.componentName = "Policies";
            policyAutodoc.tableHeaders = ["GROUP #", "SOURCE", "PLAN", "TYPE", "PRODUCT", "COVERAGE LEVEL", "ELIGIBILITY DATES", "STATUS", "REF REQ", "PCP REQ", "RESOLVED"]; // // US2928520: Policies Card - updated with "TYPE"
            policyAutodoc.tableBody = defaultAutoDocPolicy.tableBody;
            policyAutodoc.selectedRows = defaultAutoDocPolicy.selectedRows;
            policyAutodoc.callTopic = 'View Member Eligibility';
            policyAutodoc.componentOrder = 0;
            policyAutodoc.hideInPreview = hideInPreview; // DE492618 - Thanish - 23rd Sept 2021
            policyAutodoc.ignoreAutodocWarningMsg = true;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), policyAutodoc);
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), memberAutodoc);
            // US3804847 - Krish - 26th August 2021
            var interactionCard = cmp.get("v.interactionCard");
            var providerFullName = '';
            var providerComponentName = '';
            if(!$A.util.isUndefinedOrNull(interactionCard) && !$A.util.isEmpty(interactionCard)){
                providerFullName = interactionCard.firstName + ' ' + interactionCard.lastName;
                providerComponentName = 'Provider: '+ ($A.util.isEmpty(providerFullName) ? "" : providerFullName);
            }
            var defaultAutoDocProvider = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"), cmp.get("v.policySelectedIndex"), providerComponentName);
            if(!$A.util.isUndefinedOrNull(defaultAutoDocProvider) && !$A.util.isEmpty(defaultAutoDocProvider)){
                // DE492618 - Thanish - 23rd Sept 2021
                var providerAutodoc = new Object();
                providerAutodoc.componentName = defaultAutoDocProvider.componentName;
                providerAutodoc.componentOrder = 0.25;
                providerAutodoc.noOfColumns = defaultAutoDocProvider.noOfColumns;
                providerAutodoc.type = defaultAutoDocProvider.type;
                providerAutodoc.caseItemsExtId = defaultAutoDocProvider.caseItemsExtId;
                providerAutodoc.allChecked = defaultAutoDocProvider.allChecked;
                providerAutodoc.cardData = defaultAutoDocProvider.cardData;
            	providerAutodoc.hideInPreview = hideInPreview;
                providerAutodoc.ignoreClearAutodoc = false;
                providerAutodoc.ignoreAutodocWarningMsg = true;
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), providerAutodoc);
            }
        }
    },

    // DE482674 - Thanish - 1st Sep 2021
    deleteDefaultAutodoc: function(cmp){
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "Policies");
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), "Member Details");

        var interactionCard = cmp.get("v.interactionCard");
        var providerFullName = '';
        var providerComponentName = '';
        if(!$A.util.isUndefinedOrNull(interactionCard) && !$A.util.isEmpty(interactionCard)){
            providerFullName = interactionCard.firstName + ' ' + interactionCard.lastName;
            providerComponentName = 'Provider: '+ ($A.util.isEmpty(providerFullName) ? "" : providerFullName);
        }
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp"), providerComponentName);
    },

    // US2931847
    checkExistingTab: function (cmp, event, helper, addressId) {
        var tableDetails = cmp.get("v.searchResults");
        if (!$A.util.isEmpty(tableDetails) && $A.util.isEmpty(tableDetails.tableBody)) {
            return false;
        }

        var existingTabs = cmp.get("v.existingTabs");
        var tabfound = false;
        var workspaceAPI = cmp.find("workspace");
        if (existingTabs.length > 0) {
            for (let index = 0; index < existingTabs.length; index++) {
                const element = existingTabs[index];
                if (element.addressId == addressId) {
                    tabfound = true;
                    workspaceAPI.focusTab({
                        tabId: element.subtabId
                    }).catch(function (error){
                        console.log(error);
                        tabfound = false;
                    });
                    if (tabfound) {
                    break;
                }
            }
            }
        } else {
            return false;
        }

        if (tabfound) {
            if (!$A.util.isEmpty(tableDetails)) {
                var tableRows = tableDetails.tableBody;
                for (var i = 0; i < tableRows.length ; i++) {
                    var tableRow = tableRows[i];
                    if (!$A.util.isEmpty(tableRow.rowDetails)) {
                        var pDetails = tableRow.rowDetails.split(',');
                        if (pDetails[2] == addressId && !tableRow.linkDisabled) {
                            this.invokeRowClick(cmp, i);
                            break;
                        }
                    }
                }
            }
        }

        return tabfound;
    },

    invokeRowClick: function (cmp, rowIndex) {
        cmp.set("v.autoLaunched", false);
        if(!cmp.get("v.isCreateSrnComponent")){ //DE438149
        var lookupTable = cmp.find("lookupResultsId");
        if (!$A.util.isEmpty(lookupTable)) {
            window.setTimeout(
                $A.getCallback(function () {
                    lookupTable.invokeOnClick(rowIndex);
                }), 1000
            );
        }
        }
    },
    //US3068299 - Sravan - Start
    deleteAutoDoc : function(component){
        var autoDocToBeDeleted = component.get("v.autoDocToBeDeleted");
        console.log('autoDocToBeDeleted'+ JSON.stringify(component.get("v.autoDocToBeDeleted")));
        console.log('cmp.get("v.policySelectedIndex")'+ component.get("v.policySelectedIndex"));
        if(!$A.util.isUndefinedOrNull(autoDocToBeDeleted) && !$A.util.isEmpty(autoDocToBeDeleted)){
             if(autoDocToBeDeleted.doNotRetainAutodDoc){
                 _autodoc.deleteAutodoc(component.get("v.autodocUniqueId"),autoDocToBeDeleted.selectedPolicyKey);
                 component.set("v.selectedRows",[]);
                 autoDocToBeDeleted.doNotRetainAutodDoc = false;
                 component.set("v.autoDocToBeDeleted",autoDocToBeDeleted);

        }
    }
    },
    //US3068299 - Sravan - End
    //DE445901 - close opened tabs
    closeDetailTabs: function(cmp, event, helper){
        var workspaceAPI = cmp.find("workspace");
        var existingTabs = cmp.get("v.existingTabs");

        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            existingTabs.forEach(element => {
                try {
                    if (element.subtabId != focusedTabId) {
                        workspaceAPI.closeTab({
                            tabId: element.subtabId
                        });
                    }
                } catch (e) {
                    console.log(e);
                }
            });
        }).catch(function (error) {
            console.log(error);
        });
        cmp.set("v.existingTabs", []);
    },

    // Keeping casewrapper ready whenever data changes
    createCaseWrapper: function (cmp, event, helper) {
        var caseWrapper = cmp.get("v.caseWrapper");
        var caseWrapperMNF = cmp.get("v.caseWrapperMNF");

        if( !$A.util.isUndefinedOrNull(caseWrapperMNF) &&  !$A.util.isUndefinedOrNull(caseWrapper)){
        var caseItems = [];
        if (cmp.get('v.isProviderSnapshot')) {
            caseItems = [];
        } else {
            caseItems = !$A.util.isUndefinedOrNull(caseWrapperMNF.caseItems) ? caseWrapperMNF.caseItems : [];
            caseWrapper = caseWrapperMNF;
        }
        caseWrapper.TaxId = cmp.get("v.taxId");

        var caseItemMap = cmp.get("v.caseItemMap");
        if (!$A.util.isEmpty(caseItemMap)) {
            for (let value of caseItemMap.values()) {
                for (var v in value) {
                    caseItems.push(value[v]);
                }
            }
        }

        caseWrapper.caseItems = caseItems;

        cmp.set("v.caseWrapper", caseWrapper);
        cmp.set("v.caseWrapperMNF", caseWrapper);
    }
    }
})