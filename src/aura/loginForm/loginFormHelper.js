({
    
    qsToEventMap: {
        'startURL'  : 'e.c:setStartUrl'
    },

    qsToEventMap2: {
        'expid'  : 'e.c:setExpId'
    },
    
    handleLogin: function (component, event, helpler) {
        var username = component.find("username").get("v.value");
        var password = component.find("password").get("v.value");
        var action = component.get("c.login");
        var startUrl = component.get("v.startUrl");
        
        startUrl = decodeURIComponent(startUrl);
        
        action.setParams({username:username, password:password, startUrl:startUrl});
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            /*This below line checks whether an exception is caught in apex*/
            if(!rtnValue.ErrorOccured){
                if (rtnValue.loginErrorMessage !== null) {
                    component.set("v.errorMessage",rtnValue.loginErrorMessage);
                component.set("v.showError",true);
                }
            } else {
                /*This Happens when a exception is caught in apex and redirects to error page*/
                var url = location.href; 
                url = url.split(".com")[0] + ".com";
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": url+ "/s/error"
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    getIsUsernamePasswordEnabled : function (component, event, helpler) {
        var action = component.get("c.getIsUsernamePasswordEnabled");
        action.setCallback(this, function(a){
        var rtnValue = a.getReturnValue();
            /*This below line checks whether an exception is caught in apex*/
            if(!rtnValue.ErrorOccured){
                if (rtnValue.isUsernamePasswordEnabled !== null) {
                    component.set('v.isUsernamePasswordEnabled',rtnValue.isUsernamePasswordEnabled);
                }
            } else {
                /*This Happens when a exception is caught in apex and redirects to error page*/
                var url = location.href; 
                url = url.split(".com")[0] + ".com";
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": url+ "/s/error"
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    getIsSelfRegistrationEnabled : function (component, event, helpler) {
        var action = component.get("c.getIsSelfRegistrationEnabled");
        action.setCallback(this, function(a){
        var rtnValue = a.getReturnValue();
            /*This below line checks whether an exception is caught in apex*/
            if(!rtnValue.ErrorOccured){
                if (rtnValue.isSelfRegistrationEnabled !== null) {
                    component.set('v.isSelfRegistrationEnabled',rtnValue.isSelfRegistrationEnabled);
                }
            } else {
                /*This Happens when a exception is caught in apex and redirects to error page*/
                var url = location.href; 
                url = url.split(".com")[0] + ".com";
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": url+ "/s/error"
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    getCommunityForgotPasswordUrl : function (component, event, helpler) {
        var action = component.get("c.getForgotPasswordUrl");
        action.setCallback(this, function(a){
        var rtnValue = a.getReturnValue();
            /*This below line checks whether an exception is caught in apex*/
            if(!rtnValue.ErrorOccured){
                if (rtnValue.forgotPasswordUrl !== null) {
                    component.set('v.communityForgotPasswordUrl',rtnValue.forgotPasswordUrl);
                }
            } else {
                /*This Happens when a exception is caught in apex and redirects to error page*/
                var url = location.href; 
                url = url.split(".com")[0] + ".com";
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": url+ "/s/error"
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    getCommunitySelfRegisterUrl : function (component, event, helpler) {
        var action = component.get("c.getSelfRegistrationUrl");
        action.setCallback(this, function(a){
        var rtnValue = a.getReturnValue();
            /*This below line checks whether an exception is caught in apex*/
            if(!rtnValue.ErrorOccured){
                if (rtnValue.selfRegistrationUrl !== null) {
                    component.set('v.communitySelfRegisterUrl',rtnValue.selfRegistrationUrl);
                }
            } else {
                /*This Happens when a exception is caught in apex and redirects to error page*/
                var url = location.href; 
                url = url.split(".com")[0] + ".com";
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": url+ "/s/error"
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    setBrandingCookie: function (component, event, helpler) {
        var expId = component.get("v.expid");
        if (expId) {
            var action = component.get("c.setExperienceId");
            action.setParams({expId:expId});
            action.setCallback(this, function(a){ });
            $A.enqueueAction(action);
        }
    }
})