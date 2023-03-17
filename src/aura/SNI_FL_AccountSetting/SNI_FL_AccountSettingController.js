({
    doInit : function(component, event, helper) {
        var action1 = component.get('c.getUserDetail');
        action1.setCallback(this, function(response) {
            var state = response.getState();
            
            
            if (state == "SUCCESS") {
                console.log('getAccountDetail----Account---'+response.getReturnValue());
                component.set('v.user', response.getReturnValue().userobj);
                component.set('v.Account', response.getReturnValue().accobj);
                var userobj = component.get('v.user');
                var accobj = component.get('v.Account');
                component.set('v.olduserphone', userobj.MobilePhone);                   
                component.set('v.olduserEmail', userobj.Email);
                component.set('v.oldphonecheck', accobj.Text_Message_SMS_Notification__c);
                component.set('v.oldemailcheck', accobj.Email_Notification__c);
                component.set('v.email', accobj.Email_Notification__c);                   
                component.set('v.txt', accobj.Text_Message_SMS_Notification__c);
                
               //start US3050350
                if(userobj.Profile.Name =='Family Link Provider User'){
                    component.set('v.CommunityUser', false);
                    
                }
                //end US3050350
          
            }
            
            
        });       
        // HSID Members/policy holders Reset password page 
        // 
        var action2 = component.get('c.HSIDmemUrls');
        action2.setCallback(this, function(response) {
            var state = response.getState();
            console.log('getAccountDetail----state---'+state);
            if (state == "SUCCESS" && response.getReturnValue()) {
                console.log('>>>>>>is member or not<<<<<<<'+response.getReturnValue());
                component.set('v.showHSID', response.getReturnValue());
               component.set('v.novalidation', response.getReturnValue());
            }
            
            
        });        
        $A.enqueueAction(action2);
        $A.enqueueAction(action1);
        
    },
    
    openPrivacyPolicy : function(component, event, helper) {
        window.open($A.get("$Label.c.DigitalOnboarding_Privacy_Policy"), '_blank'); 
        // component.set("v.displayPrivacyPolicy",true);
    },
    openTerms : function(component, event, helper) {
        window.open($A.get("$Label.c.DigitalOnboarding_Terms_Of_Use"), '_blank');
        //component.set("v.displayTerms",true);
    },
    onSave : function(component, event, helper) {
        $A.util.removeClass(component.find('saveMessage'),'Saved-MessageDisplay');
        $A.util.addClass(component.find('saveMessage'), 'Saved-Message');
        var pwdChange = component.get("v.PasswordUpdate");
        var preferenceUpdate = component.get("v.NotificationPreferenceUpdate");
        var isoldpasswrdvalid = false;
        var isAllvalid = true;
        var currntpasswrd = '' ;
        if (component.get("v.showHSID")==false) {
        currntpasswrd = component.find("OldPassword").get("v.value");
        }
        var phoneUpdate = component.get("v.phoneUpdate");        
        var emailUpdate = component.get("v.emailUpdate");
        var phoneCheck = component.get("v.phoneCheck");        
        var emailCheck = component.get("v.emailCheck");
        var phoneCheckVal = component.get("v.txt");
        var prevMobNumber = component.get("v.olduserphone");
        var emailCheckVal = component.get("v.email");
        var NotificPrefCheckUpdate = component.get("v.NotificPrefCheckUpdate");  
        var savebtn = component.get("v.showEmailError");
        var noValidt = component.get("v.novalidation");
        
        if ((pwdChange || preferenceUpdate) && (noValidt == false)) { 
            if($A.util.isEmpty(currntpasswrd)){
                component.find("OldPassword").setCustomValidity("Enter Current Password to proceed"); 
                isAllvalid = false;     
            }
            else{
                component.find("OldPassword").setCustomValidity("");      
            }
            component.find("OldPassword").reportValidity();            
        }if(phoneUpdate || (phoneCheck==true && phoneCheckVal==true)){
            var userphone = component.get("v.olduserphone");
            var cellphnCmp = component.find('cellPhnId');
            var trimNum  = cellphnCmp.get('v.value');
            if(($A.util.isEmpty(trimNum) && !$A.util.isEmpty(userphone))|| ($A.util.isEmpty(trimNum) && (phoneCheck==true && phoneCheckVal==true))){
                component.find("cellPhnId").setCustomValidity('Phone Number cannot be blank');
                isAllvalid = false;
            }else{
                component.find("cellPhnId").setCustomValidity("");
                if(trimNum){
                    trimNum = trimNum.replace(/\D/g, '')
                    if(trimNum.length > 10){
                        trimNum = trimNum.substring(0,10);
                    }
                    if(trimNum.length == 10){
                        var fortdBNum = trimNum.match(/^(\d{3})(\d{3})(\d{4})$/);
                        if (fortdBNum) {
                            fortdBNum = '(' + fortdBNum[1] + ') ' + fortdBNum[2] + '-' + fortdBNum[3];
                        }
                        cellphnCmp.set('v.value',fortdBNum);
                        cellphnCmp.setCustomValidity("");
                    }
                    else if(trimNum.length < 10){
                        cellphnCmp.setCustomValidity('Phone Number must be 10 digit number');
                        isAllvalid = false;
                    }
                }     
            }                             
            component.find("cellPhnId").reportValidity();
        }
        if(emailUpdate || (emailCheck==true && emailCheckVal==true)){
            var emailField = component.find("emailId").get("v.value");
            if($A.util.isEmpty(emailField)){
                component.find("emailId").setCustomValidity('Email cannot be blank');
                isAllvalid = false;
                var dskTop = document.getElementsByClassName("accountsettingtop");
                if(dskTop.length >0){                                
                    dskTop[0].scrollIntoView();
                } 
                
            }else{
                component.find("emailId").setCustomValidity("");
                var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;                      
                if(!emailField.match(regExpEmailformat)){
                    component.find("emailId").setCustomValidity('Please enter a valid Email');          
                    isAllvalid = false;
                    var dskTop = document.getElementsByClassName("accountsettingtop");
                    if(dskTop.length >0){                               
                        dskTop[0].scrollIntoView();
                    } 
                    
                }else{
                    component.find("emailId").setCustomValidity("");                     
                }          
            }
            component.find("emailId").reportValidity(); 
        }            
        if(isAllvalid == true && pwdChange && !preferenceUpdate){
            helper.updateChangePassword(component, event, helper);
        }
        if(isAllvalid == true && preferenceUpdate && !pwdChange){
           helper.updatePreferences(component, event, helper);
        }
        if(isAllvalid == true && pwdChange && preferenceUpdate) { 
            helper.updatePreferences(component, event, helper);
        }
        //if(isAllvalid == true && NotificPrefCheckUpdate==true  )
        //if(isAllvalid == true && (NotificPrefCheckUpdate==true || phoneCheckVal) && savebtn == false){
        if(isAllvalid == true && (NotificPrefCheckUpdate==true || phoneCheckVal)){ 
			helper.updateAccountrec(component, event, helper, preferenceUpdate, pwdChange, emailCheckVal, phoneCheckVal, prevMobNumber);
        } 
        
    },
    onChangefields : function(component, event, helper) {  
        console.log('onchange method ?>>>'+event.getSource().getLocalId());
        component.set("v.showEmailError",false);
        component.set("v.showUnexpectedError",false);
        component.set("v.showAccError", false);
        console.log('idd---162'+event.getSource().getLocalId());
        if (component.get("v.showHSID")==false) {
            var newpasswrd = component.find("newPassword").get("v.value");
            var verfypasswrd = component.find("verfyPassword").get("v.value");
        }
        console.log('idd---'+verfypasswrd);
        var phonecheck = component.get("v.txt");        
        var emailcheck = component.get("v.email");      
        var olduserph = component.get("v.olduserphone").trim();
        var olduseremail = component.get("v.olduserEmail").trim();
        var oldphcheck = component.get("v.oldphonecheck");
        var oldemailcheck = component.get("v.oldemailcheck");
        var prevMobNumber = component.get("v.olduserphone");
        var id = event.getSource().getLocalId();
        console.log('idd---'+id);
      	if(id == 'emailId' || id == 'cellPhnId'){ 
            component.set("v.NotificationPreferenceUpdate",true);           
        }
       
        if(id == 'newPassword' || id == 'verfyPassword'){
            component.set("v.showerror", false);
            if(!$A.util.isEmpty(newpasswrd) || !$A.util.isEmpty(verfypasswrd)){
                component.set("v.PasswordUpdate",true);      
                component.set("v.isSaveButtonActive",false);
            }else{
                component.set("v.PasswordUpdate",false);      
                component.set("v.isSaveButtonActive",true);
            }
        }
        if(id == 'cellPhnId'){
            component.find("cellPhnId").setCustomValidity("");
            component.find("cellPhnId").reportValidity(); 
            var comp = component.find('cellPhnId');
            var trimNum  = comp.get('v.value').trim();
            if(trimNum.length > 0){
                trimNum = trimNum.replace(/\D/g, '')
            }
            if(trimNum.length > 10){
                trimNum = trimNum.substring(0,10);
            }
            if(trimNum.length == 10){
                var fortdBNum = trimNum.match(/^(\d{3})(\d{3})(\d{4})$/);
                if (fortdBNum) {
                    fortdBNum = '(' + fortdBNum[1] + ') ' + fortdBNum[2] + '-' + fortdBNum[3];
                }
                comp.set('v.value',fortdBNum);
            }
            else{
                comp.set('v.value',trimNum);
            }
            if(trimNum && fortdBNum == olduserph){
                component.set("v.phoneUpdate",false);
                component.set("v.isSaveButtonActive",true);
            }
            /*  else if(trimNum || ($A.util.isEmpty(trimNum) && !$A.util.isEmpty(olduserph))){
                component.set("v.phoneUpdate",true);
                component.set("v.isSaveButtonActive",false);
                alert('phoneUpdate1');
            }*/
            else if(trimNum && fortdBNum!=olduserph){
                component.set("v.phoneUpdate",true);
                component.set("v.isSaveButtonActive",false);
            }
            
        }
        console.log('getIdDetail----state---'+id);
        if(id == 'emailId'){  
            
            var emailField = component.find("emailId").get("v.value").trim().toLowerCase();
            console.log('getEmailDetail----state---'+emailField);
            if(emailField && emailField == olduseremail){
                component.set("v.emailUpdate",false);
                component.set("v.isSaveButtonActive",true);
                
            }
            if($A.util.isEmpty(emailField)){
                component.set("v.emailUpdate",true);
                component.set("v.isSaveButtonActive",false); 
            }if(emailField && emailField != olduseremail){
                component.set("v.emailUpdate",true);
                component.set("v.isSaveButtonActive",false); 
            }
            component.find("emailId").setCustomValidity("");
            component.find("emailId").reportValidity(); 
        }if(id == 'OldPassword'){
            component.set("v.showerror", false);
            component.find("OldPassword").setCustomValidity("");
            component.find("OldPassword").reportValidity(); 
        }if(id == 'phoneCheckId' || id == 'emailCheckId'){
            component.set("v.NotificPrefCheckUpdate",true);  
        }if(id == 'phoneCheckId'){
            
            if(phonecheck == oldphcheck){
                component.set("v.phoneCheck",false);
                component.set("v.isSaveButtonActive",true);
            }else{
                component.set("v.phoneCheck",true);
                component.set("v.isSaveButtonActive",false);
            }
            
        }if(id == 'emailCheckId'){
            if(emailcheck == oldemailcheck){
                component.set("v.emailCheck",false);  
                component.set("v.isSaveButtonActive",true);
            }else{
                component.set("v.emailCheck",true);
                component.set("v.isSaveButtonActive",false);
            }            
        }
        var pwdChange = component.get("v.PasswordUpdate");
        var phUpdate = component.get("v.phoneUpdate");
        var emailUpdate = component.get("v.emailUpdate");
        var phcheckUpdate = component.get("v.phoneCheck");
        var emailcheckUpdate = component.get("v.emailCheck");
        if(pwdChange || phUpdate == prevMobNumber || emailUpdate || phcheckUpdate || emailcheckUpdate ){
            component.set("v.isSaveButtonActive",false);
        }
        var savebtn = component.get("v.isSaveButtonActive");
        if(savebtn){
            component.find("OldPassword").setCustomValidity("");
            component.find("OldPassword").reportValidity();
        }
    },
    warnDelete: function(component, event, helper) {
        component.set("v.isDeleteModalOpen", true);
    },
    handleClick: function(component, event, helper) {
        /*var urlEvent = $A.get("$Label.c.Change_Password_URL");
        var win = window.open(urlEvent, "_self");*/
        
        /*( added Feature flag for Reset Password/ Ravikumar M ) */
        
        var action = component.get("c.getCustMetaData");
        action.setCallback(this, function(response){          
            if(response.getReturnValue()==false){
                window.open($A.get("$Label.c.Change_Password_URL"),'_self');   
            }
            
        });
        var action2 = component.get('c.HSIDmemUrls');
        action2.setCallback(this, function(response) {
            var state = response.getState();
            console.log('getAccountDetail----state---'+state);
            if (state == "SUCCESS") {
                console.log('>>>>>>is member or not<<<<<<<'+response.getReturnValue());
                component.set('v.showHSID', false);
                
            }
            
        
            
        });        
        $A.enqueueAction(action2);
        $A.enqueueAction(action);
    }
})