({
    doInit : function(component, event, helper) {
        console.log('Test');
        var recordId = component.get('v.recordId');
        var action = component.get('c.addMemberOnWorkOrder');
            action.setParams({
                "workOrderId" : recordId
                
            });
        action.setCallback(this, function(response){
            console.log('Enter');
            var state = response.getState(); 
            console.log(state);
            console.log(response.getReturnValue());
            if(state == 'SUCCESS') {                
                var returnValue= response.getReturnValue() 
                console.log('returnValue'+ JSON.stringify(returnValue));
                if(returnValue!=null){
                    if(returnValue.checkAccount == 'Account Exist'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: "Error!",
                            message: "This Work order is already assigned",
                            type: "Error"});
                       
                           $A.get("e.force:closeQuickAction").fire();
                        //$A.get("e.force:refreshView").fire();
                        toastEvent.fire(); 
                    }else{
                        if(returnValue.checkAccount == 'Account added from Salesforce'){
                            $A.get("e.force:closeQuickAction").fire();
                            $A.get("e.force:refreshView").fire();
                        }
                             else{
                        console.log('Wo'+returnValue);
                        localStorage.setItem('memId', returnValue.workod.Member_ID__c);
                        localStorage.setItem('workOrderId', recordId);
                        localStorage.setItem('isACETNavigation' , true);
                        var memId = returnValue.workod.Member_ID__c;
                        var workOrderId = returnValue.workod.Id;
                        console.log(memId);
                        console.log(workOrderId);
                        localStorage.setItem(memId+'_memDOB', returnValue.workod.Date_of_Birth__c);
                        //localStorage[memId+'_memDOB']= returnValue.Date_of_Birth__c;
                        var urlEvent = $A.get("e.force:navigateToURL");
                          urlEvent.setParams({
                               "url": "/lightning/n/Member_Search_SNI"
                               });
                       urlEvent.fire();
                        console.log('Coming false');
                        
                    }
                        }
                    }
                   
                    }
           
                });
        
            $A.enqueueAction(action);
        
        
    }
})