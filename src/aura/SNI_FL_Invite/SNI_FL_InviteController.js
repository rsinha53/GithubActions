({
    doInit: function(component, event, helper) {
        if(screen.width < 680){
            component.set('v.isSmallScreen', true);
        }
		console.log('typeOfInvite-------'+component.get('v.typeOfInvite'));
        var emailVal = component.get('v.Email') ; 
        component.set('v.prevEmail',emailVal);
        if(component.get('v.typeOfInvite') == 'resendInvite' && ! $A.util.isEmpty(emailVal) ){
            component.set('v.isInviteButtonDisable', false); 
        }
        else{
            component.set('v.isInviteButtonDisable', true); 
        }
        if(component.get('v.typeOfInvite') == 'editInvite'){
            if(! $A.util.isEmpty(emailVal)){
               component.set('v.isNextButtonDisable', false);
            }
            else{
             component.set('v.isNextButtonDisable', true);                
            }
        }
        var editinvite = component.get('v.isEditInvite');
       helper.getUserdetails(component, event, helper);
    },
	closeWarning: function(component, event, helper) {
        component.set("v.isInviteModalOpen", false);
    },
    onChangeEmail: function(component, event, helper) {
		    if(component.get('v.typeOfInvite') == 'editInvite'){
               component.set('v.isNextButtonDisable', true);             
            }
            component.find("emailId").setCustomValidity("");
            component.find("emailId").reportValidity();
            var emailField = component.find("emailId").get("v.value");
       		var iseditInvite = component.get("v.isEditInvite");
             var typeOfInv = component.get("v.typeOfInvite");
            var extuser = component.get("v.User");
			var isAllvalid = true;         		
            if(!$A.util.isEmpty(emailField)){
                var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;                      
                  if(!emailField.match(regExpEmailformat)){
                     component.find("emailId").setCustomValidity('Please enter a valid Email');          
                      isAllvalid = false;
                      component.set("v.isInviteButtonDisable", true);
                  }else{
                      component.set("v.isInviteButtonDisable", false);
                      component.find("emailId").setCustomValidity("");                     
                  }      
                component.find("emailId").reportValidity(); 
                if(isAllvalid == true){
                    var emailval = emailField.trim().toLowerCase();
                    var prevemail = component.get('v.prevEmail');
                    if(typeOfInv == 'editInvite' || typeOfInv == 'resendInvite'){
                        debugger;
                        //if( (!$A.util.isUndefinedOrNull(extuser) && extuser.Username != emailval)  || (!$A.util.isUndefinedOrNull(prevemail) && emailval != prevemail) ){ 
                        if( (!$A.util.isUndefinedOrNull(extuser) && extuser.Username != emailval  && prevemail != emailval) || ( $A.util.isUndefinedOrNull(extuser) &&  prevemail != emailval) ){                                                       
                                helper.checkUserName(component, event, helper); 
                        }
                        else{
                                component.find("emailId").setCustomValidity(""); 
                                component.find("emailId").reportValidity();
                                if(typeOfInv == 'editInvite'){
                                    component.set("v.isInviteButtonDisable", true);
                                    component.set('v.isNextButtonDisable', false); 
                                }
                                else{
                                    component.set("v.isInviteButtonDisable", false);
                                }
                            }
                    }
                    else{
                        console.log('email check in invite');
                        helper.checkUserName(component, event, helper); 
                    }
                }
            }else{
                component.find("emailId").setCustomValidity(""); 
                component.find("emailId").reportValidity();
                component.set("v.isInviteButtonDisable", true);
            }
    },
    inviteClick: function(component, event, helper) { // savedetails modified
         console.log('@@@-inviteClick-------');
         var emailId = component.get("v.Email");
         var careteamId = component.get("v.careTeamId");
        /* save email into Careteam object and open sing auth popup */
        var action = component.get('c.updateEmailonCT');
        action.setParams({
                "careTeamId": careteamId,
                "emailId": emailId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('-------state----'+state);
                if(state == "SUCCESS"){
                    /* redirect to sign auth component */
                    helper.roiEventFire(component, event, helper);
                }else{                    
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/error"
                    });
                    urlEvent.fire(); 
                }
            });
       $A.enqueueAction(action);
        /* open sing auth popup */
        /* var persnaccId = component.get("v.careTeamMembId");
         var persnaccfrstname = component.get("v.careTeamMembfrstName");
         var persnacclstname = component.get("v.careTeamMemblstName");
         var action = component.get('c.createCommunityUser');
            action.setParams({
                "careTeamId": careteamId,
                "persnAccId": persnaccId,
                "persnAccfrstname": persnaccfrstname,
                "persnAcclstname": persnacclstname,
                "emailId": emailId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('-------state----'+state);
                if(state == "SUCCESS"){
                    var evt = $A.get("e.c:SNI_FL_RefreshCmp");
                    evt.setParams({ 
                        "isRefresh" : true
                    });
                    evt.fire();
                    component.destroy();
                }else{                    
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/error"
                    });
                    urlEvent.fire(); 
                }
            });
       $A.enqueueAction(action); */
    },
    nextClick: function(component, event, helper) { // new method
        var careteamId = component.get("v.ctMemDataIndex");
       helper.roiEventFire(component, event, helper);
       
    },
    resendInviteClick: function(component, event, helper) { // editInvite function name change
        console.log('-------editInvite-------');
        var careteamId = component.get("v.careTeamId");
         var emailId = component.get("v.Email");
         var userobj = component.get("v.User");
         var action = component.get('c.resendInvite');
            action.setParams({
                "careTeamId": careteamId,
                "emailId": emailId,
                "userdetail": userobj
            });
            action.setCallback(this, function(response) {
                var state = response.getState();                
                console.log('-------state----'+state);
                if(state == "SUCCESS"){
                    var evt = $A.get("e.c:SNI_FL_RefreshCmp");
                    evt.setParams({ 
                        "isRefresh" : true
                    });
                    
                    evt.fire();
                    component.destroy();
                }else{                    
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/error"
                    });
                    urlEvent.fire(); 
                }
            });
       $A.enqueueAction(action);
    }
})