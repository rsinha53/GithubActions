({
    doInit: function(cmp, event, helper){
    },
    // US1954477    Targeted COB Details - Integration - 30/09/2019 - Sarma
    //Making changes & removing hardcoded vals
    // onDatachange: function(cmp, event, helper) {
    //     helper.setCobCommentsDetails(cmp);
    //     var policyDetails = cmp.get('v.policyDetails');
    //     if(!$A.util.isEmpty(policyDetails) && !$A.util.isEmpty(policyDetails.resultWrapper) && !$A.util.isEmpty(policyDetails.resultWrapper.policyRes)){
    //     	helper.getCOBHistory(cmp);
    //     }
    // },

    closeCOBHistory: function(cmp, event, helper) {
        cmp.set('v.isShowCobHistory', false);
    },

    // US3269760 - Thanish - 16th Feb 2021
    onShowCobHistory: function(cmp, event, helper){
        if(cmp.get("v.isShowCobHistory")){
            cmp.set("v.isCobHistoryLoaded", false);
            cmp.set("v.isCobCommentsLoaded", false);
            // US2890614: COB History Integration M&R
            var policyDetails = cmp.get('v.policyDetails');
            if(!$A.util.isEmpty(policyDetails) && !$A.util.isEmpty(policyDetails.resultWrapper) && !$A.util.isEmpty(policyDetails.resultWrapper.policyRes)){
                helper.setCobHistoryDetails(cmp);
                helper.setCobCommentsDetails(cmp);
            }
        }
    }

})