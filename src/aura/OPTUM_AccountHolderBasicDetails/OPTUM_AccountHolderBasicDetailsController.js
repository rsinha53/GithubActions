({
    doInit: function (cmp, event, helper) {
        helper.dateFormat(cmp, event, helper);
        // Added by Dimpy US2904971: Create New Case
        helper.getUserInfo(cmp, event, helper);
		//Added by Prasad US3039766: Get Org Name
        helper.getorgInfo(cmp, event, helper);
	  helper.employeDetails(cmp, event, helper);
	  //Added by Iresh DE411196: To fix the space between Middle name and Last name
	  helper.getFullName(cmp, event, helper);
	  // Added By Prasad -US3381292 -'WEX' Deep Link - Member Level - Member Page
	    var emp;
        //US3703234: Member with No Accounts
      var ssnMemberDetails = cmp.get("v.memberDetails");
      if(ssnMemberDetails != null && !($A.util.isUndefinedOrNull(ssnMemberDetails.accountDetails)) 
          && !((Object.keys(ssnMemberDetails.accountDetails).length)==0)) {
          var accountDetails = Object.values(cmp.get("v.memberDetails.accountDetails"));
    for (var acct = 0; acct < accountDetails.length; acct++) {
          if (!($A.util.isUndefinedOrNull(accountDetails[acct].employerAlias))) {
              emp = accountDetails[acct].employerAlias;
              break;
          }
        }
      }
        if(emp ==="undefined" || emp==null || emp ===""){
           cmp.set('v.isHide', true);
        }
    },
	 openRecordDetails : function(cmp, event, helper) {
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.openTab({
          recordId:cmp.get("v.optumInt.Originator__c"),
            focus: true
        }).then(function(response) {
            workspaceAPI.openSubtab({
                parentTabId: response,
                recordId:cmp.get("v.optumInt.Id"),
                focus: true
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
  //Added by Prasad US3039766: for navigate to FTPS browser
    navigate : function(cmp, event, helper) {
        var faro= cmp.get("v.memberDetails.member.faroId");
        var orgname= cmp.get("v.orgInfo.IsSandbox");
        if(orgname!=undefined && orgname==true){
           var devftps = $A.get("$Label.c.OPTUM_DevFTPS");  
        }
        else{
          var devftps = $A.get("$Label.c.OPTUM_PrdFTPS");   
        }
     var urlEvent = $A.get("e.force:navigateToURL");
      urlEvent.setParams({
        'url': ''+devftps+''+ faro + ''
     });
      urlEvent.fire();
},
//Added by Prasad 	US3157974: Deep link CAP Super User
 //Added by Manohar US3325790: Changed custom label for OPTUM_DevCapSuperUser
capSuperUser : function(cmp, event, helper) {
        var faro= cmp.get("v.memberDetails.member.faroId");
        var orgname= cmp.get("v.orgInfo.IsSandbox");
        if(orgname!=undefined && orgname){
           var devftps = $A.get("$Label.c.OPTUM_DevCapSuperUser");  
        }
        else{
          var devftps = $A.get("$Label.c.OPTUM_PrdCapSuperUser");   
        }
     var urlEvent = $A.get("e.force:navigateToURL");
      urlEvent.setParams({
        'url': ''+devftps+''+ faro + ''
     });
      urlEvent.fire();
},
//Added by Iresh US3157978: Deep link Healthsafe ID Admin
     healthsafe : function(cmp, event, helper) {
         var faro= cmp.get("v.memberDetails.member.faroId");
         var orgname= cmp.get("v.orgInfo.IsSandbox");
         if(orgname!=undefined && orgname==true){
            var devHealth = $A.get("$Label.c.OPTUM_DevHealthsafe");
         }
         else{
           var devHealth = $A.get("$Label.c.OPTUM_PrdHealthsafe");
         }
      var urlEvent = $A.get("e.force:navigateToURL");
       urlEvent.setParams({
         'url': ''+devHealth+''+ faro + ''
      });
       urlEvent.fire();
 },
 //Added by prasad-US3223518:Tech Story: Auto Doc General Information
 openPreview : function(cmp) {
        var selectedString = _autodoc.getAutodoc(cmp.get("v.autodocUniqueId"));
        cmp.set("v.tableDetails_prev",selectedString);
        cmp.set("v.showpreview",true);
		
	},
	//Added by Prasad US3209142: WEX Deep Link Member Level
    wex : function(cmp, event, helper) {
      //US3703234: Member with No Accounts
    var ssnMemberDetails = cmp.get("v.memberDetails");
    if(ssnMemberDetails != null && !($A.util.isUndefinedOrNull(ssnMemberDetails.accountDetails)) 
        && !((Object.keys(ssnMemberDetails.accountDetails).length)==0)) {
  var emp =cmp.get("v.memberDetails.accountDetails[0].employerAlias");
        }
        if(emp!="undefined"){
         var orgname= cmp.get("v.orgInfo.IsSandbox");
         if(orgname!=undefined && orgname==true){
            var devHealth = $A.get("$Label.c.OPTUM_WexHealthCloud");
         }
         else{
           var devHealth = $A.get("$Label.c.OPTUM_WexHealthCloud");
         }
      var urlEvent = $A.get("e.force:navigateToURL");
       urlEvent.setParams({
         'url':''+devHealth+''
      });
       urlEvent.fire();
		}
 },
})