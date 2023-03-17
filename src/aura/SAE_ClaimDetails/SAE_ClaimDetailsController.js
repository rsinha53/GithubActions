({
    //US1956058 : Malinda
	doInit : function(component, event, helper) {    
		helper.callClaimDetail(component, event, helper);
        let claim = component.get("v.selectedClaim");
        component.set("v.claimNo",claim.claimNumber);
        component.set("v.claimBenefitLevel",claim.claimBenefitlevel);
        component.set("v.totalPaidAmount",claim.totalPaidAmt);
        component.set("v.totalDeniedAmount",claim.totalDeniedAmt);
        component.set("v.totalAllowedAmount",claim.totalAllowedAmt);
        component.set("v.totalDeductible",claim.totalDeductibleAmt);
        component.set("v.totalCopay",claim.totalCopayAmt);
        component.set("v.totalCoInsurance",claim.totalCoinsuranceAmt);
        component.set("v.totalProviderResponsibilty",claim.totalProviderResponsibiliyAmt);
        
	}
    
})