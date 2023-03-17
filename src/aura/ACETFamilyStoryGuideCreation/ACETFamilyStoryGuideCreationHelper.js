({
	doInit : function(component, event, helper) {
       
		var recordId = component.get("v.recordId");
        var action = component.get("c.getFsgRecord");
         action.setParams({
            "accountId" :recordId
        });
        action.setCallback(this, function(response){
            console.log("Init Function");
            var stateResponse = response.getState();
                if(stateResponse == 'SUCCESS') {
                    var result = response.getReturnValue();
                    console.log("result in family story guide apex" + JSON.stringify(result));                    
                     if((result != '' && result) && result.Status__c ){
                         console.log("Is status true");
                       component.set("v.fsgRecordId",result.Id);
                        component.set("v.fsgRecord",result);
                        component.set("v.ShowFSGRecord",true);
						component.set("v.buttonsVis",true);
						if(result.Status__c != 'Not Offered'){
                        component.set("v.buttonVisibiity",false);
                            
                        }
                         
                        if(result.Status__c == 'Declined (Not Interested)' || result.Status__c == 'Declined (Busy, Try Again)'){
                            console.log(" In Declined");
                            component.set("v.statusVal",'showPopup');
                            
                        } 
                     }
                }
        });
        $A.enqueueAction(action);
	},
    getUserProfile : function(component, event, helper){
     var action = component.get("c.getUserProfile");
        action.setCallback(this, function(response){
            var stateResponse = response.getState();
                if(stateResponse == 'SUCCESS') {
                    var result = response.getReturnValue();
                   console.log('==='+result);
                    if((result != '' && result) ){
                        if(result == 'Family Engagement Center - Read Only'){
                            console.log('true');
                            component.set("v.buttonReadOnly",true);
                        }
                        else if(result != 'Family Engagement Center - Read Only'){
                            component.set("v.buttonReadOnly",false);
                        }
                       
                       // component.set("v.fsgRecord",result);
                       
                     }
                   
                }
        });
        $A.enqueueAction(action);
	}
})