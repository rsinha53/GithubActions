({
    roiEventFire :function(component, event, helper){
        var roievtFire = $A.get("e.c:SNI_FL_RedirectToRoi");
		var usr = false;
        if( ! $A.util.isUndefinedOrNull(component.get('v.User'))  ){
            usr = true;
        }
        roievtFire.setParams({ 
            "ctMemDataIndex" : component.get("v.ctMemDataIndex"),
			"userExist": usr
        });
        roievtFire.fire();
        /*
        var evt = $A.get("e.c:SNI_FL_RefreshCmp");
        evt.setParams({ 
          "isRefresh" : true
        });
        evt.fire();
        */
        component.destroy();
    },
	checkUserName :function(component, event, helper){
		 var emailId = component.get("v.Email");
         var action = component.get('c.checkDuplicateUserName');
            action.setParams({
                "emailId": emailId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('-------state----'+state);
                if(state == "SUCCESS"){
                    var msg = response.getReturnValue();
					var curemalVal = component.get("v.Email");
                    if(!$A.util.isEmpty(msg) && msg=="SUCCESS"){
                         component.find("emailId").setCustomValidity(""); 
                         component.find("emailId").reportValidity();
                         if(curemalVal == emailId ){
                           component.set("v.isInviteButtonDisable", false);
                        }
                        else{
                            component.set("v.isInviteButtonDisable", true);
                        }

                    }else{
                        
                         component.find("emailId").setCustomValidity(msg); 
                         component.find("emailId").reportValidity();
                         component.set("v.isInviteButtonDisable", true);
                    }
                }else{                    
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/error"
                    });
                    urlEvent.fire(); 
                }
            });
       $A.enqueueAction(action);
	},
    getUserdetails: function(component, event, helper){
          var persnaccId = component.get("v.careTeamMembId");
          var action = component.get('c.getuserDetail');
            action.setParams({
                "persnAccId": persnaccId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('-INV-H-getUserdetails-state----'+state);
                console.log('-INV-H-getUserdetails-ret val----'+response.getReturnValue);
                if(state == "SUCCESS"){
  
                    component.set('v.User', response.getReturnValue());
                }            
            });
       $A.enqueueAction(action);
    }
})