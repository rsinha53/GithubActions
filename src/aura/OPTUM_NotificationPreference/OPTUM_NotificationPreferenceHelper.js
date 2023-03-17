({ 
 notifications:function(component, event, helper) {
             var sysntheticId = component.get("v.Syntheticid");
             var accountStatus = component.get("v.accountStatus");
             var id = component.get("v.accountList[0].syntheticId");
             var fetchedStatus = component.get("v.accountList[0].nonNotionalAccountDetails[0].accountStatus");
             if((sysntheticId!=id) && (!accountStatus!=fetchedStatus))
            {
             component.set("v.Spinner", true);
            component.set("v.Syntheticid", component.get("v.accountList[0].syntheticId"));
            component.set("v.accountStatus",component.get("v.accountList[0].nonNotionalAccountDetails[0].accountStatus"));
             var action = component.get("c.notifications");
             var selectedAccountNumberytenticId = component.get("v.accountList[0].syntheticId");;
             action.setParams({
			     "FAROID": component.get("v.faroId"),
                 "syntheticId": selectedAccountNumberytenticId
             });
             action.setCallback(this, function(response) {
                 var state = response.getState(); //Checking response status
                 var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
                 if ((state === "SUCCESS")&& (component.isValid())){
                     component.set("v.Spinner", false);
					if(responseValue != null && !($A.util.isUndefinedOrNull(responseValue.result)) && !((Object.keys(responseValue.result).length)==0) && !($A.util.isUndefinedOrNull(responseValue.result.data)) && !((Object.keys(responseValue.result.data).length) == 0)) {
                 component.set("v.notifications", responseValue.result.data);
                 console.log(" Notification Response",JSON.stringify(responseValue.result.data));
                 helper.notificationPreferenceValue(component, event, helper);
				 helper.autoDocNotification(component, event, helper);

				 } 
				}
               else if ((responseValue == null) || (state === "ERROR")) {
               		component.set("v.Spinner", false);
               		component.set("v.APIResponse", true);
            }
               else if (state === "INCOMPLETE") {
                	component.set("v.Spinner", false);
            }
             });
           $A.enqueueAction(action);
		   }
         },
   notificationPreferenceValue : function(component, event, helper) {
      var accountStatements = component.get("v.notifications.statement");
        if(accountStatements == "2"){
             component.set("v.accountStatements","Electronic");
        }else if(accountStatements == "4"){
            component.set("v.accountStatements","Paper");
        }else if(accountStatements == "0"){
            component.set("v.accountStatements","None Selected");
        }
        
       var taxDocuments = component.get("v.notifications.taxDoc");
        if(taxDocuments == "2"){
             component.set("v.taxDocuments","Electronic");
        }else if(taxDocuments == "4"){
            component.set("v.taxDocuments","Paper");
        }else if(taxDocuments == "0"){
            component.set("v.taxDocuments","None Selected");
        }
        
        var annualPrivacy = component.get("v.notifications.privacyStatement");
        if(annualPrivacy == "2"){
             component.set("v.annualPrivacy","Electronic");
        }else if(annualPrivacy == "4"){
            component.set("v.annualPrivacy","Paper");
        }else if(annualPrivacy == "0"){
            component.set("v.annualPrivacy","None Selected");
        }
        
        var futureDocuments = component.get("v.notifications.futureDoc");
        if(futureDocuments == "2"){
             component.set("v.futureDocuments","Electronic");
        }else if(futureDocuments == "4"){
            component.set("v.futureDocuments","Paper");
        }else if(futureDocuments == "0"){
            component.set("v.futureDocuments","None Selected");
        }
    },
	autoDocNotification : function(cmp, event, helper) {
         var autoDocTabData = cmp.get("v.notifications");
         var notificationDetails = [];
         var accDetails={documents:'Account Statements',preference:cmp.get("v.accountStatements")};
         var taxDetails={documents: 'Tax Documents',preference:cmp.get("v.taxDocuments")};
         var annualDetails={documents: 'Annual Privacy',preference:cmp.get("v.annualPrivacy")};
         var futureDetails={documents: 'Future Documents',preference:cmp.get("v.futureDocuments")};
         var hsaDetails={documents: 'HSA Account Summary*',preference:''};
         notificationDetails.push(accDetails);
         notificationDetails.push(taxDetails);
         notificationDetails.push(annualDetails);
         notificationDetails.push(futureDetails);
         notificationDetails.push(hsaDetails);
        var action = cmp.get('c.getautoDocNotifications');
        action.setParams({
            "notiDetails": notificationDetails
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.stringify(response.getReturnValue());
            if ((state === "SUCCESS")){
                cmp.set("v.autoDocNotDetails" ,response.getReturnValue());
                 
             }
        });
        $A.enqueueAction(action);
    }
    
})