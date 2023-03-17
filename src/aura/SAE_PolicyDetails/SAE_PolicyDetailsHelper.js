({
    // US3299151 - Thanish - 16th Mar 2021
    policyDetailsErrorMessage: "Unexpected Error Occurred in the Policy Details Card. Please try again. If problem persists please contact the help desk",

    payerIdPopulation : function(component,event,helper){
        //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga - START
        var policy = component.get("v.policyDetails");
		var currentTranscationId = '';
        if (!$A.util.isUndefined(policy) && !$A.util.isUndefined(policy.resultWrapper) && !$A.util.isUndefined(policy.resultWrapper.policyRes)) {
          currentTranscationId = policy.resultWrapper.policyRes.transactionId;
        }
        //US2855833
        else if(!$A.util.isUndefinedOrNull(component.get("v.currentTransactionId"))  && !$A.util.isEmpty(component.get("v.currentTransactionId")) ){
            currentTranscationId = component.get("v.currentTransactionId");
        }
        var policymap = component.get("v.policywithPayerIdMap");
        var isDependent = component.get("v.isDependent");
        var isActiveFound =false;
        var strDependentActiveValue='';
        if(currentTranscationId != '' && policymap != null && !$A.util.isEmpty(policymap) ){
            for(var key in policymap){
                var currentPayerIdValue = policymap[key].split(';;');
                if(key == currentTranscationId){
                    isActiveFound = true;
                	component.set("v.payerId",currentPayerIdValue[0]);
                }
                if(currentPayerIdValue[1] == 'T'){
                    strDependentActiveValue = currentPayerIdValue[0];
                }
            }
            if(isActiveFound == false ){
                if(isDependent && strDependentActiveValue != '' ){
                   component.set("v.payerId",strDependentActiveValue);
                }
                else if(component.get("v.searchQueryPayerId") != ''){
                	component.set("v.payerId",component.get("v.searchQueryPayerId"));
                }

            }
        }
        else if(component.get("v.searchQueryPayerId") != ''){
            component.set("v.payerId",component.get("v.searchQueryPayerId"));
        }
        //US2669563-MVP- Member Snapshot - Policy Details - Populate Payer ID-Durga -END
        //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga
         if(!$A.util.isUndefinedOrNull(component.get("v.caseWrapper"))){
            var caseWrapper = component.get("v.caseWrapper");

            if(!$A.util.isUndefinedOrNull(component.get("v.payerId"))){
                 caseWrapper.payerId  = component.get("v.payerId");

            }
            if(!$A.util.isUndefinedOrNull(component.get("v.groupName")) && component.get("v.groupName") != '--' ){
                caseWrapper.groupName  = component.get("v.groupName");
            }
            component.set("v.caseWrapper",caseWrapper);
        }
    },
    callAddressName :function (component, event, helper){
        console.log('currentTransactionId');
        console.log(component.get("v.currentTransactionId"));
        let action = component.get("c.getPolicyAddress");
        var params = {
            "transactionId": component.get('v.currentTransactionId') 
        };
        action.setParams(params);
        action.setCallback(this, function (response) {
             let state = response.getState();
            console.log(state);
         if (state === "SUCCESS") {
             var addResultWrap=response.getReturnValue();
            component.set("v.policyaddresswp",addResultWrap);
             console.log('---originalEffectiveDate---')
            console.log(component.get('v.policyaddresswp').originalEffectiveDate);
         }
            else{
                console.log('AddressDetails--Issue');
            }
        });
        $A.enqueueAction(action);
    },

    // US2646403
    callGroupName: function (component, event, helper) {
        this.showSpinner(component);
        let action = component.get("c.call_RCED_API");
        
        var policyData = component.get("v.policyDetails");
        
        var sourceCode = '';
        if (!$A.util.isUndefinedOrNull(policyData.resultWrapper) && !$A.util.isUndefinedOrNull(policyData.resultWrapper.policyRes) &&
        !$A.util.isUndefinedOrNull(policyData.resultWrapper.policyRes.sourceCode)) {
            sourceCode = policyData.resultWrapper.policyRes.sourceCode;
        }
        var params = {
            "subscriberId": component.get('v.subjectCard').EEID,
            "policyNumber": component.get('v.policyNumber'),
            "sourceCode": sourceCode
        };
        action.setParams(params);
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                //component.set("v.groupName", response.getReturnValue());
                //US2770009
                var rcedResultWrap=response.getReturnValue();
                if(!$A.util.isUndefinedOrNull(rcedResultWrap))
                {
                    if(!$A.util.isUndefinedOrNull(rcedResultWrap.statusCode) && rcedResultWrap.statusCode==200)
                    {
                        
                        if(!$A.util.isUndefinedOrNull(rcedResultWrap.groupName) && rcedResultWrap.groupName != '--')
                        {
                            component.set("v.groupName", rcedResultWrap.groupName);
                            console.log('rcedgroupname',rcedResultWrap.groupName);
                        }else
                        {
                            component.set("v.isGroupNameBlank", false);
                            component.set("v.groupName", rcedResultWrap.groupName);
                        }
                        //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga -START
                        if(!$A.util.isUndefinedOrNull(component.get("v.caseWrapper"))){
                            var caseWrapper = component.get("v.caseWrapper");
                            if(!$A.util.isUndefinedOrNull(component.get("v.groupName")) && component.get("v.groupName") != '--' ){
                                caseWrapper.groupName  = component.get("v.groupName");
                            }
                            component.set("v.caseWrapper",caseWrapper);
                        }
                        //US2784325 - TECH: Case Details - Caller ANI/Provider Add'l Elements Mapped to ORS - Durga - END
                    // US3299151 - Thanish - 16th Mar 2021
                    } else{
                        component.set("v.isGroupNameBlank", true);
                        helper.fireToastMessage("We hit a snag.", this.policyDetailsErrorMessage, "error", "dismissible", "30000");
                    }
                }
            }
            else
            {
                        component.set("v.isGroupNameBlank", true);
                helper.fireToastMessage("We hit a snag.", this.policyDetailsErrorMessage, "error", "dismissible", "30000"); // US3299151 - Thanish - 16th Mar 2021
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    /*
    // US2646403
    showSpinner: function (component) {
        var spinner = component.find("policydetails-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    // US2646403
    hideSpinner: function (component) {
        var spinner = component.find("policydetails-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },*/
    //US2770009
    fireToastMessage: function (title, message, type, mode, duration) {
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

    // US2808743 - Thanish - 3rd Sep 2020 - New Autodoc Framework
    setAutodocCardData: function (cmp, strIdentifierValue, strSourceCode, isGracePeriod, objPolicyDetails) {
        var autodocCmp = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), "Policy Details");
		var mktype;
        var sarrangement;                
        if(!$A.util.isEmpty(autodocCmp) && !autodocCmp.isDummyData){ // DE418896 - Thanish - 22nd Mar 2021
            cmp.set("v.cardDetails", autodocCmp);

        } else {
            var policyDetails = cmp.get("v.policyDetails");
            


            if(!$A.util.isEmpty(policyDetails.resultWrapper.policyRes.marketType)&&!$A.util.isEmpty(policyDetails.resultWrapper.policyRes.marketSite)){
            mktype = policyDetails.resultWrapper.policyRes.marketType + '' + '/'+ ''+ policyDetails.resultWrapper.policyRes.marketSite;
        	}
            if(($A.util.isEmpty(policyDetails.resultWrapper.policyRes.marketType))&&!$A.util.isEmpty(policyDetails.resultWrapper.policyRes.marketSite)){
             mktype = '--' + '' + '/'+ ''+ policyDetails.resultWrapper.policyRes.marketSite;
            }
            if(!$A.util.isEmpty(policyDetails.resultWrapper.policyRes.marketType)&&$A.util.isEmpty(policyDetails.resultWrapper.policyRes.marketSite)){
            mktype = policyDetails.resultWrapper.policyRes.marketType + '' + '/'+ ''+ '--';
            }
            if($A.util.isEmpty(policyDetails.resultWrapper.policyRes.marketType)&&$A.util.isEmpty(policyDetails.resultWrapper.policyRes.marketSite)){
            mktype = '--' + '' + '/'+ ''+ '--';
            }
        	if(!$A.util.isEmpty(policyDetails.resultWrapper.policyRes.sharedArrangement)&&!$A.util.isEmpty(policyDetails.resultWrapper.policyRes.obligorID)){
            sarrangement = policyDetails.resultWrapper.policyRes.sharedArrangement+''+ '/'+ ''+policyDetails.resultWrapper.policyRes.obligorID;
        	}
            if($A.util.isEmpty(policyDetails.resultWrapper.policyRes.sharedArrangement)&&!$A.util.isEmpty(policyDetails.resultWrapper.policyRes.obligorID)){
            sarrangement = '--' + '' + '/'+ ''+ policyDetails.resultWrapper.policyRes.obligorID;
            }
            if(!$A.util.isEmpty(policyDetails.resultWrapper.policyRes.sharedArrangement)&&$A.util.isEmpty(policyDetails.resultWrapper.policyRes.obligorID)){
            sarrangement = policyDetails.resultWrapper.policyRes.sharedArrangement + '' + '/'+ ''+ '--';
            }
            if($A.util.isEmpty(policyDetails.resultWrapper.policyRes.sharedArrangement)&&$A.util.isEmpty(policyDetails.resultWrapper.policyRes.obligorID)){
            sarrangement = '--' + '' + '/'+ ''+ '--';
            }
            var policyList = cmp.get("v.policyList");
            var claimsMailingAddress = "";
            var claimsEffDate ="";
           /* if(!$A.util.isEmpty(policyList) && policyList.length > cmp.get("v.policySelectedIndex")){
                // DE407175 - Thanish - 18th Jan 2021
                claimsMailingAddress = (!$A.util.isEmpty(policyList[cmp.get("v.policySelectedIndex")].addressLine1) ? claimsMailingAddress + policyList[cmp.get("v.policySelectedIndex")].addressLine1 + "\n" : "")
                                     + (!$A.util.isEmpty(policyList[cmp.get("v.policySelectedIndex")].city) ? policyList[cmp.get("v.policySelectedIndex")].city + ", " : "")
                                     + (!$A.util.isEmpty(policyList[cmp.get("v.policySelectedIndex")].state) ? policyList[cmp.get("v.policySelectedIndex")].state + "\n" : "")
                                     + (!$A.util.isEmpty(policyList[cmp.get("v.policySelectedIndex")].zip) ? policyList[cmp.get("v.policySelectedIndex")].zip : "");
            }*/
             //claimsMailingAddress= cmp.get("v.policyaddresswp").city;
            if(!$A.util.isEmpty(cmp.get("v.policyaddresswp"))) {
                claimsMailingAddress = (!$A.util.isEmpty(cmp.get("v.policyaddresswp").street1) ? claimsMailingAddress + cmp.get("v.policyaddresswp").street1 + "\n" : "")
                + (!$A.util.isEmpty(cmp.get("v.policyaddresswp").street2) ? cmp.get("v.policyaddresswp").street2 + "\n" : "")
                + (!$A.util.isEmpty(cmp.get("v.policyaddresswp").city) ? cmp.get("v.policyaddresswp").city +", " : "")
                + (!$A.util.isEmpty(cmp.get("v.policyaddresswp").state) ? cmp.get("v.policyaddresswp").state +  "\n" : "")
                + (!$A.util.isEmpty(cmp.get("v.policyaddresswp").zip) ? cmp.get("v.policyaddresswp").zip : "");

				claimsEffDate= cmp.get("v.policyaddresswp").originalEffectiveDate;
            }
// US2928520: Policies Card
           /* if(!$A.util.isEmpty(policyDetails.resultWrapper.policyRes.productType)){
                if(policyDetails.resultWrapper.policyRes.sourceCode == "CO"){
                    if(!$A.util.isEmpty(selectedPolicyData.insuranceTypeCode)){
                        if(selectedPolicyData.insuranceTypeCode == "HN"){
                            productType = "HMO";
                        } else if(selectedPolicyData.insuranceTypeCode == "PR"){
                            productType = "PPO";
                        } else if(selectedPolicyData.insuranceTypeCode == "PS"){
                            productType = "POS";
                        }
                    }
                } else{
                    productType = policyDetails.resultWrapper.policyRes.productType;
                }
            }*/

            let strDatePaid, lstDetails;
            if(objPolicyDetails.strGracePaidThrough) {
                lstDetails = objPolicyDetails.strGracePaidThrough.split('-');
                if(lstDetails.length == 3) {
                        strDatePaid = lstDetails[1]+'/'+lstDetails[2]+'/'+lstDetails[0];
                 }
            }

            // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021
            var caseItemsExtId = '';
            var memberCardData = cmp.get("v.memberCardData");
            var memberId = '';
            var groupNumber = '';
            var sourceCode = '';
            var policySelectedIndex = cmp.get("v.policySelectedIndex");

            if(!$A.util.isUndefinedOrNull(memberCardData) && !$A.util.isUndefinedOrNull(memberCardData.CoverageLines) && !$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex]) && !$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].patientInfo)){
                memberId = !$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].patientInfo.MemberId) ? memberCardData.CoverageLines[policySelectedIndex].patientInfo.MemberId : '';
            }
            if(!$A.util.isUndefinedOrNull(policyDetails) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes)){
                var policyRes = policyDetails.resultWrapper.policyRes;
                groupNumber = !$A.util.isUndefinedOrNull(policyRes.groupNumber) ? policyRes.groupNumber : '';
                sourceCode = !$A.util.isUndefinedOrNull(policyRes.sourceCode) ? policyRes.sourceCode :'';
            }
            // Trim Leading 0s
            if(groupNumber.length > 0 && groupNumber.charAt(0) == 0){
                groupNumber = groupNumber.substring(1);
            }
            caseItemsExtId = groupNumber + '/' + sourceCode + '/' + memberId;
            console.log('Policy Details: caseItemsExtId '+JSON.stringify(caseItemsExtId));

            var cardDetails = new Object();
            cardDetails.componentName = "Policy Details";
            cardDetails.componentOrder = 3;
            cardDetails.noOfColumns = "slds-size_6-of-12";
            cardDetails.type = "card";
            cardDetails.allChecked = false;
            cardDetails.isDummyData = false;// DE418896 - Thanish - 22nd Mar 2021
            cardDetails.caseItemsExtId = !$A.util.isEmpty(caseItemsExtId) ? caseItemsExtId : ''; // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021
            cardDetails.cardData = [
             // US2928520: Policies Card
                /*{
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "Type",
                    "fieldType": "outputText",
                    "fieldValue": productType,
                    "showCheckbox": true,
                    "isReportable":true
                },*/
            ];

            if(strSourceCode && strSourceCode == 'CS') {
                let lstValues = [], lstValuesForCombined = [], strUpdatedIdentifiedValue, strMultipleValues;
                if(strIdentifierValue && strIdentifierValue.includes('Engaged')) {
                    lstValues = strIdentifierValue.split('-');
                    if(lstValues[1]) {
                    	lstValuesForCombined = lstValues[1].split(',');
                        if(lstValuesForCombined[1]) {
                        	strMultipleValues = lstValuesForCombined[0] + "<br/>" + lstValuesForCombined[1];
                        } else {
                            strMultipleValues = lstValuesForCombined[0];
                        }
                    }
                    strUpdatedIdentifiedValue = "<p>"+ lstValues[0] +"<br/> Care Advisor: " +  strMultipleValues + "</p>";
                } else {
                    strUpdatedIdentifiedValue = strIdentifierValue;
                }


                cardDetails.cardData.push({
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "Policy Identifier",
                    "fieldType": "unescapedHtml",
                    "fieldValue": (!$A.util.isEmpty(strUpdatedIdentifiedValue)) ? strUpdatedIdentifiedValue : '--', // DE421678 - Thanish - 11th Mar 2021
                    "showCheckbox": true,
                    "isReportable":true
                });


                //ketki RCED begin
                var rcedResultWrap = cmp.get("v.rcedResultWrapper");
                var delegatedType='';

                    if(!$A.util.isUndefinedOrNull(rcedResultWrap))
                    {
                        if(!$A.util.isUndefinedOrNull(rcedResultWrap.groupName) && rcedResultWrap.groupName != '--')
              			{
                            cmp.set("v.groupName", rcedResultWrap.groupName);
                            console.log('rcedgroupname',rcedResultWrap.groupName);
               			 }else{
                            cmp.set("v.isGroupNameBlank", false);
                            cmp.set("v.groupName", rcedResultWrap.groupName);
                        }
                        if(!$A.util.isUndefinedOrNull(cmp.get("v.caseWrapper"))){
                            var caseWrapper = cmp.get("v.caseWrapper");
                            if(!$A.util.isUndefinedOrNull(cmp.get("v.groupName")) && cmp.get("v.groupName") != '--' ){
                                caseWrapper.groupName  = cmp.get("v.groupName");
                            }
                            cmp.set("v.caseWrapper",caseWrapper);
                        }
                        if(!$A.util.isUndefinedOrNull(rcedResultWrap.ipaMarketRes)   ){

                                if(!$A.util.isUndefinedOrNull(rcedResultWrap.ipaMarketRes.utilizationManagementDelegateIndicator)
                                   && rcedResultWrap.ipaMarketRes.utilizationManagementDelegateIndicator=='Y'){
                                    delegatedType='Utilization Management';

                                }
                                if(!$A.util.isUndefinedOrNull(rcedResultWrap.ipaMarketRes.financialRiskDelegateIndicator)
                                   && rcedResultWrap.ipaMarketRes.financialRiskDelegateIndicator=='Y'){
                                    delegatedType +=', Financial Risk';

                                }
                                if(!$A.util.isUndefinedOrNull(rcedResultWrap.ipaMarketRes.claimAdminDelegateIndicator)
                                   && rcedResultWrap.ipaMarketRes.claimAdminDelegateIndicator=='Y'){
                                    delegatedType +=', Claim Admin';

                                }
                                if(!$A.util.isUndefinedOrNull(rcedResultWrap.ipaMarketRes.providerCredentialDelegateIndicator)
                                   && rcedResultWrap.ipaMarketRes.providerCredentialDelegateIndicator=='Y'){
                                    delegatedType +=', Provider Credential';

                                }
                         }

                   }

                   var delegationTypeYesClickedValue = cmp.set("v.delegationTypeYesClickedValue", delegatedType);

                   var delTypeFieldValue = "--" ;
                   var delTypeFieldType = "outputText";
                   if(delegatedType==""){
                        delTypeFieldValue = "No" ;
                   }
                   else{

                           delTypeFieldValue = "Yes" ;
                           delTypeFieldType = "link" ;

                   }




                  cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Delegation",
                        "fieldType": delTypeFieldType,
                        "fieldValue": delTypeFieldValue,
                        "showCheckbox": true,
                        "isReportable":true
                    });

                    let optumHealthFV="--";
                	let topsOrigCoverageEffectiveDate ="--";
                	let retirementDate="--";
                    if( !$A.util.isUndefinedOrNull(rcedResultWrap) && !$A.util.isUndefinedOrNull(rcedResultWrap.vendor) && rcedResultWrap.vendor.vendorBenefitOptionTypeCode != '--')
                    {
                            var vendorBenefitOptionTypeCodeMap = cmp.get("v.vendorBenefitOptionTypeCodeMap");
                        	var vendorStartDate=($A.util.isEmpty(rcedResultWrap.vendor.vendorStartDate) ? "--" : $A.localizationService.formatDate(rcedResultWrap.vendor.vendorStartDate, "MM/DD/YYYY"))
                            optumHealthFV = vendorBenefitOptionTypeCodeMap[rcedResultWrap.vendor.vendorBenefitOptionTypeCode]+'<br/>';
                        	optumHealthFV +='Eff '+vendorStartDate;
                     }
                	 /*if(!$A.util.isUndefinedOrNull(rcedResultWrap) && !$A.util.isUndefinedOrNull(rcedResultWrap.demRes))
                    {
                     	 topsOrigCoverageEffectiveDate=($A.util.isEmpty(rcedResultWrap.demRes.topsOrigCoverageEffectiveDate) ? "--" : $A.localizationService.formatDate(rcedResultWrap.demRes.topsOrigCoverageEffectiveDate, "MM/DD/YYYY"));
      					 retirementDate= ($A.util.isEmpty(rcedResultWrap.demRes.retirementDate) ? "--" : $A.localizationService.formatDate(rcedResultWrap.demRes.retirementDate, "MM/DD/YYYY"));
                     }*/


                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "OptumHealth",
                        "fieldType": "unescapedHtml",
                        "fieldValue": optumHealthFV,
                        "showCheckbox": true,
                        "isReportable":true
                    });
                	/*cardDetails.cardData.push({
                            "checked": false,
                            "defaultChecked": false,
                            "fieldName": "Original Eff",
                            "fieldType": "outputText",
                            "fieldValue":topsOrigCoverageEffectiveDate ,
                            "showCheckbox": true,
                            "isReportable":true
                        });
                        cardDetails.cardData.push({
                            "checked": false,
                            "defaultChecked": false,
                            "fieldName": "Retirement",
                            "fieldType": "outputText",
                            "fieldValue": retirementDate,
                            "showCheckbox": true,
                            "isReportable":true
                        });*/
                   //ketki RCED end

            }

            if(policyDetails.resultWrapper.policyRes.showAllFields){
                if(policyDetails.resultWrapper.policyRes.isPHSPlan || policyDetails.resultWrapper.policyRes.isComPlan){
                    var cobra = "--";
                    if(cmp.get("v.cobraCode") == "CO"){
                        cobra = "Yes";
                    } else{
                        cobra = "No";
                    }
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Cobra",
                        "fieldType": "outputText",
                        "fieldValue": cobra,
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                if(policyDetails.resultWrapper.policyRes.isMedicaidPlan){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Funding Arrangement",
                        "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(policyDetails.resultWrapper.policyRes.fundingType) ? "--" : policyDetails.resultWrapper.policyRes.fundingType),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                if(policyDetails.resultWrapper.policyRes.isMedicarePlan){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "DIV",
                        "fieldType": "outputText",
                        "fieldValue": (policyDetails ? (policyDetails.resultWrapper ? (policyDetails.resultWrapper.policyRes ?(policyDetails.resultWrapper.policyRes.cosmosDivision ? policyDetails.resultWrapper.policyRes.cosmosDivision : '--') : '--') : '--') : '--'),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
            }
            // Durga Start - US3584388
            var policySelectedIndex = cmp.get("v.policySelectedIndex");
            var memberCardData = cmp.get("v.memberCardData");
            if( strSourceCode && strSourceCode == 'CO' && !$A.util.isEmpty(memberCardData.CoverageLines)  && memberCardData.CoverageLines.length >0  ){
                var delg = memberCardData.CoverageLines[policySelectedIndex].cosmosDelegatedEntity;
                console.log('==delg'+delg);
                //US3583813 - Sravan - Start
                if(!$A.util.isUndefinedOrNull(delg) && !$A.util.isEmpty(delg)){
                    if(delg != 'No'){
                        cardDetails.cardData.push({
                            "checked": false,
                            "defaultChecked": false,
                            "fieldName": "Delegation ",
                            "fieldType": "link",//US3583813 - Sravan
                            "fieldValue": delg,
                            "showCheckbox": true,
                            "isReportable":true
                        });
                    }
                    else{
                        cardDetails.cardData.push({
                            "checked": false,
                            "defaultChecked": false,
                            "fieldName": "Delegation ",
                            "fieldType": "outputText",
                            "fieldValue": delg,
                            "showCheckbox": true,
                            "isReportable":true
                        });
                    }
                    cmp.set("v.delegationValue",delg);

                }
                else{
                    cmp.set("v.delegationValue",'');
                }
                //US3583813 - Sravan - End
            }
            // Durga End - US3584388
            var timelyFiling = cmp.get("v.timelyFiling");
            cardDetails.cardData.push({
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Timely Filing",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(timelyFiling) ? "--" : timelyFiling),
                "showCheckbox": true,
                "isReportable":true
            });

            if(policyDetails.resultWrapper.policyRes.showAllFields){
                if((policyDetails.resultWrapper.policyRes.isPHSPlan || policyDetails.resultWrapper.policyRes.isComPlan) && (cmp.get("v.cobraCode") == "CO")){
                    var cobraAdmin = "--";
                    var paidThruDate = cmp.get("v.paidThruDate");
                    if(cmp.get("v.cobraAdmin")){
                        cobraAdmin = ($A.util.isEmpty(paidThruDate) ? "UHC/--" : "UHC/" + paidThruDate);
                    } else{
                        cobraAdmin = ($A.util.isEmpty(paidThruDate) ? "Non UHC/--" : "Non UHC/" + paidThruDate);
                    }
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Cobra Admin / Pd thru",
                        "fieldType": "outputText",
                        "fieldValue": cobraAdmin,
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                if((policyDetails.resultWrapper.policyRes.isPHSPlan || policyDetails.resultWrapper.policyRes.isComPlan) && (cmp.get("v.cobraCode") != "CO")){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Funding Arrangement",
                        "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(policyDetails.resultWrapper.policyRes.fundingType) ? "--" : policyDetails.resultWrapper.policyRes.fundingType),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                if(policyDetails.resultWrapper.policyRes.isMedicarePlan){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Panel",
                        "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(policyDetails.resultWrapper.policyRes.groupPanelNumber) ? "--" : policyDetails.resultWrapper.policyRes.groupPanelNumber),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                if(policyDetails.resultWrapper.policyRes.isMedicaidPlan && !isGracePeriod){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Health Plan",
                        "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(policyDetails.resultWrapper.policyRes.stateOfIssueCode) ? "--" : policyDetails.resultWrapper.policyRes.stateOfIssueCode),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
            }

            cardDetails.cardData.push({
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Maintenance Date",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(cmp.get("V.maintenanceDate")) ? "--" : cmp.get("V.maintenanceDate")),
                "showCheckbox": true,
                "isReportable":true
            });

            if(policyDetails.resultWrapper.policyRes.showAllFields){
                if((policyDetails.resultWrapper.policyRes.isPHSPlan || policyDetails.resultWrapper.policyRes.isComPlan) && (cmp.get("v.cobraCode") == "CO")){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Funding Arrangement",
                        "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(policyDetails.resultWrapper.policyRes.fundingType) ? "--" : policyDetails.resultWrapper.policyRes.fundingType),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                if((policyDetails.resultWrapper.policyRes.isPHSPlan || policyDetails.resultWrapper.policyRes.isComPlan) && (cmp.get("v.cobraCode") != "CO")){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Shared Savings",
                        "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(cmp.get("v.sharedSavings")) ? "--" : cmp.get("v.sharedSavings")),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                if(policyDetails.resultWrapper.policyRes.isMedicarePlan){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Group Name",
                        "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(cmp.get("v.groupName")) ? "--" : cmp.get("v.groupName")),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                if(policyDetails.resultWrapper.policyRes.isMedicaidPlan && !isGracePeriod){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Health Plan Site",
                        "fieldType": ($A.util.isEmpty(policyDetails.resultWrapper.policyRes.HealthPlanSite) ? "outputText" : "link"),
                        "fieldValue": ($A.util.isEmpty(policyDetails.resultWrapper.policyRes.HealthPlanSite) ? "Follow standard process" : "Click here for state site"),
                        "urlLabel": "Click here for state site",
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
            }

            cardDetails.cardData.push({
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Payer ID",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isEmpty(cmp.get("V.payerId")) ? "--" : cmp.get("V.payerId")),
                "showCheckbox": true,
                "isReportable":true
            });

            if(policyDetails.resultWrapper.policyRes.isMedicaidPlan && !isGracePeriod){
                cardDetails.cardData.push({
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "Network Type",
                    "fieldType": "outputText",
                    "fieldValue": ($A.util.isEmpty(policyDetails.resultWrapper.policyRes.productId) ? "--" : policyDetails.resultWrapper.policyRes.productId),
                    "showCheckbox": true,
                    "isReportable":true
                });
            }

            if(policyDetails.resultWrapper.policyRes.showAllFields){
                if((policyDetails.resultWrapper.policyRes.isPHSPlan || policyDetails.resultWrapper.policyRes.isComPlan) && (cmp.get("v.cobraCode") == "CO")){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Shared Savings",
                        "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(cmp.get("v.sharedSavings")) ? "--" : cmp.get("v.sharedSavings")),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                if((policyDetails.resultWrapper.policyRes.isPHSPlan || policyDetails.resultWrapper.policyRes.isComPlan) && (cmp.get("v.cobraCode") != "CO")){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Region Code",
                        "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(cmp.get("v.regionCode")) ? "--" : cmp.get("v.regionCode")),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                if(policyDetails.resultWrapper.policyRes.isComPlan && cmp.get("v.cobraCode") != "CO"){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Group Name",
                        "fieldType": "outputText",
                        "fieldValue": (!$A.util.isEmpty(cmp.get("v.groupName")) && cmp.get("v.groupName") != "--") ? cmp.get("v.groupName") : "--",
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
            }

            cardDetails.cardData.push({
                "checked": false,
                "defaultChecked": false,
                "fieldName": "Claims Mailing Address",
                "fieldType": "formattedText",
                "fieldValue": $A.util.isEmpty(claimsMailingAddress) ? "--" : claimsMailingAddress, // DE373933 - Thanish - 8th Oct 2020
                "showCheckbox": true,
                "isReportable":true
            });
            if(policyDetails.resultWrapper.policyRes.showAllFields){
                if(policyDetails.resultWrapper.policyRes.isMedicarePlan){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Passport",
                        "fieldType": "outputText",
                        "fieldValue": "--",
                        "showCheckbox": true,
                        "isReportable":true
                    }); 
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Original Eff",
                       "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(claimsEffDate) ? "--" : $A.localizationService.formatDate(claimsEffDate, "MM/DD/YYYY")),
                        "showCheckbox": true,
                        "isReportable":true
                    }); 
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Medicare ID",
                        "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(policyDetails.resultWrapper.policyRes.mbi) ? "--" : policyDetails.resultWrapper.policyRes.mbi),
                        "showCheckbox": true,
                        "isReportable":true
                    }); 
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Member Services",
                        "fieldType": "outputText",
                        "fieldValue": "--",
                        "showCheckbox": true,
                        "isReportable":true
                    }); 
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Provider Services",
                        "fieldType": "outputText",
                        "fieldValue": "877-842-3210",
                        "showCheckbox": true,
                        "isReportable":true
                    }); 
                }
            }

            if(policyDetails.resultWrapper.policyRes.showAllFields){
                if(policyDetails.resultWrapper.policyRes.isPHSPlan && cmp.get("v.cobraCode") == "CO"){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Group Name",
                        "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(cmp.get("v.groupName")) ? "--" : cmp.get("v.groupName")),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                if(policyDetails.resultWrapper.policyRes.isComPlan && cmp.get("v.cobraCode") == "CO"){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Group Name",
                        "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(cmp.get("v.groupName")) ? "--" : cmp.get("v.groupName")),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                if(policyDetails.resultWrapper.policyRes.isPHSPlan && cmp.get("v.cobraCode") != "CO"){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Group Name",
                        "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(cmp.get("v.groupName")) ? "--" : cmp.get("v.groupName")),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                if((policyDetails.resultWrapper.policyRes.isComPlan && cmp.get("v.cobraCode") != "CO" && strSourceCode !="CS") || isGracePeriod ){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Market Type",
                        "fieldType": "outputText",
                        "fieldValue": ($A.util.isEmpty(policyDetails.resultWrapper.policyRes.marketType) ? "--" : policyDetails.resultWrapper.policyRes.marketType),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }else if(policyDetails.resultWrapper.policyRes.isComPlan){
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Market Type/#",
                        "fieldType": "outputText",
                        "fieldValue": mktype,
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                if(policyDetails.resultWrapper.policyRes.showAllFields){
                    if(policyDetails.resultWrapper.policyRes.isComPlan) {
                        cardDetails.cardData.push({
                            "checked": false,
                            "defaultChecked": false,
                            "fieldName": "SA/OI",
                            "fieldType": "outputText",
                            "fieldValue": sarrangement,
                            "showCheckbox": true,
                            "isReportable":true
                        });
                       var topsOrigCoverageEffectiveDate="";
                        var retirementDate="";
                        if(!$A.util.isEmpty(rcedResultWrap) ){
                            if(!$A.util.isEmpty(rcedResultWrap.demRes) ){
                                 topsOrigCoverageEffectiveDate=rcedResultWrap.demRes.topsOrigCoverageEffectiveDate;   
                            	retirementDate=rcedResultWrap.demRes.retirementDate;
                            }
                            
                        }
                        cardDetails.cardData.push({
                            "checked": false,
                            "defaultChecked": false,
                            "fieldName": "Original Eff",
                            "fieldType": "outputText",
                            "fieldValue": ($A.util.isEmpty(topsOrigCoverageEffectiveDate) ? "--" : $A.localizationService.formatDate(topsOrigCoverageEffectiveDate, "MM/DD/YYYY")),
                            "showCheckbox": true,
                            "isReportable":true
                        });             
                        cardDetails.cardData.push({
                            "checked": false,
                            "defaultChecked": false,
                            "fieldName": "Retirement",
                            "fieldType": "outputText",
                            "fieldValue": ($A.util.isEmpty(retirementDate) ? "--" : $A.localizationService.formatDate(retirementDate, "MM/DD/YYYY")),
                            "showCheckbox": true,
                           "isReportable":true
                        });
                        /*
                        cardDetails.cardData.push({
                            "checked": false,
                            "defaultChecked": false,
                            "fieldName": "Original Eff",
                            "fieldType": "outputText",
                            "fieldValue": ($A.util.isEmpty(rcedResultWrap.demRes.topsOrigCoverageEffectiveDate) ? "--" : $A.localizationService.formatDate(rcedResultWrap.demRes.topsOrigCoverageEffectiveDate, "MM/DD/YYYY")),
                            "showCheckbox": true,
                            "isReportable":true
                        });             
                        cardDetails.cardData.push({
                            "checked": false,
                            "defaultChecked": false,
                            "fieldName": "Retirement",
                            "fieldType": "outputText",
                            "fieldValue": ($A.util.isEmpty(rcedResultWrap.demRes.retirementDate) ? "--" : $A.localizationService.formatDate(rcedResultWrap.demRes.retirementDate, "MM/DD/YYYY")),
                            "showCheckbox": true,
                            "isReportable":true
                        });
						*/
                        
                        cardDetails.cardData.push({
                            "checked": false,
                            "defaultChecked": false,
                            "fieldName": "Member Services",
                            "fieldType": "outputText",
                            "fieldValue": "--",
                            "showCheckbox": true,
                            "isReportable":true
                        });
                        cardDetails.cardData.push({
                            "checked": false,
                            "defaultChecked": false,
                            "fieldName": "Provider Services",
                            "fieldType": "outputText",
                            "fieldValue": "877-842-3210",
                            "showCheckbox": true,
                            "isReportable":true
                        });
                    }
                }                
                //Jitendra
                if(isGracePeriod) {
                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Grace Paid Through",
                        "fieldType": "outputText",
                        "fieldValue": (strDatePaid?  strDatePaid : "--" ),
                        "showCheckbox": true,
                        "isReportable":true
                    });

                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Grace Period Month",
                        "fieldType": "outputText",
                        "fieldValue": (objPolicyDetails.strGracePeriodMonth ? objPolicyDetails.strGracePeriodMonth : "--" ),
                        "showCheckbox": true,
                        "isReportable":true
                    });

                    cardDetails.cardData.push({
                        "checked": false,
                        "defaultChecked": false,
                        "fieldName": "Grace Period Message",
                        "fieldType": "outputText",
                        "fieldValue": (objPolicyDetails.strGraceMessageByState ? objPolicyDetails.strGraceMessageByState : '--'),
                        "showCheckbox": true,
                        "isReportable":true
                    });
                }
                //Jitendra
            }
			/*
            if(policyDetails.resultWrapper.policyRes.showAllFields && policyDetails.resultWrapper.policyRes.isComPlan && cmp.get("v.cobraCode") == "CO"){
                cardDetails.cardData.push({
                    "checked": false,
                    "defaultChecked": false,
                    "fieldType": "emptySpace",
                    "showCheckbox": false
                });
                cardDetails.cardData.push({
                    "checked": false,
                    "defaultChecked": false,
                    "fieldName": "Market Type",
                    "fieldType": "outputText",
                    "fieldValue": ($A.util.isEmpty(policyDetails.resultWrapper.policyRes.marketType) ? "--" : policyDetails.resultWrapper.policyRes.marketType),
                    "showCheckbox": true,
                    "isReportable":true
                });
            } */

            cmp.set("v.cardDetails", cardDetails);
        }
        // US3340930 - Thanish - 6th Mar 2021
        this.hideSpinner(cmp);
    },
    // US2645457: Health Plan Site & COB History Link Selected in Auto Doc

    handleHealthPlanSiteLinkClick: function (cmp, event, helper) {
        var eventData = event.getParam("eventData");
        if(eventData.fieldName == "Health Plan Site"){
            var policyDetails = cmp.get("v.policyDetails");
            window.open(policyDetails.resultWrapper.policyRes.HealthPlanSite, '_blank');
            var cardDetails = cmp.get("v.cardDetails");
            var isPresent = false;
            for(var data in cardDetails.cardData){
                console.log(cardDetails.cardData[data].fieldName +" "+ cardDetails.cardData[data].hideField);
                if(cardDetails.cardData[data].fieldName === "Health Plan Site" && cardDetails.cardData[data].hideField == true){
                    isPresent = true;
                    console.log("Already Autodoced");
                }
            }
            if(!isPresent){
                cardDetails.cardData.push({
                        "checked": true,
                        "defaultChecked": false,
                        "fieldName": "Health Plan Site",
                        "fieldType": "outputText",
                        "fieldValue": "Accessed",
                        "showCheckbox": false,
                        "hideField": true,
                        "isReportable":true
                    });
                cmp.set("v.cardDetails", cardDetails);
                _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueIdCmp"), cardDetails);
            } 
        }
    },
    
    showSpinner: function (cmp) {
        var spinner = cmp.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideSpinner: function (cmp) {
        var spinner = cmp.find("spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    // DE418896 - Thanish - 22nd Mar 2021
    setEmptyAutoDocData: function(cmp){
        var policyList = cmp.get("v.policyList");
        var cardDetails = new Object();
        cardDetails.componentName = "Policy Details";
        cardDetails.componentOrder = 3;
        cardDetails.noOfColumns = "slds-size_6-of-12";
        cardDetails.type = "card";
        cardDetails.allChecked = false;
        cardDetails.isDummyData = true;

        // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021
        var caseItemsExtId = '';
        var memberCardData = cmp.get("v.memberCardData");
        var memberId = '';
        var groupNumber = '';
        var sourceCode = '';
        var policySelectedIndex = cmp.get("v.policySelectedIndex");
        var policyDetails = cmp.get("v.policyDetails");
        if(!$A.util.isUndefinedOrNull(memberCardData) && !$A.util.isUndefinedOrNull(memberCardData.CoverageLines) && !$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex]) && !$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].patientInfo)){
            memberId = !$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].patientInfo.MemberId) ? memberCardData.CoverageLines[policySelectedIndex].patientInfo.MemberId : '';
        }
        if(!$A.util.isUndefinedOrNull(policyDetails) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes)){
            var policyRes = policyDetails.resultWrapper.policyRes;
            groupNumber = !$A.util.isUndefinedOrNull(policyRes.groupNumber) ? policyRes.groupNumber : '';
            sourceCode = !$A.util.isUndefinedOrNull(policyRes.sourceCode) ? policyRes.sourceCode :'';
        }
        // Trim Leading 0s
        if(groupNumber.length > 0 && groupNumber.charAt(0) == 0){
            groupNumber = groupNumber.substring(1);
        }
        caseItemsExtId = groupNumber + '/' + sourceCode + '/' + memberId;
        console.log('Policy Details: caseItemsExtId '+JSON.stringify(caseItemsExtId));
        cardDetails.caseItemsExtId = !$A.util.isEmpty(caseItemsExtId) ? caseItemsExtId : ''; // US3691233: Add missing fields/components to autodoc reporting - Krish - 11th Aug 2021
        cardDetails.cardData = [];

        cardDetails.cardData.push({
            "checked": false,
            "defaultChecked": false,
            "fieldName": "Timely Filing",
            "fieldType": "outputText",
            "fieldValue": "--",
            "showCheckbox": true,
            "isReportable":true
        });
        cardDetails.cardData.push({
            "checked": false,
            "defaultChecked": false,
            "fieldName": "Maintenance Date",
            "fieldType": "outputText",
            "fieldValue": "--",
            "showCheckbox": true,
            "isReportable":true
        });
        cardDetails.cardData.push({
            "checked": false,
            "defaultChecked": false,
            "fieldName": "Payer ID",
            "fieldType": "outputText",
            "fieldValue": "--",
            "showCheckbox": true,
            "isReportable":true
        });
        cardDetails.cardData.push({
            "checked": false,
            "defaultChecked": false,
            "fieldName": "Claims Mailing Address",
            "fieldType": "formattedText",
            "fieldValue": "--",
            "showCheckbox": true,
            "isReportable":true
        });
        cmp.set("v.cardDetails", cardDetails);
    }
    /*
   
    callPESForDelegation: function (component, event, helper) {
        let action = component.get("c.call_PES_Market_IPA_Association");
        var policyData = component.get("v.policyDetails");
        var params = {
            "appName" : "acet",
            "marketNumber": "",
            "marketType": "",
            "ipa": ""
        };
        action.setParams(params);
        action.setCallback(this, function (response) {
            
        });
        $A.enqueueAction(action);
    }*/
    
})