({
    updateDetails : function(component, event) {
         var recordId = component.get("v.recordId"); 
         var selectedOption = component.get("v.selectedRow");
         var action = component.get("c.updateCareTeam");
		 action.setParams({"ctmIdSet" :selectedOption,
                           "personAccountId":recordId});
		 action.setCallback(this, function(response1) {
			 console.log('updateCareTeam-------------');
                var state1 = response1.getState();
				console.log('updateCareTeam-----state1--------'+state1);
                if(state1 == 'SUCCESS') {
					var resultVal = response1.getReturnValue();
					console.log('updateCareTeam-----resultVal--------'+resultVal);
                    this.hideGlobalSpinner(component);
					if(resultVal){
					}
					else{
						 
					}
				}
				else{
				    this.hideGlobalSpinner(component);   
				}
		 })
		 $A.enqueueAction(action);
         component.set("v.showModal", false);
    },
    fetchAccounts : function(component, event) {
       var recordId = component.get("v.recordId"); 
        console.log('recordId='+recordId);
        if (recordId) { 
            var action = component.get("c.getFamilyInfo");
            action.setParams({
                "recordId": recordId
            });
            action.setCallback(this, function(response){
              var state = response.getState();
              console.log('getFamilyInfo state='+state);
              if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('getFamilyInfo result=');
                console.log(result);
               if(result && result.length>0){ // && result.elligHubCheck
                   component.set("v.maxRowSelection",result.length);
                   console.log('Array Size='+result.length);
                   result.forEach(function(record) {
                   if(record.SNI_FL_Member__c){
                       component.set("v.memberName",record.SNI_FL_Member__r.Name);
                   }
                   if(record.SNI_FL_Family__c){
                       record.famName= record.SNI_FL_Family__r.Name;
                       record.famMemberId=record.SNI_FL_Family__r.Member_ID__c;
                       record.famPolicyID=record.SNI_FL_Family__r.Policy_ID__c;
                   }
                    record.CheckBool = false;
                    
                });
                    component.set("v.memberDetails",result);   
                   if(result.length>1){
                     component.set("v.showModal",true);
                   }
                }
                else{
                }
               }
               else{
                    
                }
            });
            $A.enqueueAction(action);        
        }
    },
	 // Show Spinner method
    showGlobalSpinner: function (component) {
        var spinner = component.find("global-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
        component.set("v.showSpinner",true);
    },//Hide Spinner method
    hideGlobalSpinner: function (component) {
        var spinner = component.find("global-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
        component.set("v.showSpinner",false);
        //return null;
    }
})