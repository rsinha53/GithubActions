({
    getProviderData: function (component, event, helper, offset) {
        debugger;
        var action = component.get("c.getLookupData");
        var lookupInputs = component.get("v.providerDetails");
        console.log('LookUp Inputs'+ JSON.stringify(lookupInputs));
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
        }
        var pcMap = component.get("v.productCodesMap");
        if(sourceCode == 'CS' && claimSourceSystemCode == '01' && eligibilitySourceSystemCode == '03'){
            if(productCode == 'M'){
                component.set("v.convertedProductCodes",'HM8');
            }else if(productCode == 'D'){
                component.set("v.convertedProductCodes",'HM9');
            }
        }else{            
            for(var i in pcMap) {
                if(pcMap[i].From_CDB__c == productCode) {
                    component.set("v.convertedProductCodes",pcMap[i].Send_To_NDB__c);
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
            start: 0,
            endCount: 50,
            filtered : component.get("v.isOnlyActive"),
	    benefitLevel : lookupInputs.benefitLevel,
            marketSite:marketSite,
            entityType:entityType,
            sharedArrangement : sharedArrangement,
    		obligorID : obligorID,
    		productCode : component.get("v.convertedProductCodes"),
    		marketType : marketType
            
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = JSON.parse(response.getReturnValue().service);
                console.log('Input Results'+ result);
                helper.processTable(component, event, helper, result);
            } else {
                console.log('FAIL## ' + JSON.stringify(response.getReturnValue()));
            }
        });

        $A.enqueueAction(action);
    },

    processTable: function (component, event, helper, result) {
        var lgt_dt_DT_Object = new Object();
        lgt_dt_DT_Object.lgt_dt_PageSize = JSON.parse(result).PageSize;
        lgt_dt_DT_Object.lgt_dt_SortBy = -1;
        lgt_dt_DT_Object.lgt_dt_SortDir = '';
        lgt_dt_DT_Object.lgt_dt_serviceObj = result;
        lgt_dt_DT_Object.lgt_dt_lock_headers = "640";
        lgt_dt_DT_Object.lgt_dt_StartRecord = 0;
        lgt_dt_DT_Object.lgt_dt_PageNumber = 1;
        lgt_dt_DT_Object.lgt_dt_serviceName = 'ACET_ProviderLookupService';
        lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"PROVIDER ID","defaultContent":"","data":"providerId"},{"title":"STATUS","defaultContent":"","data":"benefitLevel"},{"title":"TIER/TYPE","defaultContent":"","data":"tierValue"},{"title":"UHPD","defaultContent":"","data":"uhpd"},{"title":"PROVIDER NAME","defaultContent":"","data":"providerName"},{"title":"MILES","defaultContent":"","data":"miles"},{"title":"ADDRESS","defaultContent":"","data":"address"},{"title":"ADDRESS TYPE","defaultContent":"","data":"addressType"},{"title":"TAX ID","defaultContent":"","data":"taxId"},{"title":"NPI","defaultContent":"","data":"npi"}]');

        component.set("v.lgt_dt_DT_Object", JSON.stringify(lgt_dt_DT_Object));
        var lgt_dt_Cmp = component.find("ProviderLookupResultsTable_auraid");
        lgt_dt_Cmp.tableinit();
    },
    //US2544945:  Provider Lookup - Detail Page Logic -Durga
    handleCellClickforTab :function(event){
        let checkboxList = event.currentTarget.parentNode.getElementsByTagName("input");
        let checkbox; let autodocCheckbox; let resolveCheckbox;
        for(checkbox of checkboxList) {
            if(checkbox.className == "autodoc") {
                autodocCheckbox = checkbox;
            } else if(checkbox.className == "autodoc-case-item-resolved") {
                resolveCheckbox = checkbox;
            }
        }
        // perform checkbox checking logic ...
        if(autodocCheckbox != null && resolveCheckbox != null) {
            if(!autodocCheckbox.disabled) {
                autodocCheckbox.checked = true;
                resolveCheckbox.checked = true;
                $A.util.addClass(event.currentTarget.parentNode, "clickedRow");
            }
        }
    },

    // US2431041 - Thanish - 23rd Apr 2020
    handleCellClick : function(event) {
        // get autodoc and resolved checkboxes ...
        let checkboxList = event.currentTarget.parentNode.getElementsByTagName("input");
        let checkbox; let autodocCheckbox; let resolveCheckbox;
        for(checkbox of checkboxList) {
            if(checkbox.className == "autodoc") {
                autodocCheckbox = checkbox;
            } else if(checkbox.className == "autodoc-case-item-resolved") {
                resolveCheckbox = checkbox;
            }
        }
        // perform checkbox checking logic ...
        if(autodocCheckbox != null && resolveCheckbox != null) {
            if(!autodocCheckbox.disabled) {
                if(autodocCheckbox.checked) {
                    autodocCheckbox.checked = false;
                    resolveCheckbox.checked = false;
                    $A.util.removeClass(event.currentTarget.parentNode, "clickedRow");
                } else if(!resolveCheckbox.checked) {
                    autodocCheckbox.checked = true;
                    resolveCheckbox.checked = true;
                    $A.util.addClass(event.currentTarget.parentNode, "clickedRow");
                } else {
                    // do nothing ...
                }
            }
        }
    },

    // US2712146
    fireCallTopicAutodoc: function(cmp, event, helper) {
        var appEvent = $A.get("e.c:ACET_CallTopicAutodoc");
        appEvent.setParams({
            memberTabId: cmp.get('v.memberTabId'),
            AutodocKey: cmp.get('v.AutodocKey'),
            AutodocPageFeature: cmp.get('v.autodocPageFeature')
        });
        appEvent.fire();
    }
})