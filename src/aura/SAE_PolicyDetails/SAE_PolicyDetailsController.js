({
    // DE418896 - Thanish - 22nd Mar 2021
    doInit : function(cmp, event, helper) {
        helper.setEmptyAutoDocData(cmp);
    },

    PolicyAddress : function(component, event, helper){
        //console.log('currentTransactionId');
        //console.log(component.get("v.currentTransactionId"));
         helper.callAddressName(component, event, helper);

    },

    // US2579637
    updatePolicyData: function (component, evt, helper) {
        //US3583813 - Sravan
        component.set("v.showDelegation",false);
        // US3340930 - Thanish - 6th Mar 2021
        helper.showSpinner(component);
        let objPolicyDetails = {}, marketTypeCode = '', sourceCode = '', memberInfo, objRequest = {}, dobVal = '', isGracePeriod = false, objActualPolicyDetails = {};

        objPolicyDetails = evt.getParams().value;

        if(typeof objPolicyDetails === 'string'){
			return false;
        }else{
           if(objPolicyDetails && objPolicyDetails.resultWrapper && objPolicyDetails.resultWrapper.policyRes){
            objActualPolicyDetails = objPolicyDetails;
            objPolicyDetails = objPolicyDetails.resultWrapper.policyRes;
        	}
        }



        if(objPolicyDetails && objPolicyDetails.marketType) {
            marketTypeCode = objPolicyDetails.marketType;
        }

        if(objPolicyDetails && objPolicyDetails.sourceCode) {
            sourceCode = objPolicyDetails.sourceCode;
            console.log('In Policy Detail Source Code'+ sourceCode);
        }

        if(sourceCode == 'AP' && (objPolicyDetails.groupNumber.includes('ONEX') || objPolicyDetails.groupNumber.includes('OFEX')) ) {
            isGracePeriod = true;
        }

        if(sourceCode == 'CS') {
            if(component.get("v.patientInfo")) {
                memberInfo =  component.get("v.patientInfo");
                objRequest['memberId'] = component.get("v.patientInfo")['MemberId'];
                objRequest['firstName'] = component.get("v.patientInfo")['fullName'];
                objRequest['lastName'] = component.get("v.patientInfo")['fullName'];
                let dob = component.get("v.patientInfo")['dobVal'];
                if(dob) {
                    dobVal = dob.split('/')[1] + '-' + dob.split('/')[0] + '-' + dob.split('/')[2]
                }
                objRequest['dob'] = dobVal;
            }

            if(component.get("v.policyNumber")) {
                objRequest['policyId'] = component.get("v.policyNumber");
            }
        }

        let action = component.get("c.getMarketTypeCode");
        action.setParams({
            "strMarketType" : marketTypeCode,
            "strSourceCode" : sourceCode,
            "strRequestBody" : JSON.stringify(objRequest)
        });
        action.setCallback(this, function (response) {
            // US3299151 - Thanish - 16th Mar 2021
            var strPolicyIdentifierDisplayName="";
            var returnValue=response.getReturnValue();
            if(response && response.getState() == 'SUCCESS') {
                strPolicyIdentifierDisplayName = returnValue.response;
            } else{
                helper.fireToastMessage("We hit a snag.", helper.policyDetailsErrorMessage, "error", "dismissible", "30000");
            }
            /*if(returnValue.statusCode!=200){
                helper.fireToastMessage("We hit a snag.", helper.policyDetailsErrorMessage, "error", "dismissible", "30000");
            }*/

            helper.payerIdPopulation(component,evt,helper);
            var policyList = component.get("v.policyList");
            //US2697888-MVP - Remapping Type Field on Member Snapshot Page - M&R Only vishnu
            var policySelectedIndex = component.get("v.policySelectedIndex");
            component.set('v.selectedPolicyData',policyList[policySelectedIndex]);
            component.set("v.cobraCode",policyList[policySelectedIndex].insuranceTypeCode);
            component.set("v.paidThruDate",policyList[policySelectedIndex].paidThroughDate);
            component.set("v.cobraAdmin",policyList[policySelectedIndex].administeredByUhc);

            helper.setAutodocCardData(component, strPolicyIdentifierDisplayName, sourceCode, isGracePeriod, objActualPolicyDetails); // US2808743 - Thanish - 3rd Sep 2020 - New Autodoc Framework
            });
        $A.enqueueAction(action);

        //Ketki PCP delegation Begin



        var policySelectedIndex = component.get("v.policySelectedIndex");
        var memberCardData = component.get("v.memberCardData");
        if( !$A.util.isEmpty(memberCardData.CoverageLines)  && memberCardData.CoverageLines.length >0 ){
             var pcpAssignment = memberCardData.CoverageLines[policySelectedIndex].pcpAssignment;
            if( !$A.util.isEmpty(pcpAssignment) &&  !$A.util.isEmpty(pcpAssignment.LastName)) {

            }
        }
         //Ketki PCP delegation End
    },

    // DE378317 - Kavinda - 22nd Oct 2020 - US2646403
    getGroupName: function (component, event, helper) {
        var eventData = event.getParam("eventData");
        var cardDetails = component.get("v.cardDetails");
        //ketki RCED begin
        if(eventData.fieldName == "Delegation"){

            var delegationTypeYesClickedValue ="Delegated For: "+component.get("v.delegationTypeYesClickedValue");
            var delegationField = cardDetails.cardData.find(c => c.fieldName =="Delegation")
            delegationField.fieldType = "outputText";
            delegationField.fieldValue = delegationTypeYesClickedValue;

        }
         //ketki RCED end

        //US3583813 - Sravan - Start
        else if(eventData.fieldName == 'Delegation '){
                component.set("v.showDelegation",true);
        }
            component.set("v.cardDetails",cardDetails);
        //US3583813 - Sravan - End

        /*
        if(eventData.fieldName == "Group Name"){
            helper.callGroupName(component, event, helper);
        }
        */
        //US2645457: Health Plan Site & COB History Link Selected in Auto Doc
        if(eventData.fieldName == "Health Plan Site"){
            helper.handleHealthPlanSiteLinkClick(component, event, helper);
        }
    },

})