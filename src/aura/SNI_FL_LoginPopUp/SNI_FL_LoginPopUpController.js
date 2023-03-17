({
    myAction : function(component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "MM/DD/YYYY");
        component.set('v.today', today);
        component.set('v.disbleCell', true);
        let currentUrl = window.location.href;
        if(currentUrl.includes('settings')){
            component.set('v.isSettingUrl', true);
            console.log('isSettingUrl---?>',component.set('v.isSettingUrl'));
        }
        var action1 = component.get('c.getLoginUserName');
        action1.setCallback(this, function(response) {
            var state = response.getState();
            console.log('getLoginUserName----state---'+state);
            if (state == "SUCCESS") {
                //console.log('getLoginUserName----username---'+response.getReturnValue());
                var result=response.getReturnValue()
                component.set('v.loginName', result.Name);
                if(result.Profile.Name =='Family Link Provider User'){
                component.set('v.ProviderUser', true);
                }else{
                component.set('v.CommunityUser', true);    
                }
                  
            }else{
                component.set('v.CommunityUser', true);    
            }
        });
        $A.enqueueAction(action1);

        var action2 = component.get('c.isMemLoginFirstTime');
        action2.setCallback(this, function(response1) {
            var state1 = response1.getState();
            if (state1 == "SUCCESS") {
                console.log('response--->',response1.getReturnValue());
                if(response1.getReturnValue() == 'true'){
                    component.set('v.isMemLoginFirstTime','true');
                     console.log('isMemLoginFirstTime--->',component.get('v.isMemLoginFirstTime'));
                    var homePageGreyOut = document.getElementsByClassName("SNI_FL_HomeId"); //cSNI_FL_Home
                    for (var i=0; i<homePageGreyOut.length; i++) {
                        $A.util.addClass(homePageGreyOut[i], 'SNI_FL_HomeGreyOut');
                    }

                }
                
                if(response1.getReturnValue() == 'trueDigitalOnboarding'){
                    console.log('inside second if--->',response1.getReturnValue());
                    component.set('v.isDigitalOnboarding','true');
                    console.log('digital onboarding--->',component.get('v.isDigitalOnboarding'));
                    
                }
            }
        });
        $A.enqueueAction(action2);
     },
    saveChanges: function(component, event, helper) {
        var cellNum = component.get('v.cellNum');
        var txt = component.get('v.txt');
        var CommunityUser = component.get('v.CommunityUser');
        var email = component.get('v.email');
        var fullName = component.get('v.fullName');
        var loginName = component.get('v.loginName');
       console.log('cellNum----'+cellNum);
        var isValid = true;
        var prefMeth ;
        var isDesktop = false;

        //var x = document.getElementById("desktopviewId");
        var dskTop = document.getElementsByClassName("desktopview");
        if( window.getComputedStyle(dskTop[0]).display == 'block'){
            isDesktop = true;
        }
		if(! isDesktop){
            var dskTop = document.getElementsByClassName("notificnCls");
            if(dskTop.length >0){
                dskTop[0].scrollIntoView();
            }
        }
        var emailCmp = isDesktop ? component.find('emailDId'): component.find('emailId');
        if(! email && ! txt){
			//DE407905 start
            var userCheck = component.get("v.ProviderUser");
            if(userCheck)
            {
			isValid = false;
            emailCmp.setCustomValidity("Email is mandatory.");  
            }
            else
            {
            emailCmp.setCustomValidity("Email or Text is mandatory.");
            isValid = false;
            }
			//DE407905 end
        }
        else{
            emailCmp.setCustomValidity("");
        }
        emailCmp.reportValidity();
        if(CommunityUser){
        // var cellphnCmp = component.find('cellPhnDId');
        var cellphnCmp = isDesktop ? component.find('cellPhnDId'): component.find('cellPhnId');
        // var cellphnCmp = x == 'block' ? component.find('cellPhnDId'): component.find('cellPhnId');
        if(txt){
            if( $A.util.isEmpty(cellNum) ){
                cellphnCmp.setCustomValidity("Cell Phone Number cannot be blank.");
                isValid = false;
            }
            else{
                //var trimNum  = component.find("cellPhnDId").get('v.value');
                var trimNum  = cellphnCmp.get('v.value');
                trimNum = trimNum.replace(/\D/g, '')
                if(trimNum.length > 10){
                    trimNum = trimNum.substring(0,10);
                }
                // console.log('save changes---trimNum-----'+trimNum.length);
                if(trimNum.length == 10){
                    var fortdBNum = trimNum.match(/^(\d{3})(\d{3})(\d{4})$/);
                    if (fortdBNum) {
                        fortdBNum = '(' + fortdBNum[1] + ') ' + fortdBNum[2] + '-' + fortdBNum[3];
                    }
                    cellphnCmp.set('v.value',fortdBNum);
                    cellphnCmp.setCustomValidity("");
                }
                else if(trimNum.length < 10){
                    // console.log('save changes---trimNum len-----'+trimNum.length);
                    cellphnCmp.setCustomValidity('Cell Phone Number must be 10 digit number.');
                    isValid = false;
                }


            }
        }
        cellphnCmp.reportValidity();
        }
        //var fullNamCmp = component.find('fullNameDId');
        var fullNamCmp = isDesktop ? component.find('fullNameDId'): component.find('fullNameId');
        if($A.util.isEmpty(fullName)){
            fullNamCmp.setCustomValidity("Signature cannot be blank.");
            isValid = false;
        }
        else if(fullName != loginName ){
            fullNamCmp.setCustomValidity("Signature does not match.");
            isValid = false;
        }
            else{
                fullNamCmp.setCustomValidity("");
            }

        fullNamCmp.reportValidity();

        if(isValid){

            /*if(email){
                if(! txt)
                    prefMeth = 'Email';
                else
                    prefMeth = 'Email;Phone';
            }
            else if (txt){
                prefMeth = 'Phone';
            }*/
            var action1 = component.get('c.savePAccountDetails');
            action1.setParams({
                "emailcheck": email,
                "phcheck": txt,
                "phn": cellNum

            })
            action1.setCallback(this, function(response) {
                var state = response.getState();                
                if (state == "SUCCESS") {                    
                    if(txt){
                        	var action2 = component.get('c.saveUserDetails');
                            action2.setParams({
                                "phn": cellNum                
                            })
                            action2.setCallback(this, function(response) {
                                var status = response.getState();
                                if (status == "SUCCESS") {
                                    var homePageGreyOut = document.getElementsByClassName("SNI_FL_HomeId"); 
                                        for (var i=0; i<homePageGreyOut.length; i++) {
                                            $A.util.removeClass(homePageGreyOut[i], 'SNI_FL_HomeGreyOut');
                                        }
                                    debugger;
                                    component.destroy();
                                    $A.get('e.force:refreshView').fire();
                                }
                            });
                        $A.enqueueAction(action2);
                    }else{
                        var homePageGreyOut = document.getElementsByClassName("SNI_FL_HomeId"); 
                        for (var i=0; i<homePageGreyOut.length; i++) {
                            $A.util.removeClass(homePageGreyOut[i], 'SNI_FL_HomeGreyOut');
                        }
                        debugger;
                        component.destroy();
                        $A.get('e.force:refreshView').fire();
                    }
                }
            });
            $A.enqueueAction(action1);
            
            //sending welcome msg//
          /* if(cellNum){
                var actionWelcome = component.get("c.sendMsgNotification");
                actionWelcome.setCallback(this, function(resp){
                    var state = resp.getState();
                });
                $A.enqueueAction(actionWelcome);
            }*/
        }

    },
    CheckLength : function(component, event, helper) {
        // alert('CheckLength change');
        var isDesktop = false;
        var dskTop = document.getElementsByClassName("desktopview");
        if( window.getComputedStyle(dskTop[0]).display == 'block'){
            isDesktop = true;
        }
        var comp = isDesktop ? component.find('cellPhnDId'): component.find('cellPhnId');
        var trimNum  = comp.get('v.value');
        if(trimNum.length > 0){
            trimNum = trimNum.replace(/\D/g, '')
        }

        if(trimNum.length > 10){
            trimNum = trimNum.substring(0,10);
        }

        //console.log('trimNum--33---'+trimNum);
        if(trimNum.length == 10){
            var fortdBNum = trimNum.match(/^(\d{3})(\d{3})(\d{4})$/);
            //console.log('fortdBNum fortdBNum 11-----'+fortdBNum);
            if (fortdBNum) {
                fortdBNum = '(' + fortdBNum[1] + ') ' + fortdBNum[2] + '-' + fortdBNum[3];
            }
            //console.log('fortdBNum-----'+fortdBNum);
            comp.set('v.value',fortdBNum);
        }
        else{
            comp.set('v.value',trimNum);
        }
    },
    txtChange: function (component, event, helper) {

        var txt = component.get('v.txt');
        if(txt){
            component.set('v.disbleCell', false);
        }
        else{
            component.set('v.cellNum','');
            component.set('v.disbleCell', true);

        }
        var isDesktop = false;
        var dskTop = document.getElementsByClassName("desktopview");
        if( window.getComputedStyle(dskTop[0]).display == 'block'){
            isDesktop = true;
        }
        var cellphnCmp = isDesktop ? component.find('cellPhnDId'): component.find('cellPhnId');
        cellphnCmp.setCustomValidity("");
        cellphnCmp.reportValidity();
        var emailCmp = isDesktop ? component.find('emailDId'): component.find('emailId');
        emailCmp.setCustomValidity("");
        emailCmp.reportValidity();
    },
    mailChange: function (component, event, helper) {


        var isDesktop = false;
        var dskTop = document.getElementsByClassName("desktopview");
        if( window.getComputedStyle(dskTop[0]).display == 'block'){
            isDesktop = true;
        }
        var emailCmp = isDesktop ? component.find('emailDId'): component.find('emailId');
        emailCmp.setCustomValidity("");
        emailCmp.reportValidity();
    },
    handleOpenModal: function handleOpenModal(cmp) {
        //cmp.set('v.isModalOpen', true);
    },

    handleCloseModal: function handleOpenModal(cmp) {
        // cmp.set('v.isModalOpen', false);
    }
})