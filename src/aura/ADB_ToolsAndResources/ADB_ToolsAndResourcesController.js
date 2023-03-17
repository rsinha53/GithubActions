({
    doInit : function (component, event, helper) {
        helper.getCastLightPolicy(component, event, helper);
    },
    changeFIMWrapper : function (component, event, helper) {
        var FIMWrapper = component.get("v.FIMWrapper");
        var SSN;
        if(!$A.util.isEmpty(FIMWrapper) && !$A.util.isEmpty(FIMWrapper.callerSSN)){
            SSN = FIMWrapper.callerSSN;
            component.set("v.SSN", SSN);
        }
    },
	 navigateAvayaCallbackUrl : function (component, event, helper) {
        // to navigate to pharmacy claims tab from ISET
        helper.openAvayaCallbackUrl(component, event, helper);
    },
    navigateEviveUrl : function (component, event, helper) {
        // to navigate to pharmacy claims tab from ISET
        helper.openEviveUrl(component, event, helper);
    },
     navigateICUEPolicyAdminUrl : function (component, event, helper) {
        // to navigate to pharmacy claims tab from ISET
        helper.openICUEPolicyAdminUrl(component, event, helper);
    },
     navigateInitiateEngagementIntakeUrl : function (component, event, helper) {
        // to navigate to pharmacy claims tab from ISET
        helper.openInitiateEngagementIntakeUrl(component, event, helper);
    },
     navigateICUEHomeUrl : function (component, event, helper) {
        // to navigate to pharmacy claims tab from ISET
        helper.openICUEHomeUrl(component, event, helper);
    },
     navigateMyHealthDirectLoginUrl : function (component, event, helper) {
        // to navigate to pharmacy claims tab from ISET
        helper.openMyHealthDirectLoginUrl(component, event, helper);
    },
     navigateRallyCostEstimatorUrl : function (component, event, helper) {
        // to navigate to pharmacy claims tab from ISET
        helper.openRallyCostEstimatorUrl(component, event, helper);
    },
    // Added Rally Impersonation function: US2991881 - Sunil Vennam
    navigateRallyImpersonation : function (component, event, helper) {
        // to navigate to pharmacy claims tab from ISET
        helper.openRallyImpersonation(component, event, helper);
    },
    navigateHealthMessageCenterUrl : function (component, event, helper) {
        // to navigate to pharmacy claims tab from ISET
        helper.openHealthMessageCenterUrl(component, event, helper);
    },
    navigateThirdPartReferralUrl : function (component, event, helper) {
        // to navigate to pharmacy claims tab from ISET
        helper.openThirdPartReferralUrl(component, event, helper);
    },
    navigateMyUhcSupervisorUrl : function (component, event, helper) {
        // to navigate to pharmacy claims tab from ISET
        helper.openMyUhcSupervisorUrl(component, event, helper);
    },
    navigateGetCastLightEndPointlUrl : function (component, event, helper) {
        // to navigate to pharmacy claims tab from ISET
        helper.getCastLightSsoUrl(component, event, helper);
    },
})