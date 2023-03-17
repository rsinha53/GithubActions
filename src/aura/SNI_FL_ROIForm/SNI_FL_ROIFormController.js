({
    myAction : function(component, event, helper) {
        //debugger;
        //console.log('inside init');
        var recId = component.get("v.recordId");
        if(recId != undefined && recId !=''){
            component.set("v.isViewAuth",true);
            //console.log('isViewAuth'+component.get("v.isViewAuth"));
        }
        helper.fetchRecords(component, event, helper);
    },
    closeWarning :function(component, event,helper){
        component.set("v.isSignAuth",false);
        component.set("v.isViewAuth",false);
        component.set("v.careTeamMemAdd",'');
        helper.refreshCareTeam(component, event,helper);
    },
    signROI : function(component, event, helper){
        debugger;
        var isInvited= component.get("v.isInvited");
        var action1 = component.get('c.SignAuthUpdate');
        var member = component.get("v.displayCareTeamId");
        var childCTMId= component.get("v.childCTMId");
        console.log('childCTMId='+childCTMId);
        if(childCTMId){
            member = childCTMId;
            console.log('Coming inside childCTMId');
        }
            
        var rOISignedWith= JSON.stringify(component.get("v.careTeamList"));
        
         action1.setParams({
            "ctmId" : member,
            "memberlist" : rOISignedWith,
             "isInvited": isInvited
             
        });
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                if(isInvited){
                      var ctmDoneList = component.get("v.ctmDoneList");
                      
                      var ctmDoneArray = [];
                      ctmDoneArray.push(member);
                      
                    if(ctmDoneList!=null && ctmDoneList.length>0){
                        for(var k=0;k<ctmDoneList.length;k++){
                          ctmDoneArray.push(ctmDoneList[k]);
                        }
                    }
                    
                      component.set("v.ctmDoneList", ctmDoneArray);
                      component.set("v.fullName","");
                      component.set("v.displayCTMName","");
                      component.set("v.selectedOption","SignElectronically");
                      component.set("v.mselectedOption","SignElectronically");
                      component.set("v.behaviourCheck",false);
                      component.set("v.mbehaviourCheck",false);
                      //component.set("v.displayCareTeamId","");
                      helper.reFetch(component, event, helper);
                }
                  else{
                     component.set("v.isSignAuth",false);
                     helper.refreshCareTeam(component, event,helper);
                     
                  }
                 
            }
        });
        $A.enqueueAction(action1);
    },
    enableSaveButton :function(component, event, helper){
        var emailField = component.get("v.emailId");
        var careTeamMemberName = component.get('v.displayCTMName');
        var isDesktop = false;
        var isValid = true;
		var dskTop = document.getElementsByClassName("desktopview");
        if( window.getComputedStyle(dskTop[0]).display == 'block'){
            isDesktop = true;
        }
        var fullNamCmp = isDesktop ? component.find('emailId'): component.find('memailId');
        if($A.util.isEmpty(emailField)){
            fullNamCmp.setCustomValidity("Email cannot be blank.");
            isValid = false;
        }
        else {
            fullNamCmp.setCustomValidity("");
                var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;                      
                  if(!emailField.match(regExpEmailformat)){
                     fullNamCmp.setCustomValidity('Please enter a valid Email');          
                	 isValid = false;
        	}
            else{
                fullNamCmp.setCustomValidity("");
            }
            
        }
        fullNamCmp.reportValidity();
     	if(isValid){
        var fullNamCmp = isDesktop ? component.find('saveButton'): component.find('msaveButton');
        $A.util.removeClass(fullNamCmp, 'BgColor');
        $A.util.addClass(fullNamCmp, 'BgColorEnable');
        component.set("v.disableSaveButton",false);
    	} 
        else {
           var fullNamCmp = isDesktop ? component.find('saveButton'): component.find('saveButton');
           component.set("v.disableSaveButton",true); 
           $A.util.removeClass(fullNamCmp, 'BgColorEnable');
           $A.util.addClass(fullNamCmp, 'BgColor');
        }
    },
    enableSignButton :function(component, event, helper){
        var fullName = component.get('v.fullName');
        var careTeamMemberName = component.get('v.displayCTMName');
        var isDesktop = false;
        var isValid = true;
		var dskTop = document.getElementsByClassName("desktopview");
        if( window.getComputedStyle(dskTop[0]).display == 'block'){
            isDesktop = true;
        }
        var fullNamCmp = isDesktop ? component.find('fullNameDId'): component.find('fullNameId');
        if($A.util.isEmpty(fullName)){
            fullNamCmp.setCustomValidity("Signature cannot be blank.");
            isValid = false;
        }
        else if(fullName != careTeamMemberName ){
            fullNamCmp.setCustomValidity("Signature does not match.");
            isValid = false;
        }
            else{
                fullNamCmp.setCustomValidity("");
            }

        fullNamCmp.reportValidity();
     if(isValid){
        component.set("v.disableSignButton",false);
        var fullNamCmp = isDesktop ? component.find('signButton'): component.find('msignButton');
        $A.util.removeClass(fullNamCmp, 'BgColor');
        $A.util.addClass(fullNamCmp, 'BgColorEnable');
        
    } 
        else {
           var fullNamCmp = isDesktop ? component.find('signButton'): component.find('msignButton');
           component.set("v.disableSignButton",true); 
           $A.util.removeClass(fullNamCmp, 'BgColorEnable');
           $A.util.addClass(fullNamCmp, 'BgColor');
        }
    },
    behaviourChange : function(component, event ,helper){
        var isDesktop = false;
        var isValid = true;
		var dskTop = document.getElementsByClassName("desktopview");
        if( window.getComputedStyle(dskTop[0]).display == 'block'){
            isDesktop = true;
        }
        var check = isDesktop ? component.get("v.behaviourCheck"): component.get("v.mbehaviourCheck");
	    var selectedOption = 'SignElectronically' ;
        if(check){
            if(isDesktop)
            component.set("v.selectedOption",selectedOption);
            else
            component.set("v.mselectedOption",selectedOption);
        }
        
        
    },
    
    sendemailsignauth : function(component, event,helper){
        var isInvited= component.get("v.isInvited");
        var email = component.find("emailId").get("v.value");
       // var faoid =Component.get()
        var member = component.get("v.displayCareTeamId");
        var childCTMId= component.get("v.childCTMId");
        if(childCTMId){
            member = childCTMId;
        }
            
        var rOISignedWith= JSON.stringify(component.get("v.careTeamList"));
        
        
        var emailauth =component.find("emailId").get("v.value");

        var action = component.get('c.SignAuthemailD');
        action.setParams({
            "curMembrEmail" : emailauth,
            "careTeamId" : member,
            "rOISignedWith" : rOISignedWith,
            "isInvited" : isInvited
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                console.log('email send Successfully'+response.getReturnValue());
                if(isInvited){
                      var ctmDoneList = component.get("v.ctmDoneList");
                      var ctmDoneArray = [];
                      ctmDoneArray.push(member);
                      
                    if(ctmDoneList!=null && ctmDoneList.length>0){
                        for(var k=0;k<ctmDoneList.length;k++){
                          ctmDoneArray.push(ctmDoneList[k]);
                        }
                    }
                  
                    component.set("v.ctmDoneList", ctmDoneArray);
                    component.set("v.fullName","");
                    component.set("v.displayCTMName","");
                    component.set("v.emailId","");
                    component.set("v.selectedOption","SignElectronically");
                    component.set("v.mselectedOption","SignElectronically");
                    component.set("v.behaviourCheck",false);
                    component.set("v.mbehaviourCheck",false);
                    //component.set("v.displayCareTeamId","");
                    helper.reFetch(component, event, helper);
                }
                  else{
                     component.set("v.isSignAuth",false);
                     helper.refreshCareTeam(component, event,helper);
                  }
            }
         });
        $A.enqueueAction(action);
    },
    viewROI :function(component, event,helper){
        component.set("v.isViewAuthorization",true);
    },
    refreshViewAuth :function(component, event,helper){
        console.log('inside event');
        component.set("v.isViewAuthorization",false);
    },
    mobViewROI :function(component, event,helper){
         var recid = component.get("v.viewRecId");
         var isctm = component.get("v.isCTM");
         var urlString = window.location.href;
         var baseURL = urlString.substring(0, urlString.indexOf("/s"));
         var winurl=baseURL+'/apex/Family_Link?recid='+recid+'&isctm='+isctm;
         var myWindow = window.open(winurl, "Family Link", "width=500px,height=500px");	
    }
})