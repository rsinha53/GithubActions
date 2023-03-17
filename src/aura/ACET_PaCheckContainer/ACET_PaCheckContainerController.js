({
    init: function (cmp, event, helper) {

        var pageReference = cmp.get("v.pageReference");
        cmp.set('v.interactionOverviewTabId', pageReference.state.c__interactionOverviewTabId);
        cmp.set('v.memberInfo', pageReference.state.c__memberInfo);
        cmp.set('v.autodocUniqueId', pageReference.state.c__autodocUniqueId);
        //cmp.set('v.autodocUniqueIdCmp', 'asdfadasdasd');
        cmp.set('v.autodocUniqueIdCmp', pageReference.state.c__autodocUniqueIdCmp);
        cmp.set('v.policySelectedIndex', pageReference.state.c__policySelectedIndex);
        cmp.set('v.caseWrapper', pageReference.state.c__caseWrapper); //DE422112
        // US3089189
        cmp.set('v.memberTabId', pageReference.state.c__memberTabId);
        cmp.set('v.memberCardSnap', pageReference.state.c__memberCardSnap);

        // DE456362
        cmp.set('v.currenttabId', pageReference.state.c__currentTabId);

        //US3584404 - Sravan - Start
        cmp.set("v.delegationValue",pageReference.state.c__delegationValue);
        cmp.set("v.patientInfo",pageReference.state.c__patientInfo);
        console.log('Delegation Value'+ JSON.stringify(cmp.get("v.delegationValue")));
        console.log('Patient Info'+ JSON.stringify(cmp.get("v.patientInfo")));
        //US3584404 - Sravan - End

        //Rajesh Start
        var policyData = JSON.stringify(pageReference.state.c__memberInfo);
        var poliyInfo = JSON.parse(policyData);
        if(poliyInfo != null ){
            cmp.set("v.sourceCode",poliyInfo.sourceCode);
        }
        //Rajesh end

        helper.createPACheckDataObject(cmp, event, helper);

        window.scrollTo(0, 0);

        // US3089189
        cmp.set('v.paCheckTabId', helper.generateUniqueString(cmp, event)); 

    },

    handleHippaGuideLines: function (component, event, helper) {
        var hipaaEndPointUrl = component.get("v.hipaaEndpointUrl");
        if (!$A.util.isUndefinedOrNull(hipaaEndPointUrl) && !$A.util.isEmpty(hipaaEndPointUrl)) {
            window.open(hipaaEndPointUrl, '_blank');
        }
        component.set("v.isHipaa", true);

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
        _autodoc.setAutodoc(component.get("v.autodocUniqueId"), 0, cardDetails);
    },

    openMisdirectComp: function (component, event, helper) {
        helper.openMisDirect(component, event, helper);
    },
    dataChange: function (cmp, event, helper) {
        cmp.set("v.isShowBenefitandAuthResults", false);
        var prValues = cmp.get('v.priorAuthResult');
        if (prValues != undefined && prValues.length > 0) {
            cmp.set("v.isShowBenefitandAuthResults", true);
        }
    },

    checkPOS: function (cmp, event, helper) {
        var flag = cmp.get("v.isShowBenefitandAuthResults");
        if (flag) {
            cmp.set('v.isShowBenefitandAuthResults', false);
            cmp.set('v.PACheckData', cmp.get('v.PACheckData'));
            cmp.set('v.isShowBenefitandAuthResults', flag);

        }
    }

})