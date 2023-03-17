({
    doInit : function(component, event, helper) {
        var homePageGreyOut = document.getElementsByClassName("SNI_FL_HomeId"); //cSNI_FL_Home
        for (var i=0; i<homePageGreyOut.length; i++) {
            $A.util.addClass(homePageGreyOut[i], 'SNI_FL_HomeGreyOut');
        }
        let action1 = component.get('c.getAdvisor');
        action1.setCallback(this, function(response) {
            let state = response.getState();
            if (state == "SUCCESS") {
                let advisorRecord = response.getReturnValue();
                component.set('v.advisor',advisorRecord);
                component.set('v.lastInitial', advisorRecord.LastName.slice(0,1));                
            } 
        });
        $A.enqueueAction(action1);
        let action2 = component.get('c.getPerson');
        action2.setCallback(this, function(response) {
            let state = response.getState();
            if (state == "SUCCESS") {
                let userRecord = response.getReturnValue();
                if(userRecord != null && userRecord != ''){
                    component.set('v.person',userRecord);                 
                }
                
            }
        });
        $A.enqueueAction(action2);
    }, 
    closeMessage : function(component, event, helper){
        helper.removeModal(component, event, helper);
    }, 

    messageClick : function(component, event, helper){
        helper.removeModal(component, event, helper);
        
        let messageEvent = component.getEvent("SNI_FL_WelcomeScreenMessageEvent");
        messageEvent.setParams({startMessage: true});
        messageEvent.fire();
    }
})