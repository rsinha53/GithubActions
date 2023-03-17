({
    updateChangePassword : function(component, event, helper) {
        var newpasswordref = '';
        var newpasswordconfirmref = '';
        var oldpasswordref = '';
        
        if (component.get("v.showHSID")==false) {
        newpasswordref = component.find("newPassword").get("v.value");
        newpasswordconfirmref = component.find("verfyPassword").get("v.value");
        oldpasswordref = component.find("OldPassword").get("v.value");
        }
        var action = component.get('c.getchangePassword');
        action.setParams({
            "newPassword": newpasswordref,
            "verifyNewPassword": newpasswordconfirmref,
            "oldPassword": oldpasswordref
        });
        
        action.setCallback(this, function(response) {
            component.set('v.showerror',false);
            var state = response.getState();
            if(state == "SUCCESS"){
                var msg = response.getReturnValue();
                if(!$A.util.isEmpty(msg) && msg=="SUCCESS"){
                    component.set('v.showerror',false);                
                    component.find("OldPassword").set("v.value",'');
                    component.find("newPassword").set("v.value",'');
                    component.find("verfyPassword").set("v.value",'');
                    component.set("v.PasswordUpdate",false);
                    component.set("v.NotificationPreferenceUpdate",false);
                    $A.util.removeClass(component.find('saveMessage'), 'Saved-Message');
                    $A.util.addClass(component.find('saveMessage'),'Saved-MessageDisplay');
                }else{
                    component.set('v.paswderrors', msg);
                    component.set('v.showerror',true);    
                    var dskTop = document.getElementsByClassName("accountsettingcls");
                    if(dskTop.length >0){
                        dskTop[0].scrollIntoView();
                    }    
                }
            } else if (state =="ERROR"){
                var message = '';
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {   
                        var msg = errors[i].message;
                        
                        if(msg.indexOf("old password is invalid") >= 0){
                            msg="Invalid password. Please enter correct password to proceed.";
                        }else{
                            msg = errors[i].message;
                        }
                        message += (message.length > 0 ? '\n' : '') + msg;
                    }
                }
                console.log('----message----'+message);
                component.set('v.paswderrors',message);
                component.set('v.showerror',true);
                var dskTop = document.getElementsByClassName("accountsettingcls");
                if(dskTop.length >0){
                    dskTop[0].scrollIntoView();
                }               
            }
        });
        
        $A.enqueueAction(action);
    },
    updatePreferences : function(component, event, helper){
        var userDetails = component.get("v.user");
        var phoneCheckBox = component.get('v.phoneCheck');
        var emailCheckBox =component.get('v.emailCheck');
        var oldpasswordref = '';
        if (component.get("v.showHSID")==false) {
        oldpasswordref = component.find("OldPassword").get("v.value");
        }
        var pwdChange = component.get("v.PasswordUpdate");
        var action = component.get('c.saveUserDetails');
        action.setParams({
            "userDetails": userDetails,
            "currentPassword" :oldpasswordref
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('getAccountDetail----state---'+state);
            if (state == "SUCCESS") {
                console.log('getAccountDetail----Account---'+response.getReturnValue());
                var responseVal = response.getReturnValue();
                if(responseVal.usermsg == 'success'){
                    component.set('v.user', responseVal.userobj);
                    if(pwdChange){
                        this.updateChangePassword(component, event);
                    }else{
                        $A.util.removeClass(component.find('saveMessage'), 'Saved-Message');
                        $A.util.addClass(component.find('saveMessage'),'Saved-MessageDisplay');    
                        component.find("OldPassword").set("v.value",'');
                        component.set("v.NotificationPreferenceUpdate",false);
                        $A.get('e.force:refreshView').fire();
                    }
                }
                else if(responseVal.usermsg == 'Duplicate UserName'){
                    component.set("v.showEmailError",true);
                    component.set("v.paswderrors",'This email is already in use, please enter another email to proceed.');
                    var dskTop = document.getElementsByClassName("accountsettingcls");
                    if(dskTop.length >0){
                        dskTop[0].scrollIntoView();
                    }
                }
                    else if(responseVal.authmsg == 'authError'){
                        component.set("v.showerror", true);
                        component.set("v.paswderrors", 'Invalid password. Please enter correct password to proceed.');
                        var dskTop = document.getElementsByClassName("accountsettingcls");
                        if(dskTop.length >0){
                            dskTop[0].scrollIntoView();
                        } 
                    }
                        else {
                            component.set("v.showUnexpectedError",true);
                            component.set("v.paswderrors", 'Unexpected error occurred. Please try again. If problem persists contact help desk.');
                            var dskTop = document.getElementsByClassName("accountsettingtop");
                            if(dskTop.length >0){
                                dskTop[0].scrollIntoView();
                            } 
                        }
            }
            else{
                console.log('in state error');
                component.set("v.showUnexpectedError",true);
                component.set("v.paswderrors", 'Unexpected error occurred. Please try again. If problem persists contact help desk.');
                var dskTop = document.getElementsByClassName("accountsettingtop");
                if(dskTop.length >0){
                    dskTop[0].scrollIntoView();
                } 
            }
        });
        $A.enqueueAction(action);
    },
    updateAccountrec : function(component, event, helper, Notificatpref, pwdchange,emailCheckVal,phoneCheckVal, prevMobNumber) {
        var accDetails = component.get("v.Account");
        var isNotificatUpdate = Notificatpref;
        var isChngPwdUpdate = pwdchange;
		var oldpasswordvar = '';
        if (component.get("v.showHSID")==false) {
        oldpasswordvar = component.find("OldPassword").get("v.value");
        }
        var action = component.get('c.UpdateAccdetails'); 
        component.set("v.showAccError", false);
        component.set("v.accerrors",'');
        action.setParams({
            "accdetails": accDetails,
            "emailCheckVal": emailCheckVal,
            "phoneCheckVal": phoneCheckVal,
            "password":oldpasswordvar, //added for welcome msg
            "prevMobileNumber": prevMobNumber
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.showerror", false);
                console.log('udpdateAccount')
                if(isNotificatUpdate==false && isChngPwdUpdate==false){
                    component.set("v.NotificPrefCheckUpdate",false);
                    $A.util.removeClass(component.find('saveMessage'), 'Saved-Message');
                    $A.util.addClass(component.find('saveMessage'),'Saved-MessageDisplay');
                    $A.get('e.force:refreshView').fire();
                }
                
            }else if(state == "ERROR"){
                component.set("v.showerror", true);
                component.set("v.paswderrors", 'Invalid password. Please enter correct password to proceed.');
                
                // component.set("v.showAccError", true);
                component.set("v.accerrors", 'Notification Preferences Update Error: Please try again. If problem persists contact help desk.');
                var dskTop = document.getElementsByClassName("accountsettingtop");
                if(dskTop.length >0){
                    dskTop[0].scrollIntoView();
                } 
            }
            
        });
        $A.enqueueAction(action);
        
    }
})