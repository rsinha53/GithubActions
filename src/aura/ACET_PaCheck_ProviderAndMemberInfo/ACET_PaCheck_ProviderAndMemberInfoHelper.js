({
    // US3304569 - Thanish - 17th Mar 2021
    showPolicyErrorMessage: true,
    paErrorMessage: "Unexpected error occurred with Medical Necessity. Please try again. If problem persists please contact the help desk.",
    paAuthErrorMessage: "Unexpected error occurred with OPTUMHEALTH AUTH indicator. Please try again. If problem persists please contact the help desk. ",

    processMemberInfo: function(cmp,event,helper){
        var memInfo = cmp.get('v.memberInfo');
        if( !$A.util.isUndefinedOrNull(memInfo) && (memInfo.EEID != '--' || memInfo.memberId != '--') &&
           memInfo.memberPlan != '--' && memInfo.memberName != '--' && memInfo.relationshipCode != '--' &&
           memInfo.sourceCode == 'CS' && memInfo.firstServiceDate != '--' &&  memInfo.lastServiceDate != '--'){
            var namelist  =  memInfo.memberName.split(" ");
            var fistName = namelist[0];
            var EEID = '';
            if(memInfo.EEID == '--'){
                if(memInfo.memberId != '--'){
                    EEID = memInfo.memberId;
                }
                else{
                    console.log('==@@EEID and MemberId not found:'+JSON.stringify(memInfo));
                    return;
                }
            }
            else{
                EEID = memInfo.EEID;
                if(EEID.length >= 9){
                    EEID = EEID.slice(-9);
                }
                EEID = 'S'+EEID;
            }
            //US3814287
            if(memInfo.firstName != '--'){
                fistName = memInfo.firstName;
            }
            var inpRequest = {
                "memberId": EEID,
                "policy": memInfo.memberPlan,
                "firstName":  fistName,
                "relationship": memInfo.relationshipCode,
                "securityToken":"",
                "firstServiceDate":  memInfo.firstServiceDate,
                "lastServiceDate":  memInfo.lastServiceDate
            };
            helper.getMedicalValues(cmp,event,helper,inpRequest);
        }
        if (!$A.util.isUndefinedOrNull(memInfo) && (!$A.util.isEmpty(memInfo)) && memInfo.sourceCode === 'CS') {
            this.callRCED(cmp, event, helper);
        }else{
            helper.createAutoDoc(cmp,event,helper);
        }
    },
    getMedicalValues : function(cmp,event,helper,inpRequest){
        console.log('==@@MedNec inpRequest @@ '+JSON.stringify(inpRequest));
        cmp.set("v.descriptionList",[]);
        var action = cmp.get("c.getMedicalValues");
        action.setParams({
            "input": inpRequest
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result.isSuccess) {
                    if (result.statusCode == 200) {
                        console.log(JSON.parse(JSON.stringify(result.response)));
                        console.log('===response'+JSON.stringify(response.getReturnValue()));
                        cmp.set("v.descriptionList",result.response);
                    }
                    else{
                        helper.showToastMessage("We hit a snag.", this.paErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 17th Mar 2021
                    }
                }
                else{
                    helper.showToastMessage("We hit a snag.", this.paErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 17th Mar 2021
                }
            }
            else{
                helper.showToastMessage("We hit a snag.", this.paErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 17th Mar 2021
            }
        });
        $A.enqueueAction(action);
    },
     callRCED: function (cmp, event, helper) {
        var memberInfo = cmp.get('v.memberInfo');

		var action = cmp.get('c.getRCEDres');
		action.setParams({
			"subscriberId": memberInfo.EEID,
            "policyNumber":memberInfo.memberPlan,
            "sourceCode":memberInfo.sourceCode
		});
		action.setCallback(this, function (response) {
			let state = response.getState();

			if (state == "SUCCESS") {

				let result = response.getReturnValue();
				if (result.statusCode == "200" && !$A.util.isUndefinedOrNull(result) && (!$A.util.isEmpty(result)) && (!$A.util.isUndefinedOrNull(result.vendor)) && (!$A.util.isEmpty(result.vendor))
                    && (!$A.util.isUndefinedOrNull(result.vendor.healthServiceProductCode)) && (!$A.util.isEmpty(result.vendor.healthServiceProductCode)) && (!$A.util.isUndefinedOrNull(result.vendor.vendorBenefitOptionTypeCode)) && (!$A.util.isEmpty(result.vendor.vendorBenefitOptionTypeCode))  ) {

					console.log("healthServiceProductCode: "+result.vendor.healthServiceProductCode);
					console.log("vendorBenefitOptionTypeCode: "+result.vendor.vendorBenefitOptionTypeCode);
                    cmp.set("v.healthServiceProductCode", result.vendor.healthServiceProductCode);
                    cmp.set("v.vendorBenefitOptionTypeCode", result.vendor.vendorBenefitOptionTypeCode);
                    if(result.vendor.healthServiceProductCode =="AC"){

                        this.callPESservices(cmp, event, helper);
                    }
                    else{
                      this.getOptumHealthAuthREQD(cmp, event,helper);
                    }
                } else {
                    helper.createAutoDoc(cmp,event,helper);
                    this.showToastMessage("We hit a snag.", this.paAuthErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 18th Mar 2021
                }
			} else if (state === "ERROR") {
                helper.createAutoDoc(cmp,event,helper);
				this.showToastMessage("We hit a snag.", this.paAuthErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 18th Mar 2021
            }

		});
		$A.enqueueAction(action);


	},
    callPESservices: function (cmp, event, helper) {
        var interactionOverviewTabId = cmp.get("v.interactionOverviewTabId");
        var interactionOverviewData = _setAndGetSessionValues.getInteractionDetails(interactionOverviewTabId);

        var providerTaxId = interactionOverviewData.providerDetails.taxId;

        var addressSequenceId = interactionOverviewData.providerDetails.addressSequenceId;

        var providerId = interactionOverviewData.providerDetails.providerId;
        var memberInfo = cmp.get('v.memberInfo');

        var action = cmp.get('c.getPESres');
        action.setParams({
            "providerId": providerId,
            "taxId":providerTaxId,
            "addressSeq":addressSequenceId
        });
        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state == "SUCCESS") {

                var retValue = response.getReturnValue();
                let result = retValue.isParticipating;

                if (!$A.util.isUndefinedOrNull(result) && (!$A.util.isEmpty(result))) {
                    cmp.set("v.isParticipating", result);

                }
                if(retValue.statusCode!=200){
                    helper.createAutoDoc(cmp,event,helper);
                    this.fireToastMessage("We hit a snag.", this.paAuthErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 18th Mar 2021
                }
                else{
                    this.getOptumHealthAuthREQD(cmp, event,helper);
                }



            } else if (state === "ERROR") {
                helper.createAutoDoc(cmp,event,helper);
                this.showToastMessage("We hit a snag.", this.paAuthErrorMessage, "error", "dismissible", "30000");// US3304569 - Thanish - 18th Mar 2021
            }



        });
        $A.enqueueAction(action);
    },

    getOptumHealthAuthREQD : function(component, event,helper){
        console.log('healthServiceProductCode: '+ component.get("v.healthServiceProductCode"));
        console.log('vendorBenefitOptionTypeCode: '+ component.get("v.vendorBenefitOptionTypeCode"));
        console.log('isParticipating: '+ component.get("v.isParticipating"));
        var healthServiceProductCode = component.get("v.healthServiceProductCode");
        var vendorBenefitOptionTypeCode = component.get("v.vendorBenefitOptionTypeCode")
        var isParticipating = component.get("v.isParticipating")
        var getOptumHealthAuthREQDStr ="";
        if(!$A.util.isUndefinedOrNull(healthServiceProductCode) && !$A.util.isUndefinedOrNull(vendorBenefitOptionTypeCode)){
            if(healthServiceProductCode == "AC" && isParticipating){
                if(vendorBenefitOptionTypeCode == "NTOY"){
                    getOptumHealthAuthREQDStr = "No OptumHealth Contact Needed";
                }else{
                    getOptumHealthAuthREQDStr = "Contact OptumHealth for PT, OT and CHIRO: 800-873-4575";
                }
            }
            if(healthServiceProductCode == "AC" && !isParticipating){
                getOptumHealthAuthREQDStr = "Selected Tax ID does not have an OptumHealth IPA number";
            }

            if(healthServiceProductCode != "AC"){
                getOptumHealthAuthREQDStr = "Member Not Enrolled";
            }
        }

        if( !$A.util.isUndefinedOrNull(getOptumHealthAuthREQDStr) && !$A.util.isEmpty(getOptumHealthAuthREQDStr) ){
            component.set('v.OptumHealthReq',getOptumHealthAuthREQDStr);
        }
        helper.createAutoDoc(component,event,helper);
        return getOptumHealthAuthREQDStr;
    },

    // US3304569 - Thanish - 17th Mar 2021
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

    //US3487597 - Sravan  - Start
    getProviderNotificationTool : function(component, event, helper){

        var action = component.get("c.getProviderNotificationTool");

        console.log('MemberInfo'+ JSON.stringify);
        let objInterval = setInterval(function() {
            try {
                var memberInfo = component.get("v.memberInfo");
                console.log('MemberInfo'+ JSON.stringify);
                if(!$A.util.isUndefinedOrNull(memberInfo) && !$A.util.isEmpty(memberInfo)){
                    var sourceCode = memberInfo.sourceCode;
                    var finalSourceCode = '';
                    var fetchSourceCode = [];
                    if(!$A.util.isUndefinedOrNull(sourceCode) && !$A.util.isEmpty(sourceCode)){
                        if(sourceCode !=  '--'){
                            fetchSourceCode = sourceCode.split('-');
                            if(!$A.util.isUndefinedOrNull(fetchSourceCode) && !$A.util.isEmpty(fetchSourceCode)){
                                finalSourceCode = fetchSourceCode[0].trim();
                                if(finalSourceCode == 'CO'){
                                    component.set("v.showSupportText",true);
                                }
                                else{
                                    component.set("v.showSupportText",false);
                                }
                            }
                        }
                    }
                }
                clearInterval(objInterval);
            } catch(exception) {
                clearInterval(objInterval);
                console.log(' exception ' + exception);
            }
        }, 500);
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('State'+ state);
            if(state == 'SUCCESS'){
                var responseUrl = response.getReturnValue();
                console.log('Provider Notification Tool'+ responseUrl);
                component.set("v.providerNotificationTool",responseUrl);
            }
        });

        $A.enqueueAction(action);
    },
    //US3487597 - Sravan  - End
    createAutoDoc : function(component, event, helper){
        setTimeout(function() {
               helper.createAutoDocCard(component, event, helper);
           }, 100);
    },

    createAutoDocCard : function(component, event, helper){
        var test1 = component.get("v.autodocUniqueId");
        var test2 = component.get("v.autodocUniqueIdCmp");
        var providerInfo = component.get("v.providerInfo");
        var memberInfo = component.get("v.memberInfo");
        var cardDetails = new Object();
        cardDetails.componentName = "Provider and Member Information";
        cardDetails.componentOrder = 14;
        cardDetails.noOfColumns = "slds-size_1-of-6";
        cardDetails.type = "card";
        cardDetails.caseItemsEnabled = true;
        cardDetails.caseItemExtId = "PA Check";
        cardDetails.caseItemsExtId = "PA Check";
        cardDetails.allChecked = false;
        cardDetails.cardData = [
            {
                "checked": true,
                "disableCheckbox":true,
                "fieldName": "Servicing Provider",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isUndefinedOrNull(providerInfo.servicingProvider) ? "--" : providerInfo.servicingProvider),
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": true,
                "disableCheckbox":true,
                "fieldName": "Provider NPI/TIN",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isUndefinedOrNull(providerInfo.npi) ? "--" : providerInfo.npi),
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "showCheckbox": false,
                "fieldType": "emptySpace",
            },
            {
                "showCheckbox": false,
                "fieldType": "emptySpace",
            },
            {
                "showCheckbox": false,
                "fieldType": "emptySpace",
            },
            {
                "showCheckbox": false,
                "fieldType": "emptySpace",
            },
            {
                "checked": true,
                "disableCheckbox":true,
                "fieldName": "Member ID",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isUndefinedOrNull(memberInfo.memberId) ? "--" : memberInfo.memberId),
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": true,
                "disableCheckbox":true,
                "fieldName": "Member Plan",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isUndefinedOrNull(memberInfo.memberPlan) ? "--" : memberInfo.memberPlan),
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": true,
                "disableCheckbox":true,
                "fieldName": "Member Name",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isUndefinedOrNull(memberInfo.memberName) ? "--" : memberInfo.memberName),
                "showCheckbox": true,
                "isReportable":true
            },
            {
                "checked": true,
                "disableCheckbox":true,
                "fieldName": "Relationship Type",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isUndefinedOrNull(memberInfo.relationshipType) ? "--" : memberInfo.relationshipType),
                "showCheckbox": true,
                "isReportable":true
            }
        ];
        if(!$A.util.isUndefinedOrNull(memberInfo.sourceCode) && memberInfo.sourceCode == "CS"){
            var cardDataRec = cardDetails.cardData;
            var OptumHealthReq = component.get("v.OptumHealthReq");
            var OPTUMHEALTHAUTH = {
                "checked": false,
                "fieldName": "OPTUMHEALTH AUTH",
                "fieldType": "outputText",
                "fieldValue": ($A.util.isUndefinedOrNull(OptumHealthReq) ? "--" : OptumHealthReq),
                "showCheckbox": true,
                "isReportable":true
            }
            cardDataRec.push(OPTUMHEALTHAUTH);
            cardDetails.cardData = cardDataRec;
        }


        component.set("v.cardDetails", cardDetails);

        setTimeout(function() {
            var defaultAutodocPACheck = component.find("defaultAutodocPACheck");
            defaultAutodocPACheck.autodocByDefault();
        }, 100);
    }
})