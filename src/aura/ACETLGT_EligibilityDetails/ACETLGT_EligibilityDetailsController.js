({
    doInit : function(cmp, event, helper) {
        setTimeout(function(){
            var tabKey = cmp.get("v.AutodocKey");
            window.lgtAutodoc.initAutodoc(tabKey);
            cmp.set("v.Spinner", false);

        },1);
        
    },
    groupElementsChanged : function(cmp, event, helper) {
		console.log('+++++++++Inside groupElementsChanged  Changed');
        var detail = cmp.get("v.MemberdetailFromGroup");
        //console.log('++++++'+detail.benefitAdmin);
	},
    handleCoveragesFamilyEvent : function(cmp, event) {
        var memberDetail = event.getParam("MemberDetail");
        cmp.set("v.MemberDetail", memberDetail);
        
        console.log('----WrittenLanguage--->>'+cmp.get("v.MemberDetail.WrittenLanguage"));
        console.log('----SpokenLanguage--->>'+cmp.get("v.MemberDetail.SpokenLanguage"));
    },
    handleGetIndividualEvent : function(cmp, event) {
        var EmploymentStartDate = event.getParam("dateOfEmployment");
        var EmploymentStatus = event.getParam("employmentStatus");
        var SpokenLanguage = event.getParam("spokenLanguage");
        var WrittenLanguage = event.getParam("writtenLanguage");
        cmp.set("v.EmploymentStartDate", EmploymentStartDate);
        cmp.set("v.EmploymentStatus", EmploymentStatus);
        cmp.set("v.SpokenLanguage", SpokenLanguage);
        cmp.set("v.WrittenLanguage", WrittenLanguage);
        console.log('======>'+EmploymentStartDate+EmploymentStatus+SpokenLanguage);
        
        //cmp.set("v.Memberdetail.languageMap", memberDetail);
    },
    handleCoveragesGroupEvent : function(cmp, event) {
        var memberDetailFromGroup = event.getParam("MemberDetailFromGroup");
        console.log('~~~~~!!!!!EligibilityDetails'+memberDetailFromGroup);
        cmp.set("v.MemberDetailFromGroup", memberDetailFromGroup);
    }
})