({
    getData : function(component){
        // call apex class method
        var action = component.get("c.getProiverTeamList");
        var recId = component.get("v.recordId");
        console.log('-->'+recId);
        action.setParams({
            'recId' : recId //how many rows to load during initialization
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            var toastReference = $A.get("e.force:showToast");
            if(state == "SUCCESS"){
                var accountWrapper = response.getReturnValue();
                if(accountWrapper.success){
                    // set total rows count from response wrapper
                   // component.set("v.totalRows",accountWrapper.totalRecords);  
                    
                    var accountList = accountWrapper.accountsList;
                    // play a for each loop on list of account and set Account URL in custom 'accountName' field
                    accountList.forEach(function(account){
                        if(JSON.stringify(account.Team_Name__c) !=undefined){
                          account.accountName = '/'+account.Id;  
                        }
                    });
                    // set the updated response on accountData aura attribute  
                    component.set("v.accountData",accountList);
                    // display a success message  
                    toastReference.setParams({
                        "type" : "Success",
                        "title" : "Success",
                        "message" : accountWrapper.message,
                        "mode" : "dismissible"
                    });
                    toastReference.fire();
                }
                else{ // if any server side error, display error msg from response
                    toastReference.setParams({
                        "type" : "Error",
                        "title" : "Error",
                        "message" : accountWrapper.message,
                        "mode" : "sticky"
                    }); 
                    toastReference.fire();
                }
            }
            else{ // if any callback error, display error msg
                toastReference.setParams({
                    "type" : "Error",
                    "title" : "Error",
                    "message" : 'An error occurred during Initialization '+state,
                    "mode" : "sticky"
                });
                toastReference.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    
})