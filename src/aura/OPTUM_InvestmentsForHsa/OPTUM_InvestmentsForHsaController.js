({
    doInit: function(component, event, helper) {
        var invPlan = component.get("v.accountList[0].nonNotionalAccountDetails[0].invstCurrPlanName");
        component.set("v.investmentPlan", invPlan);
        var invThreshold = component.get("v.accountList[0].nonNotionalAccountDetails[0].invstCurrThresholdAmt");
        component.set("v.investmentThreshold", invThreshold);
        var mutualFbalance = component.get("v.accountList[0].nonNotionalAccountDetails[0].invstTotalBalance");
        component.set("v.mutualFundBalance", mutualFbalance);
        var mutualFundstatus = component.get("v.accountList[0].nonNotionalAccountDetail[0].invstCurrStatusDesc");
        component.set("v.mutualFundStatus", mutualFundstatus);
        var hsbaBalance = component.get("v.accountList[0].nonNotionalAccountDetails[0].invstHSBATotalBalance");
        component.set("v.hsbaBalance", hsbaBalance);
        var hsbaStatus = component.get("v.accountList[0].nonNotionalAccountDetails[0].invstHSBAStatusDesc");
        component.set("v.hsbaStatus", hsbaStatus);
        var hsbaCashBalance = component.get("v.accountList[0].nonNotionalAccountDetails[0].invstHSBACashBalance");
        component.set("v.hsbaCashBalance", hsbaCashBalance);
        var bettermentBalance = component.get("v.accountList[0].nonNotionalAccountDetails[0].invstBMTTotalBalance");
        component.set("v.bettermentBalance", bettermentBalance);
        var bettermentStatus = component.get("v.accountList[0].nonNotionalAccountDetails[0].invstBMTStatusDesc");
        component.set("v.bettermentStatus", bettermentStatus);
        var invstBalance = parseInt(mutualFbalance) + parseInt(hsbaBalance) + parseInt(bettermentBalance);
        component.set("v.investmentBalance", invstBalance);

    },

    hsaData: function(component, event, helper) {
        helper.getHSADetails(component, event, helper);
    },
	// Added for Sweep details button
    getData : function(component, event, helper) {
         component.set("v.flag", true);
         helper.investmentSummery(component, event, helper);
    }
})