({
	fireToast: function(title, messages, component, event, helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messages,
            "type": "error",
            "mode": "dismissible",
            "duration": "10000"
        });
        toastEvent.fire();
        return;
        
    },
    
     callAdvancedApi: function(component, event, helper){
	   var errorEvent = component.getEvent("errorEvent");
       errorEvent.setParams({"error":"","clearType" :"api"});
       errorEvent.fire();
       var birthDate = component.get("v.birthDate");
       if(birthDate!= null && !($A.util.isUndefinedOrNull(birthDate))){
         birthDate = $A.localizationService.formatDate(birthDate, "YYYY-MM-dd");
         birthDate = birthDate.trim();		 
       }
        var action = component.get("c.memberWithAdvanceSearch");
          component.set("v.Spinner", true);
        action.setParams({
            "ssn": component.get("v.ssn"),
            "dob": birthDate,
            "accountNumber" : component.get("v.accountNumber"),
            "email" : component.get("v.emailAddress"),
            "firstName" : component.get("v.firstName"),
            "lastName" : component.get("v.lastName")
        });
        action.setCallback(this, function(response) {
        var state = response.getState();
        var responseValue = JSON.parse(response.getReturnValue());
      console.log("check Advanced response", JSON.stringify(responseValue));
      if (state === "SUCCESS") {
        if (responseValue != null && !($A.util.isUndefinedOrNull(responseValue.result)) && !((Object.keys(responseValue.result).length) == 0) && !($A.util.isUndefinedOrNull(responseValue.result.data)) && !((Object.keys(responseValue.result.data).length) == 0)) {
          component.set("v.Spinner", false);
		  component.set("v.MemberDetails", responseValue.result.data);
          var advanceEvent = component.getEvent("advanceSearchEvent");
          advanceEvent.setParams({ "MemberDetails": responseValue.result.data });
          advanceEvent.fire();
       }
        else {
          component.set("v.MemberDetails", "");
          component.set("v.Spinner", false);
          if(responseValue!=null && !($A.util.isUndefinedOrNull(responseValue.status))){
               if (!(responseValue.status.messages[0].name === 'Success') || Object.keys(responseValue.result.data).length === 0) {
              component.set("v.Spinner", false);
              var errorEvent = component.getEvent("errorEvent");
             errorEvent.setParams({ "error": responseValue.status.messages[0].description,"clearType" :"api" });
             errorEvent.fire();
            }}else{
                 var errorEvent = component.getEvent("errorEvent");
          errorEvent.setParams({ "error": "Something went wrong" ,"clearType" :"api"});
          errorEvent.fire();
            }
          }
      }
      else if (state === "INCOMPLETE") {

      }
      else if (state === "ERROR") {

        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log("Error message: " +
              errors[0].message);

          }
        } else {
          console.log("Unknown error");
        }
      }

    });
    $A.enqueueAction(action);

  },
    
    clearResultHelper: function(component,event,helper){
       
        component.set("v.memberId", "");
        component.set("v.firstName", "");
        component.set("v.lastName", "");
        component.set("v.birthDate", "");
        component.set("v.emailAddress", "");
        component.set("v.accountNumber", "");
        component.set("v.ssn", "");
        var errorEvent = component.getEvent("errorEvent");
        errorEvent.setParams({"error":"","clearType" :"clear"});
        errorEvent.fire();
        $A.util.removeClass(component.find("firstName"), "slds-has-error") ;
        $A.util.removeClass(component.find("lastName"), "slds-has-error") ;
		$A.util.removeClass(component.find("birthDate"), "slds-has-error") ;
        $A.util.removeClass(component.find("memEmail"), "slds-has-error") ;
        $A.util.removeClass(component.find("ssn"), "slds-has-error") ;
        $A.util.removeClass(component.find("accountNumber"), "slds-has-error") ;
       
        
        
}  
})