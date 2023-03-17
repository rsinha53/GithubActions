({
    doInit: function (cmp, event, helper) {
        // US3182441: COB Card Update Fields UI
        var cobHistoryURL = "http://knowledgecentral.uhc.com/SPA/ProviderServiceAdvocateCallHandlingSOP/index.html#/";
        cmp.set('v.cobHistoryURL', cobHistoryURL);
        helper.showCobSpinner(cmp);
        helper.setAutodocCardData(cmp);
        // US3340930 - Thanish - 6th Mar 2021
    },

   ProcessCobData: function (cmp, event, helper) {
        //helper.updateCobData(cmp);
        //helper.showCobSpinner(cmp);
        var policyDetails = cmp.get("v.policyDetails");
        console.log(JSON.stringify(policyDetails));
        if (!$A.util.isEmpty(policyDetails) && !$A.util.isEmpty(policyDetails.resultWrapper) && !$A.util.isEmpty(policyDetails.resultWrapper.policyRes)) {
            helper.getENICobInfo(cmp);
        }
        
        //US1888880
        //component.set("v.isFireSpinner", isFireSpinner); 
    },

    handleAutodocEvent: function (cmp, event, helper) {
        var eventData = event.getParam("eventData");
        if (eventData.fieldName == "") {
            
        }
        // US2645457: Health Plan Site & COB History Link Selected in Auto Doc
        if (eventData.fieldName == "" && eventData.fieldType == "link" && eventData.fieldValue == "COB History/Comments") {
            helper.handleCOBHistoryLinkClick(cmp, event, helper);
            helper.showCOBHistory(cmp);
        }
        if (eventData.fieldName == "" && eventData.fieldType == "link" && eventData.fieldValue == "COB Process SOP") {
            helper.handleCOBProcessSOPLinkClick(cmp, event, helper);
        }
    }
})