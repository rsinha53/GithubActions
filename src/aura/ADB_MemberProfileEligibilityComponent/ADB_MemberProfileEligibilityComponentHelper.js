({
    // get data from Eligibility Extended service
    getMemberInfo : function(component, event, helper){
        var action = component.get("c.getMemberInfo"); 
        component.set("v.showSpinner", true);
        
        // Get member Id & Member DOB to pass as a Extended request
        var memberId = component.get("v.decodedMemberId");
        var DOB = component.get("v.memberDOB");
        var transactionId = component.get("v.transactionId");
        // change date format as per the request
        if(DOB != undefined){
            var memberDOB = DOB.split("/");
            var memberdob = memberDOB[2]+"-"+memberDOB[0]+"-"+memberDOB[1]; 
        }
        var callerdob = component.get("v.callerDateofBirth");
        var callerDobFrm;
        if(callerdob != undefined){
            var callerDobls = callerdob.split("/");
            callerDobFrm = callerDobls[2]+"-"+callerDobls[0]+"-"+callerDobls[1];
        }
		console.log('transactionId'+transactionId);
        console.log('memberId'+memberId+'::memberdob'+memberdob);
        // Pass details to apex class
        action.setParams({ 
            memberId : memberId, //'587065389', //memberId ,//'587065389', //
            memberDob : memberdob, //'1961-08-27' //memberdob //'1961-08-27'//
            transactionId : transactionId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            
            if (state === "SUCCESS") {
                var recordsList = response.getReturnValue();
				var finalMemberList = [];						 
                console.log('record list' + JSON.stringify(recordsList));
                if(recordsList.relationship == 'Subscriber'){
                component.set("v.coveredMemberInfo", recordsList);
                    console.log('elig member first name'+component.get('v.callerFirstName'));
                    console.log('elig member last name'+component.get('v.callerLastName'));
                    if(!component.get('v.memberSelected')){
                        if(callerDobFrm == component.get('v.coveredMemberInfo.dob')){   
                            component.set('v.selectedMemberSubscriber',true);
                        }
                    }
                }else if(recordsList.relationship == 'Spouse'){
                    component.set("v.spouseMemberInfo", recordsList);
                     if(!component.get('v.memberSelected')){
                    component.set('v.selectedMemberSubscriber',false);
                     }
                }else{
                     if(!component.get('v.memberSelected')){
                   component.set('v.selectedMemberSubscriber',false);
                     }
                    if(recordsList.member.length  > 0){
                        var memberObj = {
                            'memLastName':recordsList.lastName,
                            'memFirstName':recordsList.firstName,
                            'memRelationship':recordsList.relationship,
                            'memDob':recordsList.dob
                        };
                	   //recordsList.member.push(memberObj) ;
						finalMemberList.push(memberObj) ;							
                    }
                }
                
              
                // reordering the recordList.memebr list..removing the subscriber and spouse from the list
                // once the order is finalised, below loop runs to update the dob
                for (let i=0; i < recordsList.member.length; i++){
                    if(recordsList.member[i].memRelationship == 'Subscriber'){
                        var subscriberObj = {
                            'lastName':recordsList.member[i].memLastName,
                            'firstName':recordsList.member[i].memFirstName,
                            'relationship':recordsList.member[i].memRelationship,
                            'dob':recordsList.member[i].memDob
                        };
                        component.set("v.coveredMemberInfo", subscriberObj);
						//recordsList.member.splice(i,1);
						
                    }else if(recordsList.member[i].memRelationship == 'Spouse'){
                         var spouseObj = {
                            'lastName':recordsList.member[i].memLastName,
                            'firstName':recordsList.member[i].memFirstName,
                            'relationship':recordsList.member[i].memRelationship,
                            'dob':recordsList.member[i].memDob
                        };
						component.set("v.spouseMemberInfo", spouseObj);
                    }else{
                        finalMemberList.push(recordsList.member[i]);
                    }
                    
                }
                component.set("v.dependentList", finalMemberList); 
  
                // Calculate Dependent Age
                var dependentAge = [];
                for (let i=0; i < finalMemberList.length; i++){
                        var dayofbirth = finalMemberList[i].memDob;
                        
                    var memberAge = this.calculateAge(helper,dayofbirth);
                        dependentAge.push(memberAge);
                        // Set age of dependent into List
                        component.set("v.dependentAge", dependentAge);
               		
                }
                var sobj = component.get("v.coveredMemberInfo");
                if(sobj != null){
                  var dayofbirth = sobj.dob;
                // Calculate Subscriber Age
                 var subscriberAge = this.calculateAge(helper,dayofbirth);
                component.set("v.subscriberDOB", subscriberAge);
                }
                
                //calculate spouse age
                var spouseobj = component.get("v.spouseMemberInfo");
                if(spouseobj != null){ 
                var spdob = spouseobj.dob;
                // Calculate Subscriber Age
                 var spouseAge = this.calculateAge(helper,spdob);
                component.set("v.spouseAge", spouseAge);
                }
                
                //spouseAge
            }
            
            component.set("v.showSpinner", false);
            
        });
        $A.enqueueAction(action);    
    },
    
    calculateAge : function(helper,dayofbirth) {
        var today = new Date();
                var birthDate = new Date(dayofbirth);
                var age = today.getFullYear() - birthDate.getFullYear();
                var m = today.getMonth() - birthDate.getMonth();
                if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
        return age;
    },
    
    // get preference language from web service
    getlanguagePreference : function(component, event, helper){
        var action = component.get("c.getlanguagePreference"); 
        component.set("v.showSpinner", true);
        
        // Get member Id & Member DOB to pass request
        var memberId = component.get("v.decodedMemberId");
        var DOB = component.get("v.memberDOB");
        var transactionId = component.get("v.transactionId");
        // change date format as per the request
        if(DOB != undefined){
            var memberDOB = DOB.split("/");
            var memberdob = memberDOB[2]+"-"+memberDOB[0]+"-"+memberDOB[1]; 
        }
        
        // Pass details to apex class
        action.setParams({ 
            memberId : memberId ,
            memberDob : memberdob,
            transactionId : transactionId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            
            if (state === "SUCCESS") {
                var recordsList = response.getReturnValue();
                console.log('record list' + JSON.stringify(recordsList));
                component.set("v.languagePreference", recordsList.verbalLanguagePreference); 
            }
            
            component.set("v.showSpinner", false);
            
        });
        $A.enqueueAction(action);    
    },
    
    callEpmpApi : function(component,event,helper) {        
        component.set("v.showSpinner", true);
        var memberId = component.get("v.decodedMemberId");
        var memDob = component.get("v.memberDOB");
        var memFirstName = component.get("v.memFirstName");
        var memLastName = component.get("v.memLastName");
        var memberPolicy = component.get("v.memberPolicy");
         var action = component.get("c.callEpmpPreferenceAPI"); 
        // Pass details to apex class
        action.setParams({ 
            memberId : memberId,
            memDob : memDob,
            memFirstName : memFirstName,
            memLastName : memLastName,
            memberPolicy : memberPolicy
        });
        action.setCallback(this, function(response) {
            var state = response.getState();       
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                if (!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {
                    console.log('result -- >>', JSON.stringify(result));
                    component.set("v.epmpDetails", result);
                    component.set('v.epmpTempPhone',result.phone);
					component.set('v.epmpTempEmail',result.email_Address);
                    if(!$A.util.isEmpty(result.prefs) && !$A.util.isUndefined(result.prefs)){
                    	component.set("v.prefDetails", result.prefs);
                    }
                    //Condition for Mixed paperless setting - US3132259
                    if($A.util.isUndefined(result.communication_Preference)){
                    	component.set('v.epmpTempCommPref','Paperless');
                        component.set('v.epmpDetails.communication_Preference','Paperless');
                    }else
                        component.set('v.epmpTempCommPref',result.communication_Preference);
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);   
    },

  // get PHIContacts from web service
    getPHIContacts : function(component, event, helper){
        
        var action = component.get("c.getPHIContacts"); 
        var userID = component.get("v.agentId");
        var cdxRefId = component.get("v.memberXrefId");    
        
        action.setParams({ 
            userID : userID ,
            cdxRefId : cdxRefId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            
            if (state === "SUCCESS") {
                var phiContactList = response.getReturnValue();
               if(phiContactList.member != null){
                    component.set("v.phiContacts", phiContactList.member);
                }
            }
            
        });
        $A.enqueueAction(action);    
    },
    // Open PHI Url - US2781361 : Sunil Vennam
  	launchPHIUrl : function(component, event, helper){
        var xrefId = component.get("v.memberXrefId");
        var userId = component.get("v.agentId");
        var action = component.get("c.getPHIUrl");
        action.setParams({ 
              xrefId : xrefId,
            	userId: userId,            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state', state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                        console.log('result'+result);
                        if(result != null && result != ''){
                        	window.open(result);
                        }
            }	
            
        });    
        $A.enqueueAction(action);
    },
    launchICUEHomeUrl : function(component, event, helper) {
        var action = component.get("c.getcoverageICUEHomeUrl");
         var userId = component.get("v.agentId");
         var memberXrefId = component.get("v.memberXrefId");
         console.log('memberXrefId for Member Prefernces'+memberXrefId);
         action.setParams({ cdbXrefId : memberXrefId,
                          userId: userId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp != ''){
                window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
           
        });
        $A.enqueueAction(action);
    },
    
    saveEpmpMail : function(component,event,helper,emailFieldValue){
        
        var memberId = component.get("v.decodedMemberId");
        var memDob = component.get("v.memberDOB");
        var memFirstName = component.get("v.memFirstName");
        var memLastName = component.get("v.memLastName");
        var memberPolicy = component.get("v.memberPolicy");
        var userID = component.get("v.agentId");
        var emailTypeCode = 'P';
		var emailTypeDesc = 'Home';
        var email = emailFieldValue;
        component.set('v.epmpDetails.email_Address',email);
		var memberDOB = '';
        if(memDob != undefined){
             memberDOB = memDob.split("/");
             memberDOB = memberDOB[2]+"-"+memberDOB[0]+"-"+memberDOB[1]; 
        }
		var reqobj = component.get('v.adbEpmpMailSaveRequestWrapper');
        reqobj = {};
        reqobj['first_nm'] = memFirstName;
        reqobj['lst_nm'] = memLastName;
        reqobj['policy_nbr'] = memberPolicy;
        reqobj['user_id'] = userID;
        reqobj['emailTypeCode'] = emailTypeCode;
        reqobj['emailTypeDesc'] = emailTypeDesc;
        reqobj['email'] = email;
        reqobj['subscriber_id'] = memberId;
        reqobj['dob'] = memberDOB;
		component.set('v.showSpinnerForEpmp',true);
		var action = component.get("c.saveEpmpMail");															  
		   action.setParams({
            reqObj : JSON.stringify(reqobj)
        });
        console.log('memberId'+memberId+'::memberDOB'+memberDOB+'::memFirstName'+memFirstName+'::memLastName'+memLastName+'::memberPolicy'+memberPolicy+'::userID'+userID+'::email'+email);
        action.setCallback(this, function(response) {
            component.set('v.showSpinnerForEpmp',false);
            
            var state = response.getState();
            console.log('response for epmp save mail'+response);
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp == 'Individual information successfully updated'){
                    console.log('Individual information successfully updated');
                   // helper.callEpmpApi(component, event, helper);
                   component.set('v.renderEpmpMailSuccess',true);
                    component.set('v.epmpFailMessage',resp);
                }else if(resp !=''){
                    component.set('v.renderEpmpUpdateFail',true);
                    component.set('v.epmpFailMessage','Individual information could not be updated');
                    console.log('Epmp Save failed');
                }
                helper.postEpmpSave(component,event,helper);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    
    saveEpmpCommPreference : function(component,event,helper,prefValue){
        
        var memberId = component.get("v.decodedMemberId");
        var memDob = component.get("v.memberDOB");
        var memFirstName = component.get("v.memFirstName");
        var memLastName = component.get("v.memLastName");
        var memberPolicy = component.get("v.memberPolicy");
        var userID = component.get("v.agentId");
        var paperless = ''; 
        if(prefValue == 'Paperless'){
            paperless = 'true'; 
        }else if(prefValue == 'Mail'){
            paperless = 'false'; 
        }
        
		var memberDOB = '';
        if(memDob != undefined){
             memberDOB = memDob.split("/");
             memberDOB = memberDOB[2]+"-"+memberDOB[0]+"-"+memberDOB[1]; 
        }
		var reqobj = {};
        reqobj['first_nm'] = memFirstName;
        reqobj['lst_nm'] = memLastName;
        reqobj['policy_nbr'] = memberPolicy;
        reqobj['user_id'] = userID;
        reqobj['subscriber_id'] = memberId;
        reqobj['dob'] = memberDOB;
        reqobj['paperless'] = paperless;
		 component.set('v.showSpinnerForEpmp',true);
        var action = component.get("c.saveEpmpCommunctnPreference");
        action.setParams({
           reqObj : JSON.stringify(reqobj)
        });
        console.log('memberId'+memberId+'::memberDOB'+memberDOB+'::memFirstName'+memFirstName+'::memLastName'+memLastName+'::memberPolicy'+memberPolicy+'::userID'+userID+'::paperless'+paperless);
        action.setCallback(this, function(response) {
            component.set('v.showSpinnerForEpmp',false);
            component.set('v.renderEpmpCommPrefConsent',false);
            
            var state = response.getState();
            console.log('response for epmp save mail'+response);
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp == 'Individual information successfully updated'){
                    console.log('Individual information successfully updated');
                    helper.callEpmpApi(component, event, helper);
                }else if(resp == 'This preference was already indicated. No update is required'){
                    console.log('This preference was already indicated. No update is required');
                    helper.callEpmpApi(component, event, helper);
                }else if(resp !=''){
                    component.set('v.renderEpmpUpdateFail',true);
                    component.set('v.epmpFailMessage',resp);
                    console.log('Epmp Save failed');
                }
                helper.postEpmpSave(component,event,helper);
            }
            
        });
        $A.enqueueAction(action);
    },
	saveEpmpPhone : function(component,event,helper,tempPhVal){
        var memberId = component.get("v.decodedMemberId");
        var memDob = component.get("v.memberDOB");
        var memFirstName = component.get("v.memFirstName");
        var memLastName = component.get("v.memLastName");
        var memberPolicy = component.get("v.memberPolicy");
        var userID = component.get("v.agentId");
        var telephoneNumber = tempPhVal;
        var paperless = ''; 
        var memberDOB = '';
        if(memDob != undefined){
             memberDOB = memDob.split("/");
             memberDOB = memberDOB[2]+"-"+memberDOB[0]+"-"+memberDOB[1]; 
        }
        component.set('v.showSpinnerForEpmp',true);
        var action = component.get("c.saveEpmpPhoneNumber");
        action.setParams({
            memberId : memberId,
            memDob : memberDOB,
            memFirstName : memFirstName,
            memLastName : memLastName,
            memberPolicy : memberPolicy,
            userID : userID,
            telephoneNumber : telephoneNumber
        });
        console.log('memberId'+memberId+'::memberDOB'+memberDOB+'::memFirstName'+memFirstName+'::memLastName'+memLastName+'::memberPolicy'+memberPolicy+'::userID'+userID+'::telephoneNumber'+telephoneNumber);
        action.setCallback(this, function(response) {
            component.set('v.showSpinnerForEpmp',false);
            component.set('v.renderEpmpCommPrefConsent',false);
            component.set('v.renderEpmpMobilePhConsent',false);
            var state = response.getState();
            console.log('response for epmp save mail'+response);
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp == 'Individual information successfully updated'){
                    console.log('Individual information successfully updated');
                    component.set('v.renderEpmpMobileSuccess',true);  
                }else if(resp !=''){
                    component.set('v.renderEpmpUpdateFail',true);
                    component.set('v.epmpFailMessage',resp);
                    console.log('Epmp Save failed');
                }
                helper.postEpmpSave(component,event,helper);
            }
        });
        $A.enqueueAction(action);
    },
    postEpmpSave: function(component,event,helper){
    component.set('v.enableCommPref',false);
        component.set('v.renderEpmpSave',true);
        component.set('v.enableEpmpPhone',false);
        component.set('v.enableEpmpAddress',false);
        component.set('v.currentEpmpFld','');
        component.set('v.renderEpmpPhoneEdit',true);
        component.set('v.renderEpmpMailEdit',true);
        component.set('v.renderEpmpCommPrefEdit',true);
    },
    
    openEPMPLinkUrl: function(component, event, helper, selLink) {
	
	var dob = component.get("v.memberDOB");
	var firstName = component.get("v.memFirstName");
	var lastName = component.get("v.memLastName");
	var policy = component.get("v.memberPolicy");
	var subID = component.get("v.decodedMemberId");
	var userId = component.get("v.agentId");
	var action = component.get("c.getEPMPSSOUrl");
	action.setParams({
		memberId: subID,
		userId: userId,
		firstname: firstName,
		lastname: lastName,
		memberDob: dob,
		policy: policy,
		selectedLink: selLink
	});
	
	action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp != null && resp != ''){
                    window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
        });
        $A.enqueueAction(action);
},
    
    saveEpmpPhoneTextServices : function(component,event,helper,tempPhVal){
        var memberId = component.get("v.decodedMemberId");
        var memDob = component.get("v.memberDOB");
        var memFirstName = component.get("v.memFirstName");
        var memLastName = component.get("v.memLastName");
        var memberPolicy = component.get("v.memberPolicy");
        var userID = component.get("v.agentId");
        var telephoneNumber = tempPhVal;
        var paperless = ''; 
        var timezone = component.get('v.epmpEnrollTimezone');
        console.log('timezone'+timezone);
        var memberDOB = '';
        if(memDob != undefined){
             memberDOB = memDob.split("/");
             memberDOB = memberDOB[2]+"-"+memberDOB[0]+"-"+memberDOB[1]; 
        }
        component.set('v.showSpinnerForEpmp',true);
        var reqobj = {};
        reqobj['lst_nm'] = memLastName;
		reqobj['first_nm'] = memFirstName;
 		reqobj['policy_nbr'] = memberPolicy;
 		reqobj['subscriber_id'] = memberId;
 		reqobj['dob'] = memberDOB;
 		reqobj['phoneNumber'] = telephoneNumber;
 		reqobj['timeZone']= timezone;
 		reqobj['user_id'] = userID;
 		component.set('v.renderEpmpMobilePhConsent',false); 
        var action = component.get("c.saveEpmpPhoneNumberGAN");
        action.setParams({
           reqObj : JSON.stringify(reqobj)
        });
        console.log('memberId'+memberId+'::memberDOB'+memberDOB+'::memFirstName'+memFirstName+'::memLastName'+memLastName+'::memberPolicy'+memberPolicy+'::userID'+userID+'::telephoneNumber'+telephoneNumber);
        action.setCallback(this, function(response) {
            component.set('v.showSpinnerForEpmp',false);
            component.set('v.renderEpmpCommPrefConsent',false);
            var state = response.getState();
            console.log('response for epmp save mail'+response);
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('resp'+resp);
                if((resp == 'Pending status updated Successfully for GAN') ||
                   (resp == 'Pre-Activated Successfully for GAN')){
                    component.set('v.renderEpmpMobilePhConsent',false); 
                    helper.callSelectionsAPI(component,event,helper);
                }else {
                    component.set('v.renderEpmpUpdateFail',true);
                    component.set('v.epmpFailMessage',resp);
                    console.log('Epmp Save failed');
                }
                helper.postEpmpSave(component,event,helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    callSelectionsAPI : function(component,event,helper){
        console.log('in callSelections API method');
        var memberId = component.get("v.decodedMemberId");
        var memDob = component.get("v.memberDOB");
        var memFirstName = component.get("v.memFirstName");
        var memLastName = component.get("v.memLastName");
        var memberPolicy = component.get("v.memberPolicy");
        var userID = component.get("v.agentId");
        var memberDOB = '';
        if(memDob != undefined){
             memberDOB = memDob.split("/");
             memberDOB = memberDOB[2]+"-"+memberDOB[0]+"-"+memberDOB[1]; 
        }
        component.set('v.showSpinnerForEpmp',true);
        var reqobj = {};
        reqobj['lst_nm'] = memLastName;
		reqobj['first_nm'] = memFirstName;
 		reqobj['policy_nbr'] = memberPolicy;
 		reqobj['subscriber_id'] = memberId;
 		reqobj['dob'] = memberDOB;
 		reqobj['user_id'] = userID;
        var prefArray = component.get("v.prefDetails");
        console.log('prefe details $$$$$$$$'+ prefArray);
        reqobj['preferences'] = prefArray;
 		component.set('v.renderEpmpMobilePhConsent',false); 
        var action = component.get("c.updateSelectionsAPI");
        action.setParams({
           reqObj : JSON.stringify(reqobj)
        });
        console.log('memberId'+memberId+'::memberDOB'+memberDOB+'::memFirstName'+memFirstName+'::memLastName'+memLastName+'::memberPolicy'+memberPolicy+'::userID'+userID);
        action.setCallback(this, function(response) {
            component.set('v.showSpinnerForEpmp',false);
            component.set('v.renderEpmpCommPrefConsent',false);
            var state = response.getState();
            console.log('response for epmp save mail'+response);
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('resp'+resp);
                if(resp == 'Individual information successfully updated'){
                    console.log('Individual information successfully updated');
                    component.set('v.renderEpmpMobileSuccess',true);  
                }else {
                    component.set('v.renderEpmpUpdateFail',true);
                    if(resp != ''){
                    	component.set('v.epmpFailMessage',resp);    
                    }else{
                        component.set('v.epmpFailMessage','EPMP Save failed.');
                    }
                    console.log('Epmp Selections API call failed');
                }
                helper.postEpmpSave(component,event,helper);
            }
        });
        $A.enqueueAction(action);
    }
    
})