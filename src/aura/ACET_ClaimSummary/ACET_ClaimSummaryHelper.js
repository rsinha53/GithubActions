({
     openProvDetails : function (cmp, event, helper) {
         debugger;
        //var selectedRowdata = event.getParam("selectedRows");
        //var currentRowIndex = event.getParam("currentRowIndex");
        //console.log('selectedRowdata'+JSON.stringify(selectedRowdata));
        var memberDetails = cmp.get("v.memberDetails");
        if($A.util.isEmpty(memberDetails)) {
            memberDetails = new Object();
        }
        memberDetails.noMemberToSearch = cmp.get("v.noMemberToSearch");
        var getUniqueKey = cmp.get("v.getUniqueKey");
        var pDetails = getUniqueKey.split(',');

        var providerDetails = new Object();
        providerDetails.taxId = pDetails[0];
        providerDetails.providerId = pDetails[1];
        // US1958736 - Thanish - 5th Feb 2020
        providerDetails.addressId = pDetails[2];
        providerDetails.addressSequence = pDetails[3];
        providerDetails.isPhysician = pDetails[5];

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
                if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].patientInfo)) {
                     memberDetails.memberId=  memberCardData.CoverageLines[policySelectedIndex].patientInfo.MemberId;
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
                "insuranceTypeCode": insuranceTypeCode //  US2696849 - Thanish - 22nd Jul 2020
            }
        }


        var matchingTabs = [];
        var workspaceAPI = cmp.find("workspace");
        //workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
        workspaceAPI.getAllTabInfo().then(function (response) {
                let tabResponse;
                if (!$A.util.isUndefinedOrNull(response) && !$A.util.isEmpty(response)) {
                    for (let i = 0; i < response.length; i++) {
                        if (!$A.util.isUndefinedOrNull(response[i].subtabs.length) && response[i].subtabs.length > 0) {
                            for (let j = 0; j < response[i].subtabs.length; j++) {

                               if(response[i].subtabs[j].pageReference.state.c__providerID === providerDetails.providerId)
                               {

                                 tabResponse = response[i].subtabs[j];
                                 matchingTabs.push(response[i]);
                                 console.log("tabResponse: "+ tabResponse.pageReference.state.c__providerID);
                                 break;
                               }
                           }
                        }
                    }
                 }
                console.log("length: "+matchingTabs.length);
                if(!(matchingTabs.length == 0)){
                workspaceAPI.openTab({
                    url: tabResponse.url
                }).then(function (response) {
                    workspaceAPI.focusTab({
                        tabId: response
                    });
                }).catch(function (error) {
                });
            }else{

                // DE476754
                var rowData = new Object();
                rowData.caseItemsExtId = cmp.get("v.claimNo");

            workspaceAPI.openSubtab({
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACET_ProviderLookupDetails"
                    },
                    "state": {
                        "c__slectedRowLinkData": null,  //not used
                        "c__providerID": providerDetails.providerId,
                        "c__interactionRec": cmp.get("v.interactionRec"),
                        "c__memberDetails": memberDetails,
                        "c__noMemberToSearch": cmp.get("v.noMemberToSearch"),
                        "c__providerNotFound": cmp.get("v.providerNotFound"),
                        "c__providerDetails": providerDetails,
                        "c__sourceCode": cmp.get("v.sourceCode"),
                        "c__autodocPageFeature": cmp.get("v.autodocUniqueId"),
                        "c__autodocKey": autodocKey,
                        "c__currentRowIndex": null, //used for tab closing event
                        "c__provSearchResultsUniqueId": null,// KJ Doesnt' apppear this atribute is being used // DE307193 - Thanish 20th March 2020
                            "c__resultsTableRowData": rowData, //KJ  used only for tab closing event // DE307193 - Thanish 20th March 2020
                        "c__contactUniqueId": cmp.get("v.contactUniqueId"),
                        // US2623985 - Thanish - 10th Jun 2020
                        "c__contractFilterData": contractFilterData,
                        "c__isProviderSnapshot": cmp.get("v.isProviderSnapshot"),
                        "c__hipaaEndpointUrl":cmp.get("v.hipaaEndpointUrl"),//US2076634 - Sravan - 22/06/2020
                        "c__providerDetailsForRoutingScreen": null,//KJ doesn't appear to have been used //US2740876 - Sravan
                        "c__flowDetailsForRoutingScreen": null,// KJ doesn't appear to have been used //US2740876 - Sravan
                        "c__autodocUniqueId":cmp.get("v.autodocUniqueId"),
                        "c__autodocUniqueIdCmp":cmp.get("v.autodocUniqueIdCmp"),
                        "c__claimNo":cmp.get("v.claimNo"),
                        "c__currentIndexOfOpenedTabs":cmp.get("v.currentIndexOfOpenedTabs"),
                        "c__maxAutoDocComponents":cmp.get("v.maxAutoDocComponents"),
                        "c__interactionOverviewTabId": cmp.get("v.interactionOverviewTabId"), //US2491365 - Avish
                        "c__isClaim" : true,
                        "c__transactionId": cmp.get("v.policyDetails.resultWrapper.policyRes.transactionId") // US3446590 - Thanish - 21st Apr 2021
                    }
                },
                focus: true
            }).then(function (subtabId) {

                workspaceAPI.setTabLabel({
                    tabId: subtabId,
                    label: pDetails[4]
                });
                workspaceAPI.setTabIcon({
                    tabId: subtabId,
                    icon: "custom:custom55",
                    iconAlt: "Provider Lookup Details"
                });
                cmp.set("v.provAlreadyOpened", true) ;
                cmp.set("v.openedSubTabId", subtabId);
            }).catch(function (error) {
                console.log(error);
            })};
        });
    },
      getMAndRProviderStatus : function(cmp,helper,taxId, providerId, fieldName) {
		let policyDetails = cmp.get("v.policyDetails");
        let firstSrvcDt = cmp.get("v.firstSrvcDt");
        let contractFilterData = {};
         if(!$A.util.isEmpty(policyDetails)){
              contractFilterData = {
                  "cosmosDiv": policyDetails.resultWrapper.policyRes.cosmosDivision,
                  "cosmosPanelNbr": policyDetails.resultWrapper.policyRes.groupPanelNumber,
                  "coverageStartDate": policyDetails.resultWrapper.policyRes.coverageStartDate,
                  "coverageEndDate": policyDetails.resultWrapper.policyRes.coverageEndDate,
                  "providerDiv" : policyDetails.resultWrapper.policyRes.providerDiv,
                  "firstSrvcDt": firstSrvcDt
              }
          }
        let action2 = cmp.get("c.getMAndRProviderStatus");
        action2.setParams({
            "providerId": providerId,
            "taxId": taxId,
            "addressId": '',
			"pd": contractFilterData,
            "provDiv" : (!$A.util.isUndefinedOrNull(contractFilterData.providerDiv) ? contractFilterData.providerDiv : "" )
        });
          action2.setCallback(this, function (response2) {
              if(response2.getState() === "SUCCESS") {
                  let mnrProviderStatus = response2.getReturnValue();
                  console.log("mnrProviderStatus@@@@@"+JSON.stringify(mnrProviderStatus));
                  let cardDetails = mnrProviderStatus.mnrCardDetails;
                  var status = '--';
                  if(!$A.util.isEmpty(cardDetails)){
                      status = cardDetails.cardData.find(x => x.fieldName === 'Status').fieldValue;
                  }
                  helper.getProviderStatus(cmp,status,fieldName);
                  if(fieldName == 'Adjudicated Provider / Status'){
                      var CosContractNum = cmp.getEvent("CosContractNum");
                      CosContractNum.setParams({
                          "contractNumber" : mnrProviderStatus.contractNum
                      });
                      CosContractNum.fire();
                  }
              } else{
                  helper.getProviderStatus(cmp,'--',fieldName);
              }
          });
          $A.enqueueAction(action2);
	},
    getEAndIProviderStatus : function(component,helper,taxId,providerId,fieldName) {
		 let memberCardData = component.get('v.memberCardData');
        let policySelectedIndex = component.get('v.policySelectedIndex');
        var insuranceTypeCode = '';
        if(!$A.util.isEmpty(memberCardData)){
            if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex])) {
                if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].insuranceTypeCode)) {
                    insuranceTypeCode = memberCardData.CoverageLines[policySelectedIndex].insuranceTypeCode;
                }
            }
        }
        console.log("insuranceTypeCode@@@@@"+insuranceTypeCode);

        let policyDetails = component.get("v.policyDetails");
        let contractFilterData = {};
        if(!$A.util.isEmpty(policyDetails)){
            contractFilterData = {
                "policyNumber": policyDetails.resultWrapper.policyRes.policyNumber,
                "subscriberID": policyDetails.resultWrapper.policyRes.subscriberID,
                "sourceCode": policyDetails.resultWrapper.policyRes.sourceCode,
                "coverageStartDate": policyDetails.resultWrapper.policyRes.coverageStartDate,
                "coverageLevelNum": policyDetails.resultWrapper.policyRes.coverageLevelNum,
                "marketSite": policyDetails.resultWrapper.policyRes.marketSite,
                "marketType": policyDetails.resultWrapper.policyRes.marketType,
                "insTypeCode": insuranceTypeCode,
            }
        }
        let actionNetworkKey = component.get("c.getNetworkKeyStatus");
        actionNetworkKey.setParams({
			"subscriberId": contractFilterData.subscriberID,
			"policyNumber": contractFilterData.policyNumber,
			"sourceCode": contractFilterData.sourceCode,
			"coverageLevel": contractFilterData.coverageLevelNum,
			"coverageStartDate": contractFilterData.coverageStartDate,
			"isTermedPolicy": ((component.get("v.memberPolicies")[component.get("v.policySelectedIndex")].planStatus) == 'false'),
		});
		actionNetworkKey.setCallback(this, function (response) {
            if(response.getState() === "SUCCESS") {
				let returnValue = response.getReturnValue();
                console.log("returnValue@@@@@"+JSON.stringify(returnValue));
                console.log("selectedIPAValue@@@@@"+component.get("v.selectedIPAValue"));
                    let actionENI = component.get("c.getEAndIProviderStatusNew");
                    actionENI.setParams({
                        "providerId": providerId,
                        "taxId": taxId,
                        "addressSeq": '',
                        "pd": contractFilterData,
                        "networkKey": returnValue.networkKey,
                        "ipaValue" : component.get("v.selectedIPAValue"),
                    });
                    actionENI.setCallback(this, function (response) {
                        if(response.getState() === "SUCCESS") {
                            let eniResponse = response.getReturnValue();
                            if(eniResponse.success){
                                let eniProviderStatus = eniResponse;
                                let cardDetails = eniProviderStatus.eniCardDetails;
                                var status = '--';
                                if(!$A.util.isEmpty(cardDetails)){
                                    status = cardDetails.cardData.find(x => x.fieldName === 'Status').fieldValue;
                                }
                                helper.getProviderStatus(component,status,fieldName);
                            }
                        }else{
                            helper.getProviderStatus(component,'--',fieldName);
                        }
                    });
                    $A.enqueueAction(actionENI);
                 }
        });
        $A.enqueueAction(actionNetworkKey);
    },


    getProviderData: function (component, event, helper, taxId, providerId) {

        debugger;
        /*var cardDetails = component.get("v.selectedClaimDetailCard");
        var taxId = cardDetails.cardData.find(x => x.fieldName === 'Billing Tax ID').fieldValue;
        var providerId = cardDetails.cardData.find(x => x.fieldName === 'Billing  Provider ID').fieldValue;
        */
        var action = component.get("c.getProviderLookupResults");

        action.setParams({
            taxId: taxId,
            npi: null,
            providerId: providerId,
            providerType: null,
            speciality: null,
            lastNameOrFacility: null,
            firstName: null,
            state: null,
            zipCode: null,
            radius: null,
            acceptNewPatients: null,
            prefferedLab: null,
            inactiveProvs: null,
            freestandingFac: null,
            cosmosDiv: null,
            cosmosPanelNum: null,
            tciTableNum: null,
            lineofBusiness: null,
            memType: null,
            start: 1,
            endCount: 50,
            filtered : true,
	    	benefitLevel : null,
            marketSite:null,
            entityType:null,
            sharedArrangement : null,
            obligorID : null,
            productCode : null,
            marketType : null,
            isDetailOpened : true

        });
		this.showSpinner(component);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(!$A.util.isUndefinedOrNull(result.recordCount)){
                    //US2573718 - Auto Doc When No Results Are Displayed - Sravan - Start
                    if(result.recordCount == 0){
                         helper.showToast(component,event,helper);
                         component.set("v.autoCheck",true);

                    }
                    else{
                        //show the first record from provider results
                        var getUniqueKey = result.tableBody[0].rowDetails;
                        component.set("v.getUniqueKey",getUniqueKey);
                        console.log("provider search results "+ JSON.stringify(result));
                        helper.openProvDetails(component, event, helper);
                    }
                }
            } else {
                console.log('FAIL## ' + JSON.stringify(response.getReturnValue()));
            }
			this.hideSpinner(component);
        });
        $A.enqueueAction(action);
      },
    getProviderStatus : function(cmp,status,fieldname) {
        var selectedClaimDetailCard = cmp.get("v.selectedClaimDetailCard");
        var billingStatus =selectedClaimDetailCard.cardData.find(x => x.fieldName === fieldname).fieldValue;
        billingStatus = billingStatus+'/'+status;
        selectedClaimDetailCard.cardData.find(x => x.fieldName === fieldname).fieldValue = billingStatus;

        cmp.set("v.selectedClaimDetailCard",selectedClaimDetailCard);
        this.hideSpinner(cmp);
    },

      showToast : function(component, event, helper) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type": "error",
                "message": "No additional provider details found."
            });
            toastEvent.fire();
      },

      hideSpinner: function (cmp) {
        var spinner = cmp.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
      },

      showSpinner: function (cmp) {
        var spinner = cmp.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
      }

})