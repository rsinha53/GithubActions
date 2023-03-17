({
	handleCoveragesFamilyEvent : function(cmp, event) {
        
        var memberDetail = event.getParam("MemberDetail");
        
        cmp.set("v.Memberdetail", memberDetail);
        cmp.set("v.SpinnerMD","false");
        cmp.set("v.SpinnerED","false");
        cmp.set("v.SpinnerCD","false");
        
        
        //console.log('@@@@@@@@@~~~Event~~~memberDetail~~~>>'+memberDetail.BenefitPlanId);
        
    },
    handleCoveragesGroupEvent : function(cmp, event) {
        var memberDetailFromGroup = event.getParam("MemberDetailFromGroup");
        cmp.set("v.SpinnerMD","false");
        cmp.set("v.SpinnerED","false");
        cmp.set("v.SpinnerCD","false");
        //cmp.set("v.SpinnerCOV","false");
        
        //console.log('~~~~~!!!!!'+memberDetailFromGroup);
        //console.log('@@@@@@@@@New~~~~~!!!!!'+memberDetailFromGroup.coverageGroupInfo.benefitAdmin);
        cmp.set("v.MemberdetailFromGroup", memberDetailFromGroup);
    },
    activateTabs :function(cmp, event) {
        
    }
})