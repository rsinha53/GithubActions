({
    onLoad: function (component, event, helper) {
        helper.showSpinner(component);
        helper.getProviderData(component, event, helper, 0);
        // US2816912	Build UI for Create SRN for Add New Provider with Provider Look-up
        // Disabling comment btn in SRN tab
        if (component.get("v.isCreateSrnComponent")) {
            component.set("v.disableCommentButton", true)
        }
        // US2808569 - Thanish - 27th Oct 2020
        if (!$A.util.isEmpty(component.get("v.memberautodocUniqueId"))) {
            helper.setDefaultAutodoc(component, true); // DE492618 - Thanish - 23rd Sept 2021
        }
        // DE373867 - Thanish - 8th Oct 2020
        if (component.get("v.isHippaInvokedInProviderSnapShot")) {
            var cardDetails = new Object();
            cardDetails.componentName = "HIPAA Guidelines";
            cardDetails.componentOrder = 0;
            cardDetails.noOfColumns = "slds-size_1-of-1";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": true,
                    "disableCheckbox": true,
                    "fieldName": "HIPAA Guidelines",
                    "fieldType": "outputText",
                    "fieldValue": "Accessed"
                }
            ];
            _autodoc.setAutodoc(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), cardDetails);
        }
    },
    
    activeToggle : function(component,event,helper){
        var activeState = ! component.get("v.isOnlyActive");
        component.set("v.isOnlyActive",activeState);
		helper.showSpinner(component);
        helper.getProviderData(component, event, helper, 0);
    },

    //Jitendra
    addToReferral : function(component,event,helper) {
        //helper.showSpinner(component);
        let strTitle,strMessage;
        let toastEvent = $A.get("e.force:showToast");
        if(component.get("v.selectedRows").length > 1 ) {
            strTitle = 'error';
            strMessage = 'Only one provider may be selected'
        }  else if (component.get("v.selectedRows").length == 0) {
            strTitle = 'error';
            strMessage = 'Select one Provider';
        }

        if(strTitle == 'error') {
            toastEvent.setParams({
                "title": "We hit a snag",
                "message": strMessage,
                "type": strTitle
            });
            toastEvent.fire();
            return;
        }

        if(component.get("v.selectedRows").length == 1) {

            if(component.get("v.selectedRows")[0] && component.get("v.selectedRows")[0]['rowColumnData'] &&
                component.get("v.selectedRows")[0]['rowColumnData'][1] && component.get("v.selectedRows")[0]['rowColumnData'][1]['fieldValue'] &&
                component.get("v.selectedRows")[0]['rowColumnData'][1]['fieldValue'] != 'INN') {
                toastEvent.setParams({
                    "title": '',
                    "message": 'Only an INN Provider may be selected. ',
                    "type": 'error'
                });
                toastEvent.fire();
                return;
            }

            let strProviderId, strTaxId, strAddressSeq, strRowDetails, objResponse;
            strRowDetails = component.get("v.selectedRows")[0].rowDetails.split(',');
            strProviderId = strRowDetails[1];
            strTaxId = strRowDetails[0];
            strAddressSeq = strRowDetails[3];
            //Call Apex method and get the details
            var action = component.get("c.getProviderDetaiils");
            action.setParams({
                providerId: strProviderId,
                taxId: strTaxId,
                adrseq: strAddressSeq
            });
            action.setCallback(this, function (response) {
                try {
                    let objResponse, objFormedResponse = component.get("v.objPcpBodyData"), isSpecialityMatched = false;
                    if(response.getState() !== 'SUCCESS') {
                    return;
                    }

                    if(response.getReturnValue()) {
                        objResponse = JSON.parse(response.getReturnValue());
                        if(objResponse && objResponse['SpecialityRecords'] && Array.isArray(objResponse['SpecialityRecords'])) {
                            let lstSpecialityRecords = objResponse['SpecialityRecords'];
                            for(let objSp in objResponse['SpecialityRecords']) {
                                if(lstSpecialityRecords[objSp]['IsPrimary'] && lstSpecialityRecords[objSp]['IsPrimary'] == 'Y') {
                                    isSpecialityMatched = true;
                                    objFormedResponse['strPrimarySpecialty'] = lstSpecialityRecords[objSp]['Speciality'];
                                }
                            }

                            if(!isSpecialityMatched) {
                                objFormedResponse['strPrimarySpecialty'] = '--';
                            }
                        }

                        if(objResponse && objResponse['ProviderCardDetails']) {
                            let objProviderDetails;
                            objProviderDetails = objResponse['ProviderCardDetails'];
                            if(component.get("v.objPcpHeaderData.showRefferingToName")) {
                                let objProviderHeader = {};
                                objProviderHeader['strReferringToHeader'] = component.get("v.objPcpHeaderData.strReferringToHeader")
                                objProviderHeader['strReferringToName'] = (objProviderDetails['ProviderName'] ? (objProviderDetails['ProviderName']) : '');
                                objProviderHeader['showRefferingToName'] = component.get("v.objPcpHeaderData.showRefferingToName");
                                component.set("v.objPcpHeaderData", objProviderHeader);
                            }
                            objFormedResponse['strAddress']  = (objProviderDetails['Address'] ? (objProviderDetails['Address'].replaceAll('<br/>',' ')) : '');
                            objFormedResponse['strStatus'] = 'INN';
                            objFormedResponse['strPhoneNumber'] = (objProviderDetails['PhoneNumber'] ? (objProviderDetails['PhoneNumber']) : '');
                            objFormedResponse['strNPI'] = (objProviderDetails['NPI'] ? (objProviderDetails['NPI']) : '');
                            objFormedResponse['strTaxID'] = (objProviderDetails['TaxId'] ? (objProviderDetails['TaxId']) : '');
                            objFormedResponse['isOutputText'] = component.get("v.objPcpBodyData")['isOutputText'];
                            objFormedResponse['isInputText'] = component.get("v.objPcpBodyData")['isInputText'];
                            objFormedResponse['isPcponFile'] = true;//DE411279
                            objFormedResponse['strProviderName'] = (objProviderDetails['ProviderName'] ? (objProviderDetails['ProviderName']) : '');
                            component.set("v.objPcpBodyData", objFormedResponse);
                            component.set("v.boolShowProviderLookup", false);
                        } else {
                            toastEvent.setParams({
                                "title": '',
                                "message": 'Unexpected error occurred please try again.',
                                "type": 'error'
                            });
                            toastEvent.fire();
                            return;
                        }

                    }


                } catch(exception) {
                    console.log('exception ' + JSON.stringify(exception));
                }
            });
            $A.enqueueAction(action);
        }
        //helper.hideSpinner(component);
    },

    getSelectedRecords: function (cmp, event, helper) {
        // DE482674 - Thanish - 1st Sep 2021
        var tableDetails = cmp.get("v.searchResults");
        if(tableDetails.selectedRows.length > 0){
            helper.setDefaultAutodoc(cmp, false); // DE492618 - Thanish - 23rd Sept 2021
        } else{
            helper.setDefaultAutodoc(cmp, true); // DE492618 - Thanish - 23rd Sept 2021
        }

        var data = event.getParam("selectedRows");
        cmp.set("v.selectedRows", data);

        var isFromAuth = cmp.get("v.isCreateSrnComponent");

        if (!isFromAuth) {
            // Save Case Consolidation - US3424763
            var searchResults = cmp.get("v.searchResults");
            if ($A.util.isEmpty(data)) {
                searchResults.hasUnresolved = false;
                cmp.set("v.searchResults", searchResults);
            }

            var hasUnresolved = !$A.util.isEmpty(searchResults) && searchResults.hasUnresolved != undefined ? cmp.get("v.searchResults").hasUnresolved : false;

            cmp.set("v.disableButtons", !hasUnresolved);
            //cmp.set("v.isCommentsBox", hasUnresolved);
            if (cmp.get("v.disableButtons")) {
                cmp.set("v.isCommentsBox", false);
                cmp.set("v.commentsValue", "");
            } else {
                cmp.set("v.disableCommentButton", false);
            }
            helper.createCaseWrapper(cmp, event, helper);
        }
    },
    
    navigateToDetail : function (cmp, event, helper) {
        helper.setDefaultAutodoc(cmp, false); // DE492618 - Thanish - 23rd Sept 2021
        var selectedRowdata = event.getParam("selectedRows");
        var currentRowIndex = event.getParam("currentRowIndex");
        console.log('selectedRowdata'+JSON.stringify(selectedRowdata));
        var memberDetails = cmp.get("v.memberDetails");
        if($A.util.isEmpty(memberDetails)) {
            memberDetails = new Object();
        }
        memberDetails.noMemberToSearch = cmp.get("v.noMemberToSearch");
        var getUniqueKey = selectedRowdata.rowDetails;
        var pDetails = getUniqueKey.split(',');

        // Add case item
        var caseItemMap = cmp.get("v.caseItemMap");
        if($A.util.isEmpty(caseItemMap)){
            caseItemMap = new Map();
            var caseItems = [];
            var caseItem = new Object();
            caseItem.uniqueKey = pDetails[0];
            caseItem.isResolved = true;
            caseItem.topic = 'Provider Lookup';//US3071655 - Sravan
            caseItems.push(caseItem);
            caseItemMap.set(currentRowIndex,caseItems);
        }else{
            if($A.util.isEmpty(caseItemMap.get(currentRowIndex))){
                var caseItems = [];
                var caseItem = new Object();
                caseItem.uniqueKey = pDetails[0];
                caseItem.isResolved = true;
                caseItem.topic = 'Provider Lookup';//US3071655 - Sravan
                caseItems.push(caseItem);
                caseItemMap.set(currentRowIndex,caseItems);
            }else{
                var caseItems = caseItemMap.get(currentRowIndex);
                var caseItem = new Object();
                caseItem.uniqueKey = pDetails[0];
                caseItem.isResolved = true;
                caseItem.topic = 'Provider Lookup';//US3071655 - Sravan
                caseItems.push(caseItem);
                caseItemMap.set(currentRowIndex,caseItems);
            }
        }
        cmp.set("v.caseItemMap",caseItemMap);
        
        var providerDetails = new Object();
        providerDetails.taxId = pDetails[0];
         providerDetails.providerId = pDetails[1];
        // US1958736 - Thanish - 5th Feb 2020
        providerDetails.addressId = pDetails[2];
        providerDetails.addressSequence = pDetails[3];
        providerDetails.isPhysician = pDetails[5];
       // providerDetails.isNiceProvider = data.isNiceProvider;
        cmp.set("v.taxId",providerDetails.taxId);
        // US2320729 - Thanish - 26th Feb 2020
        let pageFeature = cmp.get("v.autodocPageFeature");
        let autodocKey = cmp.get("v.AutodocKey");
        // US2623985 - Thanish - 10th Jun 2020
        let policyDetails = cmp.get("v.policyDetails");
        let contractFilterData = {};
        
        //  US2696849 - Thanish - 22nd Jul 2020
        let memberCardData = cmp.get('v.memberCardData');
        let policySelectedIndex = cmp.get('v.policySelectedIndex');
        var insuranceTypeCode = '';
        if(!$A.util.isEmpty(memberCardData)){
            if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex])) {
                if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].insuranceTypeCode)) {
                    insuranceTypeCode = memberCardData.CoverageLines[policySelectedIndex].insuranceTypeCode;
                }
            }
        }
        
        if(!$A.util.isEmpty(policyDetails)){
            contractFilterData = {
                "productType": policyDetails.resultWrapper.policyRes.productType,
                "marketSite": policyDetails.resultWrapper.policyRes.marketSite,
                "marketType": policyDetails.resultWrapper.policyRes.marketType,
                "cosmosDiv": policyDetails.resultWrapper.policyRes.cosmosDivision,
                "providerDiv" : policyDetails.resultWrapper.policyRes.providerDiv, //US3574032
                "cosmosPanelNbr": policyDetails.resultWrapper.policyRes.groupPanelNumber,
                "policyNumber": policyDetails.resultWrapper.policyRes.policyNumber, //  US2696849 - Thanish - 22nd Jul 2020
                "subscriberID": policyDetails.resultWrapper.policyRes.subscriberID, //  US2696849 - Thanish - 22nd Jul 2020
                "coverageLevelNum": policyDetails.resultWrapper.policyRes.coverageLevelNum, //  US2696849 - Thanish - 22nd Jul 2020
                "insuranceTypeCode": insuranceTypeCode, //  US2696849 - Thanish - 22nd Jul 2020
                "selectedIPAValue" : cmp.get("v.selectedIPAValue"),
                "coverageStartDate": policyDetails.resultWrapper.policyRes.coverageStartDate, //  US3244384 - Sarma - 01/03/2021
                "isTermedPolicy": ((cmp.get("v.policyList")[cmp.get("v.policySelectedIndex")].planStatus) == 'false'), // Thanish - 2nd Mar 2021
                "coverageEndDate": policyDetails.resultWrapper.policyRes.coverageEndDate //  US3244384 - Sarma - 01/03/2021
            }
        }

        var selecetedCallTopicListstr = JSON.stringify(cmp.get("v.callTopicLstSelected"));
        //Move to the front
        // selectedRowdata.prevIndex = currentRowIndex;
        // US3537364
        var tableDetails = cmp.get("v.searchResults");
        var rowData = tableDetails.tableBody;
        var newBody = [];
         var noRows=[];
        newBody.push(selectedRowdata);
        for (let i = 0; i < rowData.length; i++) {
                    const element = rowData[i];
                    // if (i != currentRowIndex) {
                    //     newBody.push(element);
                    // }
        			if(element.caseItemsExtId=='No Matching Provider Lookup Results Found')
                            noRows.push(element);
                    else if (element.caseItemsExtId != selectedRowdata.caseItemsExtId) {
                        newBody.push(element);
                    }
                }
        tableDetails.tableBody =noRows.concat(newBody);
        cmp.set("v.searchResults", tableDetails);

        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_ProviderLookupDetails"
                    },
                    "state": {
                        "c__slectedRowLinkData": selectedRowdata,
                        "c__interactionRec": cmp.get("v.interactionRec"),
                        "c__memberDetails": memberDetails,
                        "c__noMemberToSearch": cmp.get("v.noMemberToSearch"),
                        "c__providerNotFound": cmp.get("v.providerNotFound"),
                        "c__providerDetails": providerDetails,
                        "c__sourceCode": cmp.get("v.sourceCode"),
                        "c__autodocPageFeature": cmp.get("v.autodocUniqueId"),
                        "c__autodocKey": autodocKey,
                        "c__currentRowIndex":currentRowIndex,
                        "c__provSearchResultsUniqueId": cmp.get("v.cmpUniqueId"), // DE307193 - Thanish 20th March 2020
                        "c__resultsTableRowData": selectedRowdata, // DE307193 - Thanish 20th March 2020
                        "c__contactUniqueId": cmp.get("v.contactUniqueId"),
                        // US2623985 - Thanish - 10th Jun 2020
                        "c__contractFilterData": contractFilterData,
                        "c__isProviderSnapshot": cmp.get("v.isProviderSnapshot"),
                        "c__hipaaEndpointUrl":cmp.get("v.hipaaEndpointUrl"),//US2076634 - Sravan - 22/06/2020
                        "c__providerDetailsForRoutingScreen": cmp.get("v.providerDetailsForRoutingScreen"),//US2740876 - Sravan
                        "c__flowDetailsForRoutingScreen": cmp.get("v.flowDetailsForRoutingScreen"),//US2740876 - Sravan
                        "c__interactionOverviewTabId": cmp.get("v.interactionOverviewTabId"), //US2491365 - Avish
                        "c__callTopicLstSelected": selecetedCallTopicListstr,
                         "c__callTopicTabId": cmp.get("v.callTopicTabId"),
                        "c__benefitPlanId": cmp.get("v.strBenefitPlanId"),
                        "c__transactionId": cmp.get("v.transactionId") // US3446590 - Thanish - 21st Apr 2021
                    }
                },
                focus: true
            }).then(function (subtabId) {
                var openedLookupDetails = cmp.get("v.openedLookupDetails");
                openedLookupDetails.push(subtabId);
                
                var existingTabs = cmp.get("v.existingTabs");
                var tabinfo = new Object();
                existingTabs.forEach(element => {
                    if (element.addressId == pDetails[2]) {
                        element.subtabId = subtabId;
                    }
                });
                tabinfo.subtabId = subtabId;
                tabinfo.addressId = pDetails[2];
                existingTabs.push(tabinfo);
                cmp.set("v.existingTabs", existingTabs);

                workspaceAPI.setTabLabel({
                    tabId: subtabId,
                    label: pDetails[4]
                });
                workspaceAPI.setTabIcon({
                    tabId: subtabId,
                    icon: "custom:custom55",
                    iconAlt: "Provider Lookup Details"
                });
            }).catch(function (error) {
                console.log(error);
            });
        });
    },

    getProviderLookupInputs: function (component, event, helper) {
        var searchResults = event.getParam('prvLookupInputs');
    },
    
   getResults : function(component,event,helper) {
        var pageNum = event.getParam('requestedPageNumber');
         component.set("v.pageNumber",pageNum);
		 helper.showSpinner(component);
        helper.getProviderData(component, event, helper,pageNum);
    },
    
    
    searchLookups: function (component, event, helper) {
		helper.showSpinner(component);
        helper.openedDetailPages(component);
        //DE373975 - Sanka
        component.set("v.pageNumber",1);
        helper.getProviderData(component, event, helper, 0);
        //component.find('lookupResultsId').clearAuotoDoc();- Commented as part of US2573718 - Sravan

    },
    
    openCommentsBox : function (component, event, helper) {
        component.set("v.isCommentsBox",true);
        component.set("v.disableCommentButton",true);
    },
    
    togglePopup : function(cmp, event) {
        let showPopup = event.currentTarget.getAttribute("data-popupId");
        cmp.find(showPopup).toggleVisibility();
    },
    
    // DE376017 - Thanish - 16th Oct 2020
     openTTSPopup  : function(component, event, helper){
        if(event.getParam("autodocKey") == component.get("v.autodocUniqueId")){
            if(event.getParam("isCancelClicked")) {
                component.set("v.openSaveCase", false);
                var lstDelegatedData = JSON.parse(event.getParam("strDelegatedData"));
                var lstTableData = component.get("v.searchResults");
                var lstUpdateTableData = [], lstSelectedRows = [];
                for (let index = 0; index < lstTableData.tableBody.length; index++) {
                    let element = lstTableData.tableBody[index];
                    lstDelegatedData.forEach(function(objDelegatedData){
                        if(objDelegatedData.uniqueKey == element.uniqueKey && objDelegatedData.isDelegatedSpecialty) {
                            element['resolved'] = true;
                        }
                    });
                    lstUpdateTableData.push(element);
                }
                for (let index = 0; index < lstTableData.selectedRows.length; index++) {
                    let element = lstTableData.selectedRows[index];
                    lstDelegatedData.forEach(function(objDelegatedData){
                        if(objDelegatedData.uniqueKey == element.uniqueKey && objDelegatedData.isDelegatedSpecialty) {
                            element['resolved'] = true;
                        }
                    });
                    lstSelectedRows.push(element);
                }
                lstTableData.selectedRows = lstSelectedRows;
                lstTableData.tableBody = lstUpdateTableData;
                component.set("v.searchResults", lstTableData);
                _autodoc.setAutodoc(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), lstTableData);
                var topicClick = component.getEvent("topicClick");
                topicClick.setParams({
                    "clickedTopic" : "Provider Lookup SearchResults"
                });
                topicClick.fire();
                return;
            }
            if(event.getParam("linkClicked")){
                var cardDetails = new Object();
                cardDetails.componentName = "Network Management Request";
                cardDetails.componentOrder = 2;
                cardDetails.noOfColumns = "slds-size_6-of-12";
                cardDetails.type = "card";
                cardDetails.allChecked = false;
                cardDetails.cardData = [
                    {
                        "checked": true,
                        "disableCheckbox": true,
                        "defaultChecked": true,
                        "fieldName": "Provider Call Advocate Network Management/Credentialing/Demographic SOP Link",
                        "fieldType": "outputText",
                        "fieldValue": "Accessed",
                        "showCheckbox": true,
                        "isReportable":true
                    }
                ];
                _autodoc.setAutodoc(component.get("v.autodocUniqueId"), component.get("v.autodocUniqueIdCmp"), cardDetails);
            }
         component.set("v.openSaveCase", event.getParam("openPopup"));
        }
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
    getPreview: function(cmp, event){
        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        cmp.set("v.tableDetails_prev",selectedString);
        cmp.set("v.showpreview",true);
    },

    openModal: function(cmp, event){
        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        var jsString = JSON.stringify(selectedString);
        var caseWrapper = cmp.get("v.caseWrapper");
        var caseWrapperMNF = cmp.get("v.caseWrapperMNF");

        var caseItems = [];
        if(cmp.get('v.isProviderSnapshot')){
            caseItems = [];
        }else{
            //DE427466
            caseItems = !$A.util.isUndefinedOrNull(caseWrapperMNF.caseItems) ? caseWrapperMNF.caseItems : [];
			caseWrapper = caseWrapperMNF;
        }
        caseWrapper.TaxId = cmp.get("v.taxId");
        caseWrapper.savedAutodoc = jsString;

        var caseItemMap = cmp.get("v.caseItemMap");
        if(!$A.util.isEmpty(caseItemMap)){
            for (let value of caseItemMap.values()) {
                for (var v in value) {
                    caseItems.push(value[v]);
                }
            }
        }

        caseWrapper.caseItems = caseItems;
      
        cmp.set("v.caseWrapper", caseWrapper);
        cmp.set("v.caseWrapperMNF", caseWrapper);
        cmp.set("v.openSaveCase", true);
    },

    enableLink : function (cmp, event) {
        var currentRowIndex = event.getParam("currentRowIndex");
        var openedLinkData = event.getParam("openedLinkData");
        var closedTabId = event.getParam("closedTabId");
        console.log('currentRowIndex =>' + currentRowIndex);
        var tableDetails = cmp.get("v.searchResults");
        var tableRows = tableDetails.tableBody;
        // tableRows[currentRowIndex].linkDisabled = false;
        tableRows.forEach(element => {
            if (element.uniqueKey == openedLinkData.uniqueKey) {
                element.linkDisabled = false;
            }
        });
        var noRows=[];
        var enabled = [];
        var disabled = [];
        tableRows.forEach(element => {
        if(element.caseItemsExtId == 'No Matching Provider Lookup Results Found')
                          noRows.push(element);

            else if (element.linkDisabled) {
                disabled.push(element);
            }  else  {
                enabled.push(element);
            }
        });

        tableDetails.tableBody = noRows.concat(disabled.concat(enabled));
        cmp.set("v.searchResults",tableDetails);

        var existingTabs = cmp.get("v.existingTabs");
        var extTabs = [];
        existingTabs.forEach(tab => {
            if (tab.subtabId != closedTabId) {
                extTabs.push(tab);
            }
        });
        console.log(JSON.stringify(extTabs));
        cmp.set("v.existingTabs", extTabs);
    },
    // US2816912	Build UI for Create SRN for Add New Provider with Provider Look-up - 2/9/2020 - Sarma
    // firing a CMP event to add Provider card in CreteaSRN tab
    addProviderToAuth : function(component, event, helper) {

        let selectedRowDetails = component.get('v.selectedRows');
        if(selectedRowDetails.length > 0){

            let hscProviderDetails = selectedRowDetails[0].createSRNProviderDetails;

            var getUniqueKey = selectedRowDetails[0].rowDetails;

            if(!$A.util.isUndefinedOrNull(getUniqueKey)){

                var pDetails = getUniqueKey.split(',');

                var createSrnNetworkStatusRequestParams = new Object();

                createSrnNetworkStatusRequestParams.providerId = pDetails[1];
                createSrnNetworkStatusRequestParams.addressId = pDetails[2];
                createSrnNetworkStatusRequestParams.addressSequence = pDetails[3];
                createSrnNetworkStatusRequestParams.taxId = selectedRowDetails[0].rowColumnData[8].fieldValue;
                createSrnNetworkStatusRequestParams.status = selectedRowDetails[0].rowColumnData[1].fieldValue;
                createSrnNetworkStatusRequestParams.npi = selectedRowDetails[0].rowColumnData[9].fieldValue;



                var compEvent = component.getEvent("addProviderCardToAuthEvent");

                compEvent.setParams({
                    "memberTabId": component.get("v.memberTabId"),
                    "createSrnNetworkStatusRequestParams": createSrnNetworkStatusRequestParams,
                    "hscProviderDetails": hscProviderDetails
                });
                compEvent.fire();

                selectedRowDetails = []; // DE438149
                component.set('v.selectedRows',selectedRowDetails);
            }
        }
    },

    // DE373867 - Thanish - 8th Oct 2020
    onHippaChanged: function (cmp) {
        if(cmp.get("v.isHippaInvokedInProviderSnapShot")){
            var cardDetails = new Object();
            cardDetails.componentName = "HIPAA Guidelines";
            cardDetails.componentOrder = 0;
            cardDetails.noOfColumns = "slds-size_1-of-1";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.cardData = [
                {
                    "checked": true,
                    "disableCheckbox": true,
                    "fieldName": "HIPAA Guidelines",
                    "fieldType": "outputText",
                    "fieldValue": "Accessed"
                }
            ];
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueId") + 0, cardDetails);
        }
    },

    // US2931847
    autoLaunch: function (cmp, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            cmp.set("v.autoLaunchAddrId", params.addressId);
            cmp.set("v.populatedFromHeader", true);
            var tabfound = helper.checkExistingTab(cmp, event, helper, params.addressId);
            if (!tabfound) {
                helper.showSpinner(cmp);
                helper.openedDetailPages(cmp);
                cmp.set("v.pageNumber", 1);
                cmp.set("v.autoLaunched", true);
                cmp.set("v.isOnlyActive", false);
                helper.getProviderData(cmp, event, helper, 0);
            }
        }
    },

    clearTable: function (cmp, event, helper) {
        var tempArry = [];
        var tableDetails = cmp.get("v.searchResults");
        if (!$A.util.isEmpty(tableDetails)) {
            var tableRows = tableDetails.tableBody;
            for (var i in tableRows) {
                var tableRow = tableRows[i];
                if (tableRow.linkDisabled) {
                    tempArry.push(tableRow);
                }
            }
        }

        tableDetails.startNumber = tempArry.length > 0 ? 1 : 0;
        tableDetails.endNumber = tempArry.length;
        tableDetails.recordCount = tempArry.length;
        tableDetails.noOfPages = 1;

        tableDetails.tableBody = tempArry;
        cmp.set("v.searchResults", tableDetails);
    },

    handleAutodocRefresh: function (cmp, event, helper) {
        if (event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId")) {
            _autodoc.resetAutodoc(cmp.get("v.autodocUniqueId"));
            // helper.setDefaultAutodoc(cmp); DE482674 - Thanish - 1st Sep 2021
            var caseWrapper = cmp.get("v.caseWrapper");
            caseWrapper.savedAutodoc = '';
            caseWrapper.caseItems = [];
            cmp.set("v.caseWrapper", caseWrapper);
            
            // Save Case Consolidation - US3424763
            cmp.set("v.disableButtons", true);
            cmp.set("v.isCommentsBox", false);
            cmp.set("v.commentsValue", "");
            
            //DE445901 - close opened tabs
            helper.closeDetailTabs(cmp, event, helper);
        }
    },
    //Is Used for PCP Referral Provider Search
    onSearch : function(component, event, helper) {
        let objChildComp = component.find('lookupResultsId');
        const cnsValue = event.getSource().get('v.value').toUpperCase();
        objChildComp.invokeSearch(cnsValue);
    },

})