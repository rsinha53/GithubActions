({
   
   dateFormat : function(cmp, event, helper){
        var dateString = cmp.get("v.memberDetails.member.birthDate");
        cmp.set("v.dateFormated", $A.localizationService.formatDate(dateString, "MM/dd/YYYY"));

 },
 employeDetails : function(cmp, event, helper){
     //US3703234: Member with No Accounts
		var ssnMemberDetails = cmp.get("v.memberDetails");
        if(ssnMemberDetails != null && !($A.util.isUndefinedOrNull(ssnMemberDetails.accountDetails)) 
               && !((Object.keys(ssnMemberDetails.accountDetails).length)==0)) {
         var accountDetails = Object.values(cmp.get("v.memberDetails.accountDetails"));
        if(accountDetails.some(obj => obj.hasOwnProperty("notionalAccountDetails")) && accountDetails.some(obj => obj.hasOwnProperty("nonNotionalAccountDetails"))){
                    for(var a in accountDetails){
                 if(accountDetails[a].hasOwnProperty("notionalAccountDetails"))
                 {
                     cmp.set("v.employerName",accountDetails[a].employerGroupName); 
                   
                  }
                     else {
                            if(accountDetails[a].hasOwnProperty("nonNotionalAccountDetails")){
                          cmp.set("v.employerName",accountDetails[a].employerGroupName); 
                     
                            }
                        }
                 
                    }
                }
        
      else if(accountDetails.some(obj => obj.hasOwnProperty("nonNotionalAccountDetails"))) {
          for(var a in accountDetails){
                 if(accountDetails[a].hasOwnProperty("nonNotionalAccountDetails")){
                     cmp.set("v.employerName",accountDetails[a].employerGroupName); 
                    break;
                   }
            }
        }
            
       else if(accountDetails.some(obj => obj.hasOwnProperty("notionalAccountDetails"))){
                    for(var a in accountDetails){
                 if(accountDetails[a].hasOwnProperty("notionalAccountDetails")){
                     cmp.set("v.employerName",accountDetails[a].employerGroupName); 
                     break;
                  }
                 
                    }
                }
            }
   },
   
   //Added by Dimpy US2904971: Create New Case
    getUserInfo: function (cmp, event, helper) {
        var action = cmp.get("c.getUser");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                cmp.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
	//Added by Prasad US3039766: Get Org Name
     getorgInfo: function (cmp, event, helper) {
        var action = cmp.get("c.getorg");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                cmp.set("v.orgInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
//Added by Iresh DE411196: To fix the space between Middle name and Last name
    getFullName: function (cmp, event, helper) {
        var middleName = cmp.get("v.memberDetails.member.middleName");
        var fistname = cmp.get("v.memberDetails.member.firstName");
        var lastName = cmp.get("v.memberDetails.member.lastName");
         if (typeof middleName !== "undefined" || middleName != null || !middleName ==="") {
            var fullName = fistname+" "+ middleName +" "+ lastName;
                cmp.set("v.fullName", fullName);
         }else{
             	cmp.set("v.fullName", fistname+ " "+lastName);
         }
    },
    
})