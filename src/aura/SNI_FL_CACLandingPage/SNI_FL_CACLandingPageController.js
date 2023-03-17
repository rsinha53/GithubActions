({
    myAction : function(component, event, helper) {
        
    },
    handleCaregiverLogin:function(component, event, helper){
        window.open($A.get("$Label.c.CACLoginpageURL"),'_self');
    },
    handleLogin:function(component, event, helper){
        //--RavikumarM - for Feature flag to show the HSID URLs
        var action = component.get("c.getCustMetaData");
        action.setCallback(this, function(response){
            console.log('response: '+response.getReturnValue());
            if(response.getReturnValue()==false){
                window.open($A.get("$Label.c.HSIDLoginPage"),'_self');   
            }else{
                window.open($A.get("$Label.c.CACLoginpageURL"),'_self');
            }
        });
        $A.enqueueAction(action);
        
    },
    
    handleRegister:function(component, event, helper){      
       // window.open('/myportal/s/digitalonboardingregistration','_self');
        
        var action = component.get("c.getCustMetaData");
        action.setCallback(this, function(response){
            console.log('response: '+response.getReturnValue());
            if(response.getReturnValue()==false){
                window.open($A.get("$Label.c.HSIDRegisterPage"),'_self');  
            }else{
                window.open($A.get("$Label.c.CACRegistrationPage"),'_self');
            }
        });
        $A.enqueueAction(action);
    }
    
    
})