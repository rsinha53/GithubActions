({
    //US1958804
    onInit: function (cmp, event, helper) {
        var caseWrapper = {};
        caseWrapper.AddInfoTopic = 'View Payments';
        cmp.set("v.caseWrapper",caseWrapper);
        helper.initSetData(cmp, event);
        // DE482674 - Thanish - 1st Sep 2021 helper.setDefaultAutodoc(cmp, event);
    },

    commentsShow: function (component, event, helper) {
        component.set("v.showComments", true);
        component.set("v.disableCommentButton",true);
    },

    // US3597656
    openPaymentDetails: function (cmp, event, helper) {
        var policyDetails = cmp.get('v.policyDetails');

        var checkSearchResp = cmp.get('v.checkSearchRespObj');
        var isMemberFlow = false;
            var sourceCode = '';
            if(((!$A.util.isUndefinedOrNull(policyDetails)) && (!$A.util.isEmpty(policyDetails)))){
                sourceCode  = policyDetails.resultWrapper.policyRes.sourceCode;
                isMemberFlow = true;
            }
        if((isMemberFlow && sourceCode == 'CO' ) || (cmp.get('v.platform') == 'COSMOS' && !isMemberFlow)){
                helper.fireToastMessage("Warning", "Additional Payment Details are not available. Access the Provider Remittance Advice (PRA) for additional details.", "Warning", "dismissible", "6000");

        }
        else{
        cmp.set("v.isShowPaymentCheckDetails", false);
        if (!$A.util.isUndefinedOrNull(checkSearchResp) && !$A.util.isUndefinedOrNull(checkSearchResp[0])) {
            if (checkSearchResp[0].statusCode == 200 || checkSearchResp[0].statusCode == 201) {
                cmp.set('v.isShowPaymentCheckDetails', true);

                	helper.checkUnresolved(cmp, event, helper);

            } else if( checkSearchResp[0].statusCode == 404 ) { //US3625667: View Payments -  Error Code Handling - Swapnil
                cmp.set('v.isShowPaymentCheckDetails', true);
                helper.fireToastMessage("We hit a snag.", helper.paymentResultsErrorMsg, "error", "dismissible", "6000");
            } else {
                helper.fireToastMessage("We hit a snag.", helper.paymentResultsErrorMsg, "error", "dismissible", "6000");
            }
        }
            }
    },

    //US3691404: View Payments Topic - Enable/Disable Auto Doc, Add Comments & Route Buttons - Swapnil
    getSelectedRecords: function(cmp, event, helper) {
        // DE482674 - Thanish - 1st Sep 2021
       /* var tableDetails = cmp.get("v.tableDetails");
        if(tableDetails.selectedRows.length > 0){
            helper.setDefaultAutodoc(cmp);
        } else{
            helper.deleteDefaultAutodoc(cmp);
        }*/

        helper.checkUnresolved(cmp, event, helper);
    },

    //US3632386:View Payments - Auto Doc for the Same Member - Swapnil
    getAutoDoc: function(cmp, event, helper) {
        var autoItems = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        cmp.set("v.tableDetails_preview", autoItems);
        cmp.set("v.showpreview", true);
    },
    openModal: function(cmp, event, helper) {
        cmp.set('v.openSaveCase',true);
    }

})