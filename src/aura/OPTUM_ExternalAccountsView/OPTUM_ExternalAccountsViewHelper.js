({
  getexternalaccounts :function(component, event, helper) {
                  var sid= component.get("v.accountList[0].syntheticId");
                  component.set("v.Syntheticid",sid);
                  var action = component.get("c.externalaccounts");
                 component.set("v.Spinner", true);
				 component.set("v.Flag", false);
                    action.setParams({
                    "syntheticId": component.get("v.Syntheticid")
                });
          action.setCallback(this, function(response) {
               var state = response.getState(); //Checking response status
               var responseValue = JSON.parse(JSON.stringify(response.getReturnValue()));
               if ((state === "SUCCESS")&& (component.isValid())){
				   component.set("v.Spinner", false);
				 if(responseValue != null && !($A.util.isUndefinedOrNull(responseValue.result)) && !((Object.keys(responseValue.result).length)==0) && !($A.util.isUndefinedOrNull(responseValue.result.data)) && !((Object.keys(responseValue.result.data).length) == 0) && !($A.util.isUndefinedOrNull(responseValue.result.data.externalAccountsList)) && ((responseValue.result.data.externalAccountsList).length>0)) {
                component.set("v.externalaccounts", responseValue.result.data.externalAccountsList);
				console.log("Response",JSON.stringify(responseValue.result.data.externalAccountsList));	
          var trans =component.get("v.externalaccounts");
                  if(typeof trans!== "undefined" ){   
	                  for(var row = 0; row < trans.length; row++){
                          var adddate = trans[row].dateAdded;
                          if(typeof adddate!== "undefined"){
                             trans[row].cmpdateAdded =$A.localizationService.formatDate(adddate, "MM/dd/YYYY");
                           }     
				    var verdate = trans[row].dateVerified;
                     if( typeof verdate!== "undefined"){
                   trans[row].cmpdateVerified =$A.localizationService.formatDate(verdate, "MM/dd/YYYY");
                  } 
				   var route = trans[row].bankRoutingNumber;
                            if( typeof route== "undefined"){
                              component.set("v.Flag", true);
                            } 
               } 
				  }  } 
               else {
                component.set("v.APIResponse", true);
                component.set("v.Spinner", false);
                }				  
	      }
		  else if ((responseValue == null) || (state === "ERROR")) {
                component.set("v.APIResponse", true);
                component.set("v.Spinner", false);
            }
                else if (state === "INCOMPLETE") {
                    component.set("v.Spinner", false);
                }
              helper.autoDocData(component, event, helper);
        });
      $A.enqueueAction(action);
     },
    //US3254499 Autodoc External Accounts
    autoDocData: function(component, event, helper){
        var autoDocTabData = component.get("v.externalaccounts");
        console.log("autoDocTabData DATAAAAA ",JSON.stringify(autoDocTabData));
        var action = component.get('c.getautoDocExternalAccounts');
        action.setParams({
            "credDetails": component.get("v.externalaccounts")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = JSON.stringify(response.getReturnValue());
            if ((state === "SUCCESS")){
                component.set("v.autoDocExternalAccounts" ,response.getReturnValue());
                console.log("autoDocExternalAccounts ---" + responseValue);
            }
        });
        $A.enqueueAction(action);
    }
})