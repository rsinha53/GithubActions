({
   doInit: function(cmp, event, helper) {

         helper.showSpinner(cmp);
         console.log("ACET_ClaimDetailController - init" );
         var pageReference = cmp.get("v.pageReference");
         helper.getMemberIdGroupIdAuthDtl(cmp);
         var hipaaEndPointUrl = pageReference.state.c__hipaaEndpointUrl;
		 // Start of US3472990 - Team Blinkers -Bala
		 var exploretaxId = pageReference.state.c__ExploreTaxId;
         var claimTaxId = pageReference.state.c__claimInput.taxId;
       if(exploretaxId != claimTaxId){
           helper.showToastMessage("Warning!", "The claim that you selected is for a different TAX ID. Follow HIPAA Guidelines if quoting any information.","warning", "dismissible", "10000");
       }
		 cmp.set('v.claimType',pageReference.state.c__addClaimType);
         cmp.set('v.networkStatus',pageReference.state.c__addnetworkStatus);
         cmp.set('v.billtype',pageReference.state.c__addbilltype);
         // End of US3472990 - Team Blinkers -Bala
         cmp.set("v.claimNo", pageReference.state.c__claimNo);
         cmp.set("v.isClaim", pageReference.state.c__isClaim);
         cmp.set("v.claimInput",pageReference.state.c__claimInput)
         cmp.set("v.interactionRec", JSON.parse(pageReference.state.c__interactionRec));
         cmp.set("v.hipaaEndpointUrl",hipaaEndPointUrl);
         cmp.set("v.contactUniqueId", pageReference.state.c__contactUniqueId);
         cmp.set("v.interactionOverviewTabId", pageReference.state.c__interactionOverviewTabId);
         cmp.set("v.isMRlob", pageReference.state.c__isMRlob);
         cmp.set("v.selectedClaimDetailCard", JSON.parse(pageReference.state.c__selectedClaimDetailCard));
         cmp.set("v.selectedClaimStatusTable", JSON.parse(pageReference.state.c__selectedClaimStatusTable));
         cmp.set("v.PolicyDetails", JSON.parse(pageReference.state.c__contractFilterData));
         cmp.set("v.selectedInOutDetailCard", JSON.parse(pageReference.state.c__mapInOutPatientDetail));
         console.log("selectedInOutDetailCard@@@"+ JSON.stringify(cmp.get('v.selectedInOutDetailCard')));

         cmp.set("v.contactName",pageReference.state.c__contactName);
         cmp.set("v.providerNotFound",pageReference.state.c__providerNotFound);
         cmp.set("v.isProviderSearchDisabled",pageReference.state.c__isProviderSearchDisabled);
         cmp.set("v.isOtherSearch",pageReference.state.c__isOtherSearch);
         cmp.set("v.contactCard",pageReference.state.c__contactCard);
         cmp.set("v.memberInfo",pageReference.state.c__memberInfo);

       	 cmp.set("v.autodocUniqueId",pageReference.state.c__autodocUniqueId);
         cmp.set("v.relatedDocData",pageReference.state.c__relatedDocData);
         cmp.set("v.autodocUniqueIdCmp",pageReference.state.c__autodocUniqueIdCmp);
         cmp.set("v.currentIndexOfOpenedTabs",pageReference.state.c__currentIndexOfOpenedTabs);
         cmp.set("v.isClaimNotOnFile",pageReference.state.c__isClaimNotOnFile);
         cmp.set("v.currentRowIndex", pageReference.state.c__currentRowIndex);
         cmp.set("v.resultsTableRowData", pageReference.state.c__resultsTableRowData); // DE307193 - Thanish 20th March 2020
         //US3189884 - Sravan - Start
         cmp.set("v.callTopicLstSelected",JSON.parse(pageReference.state.c__callTopicLstSelected));
         cmp.set("v.callTopicTabId",pageReference.state.c__callTopicTabId);
         console.log('Call Topics'+cmp.get("v.callTopicLstSelected"));
         console.log('Call Topic Id'+ cmp.get("v.callTopicTabId"));
        cmp.set("v.memberEEID", pageReference.state.c__memberEEID); // US3177995 - Thanish - 22nd Jun 2021
         //US3189884 - Sravan - End

         // ketki 12/22 opening auth detail from claim detail page
         cmp.set("v.claimspolicyDetails", pageReference.state.c__policyDetails);
         cmp.set("v.selectedIPAValue", pageReference.state.c__selectedIPAValue);
         console.log("v.PolicyDetails in ACET_ClaimDetails: "+ JSON.stringify(cmp.get('v.PolicyDetails')));
         console.log("v.selectedClaimStatusTable in ACET_ClaimDetails: "+ JSON.stringify(cmp.get('v.selectedClaimStatusTable')));
         console.log(pageReference.state.c__interactionOverviewTabId);
         console.log("ketki log-- value of claimNo in claimDetail: "+ cmp.get("v.claimNo"));
         cmp.set("v.providerId", pageReference.state.c__providerId);
         //helper.getClaimDetails(cmp, event, helper);
         var selectedClaimDetailCard = cmp.get("v.selectedClaimDetailCard");
       cmp.set("v.memberPolicies",JSON.parse(pageReference.state.c__memberPolicies));
       var workspaceAPI = cmp.find("workspace");
       workspaceAPI.getEnclosingTabId().then(function(tabId) {
            cmp.set("v.tabId",tabId);
       })
        .catch(function(error) {
            console.log(error);
        });
       var cardDataListRec =  selectedClaimDetailCard.cardData;
       var KeyedClaimValue = '';
       var OriginalValue = '';
       var claimIdValue = '';
       var ClaimStatusValue = '';
       var isKeyedClaimSame = false;
       var isOriginalClaimSame = false;
       var isRejected = false;
       var KeyedClaimVal ;
       var OriginalVal;
       var originalClaimfieldType = '';

       for(var x in cardDataListRec){
           var fieldRec = cardDataListRec[x];
           if(fieldRec.fieldName == 'Keyed Claim #'){
               KeyedClaimValue = fieldRec.fieldValue;
           }
           if(fieldRec.fieldName == 'Original Claim #'){
               OriginalValue = fieldRec.fieldValue;
           }
           if(fieldRec.fieldName == 'claimId'){
               claimIdValue = fieldRec.fieldValue;
           }
           if(fieldRec.fieldName == 'claimStatus'){
               ClaimStatusValue = fieldRec.fieldValue;
           }
       }
       cmp.set("v.claimRecStatus", ClaimStatusValue);

      /* if(KeyedClaimValue == claimIdValue){
           isKeyedClaimSame = true;
       }

       if(OriginalValue == claimIdValue){
           isOriginalClaimSame = true;
       }

       if(ClaimStatusValue == 'Rejected'){
           isRejected = true;
       }

       if(isRejected){
          originalClaimfieldType = 'outputText';
       }*/

       //const cardDataKeeyedClaim = cardDataListRec.find(i => i.fieldName == 'Keyed Claim #');
       //const cardDataOriginalClaim = cardDataListRec.find(i => i.fieldName == code);
       //if(!codeFound){
         //  if(fieldRec.fieldName == 'Keyed Claim #'){

           //}

      // }

       if(!cmp.get("v.isClaimNotOnFile")){
           var selectedClaimDetailCard = cmp.get("v.selectedClaimDetailCard");
           //selectedClaimDetailCard.componentName = "Claim Summary";
           var cardDataList =  selectedClaimDetailCard.cardData;
           var CNFSummaryFields = cmp.get("v.CDSummaryFields");
           let CNFSummaryFieldsNew = new Set();
           var cardDataListNew = [];
           for (var x in CNFSummaryFields) {
               CNFSummaryFieldsNew.add(CNFSummaryFields[x]);
           }
           for(var x in cardDataList){
               var fieldRec = cardDataList[x];

               if(!CNFSummaryFieldsNew.has(fieldRec.fieldName)){
                   cardDataListNew.push(fieldRec);
               }

           }
           selectedClaimDetailCard.cardData = cardDataListNew;
           cmp.set("v.selectedClaimDetailCard",selectedClaimDetailCard);


         helper.getClaimDetails(cmp, event, helper);
       }else{
           cmp.set("v.additionalClaimInfoCNF",JSON.parse(pageReference.state.c__selectedAdditionalInfoTable));

           var selectedClaimDetailCard = cmp.get("v.selectedClaimDetailCard");
           //selectedClaimDetailCard.componentName = "Claim Summary";
           var cardDataList =  selectedClaimDetailCard.cardData;
           var CNFSummaryFields = cmp.get("v.CNFSummaryFields");
           let CNFSummaryFieldsNew = new Set();
           var cardDataListNew = [];
           for (var x in CNFSummaryFields) {
               CNFSummaryFieldsNew.add(CNFSummaryFields[x]);
           }
           for(var x in cardDataList){
               var fieldRec = cardDataList[x];
               if(!CNFSummaryFieldsNew.has(fieldRec.fieldName)){
                   var fieldTypeCNF = 'link';
                   var fieldValueCNF = fieldRec.fieldValue;
                   if(fieldRec.fieldName == 'Keyed Claim #'){

                       if(fieldValueCNF == claimIdValue && fieldValueCNF.length < 15){
                           isKeyedClaimSame = true;
                           fieldTypeCNF = "outputText";
                       }
                       if( fieldValueCNF.length == 15 ){
                           fieldTypeCNF = "link";
                       }
                       var fieldRecord = {
                           "checked": false,
                           "defaultChecked": false,
                           "fieldName": "Keyed Claim #",
                           "fieldType": fieldTypeCNF,
                           "fieldValue": fieldValueCNF,
                           "isReportable": true,
                           "showCheckbox": true
                       }
                       fieldRec = fieldRecord;
                   }

                   if(fieldRec.fieldName == 'Original Claim #'){

                       if(OriginalValue == claimIdValue){
                           isOriginalClaimSame = true;
                           fieldTypeCNF = "outputText";
                           fieldValueCNF = "--";
                       }

                       if(ClaimStatusValue == 'Rejected'){
                           fieldValueCNF = "--";
                           fieldTypeCNF = "outputText";
                       }

                       var fieldRecord = {
                           "checked": false,
                           "defaultChecked": false,
                           "fieldName": "Original Claim #",
                           "fieldType": fieldTypeCNF,
                           "fieldValue": fieldValueCNF,
                           "isReportable": true,
                           "showCheckbox": true
                       }
                       fieldRec = fieldRecord;
                   }
                   cardDataListNew.push(fieldRec);
               }
           }
           selectedClaimDetailCard.cardData = cardDataListNew;
           cmp.set("v.selectedClaimDetailCard",selectedClaimDetailCard);
           var hideSpinnerCNF = cmp.get("c.hideSpinnerController");
           $A.enqueueAction(hideSpinnerCNF);
       }
         //added by chandra

                        cmp.set("v.caseWrapperMNF",pageReference.state.c__caseWrapperMNF);
                        cmp.set("v.componentId",pageReference.state.c__componentId);
                        cmp.set("v.memberDOB",pageReference.state.c__memberDOB);
                        cmp.set("v.policyDetails",pageReference.state.c__policyDetails);
                        cmp.set("v.memberFN",pageReference.state.c__memberFN);
                        cmp.set("v.memberCardData",pageReference.state.c__memberCardData);
                        cmp.set("v.memberCardSnap",pageReference.state.c__memberCardSnap);
                        cmp.set("v.policyNumber",pageReference.state.c__policyNumber);
                        cmp.set("v.houseHoldMemberId",pageReference.state.c__houseHoldMemberId);
                        cmp.set("v.memberPolicies",JSON.parse(pageReference.state.c__memberPolicies));
                		   console.log('===@@@###memberPolicies44='+JSON.stringify(cmp.get("v.memberPolicies")));
                        cmp.set("v.policySelectedIndex",pageReference.state.c__policySelectedIndex);
                        cmp.set("v.currentPayerId",pageReference.state.c__currentPayerId);
                        cmp.set("v.autoDocToBeDeleted",pageReference.state.c__autoDocToBeDeleted);
                        cmp.set("v.serviceFromDate",pageReference.state.c__serviceFromDate);
                        cmp.set("v.serviceToDate",pageReference.state.c__serviceToDate);


       // End of change

       //Bharat Added
               cmp.set("v.memberLN",pageReference.state.c__memberLN);
               cmp.set("v.memberTabId",pageReference.state.c__memberTabId);
               cmp.set("v.Type",pageReference.state.c__Type);
               cmp.set("v.SubType",pageReference.state.c__SubType);
               cmp.set("v.AuthAutodocPageFeature",pageReference.state.c__AuthAutodocPageFeature);
               cmp.set("v.authContactName",pageReference.state.c__authContactName);
               cmp.set("v.interactionType",pageReference.state.c__interactionType);
               cmp.set("v.AutodocPageFeatureMemberDtl",pageReference.state.c__AutodocPageFeatureMemberDtl);
                cmp.set("v.AutodocKeyMemberDtl",pageReference.state.c__AutodocKeyMemberDtl);
              // cmp.set("v.caseNotSavedTopics",pageReference.state.c__caseNotSavedTopics);
               cmp.set("v.providerDetailsForRoutingScreen",pageReference.state.c__providerDetailsForRoutingScreen);
               cmp.set("v.flowDetailsForRoutingScreen",pageReference.state.c__flowDetailsForRoutingScreen);
               cmp.set("v.interactionCard",pageReference.state.c__interactionCard);
               cmp.set("v.selectedTabType",pageReference.state.c__selectedTabType);
               cmp.set("v.originatorType",pageReference.state.c__originatorType);

       //Bharat End

              //Bharat Financial Start

			   cmp.set("v.selectedPolicy",JSON.parse(pageReference.state.c__selectedPolicy));
               cmp.set("v.callTopicOrder",JSON.parse(pageReference.state.c__callTopicOrder));
               cmp.set("v.planLevelBenefitsRes",JSON.parse(pageReference.state.c__planLevelBenefitsRes));
               cmp.set("v.eligibleDate",pageReference.state.c__eligibleDate);
               cmp.set("v.highlightedPolicySourceCode",pageReference.state.c__highlightedPolicySourceCode);
               cmp.set("v.isSourceCodeChanged",pageReference.state.c__isSourceCodeChanged);
               cmp.set("v.policyStatus",pageReference.state.c__policyStatus);
               cmp.set("v.isTierOne",pageReference.state.c__isTierOne);
               cmp.set("v.policyDetailss",pageReference.state.c__policyDetails);
               cmp.set("v.memberPoliciess",JSON.parse(pageReference.state.c__memberPolicies));
               cmp.set("v.houseHoldData",JSON.parse(pageReference.state.c__houseHoldData));
               cmp.set("v.dependentCode",pageReference.state.c__dependentCode);
               cmp.set("v.cobData",JSON.parse(pageReference.state.c__cobData));
               cmp.set("v.secondaryCoverageList",JSON.parse(pageReference.state.c__secondaryCoverageList));
               cmp.set("v.cobMNRCommentsTable",JSON.parse(pageReference.state.c__cobMNRCommentsTable));
               cmp.set("v.cobENIHistoryTable",JSON.parse(pageReference.state.c__cobENIHistoryTable));
               cmp.set("v.regionCode",pageReference.state.c__regionCode);
       		  cmp.set("v.providerDetails",JSON.parse(pageReference.state.c__providerDetails));
               var claimDetailPageOpenedFromCNFPage = pageReference.state.c__claimDetailPageOpenedFromCNFPage;
               if(claimDetailPageOpenedFromCNFPage){
                   cmp.set("v.claimDetailPageOpenedFromCNFPage",claimDetailPageOpenedFromCNFPage);
               }


              //Bharat FiNANCIAL End

       var selectedInOutDetailCard = cmp.get("v.selectedInOutDetailCard");
       var currentIndexOfOpenedTabs = cmp.get("v.currentIndexOfOpenedTabs");
       var maxAutoDocComponents = cmp.get("v.maxAutoDocComponents");
       selectedInOutDetailCard.componentOrder = selectedInOutDetailCard.componentOrder + (maxAutoDocComponents*currentIndexOfOpenedTabs);
       cmp.set("v.selectedInOutDetailCard",selectedInOutDetailCard);
       var relatedDocData = cmp.get("v.relatedDocData");
       if(relatedDocData.platform == 'UNET'){
           helper.getContractExceptions(cmp, event, helper, relatedDocData.platform);
       }

    },
     //View Claim Details Page - Add hippa guidelines Button
	 handleHippaGuideLines : function(component, event, helper) {
         var hipaaEndPointUrl = component.get("v.hipaaEndpointUrl");
         if(!$A.util.isUndefinedOrNull(hipaaEndPointUrl) && !$A.util.isEmpty(hipaaEndPointUrl)){
              window.open(hipaaEndPointUrl, '_blank');
         }
         component.set("v.isHipaa",true);

         //Added by Mani -- Start 12/02/2020
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
                 "fieldValue": "HIPAA Guidelines button was selected."
             }
         ];
         _autodoc.setAutodoc(component.get("v.autodocUniqueId"), 0, cardDetails);
         //Added by Mani -- End
	},
    //View Claim Details Page - Add Misdirect Button
     openMisdirectComp: function (component, event, helper) {
        console.log("component retrieved "+ component);
        helper.openMisDirect(component, event, helper);
    },
    //View Claim Details Page - Add Alerts Button
    getAlertsClaimDetails : function(component, event, helper) {
        component.find("alertsAI_ClaimDetails").getAlertsOnClaimDetailsPage();
    },

     onTabClosed: function (cmp, event, helper) {
        if(!cmp.get("v.claimDetailPageOpenedFromCNFPage")){
        let tabId = event.getParam('tabId');
            if(tabId == cmp.get("v.tabId")) {
                let tabClosedEvt = $A.get("e.c:ACET_EnableAutoDocLink");
                tabClosedEvt.setParams({
                    "closedTabId" : tabId,
                    "openedLinkData":cmp.get("v.resultsTableRowData"),
                    "currentRowIndex":cmp.get("v.currentRowIndex")
                });
                tabClosedEvt.fire();
            }
        }

    },

    onTabFocused: function (cmp, event, helper) {
        let focusedTabId = event.getParam('currentTabId');
        let tabId = cmp.get("v.tabId");
        if($A.util.isEmpty(tabId))
            cmp.set("v.tabId", focusedTabId);
      },

    setMmberIdGroupIdAuthDtl : function(component, event, helper) {
        var memberId = event.getParam("memberIdAuthDtl");
        var GroupId = event.getParam("groupIdAuthDtl");
        var taxId = event.getParam("alertTaxId");
        var providerId = event.getParam("alertProviderId");

        component.set("v.groupIdAuthDtl",GroupId);
        component.set("v.alertProviderId",providerId);
        component.set("v.alertTaxId",taxId);
        component.set("v.memberIdAuthDtl",memberId);
    },

    // US3474282 - Thanish - 15th Jul 2021 - removed unwanted code

    toggleSection: function (component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();

        var sectionState = sectionDiv.getAttribute('class').search('slds-is-close');

        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
            component.set("v.showHighlightsPanel",false);//US3189884 - Sravan
        }
        else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
            component.set("v.showHighlightsPanel",true);//US3189884 - Sravan
        }
    },

    //US3189884 - Sravan - Start
    navigateToCallTopic : function(component, event, helper){
        var selectedPillId = event.getSource().get("v.label");
         component.set("v.callTopicName",selectedPillId);
         var calltopictabid = component.get("v.callTopicTabId");
         var workspaceAPI = component.find("workspace");
         workspaceAPI.focusTab({
             tabId : calltopictabid
         }).then(function(response) {
             console.log("tabfocused");
             var focusCalltopicTab = component.get('c.focusCalltopicTab');
             $A.enqueueAction(focusCalltopicTab);
        }).catch(function(error) {
             console.log(error);
         });
     },
    //US3189884 - Sravan - End

    toggleSection1: function (component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv =component.find(sectionAuraId).getElement();

        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');

        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
    },
    viewCOBHistory: function (component, event, helper) {
        var cobhistoryViewed = event.getParam("cobhistoryViewed");
        component.set("v.isShowCobHistory", cobhistoryViewed);
    },
    handleCNFEvent: function (component, event, helper) {
        var originalKeyedClaim = event.getParam("claimNumber");
        var fieldName = event.getParam("fieldName");
        component.set("v.originalKeyedClaim", originalKeyedClaim);
        //helper.openClaimDetails(component, event, helper);
        var claimStatusRej = "Rejected";
        var claimRecStatus = component.get("v.claimRecStatus")
        if( claimRecStatus.toUpperCase() == claimStatusRej.toUpperCase() || (originalKeyedClaim.length == 15)){
            helper.navigateToClaimsDoc(component, event, helper);
        }else{
            helper.callGetClaimsDetails(component, event, helper);
        }
        helper.autoKeyedOriginalClaim(component, event, helper,fieldName);
    },
    switchClaimsNo: function (cmp, event, helper) {
        cmp.set("v.showWarning",false);
    },
    switchClaimsYes: function (component, event, helper) {
        helper.openMemberSnapshotPage(component, event, helper);
    },
    hideSpinnerController: function (component, event, helper) {
        setTimeout(function() {
            helper.hideSpinner(component);
        }, 1000);
    },
     handleCosContractNum: function (cmp, event, helper) {
        var contractNumber = event.getParam("contractNumber");
        cmp.set("v.contractNumber",contractNumber);
        helper.getContractExceptions(cmp, event, helper,'COSMOS');
     }

})