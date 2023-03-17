({
    doInit : function(component, event, helper) {
        
       /* var url = $A.get('$Resource.SNI_FL_backgroundImage_min');
        console.log('url-'+url);
        component.set('v.backgroundImageURL', url);*/
        component.set('v.isRegister',true);
        window.scrollTo(0,0);
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
        helper.getOrgCode(component, event, helper);
    },
    activeContinue : function(component, event, helper){
        let memId = component.find("memId").get("v.value");
        let policyId = component.find("polId").get("v.value");
        let fName = component.find("fName").get("v.value");
        let lName = component.find("lName").get("v.value");  
        var regExpMemId = /^[0-9]+$/;
        if(!regExpMemId.test(memId) && memId !== null && memId !== '') {
            component.find('memId').setCustomValidity('Please enter a numeric value for Member ID.');
        } else {
            component.find('memId').setCustomValidity('');
        }
        var regExpPolId = /^[a-z0-9]+$/i;
        if(!regExpPolId.test(policyId) && policyId !== null && policyId !== '') {
            component.find('polId').setCustomValidity('Please enter valid Policy ID.');
        } else {
            component.find('polId').setCustomValidity('');
        }
        
        let dob = component.find("dob").get("v.value");
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var dateValue = component.get("v.dob");
        var dobdt = component.get('v.dob');
        let [year, month, day] = dobdt.split("-");
        var dobnew = new Date(year,month,day);
        var dt2 = new Date();
        var diff =(dt2.getTime() - dobnew.getTime()) / 1000;
        diff = diff/(60 * 60 * 24);
        var datecheck = Math.abs(Math.round(diff/365.25));
        if(dob > today){
            component.find('dob').setCustomValidity('Date cannot be in the future');
            dateValue = null;
            component.set("v.dob", dateValue);
        }else{
            component.find('dob').setCustomValidity('');
        }
        
        var continueBool = false;
        if (component.find('dob').reportValidity() && component.find('memId').reportValidity() && component.find('polId').reportValidity) {
            continueBool = true;
        }
        
       if (datecheck <= 13 && component.find('dob').reportValidity()) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'This member is under the age of 13, so they cannot be invited to Care Advisor Connect. Please choose another member.',   
                key: 'info_alt',
                type: 'error',
                mode: 'pester',
                duration:' 10000'
            });
            toastEvent.fire();
            $A.get('e.force:closeQuickAction').fire();
        } else if (continueBool && memId != null && memId != '' && policyId != null && policyId != '' && fName != null && fName != '' && lName != null && lName != '' && dob != null && dob != ''){         
            component.set('v.isContinue',false);
        } else {
            component.set('v.isContinue',true);
        }  
    },
    confirmCheck : function(component, event, helper){
        let conpassword = component.find("conpassword").get("v.value");
        if(conpassword == null || conpassword == "" || conpassword.length == 0){
            component.find('conpassword').setCustomValidity('Please enter a value in the Confirm Password field.');
            component.find("conpassword").reportValidity(); 
        }
        helper.confirmCheckPassword(component, event);
    },
    passCheck : function(component, event, helper){
        component.find('password').setCustomValidity('');
        component.find("password").reportValidity(); 
        let password = component.find("password").get("v.value");
        let conpassword = component.find("conpassword").get("v.value"); 
        if(password == null || password == "" || password.length == 0){
            component.find('password').setCustomValidity('Please enter a value in the Password field.');
            component.find("password").reportValidity(); 
        } else if(password){
            var passwordcheck = password.match('^(?=.*\\W)(?=.*[a-zA-Z])(?=.*\\d)(?=.*\\d).+$');
            //var passwordcheck = password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/);
            if(password.length < 8 || passwordcheck ==null || password.replace(/[^A-Z]/g,"").length == 0 || password.replace(/[^a-z]/g,"").length == 0){
                component.find('password').setCustomValidity('Passwords must contain 8 characters, including an uppercase and lowercase letter,  a number and a special character.');
            }
            else{
                component.find('password').setCustomValidity('');
            }
            component.find("password").reportValidity(); 
        }  
        helper.confirmCheckPassword(component, event);
    },
    onfocus : function(component, event, helper){
        let emailCheck = component.get("v.emailCheck");
        let smsCheck = component.get("v.SMS");
        let futureEmailCheck = component.get("v.futureEmail");
        let futureSmsCheck = component.get("v.futureSMS");
        if(emailCheck ==false && smsCheck==false){
            component.set('v.showNotificationError',true);
        }
        else{
            component.set('v.showNotificationError',false);
        }    
        if(futureEmailCheck ==false && futureSmsCheck==false){
            component.set('v.showFutureNotificationError',true);
        }
        else{
            component.set('v.showFutureNotificationError',false);
        }
    },
    checkPhoneLength: function(component, event, helper){
        var comp = component.find('phonenum');
        var trimNum  = comp.get('v.value').trim();
        component.find("phonenum").setCustomValidity("");
        component.find("phonenum").reportValidity();
        if(trimNum.length > 0 && trimNum.length < 10){
            component.find('phonenum').setCustomValidity('Please enter a valid 10 digit US Phone Number.');
			component.find("phonenum").reportValidity();
        }
        helper.checkActiveSubmit(component, event);
    },
    activeSubmit : function(component, event, helper){
        helper.checkActiveSubmit(component, event);     
    },
    onVerify: function(component, event, helper){
        let verify = component.find("verify").get("v.value");
        if(verify != null && verify != ''){
            component.set('v.isVerifyButton',false);
        }
        else{
            component.set('v.isVerifyButton',true);
        }      
    },
    handleContinue : function(component, event, helper) {
        component.set('v.isContinue',true);
        var memId = component.get('v.memberId');
        var policyId = component.get('v.policyId');
        var fName = component.get('v.firstName');
        var lName = component.get('v.lastName');
        var dob = component.get('v.dob');
        if((!$A.util.isEmpty(memId)) && (!$A.util.isEmpty(policyId)) && (!$A.util.isEmpty(fName)) && (!$A.util.isEmpty(lName)) && (!$A.util.isEmpty(dob))){
            //If all items are filled in, check eligibility
            var action = component.get('c.verifyUser');
            action.setParams({
                firstName : component.get('v.firstName'),
                lastName : component.get('v.lastName'),
                dob : component.get('v.dob'),
                memberId : component.get('v.memberId'),
                policyId : component.get('v.policyId')
            });
            action.setCallback(this, function(response) {
                var state = response.getState();    
                
                if (state == "SUCCESS") {
                    var result =response.getReturnValue();
                    if(result && result != 'Error' && result != 'Error-UserPresent') {
                        //If they are eligible, advance to next step
                        component.set('v.personAccountId', result);
                        var intCurrentStep = component.get('v.intCurrentStep');
                        component.set('v.intCurrentStep', intCurrentStep + 1);
                        component.set('v.isRegisterstep',true);
                        component.set('v.isRegister',false);
                    }else{
                        if(result == 'Error-UserPresent'){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                message: 'This user already exists, click {0} to login.',  
                                messageTemplate: 'This user already exists, click {0} to login.',
                                messageTemplateData: [{
                                    url: '/login',
                                    label: 'here',
                                }],
                                key: 'info_alt',
                                type: 'info',
                                mode: 'sticky'
                            });
                            toastEvent.fire();
                            $A.get('e.force:closeQuickAction').fire();
                        }else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                message: 'Further Assistance Required: Unfortunately, we cannot register your account at this time. Please call the number on the back of your Member ID card.',   
                                key: 'info_alt',
                                type: 'error',
                                mode: 'pester',
                                duration:' 10000'
                            });
                            toastEvent.fire();
                            $A.get('e.force:closeQuickAction').fire();
                        }
                    }
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'If you are having trouble, please call the number on the back of your insurance card.',   
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester',
                        duration:' 10000'
                    });
                    toastEvent.fire();
                    $A.get('e.force:closeQuickAction').fire();
                }
            });
            $A.enqueueAction(action);
            
        }else {
            component.find('memId').showHelpMessageIfInvalid();
            component.find('polId').showHelpMessageIfInvalid();
            component.find('fName').showHelpMessageIfInvalid();
            component.find('lName').showHelpMessageIfInvalid();
            component.find('dob').showHelpMessageIfInvalid();
            component.set('v.isRegisterstep',false);
            
        }
    },
    handleSubmit : function(component, event, helper) {
        var email = component.get('v.emailAddress');
        var password = component.get('v.password');
        var conpassword = component.get('v.confirmPassword');
        var phonenum = component.get('v.phoneNumber');
        var emailCheck = component.get('v.emailCheck');
        var SMS = component.get('v.SMS');
        
        if((!$A.util.isEmpty(email)) && (!$A.util.isEmpty(password)) && (!$A.util.isEmpty(conpassword)) && (!$A.util.isEmpty(phonenum)) && (emailCheck || SMS)){
            var action2 = component.get('c.emailInUse');
            action2.setParams({
                emailAddress : email
            });
            action2.setCallback(this, function(response) {
                var state = response.getState();    
                if (state == "SUCCESS") {
                    var result =response.getReturnValue();
                    if(result == false) {
                        component.set('v.isRegisterstep',false);
                        component.set('v.isRegister',false);
                        component.set('v.isVerify',true);
                        component.set('v.isVerifyelse',false);
                        helper.onSubmit(component, event, helper);
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message: 'This user already exists, click {0} to login.',  
                            messageTemplate: 'This user already exists, click {0} to login.',
                            messageTemplateData: [{
                                url: '/login',
                                label: 'here',
                            }],
                            key: 'info_alt',
                            type: 'info',
                            mode: 'sticky'
                        });
                        toastEvent.fire();
                        $A.get('e.force:closeQuickAction').fire();
                    }
                }
            });
            $A.enqueueAction(action2);
        } else {
            component.find('email').showHelpMessageIfInvalid();
            component.find('password').showHelpMessageIfInvalid();
            component.find('conpassword').showHelpMessageIfInvalid();
            component.find('phonenum').showHelpMessageIfInvalid();
            component.find('emailCheck').showHelpMessageIfInvalid();
            component.find('SMS').showHelpMessageIfInvalid();
        }
    },
    handleCancel : function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/"
        });
        urlEvent.fire();
        var urlEvent1 = $A.get('e.force:refreshView');
        urlEvent1.fire();
    },
    openPrivacyPolicy : function(component, event, helper) {
        var URL = $A.get("$Label.c.DigitalOnboarding_Privacy_Policy");
        var win = window.open(URL, "_blank");
    },
    openTerms : function(component, event, helper) {
        var URL = $A.get("$Label.c.DigitalOnboarding_Terms_Of_Use");
        var win = window.open(URL, "_blank");
    },
    /*openTextingTerms : function(component, event, helper) {
        var URL = $A.get("$Label.c.DigitalOnboarding_Texting_Terms_of_Use");
        var win = window.open(URL, "_blank");
    },*/
    onclickVerification : function(component, event, helper) {
        var firstName = component.get('v.firstName');
        var lastName = component.get('v.lastName');
        var dob = component.get('v.dob');
        var email = component.get('v.emailAddress');
        var phone = component.get('v.phoneNumber');
        var password = component.get('v.password');
        var futureSMS = component.get("v.futureSMS");
        var startTime = component.get('v.startTime');
        var OTPcode = component.get('v.OTPcode');
        var personAcct = component.get('v.personAccountId');
        var action = component.get('c.registerUser');
        let verify = component.find("verify").get("v.value");
        let orgCode = component.get('v.orgCode');
        if(OTPcode == verify || (orgCode != '' && orgCode != 'false' && orgCode == verify)){
            component.find('verify').setCustomValidity('');
            action.setParams({
                startTime:startTime,
                OTPcode:OTPcode,
                email: email,
                mobilePhone: phone,
                smsNotifications: futureSMS,
                dob: dob,
                userName:email,
                password: password,
                firstName:firstName,
                lastName: lastName,
                personAcctId: personAcct
            });
            action.setCallback(this, function(response) {
                var state = response.getState();           
                if (state == "SUCCESS") {
                    if(response.getReturnValue() =='Expired'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message: 'The verification code that you have entered has expired. Please click \'Resend Code\' to generate a new verification code.',   
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester',
                            duration:' 10000'
                        });
                        toastEvent.fire();
                        $A.get('e.force:closeQuickAction').fire();
                    } else if(response.getReturnValue() == 'Failed'){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message: 'Further Assistance Required: Unfortunately, we cannot register your account at this time. Please call the number on the back of your Member ID card.',   
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester',
                            duration:' 10000'
                        });
                        toastEvent.fire();
                        $A.get('e.force:closeQuickAction').fire();
                    }

                }
            });
            $A.enqueueAction(action);
        }
        else{ 
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'Please try again. If you are having issues, please click \'Resend Code\' to generate a new verification code.',   
                key: 'info_alt',
                type: 'error',
                mode: 'pester',
                duration:' 10000'
            });
            toastEvent.fire();
            $A.get('e.force:closeQuickAction').fire();
        }
        
    },
    
    handleResend : function (component, event, helper) {
        helper.onSubmit(component, event, helper);
        var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'New Verification Code Sent.',  
                //key: 'info_alt',
                key: 'check',
                type: 'info',
                mode: 'dismissible',
                duration:'5000'
            });
            toastEvent.fire();
            $A.get('e.force:closeQuickAction').fire();
    }
    
})