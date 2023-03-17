({
    myAction : function(component, event, helper) {
        if(component.get("v.getDataonLoad")){
            console.log('myaction activities--');
            var famAccId = component.get("v.familyId");
           
            var action = component.get('c.getDashboardData');
            action.setParams({
                "famAccId" : famAccId 
            });
            action.setCallback(this, function(actionResult) {
            var stateResponse = actionResult.getState();
            if(stateResponse == 'SUCCESS') {
                var result = actionResult.getReturnValue();
                /*This below line checks whether an exception is caught in apex*/
                if(!result.ErrorOccured){
                    component.set('v.taskHis', result.allActions);
                }else{
                    /*This Happens when a exception is caught in apex and redirects to error page*/
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/error"
                    });
                    urlEvent.fire(); 
                }
            }
            
        });
            $A.enqueueAction(action);
        } 
    },
    setCurrentFamily : function(component, event) { 
        
        var selectFamId = event.getParam("familyAccId"); 
       // selectFamId = '001R000001ebyDwIAI';
        console.log('Activities from event ---'+selectFamId);
        var action = component.get('c.getDashboardData');
        action.setParams({
            "famAccId" : selectFamId  
        });
        action.setCallback(this, function(actionResult) {
            console.log('event stateResponse--actionResult---'+actionResult);
            var stateResponse = actionResult.getState();
            console.log('event stateResponse---'+stateResponse);
            if(stateResponse == 'SUCCESS') {
                var result = actionResult.getReturnValue();
                 /*This below line checks whether an exception is caught in apex*/
                if(!result.ErrorOccured){
                    component.set('v.taskHis', result.allActions);
                }else{
                    /*This Happens when a exception is caught in apex and redirects to error page*/
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/error"
                    });
                    urlEvent.fire(); 
                }
            }
            
        });
        $A.enqueueAction(action); 
               
    }

})