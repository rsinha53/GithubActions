({
    doInitHelper : function(component, event, helper) {
        
    },
    onSubmit : function(component, event, helper){
       	    var action1 = component.get('c.verificationCodeGeneration');
         			action1.setParams({
             			phoneNumber : component.get("v.phoneNumber"),
           				emailId :component.get('v.emailAddress'),
                        emailCheckBox : component.get('v.emailCheck'),
                        smsCheckBox : component.get('v.SMS')
                    });
               action1.setCallback(this, function(response) {
               var state = response.getState();
                   if (state == "SUCCESS") {
                      component.set('v.startTime',response.getReturnValue().startTime);
                     component.set('v.OTPcode',response.getReturnValue().randomNumber);
               }
            });
            $A.enqueueAction(action1);
        	var action2 = component.get('c.setNotificationPreferences');
            action2.setParams({
                emailcheck : component.get("v.futureEmail"),
                phcheck : component.get("v.futureSMS"),
                personAccountId : component.get("v.personAccountId")
            });
            action2.setCallback(this, function(response){
                var state = response.getState();
            });
            $A.enqueueAction(action2);
         },
    checkActiveSubmit : function(component, event, helper){
        let email = component.find("email").get("v.value");
        let password = component.find("password").get("v.value");
        let conpassword = component.find("conpassword").get("v.value");
        let phonenum = component.find("phonenum").get("v.value");
        var myCheck = event.getSource().get('v.checked');
        var isChecked = event.getSource().get('v.value');
        var id = event.getSource().getLocalId();
        if(id == 'phonenum'){ 
            var comp = component.find('phonenum');
            var trimNum  = comp.get('v.value').trim();
            if(trimNum.length > 0){
                trimNum = trimNum.replace(/\D/g, '');
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
            }
        }
        if(myCheck == true && isChecked =='terms'){
            component.set('v.isChecked',true);
        }else if(myCheck == true && isChecked =='Email'){
            component.set('v.emailCheck',true);
            component.set('v.SMS',false);
            component.find("SMS").set("v.checked",false);
            component.set('v.showNotificationError',false);
        }else if(myCheck == true && isChecked =='SMS'){
            component.set('v.SMS',true);
            component.set('v.emailCheck',false);
            component.find("emailCheck").set("v.checked",false);
            component.set('v.showNotificationError',false);
        }else if(myCheck == false && isChecked =='Email'){
            component.set('v.emailCheck',false);
        }else if(myCheck == false && isChecked =='SMS'){
            component.set('v.SMS',false);
        }else if(myCheck == false && isChecked =='terms'){
            component.set('v.isChecked',false); 
        }else if(myCheck == true && isChecked =='futureEmail'){
            component.set('v.futureEmail',true); 
            component.set('v.showFutureNotificationError',false);
        }else if(myCheck == false && isChecked =='futureEmail'){
            component.set('v.futureEmail',false); 
        }else if(myCheck == true && isChecked =='futureSMS'){
            component.set('v.futureSMS',true); 
            component.set('v.showFutureNotificationError',false);
        }else if(myCheck == false && isChecked =='futureSMS'){
            component.set('v.futureSMS',false); 
        }
        let termscheck = component.get("v.isChecked");
        let emailCheck = component.get("v.emailCheck");
        let smsCheck = component.get("v.SMS");
        let futureEmailCheck = component.get("v.futureEmail");
        let futureSmsCheck = component.get("v.futureSMS");
        phonenum = component.find("phonenum").get("v.value");
        if(email != null && email != "" && password != null && password != "" && conpassword != null && conpassword != "" && password == conpassword 
           && phonenum != null && phonenum.length == 14 && termscheck == true && (emailCheck == true || smsCheck == true) && (futureEmailCheck == true || futureSmsCheck == true)){
            if(component.find('email').reportValidity() && component.find('password').reportValidity() && component.find('conpassword').reportValidity() && component.find('phonenum').reportValidity()){
            	component.set('v.isSubmit',false); 
            } else {
                component.set('v.isSubmit',true); 
            }
        }else{
            component.set('v.isSubmit',true);  
        }       
    },
    confirmCheckPassword : function(component, event, helper){
        let password = component.find("password").get("v.value");
        let conpassword = component.find("conpassword").get("v.value");
        if(conpassword != null && conpassword != ""){
            if(password != conpassword){
                component.find('conpassword').setCustomValidity('Please confirm the passwords match and try again.');
                component.find("conpassword").reportValidity();
            }
            else{
                component.find('conpassword').setCustomValidity('');
                component.find("conpassword").reportValidity();
            }
        }
        this.checkActiveSubmit(component, event);
    },
    
    getOrgCode : function(component, event, helper){
        var action2 = component.get('c.getOrgName');
        action2.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var returnCode = response.getReturnValue();
                if(returnCode != 'false' && returnCode != null){
                    component.set('v.orgCode', returnCode);
                }
            }
        });
        $A.enqueueAction(action2);
    }
})