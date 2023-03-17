({
    onLoad : function(cmp, event, helper) {
         if(cmp.get("v.policyName")=='CO - Physician' && cmp.get("v.claimPolicyList").length==3)
          cmp.set("v.count",2);
        //US3463210 - Sravan - Start
        var viewClaimsSubType = cmp.get("v.viewClaimsSubType");
        if(viewClaimsSubType == 'Claims Project 20+ Claims'){
             cmp.set("v.showSendTo",false);

        }
        //US346210 - Sravan - End
    },
    validation : function(cmp, event, helper) {
       //US3463210 - Sravan - Start
       var viewClaimsSubType = cmp.get("v.viewClaimsSubType");
       if(viewClaimsSubType == 'Claims Project 20+ Claims'){
            cmp.find("AdditionalRequestDetails").validation();
            cmp.find("ServiceRequestRequirement").validation();
       }
       else{
        cmp.find("sendToRouting").validation();
        cmp.find("AdditionalRequestDetails").validation();
        cmp.find("ServiceRequestRequirement").validation();
       }
       //US346210 - Sravan - End

     },
     createORSCases : function(cmp, event, helper) {
         console.log("createORSCases in Claim Service Routing component");
         //US3463210 - Sravan - Start
         var viewClaimsSubType = cmp.get("v.viewClaimsSubType");
         if(viewClaimsSubType == 'Claims Project 20+ Claims'){
            cmp.find("sendToRouting").createCaseForClaimsProject();
         }
         else{
         cmp.find("sendToRouting").createORSCases();
         }
        //US346210 - Sravan - End
     },
     retryORSCases : function(cmp, event, helper) {
         console.log("retryORSCases in Claim Service Routing component");
         cmp.find("sendToRouting").retryORSCases();
     }

})