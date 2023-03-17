({
    showToast: function(cmp, event, title,type,message ){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
            
        });
        toastEvent.fire();
    },
    
	initializeObjects : function(cmp) {
		    var emailContent = {
            "subjectLine": "Email",
            "memberName": "",
            "providerAccountNumber":"",
            "dateofService":"",
            "totalCharges":"",
            "claimNumber":"",
            "providerName":"",
            "attachwithClaimInfo":false,
            "providerContact":"",
            "caseSummary":"",
            "employeeName":"",
            "title":"",
            "phoneNumber":"",
            "email":"",
            "IsthisCommercialPlan":"",
             
        };
        cmp.set("v.emailContent", emailContent);
	},
    clearFieldValues: function(cmp){
       // alert('Hey');
         var caseRecord = cmp.get("v.caseRec");
         var pirRecord = cmp.get("v.pirRec");
         var caseType=cmp.get("v.selectedCaseType");
         var providerName=cmp.get("v.providerName");
         var selectedMarketList=cmp.get("v.selectedMarketList");
                  
        cmp.set("v.caseRec", "");
        cmp.set("v.pirRec","");
        cmp.set("v.selectedCaseType", "");
        cmp.set("v.providerName","");
        cmp.set("v.selectedMarketList","");
        $A.get('e.force:refreshView').fire();
    } 
    
})