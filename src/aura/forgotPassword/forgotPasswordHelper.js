({
    qsToEventMap: {
        'expid'  : 'e.c:setExpId'
    },
    
    handleForgotPassword: function (component, event, helper) {
        var emailaddress = component.find("emailaddress").get("v.value");
        var checkEmailUrl = component.get("v.checkEmailUrl");
        var action = component.get("c.forgotPassword");
        action.setParams({emailaddress:emailaddress, checkEmailUrl:checkEmailUrl});
        action.setCallback(this, function(a) {
            var rtnValue = a.getReturnValue();
            if(!rtnValue.ErrorOccured){
                if (rtnValue.ErrorMessage != null) {
                    component.set("v.errorMessage",rtnValue.ErrorMessage);
                    component.set("v.showError",true);
                }
            }
            else{
                /*This Happens when a exception is caught in apex and redirects to error page*/
                var url = location.href; 
                url = url.split(".com")[0] + ".com";
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": url+ "/myportal/s/error"
                });
                urlEvent.fire();
                
            }
            
            
       });
        $A.enqueueAction(action);
    },

    setBrandingCookie: function (component, event, helper) {
        var expId = component.get("v.expid");
        if (expId) {
            var action = component.get("c.setExperienceId");
            action.setParams({expId:expId});
            action.setCallback(this, function(a){ });
            $A.enqueueAction(action);
        }
    }
})