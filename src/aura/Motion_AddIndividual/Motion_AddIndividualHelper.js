({
	clearSearch : function(component, event, helper) {       
		var isCaseRecord=component.get("v.iscaserecord");
        if(!isCaseRecord){
            $A.get('e.force:refreshView').fire();
        }else{
            component.set('v.firstName','');
            component.set('v.lastName','');
            component.set('v.phoneNumber','');
            component.set('v.emailAddress','');
            component.set('v.groupName','');
            component.set('v.groupNumber','');
            component.set('v.dateOfBirth','');
            component.set('v.stateDefault','');
            component.set('v.zipcode','');
        }
    },
    createIndividualAccount : function(component,event,helper){
        var isValidSuccess = false;
        var workspaceAPI = component.find("workspace");
        var firstname = component.find("firstName").get("v.value");
        var lastname = component.find("lastName").get("v.value");
        var phone = component.find("phoneNumber").get("v.value");
        var email = component.find("emailaddress").get("v.value");
        var groupName = component.find("groupName").get("v.value");
        var groupNumber = component.find("groupNumber").get("v.value");
        var dob = component.get("v.dateOfBirth");
        var addIndividual=component.get("v.addIndividual");
        var state = component.find("State").get("v.value");
        var zipcode = component.find("zipCode").get("v.value");
        var interactiontype = component.get("v.interactType");
        if(interactiontype=='Phone'){
            interactiontype='Phone Call'
        }
        var zipvalid =false;
        var phonevalid =false;
        
        var fmtDtDob;
        if(dob != null && dob != ''){
            fmtDtDob = $A.localizationService.formatDate(dob, "MM/dd/yyyy");
        }
        
     var isValidSuccess = this.validateAdvanceSearchFields(component, firstname, lastname, phone, email);
        if (isValidSuccess){  
            
            if (zipcode!= null && zipcode != '' && zipcode.length > 0 && zipcode.length < 5){
                component.find("zipCode").setCustomValidity("Error: Enter a valid 5 digit Zip Code");        
            }else{
                component.find("zipCode").setCustomValidity(""); 
                zipvalid=true;
            }
            component.find("zipCode").reportValidity();
            var phoneUnformatted = phone.replace(/-/g, "");
            if(phoneUnformatted != null && phoneUnformatted != '' && phoneUnformatted.length < 10){
                component.find("phoneNumber").setCustomValidity("Error: Enter a valid 10 digit number");
            }else{
                component.find("phoneNumber").setCustomValidity(""); 
                phonevalid = true;
            }
            component.find("phoneNumber").reportValidity();
            
            /*var action=component.get("c.createThirdPartyRecord");
            action.setParams({                
                firstName:firstname,
                lastName:lastname,                
                emailaddress:email,
                phone:phone,
                groupname:groupName,
                groupnumber:groupNumber,
                dob:fmtDtDob,
                state:state,
                zip:zipcode,
                inttype:interactiontype
            });
            action.setCallback(this,function(response){
                var state=response.getState();            
                if(state==="SUCCESS"){ 
                    
                    var response=response.getReturnValue(); 
                    
                    //console.log('response'+ JSON.stringify(response.Id));
                    component.set('v.interactionRec',response);
                    */
            if(isValidSuccess== true && zipvalid==true && phonevalid==true ){
				var isCaseRecord=component.get("v.iscaserecord");
                if(!isCaseRecord){
                        workspaceAPI.getFocusedTabInfo().then(function(response){
                            if(response != null){
                                membnotfoundTabId = response.tabId;
                            }
                            
                        });
                    
                     workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__Motion_MemberDetails"  
                },
                "state": {
                    
                    "c__isMemberNotFound": true,
                    "c__lastName": lastname,
                    "c__firstName": firstname,
                    "c__emailaddress": email,
                    "c__phone":phone,
                    "c__groupname":groupName,
                    "c__groupnumber":groupNumber,
                    "c__dob":fmtDtDob,
                    "c__inttype":interactiontype,
                    "c__state":state,
                    "c__zipcode":zipcode
                    
                    
                }
                
            },
            focus: true
        }).then(function(response) {
                    
                    workspaceAPI.getTabInfo({
                        tabId: response
                        
                    }).then(function(tabInfo) {
                        
                        workspaceAPI.setTabLabel({
                            tabId: tabInfo.tabId,
                            label: 'INT - '+ lastname
                        });
                        workspaceAPI.setTabIcon({
                            tabId: tabInfo.tabId,
                            icon: "standard:people",
                            iconAlt: "Member"
                        });
                       //Close the membernotfound form tab after opening Member detail page                        
                            workspaceAPI.closeTab({
                            tabId: membnotfoundTabId    
                           });      
                    });
                }).catch(function(error) {
            console.log(error);
        });  
}else{
                    var addIndvEvent = component.getEvent("caseMemberEvent");
                    addIndvEvent.setParams({
                        isMemberNotFound:true,
                        FirstName:firstname,
                        LastName:lastname,
                        email:email,
                        phone:phone,
                        GroupName:groupName,
                        groupNumber:groupNumber,
                        DOB:fmtDtDob,
                        interactType:interactiontype,
                        state:state,
                        zipcode: zipcode,
                        addIndiv:true
                    });
                    addIndvEvent.fire();
                }		
			
         }         
                    
                //}
            //}); 
        	//$A.enqueueAction(action);
        }
    
    },
    validateAdvanceSearchFields : function(component, firstname, lastname, phone, email){
        var isValid = false;
        	var errorMessage = 'First Name, Last Name and either Email Address OR Phone Number are required';
           	var showErrorMsg= false;
        	var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if( phone === '' && email === '') {
            showErrorMsg = true;
        }
        if(firstname === '' || lastname === ''){
        showErrorMsg = true;
        }
            /*else if(firstname === '' && lastname==='' && email === ''){
            showErrorMsg = true;
        }*/
        if(!email.match(regExpEmailformat) && email != ''){
          showErrorMsg = true;
          errorMessage = 'Invalid Email format';
        }
        
        if(showErrorMsg){                
            var advToastEvent = $A.get("e.force:showToast");
            advToastEvent.setParams({                
            	message : errorMessage,
                duration: '10000',                
                type: 'error',
                mode: 'dismissible'
            	});
            	advToastEvent.fire();                 
            }else{
                isValid = true;
            }
        
        return isValid;
    },
    populatePickListValues : function(component, event, helper){
		var iscaserecord = component.get('v.iscaserecord');
        if(!iscaserecord){
    	var importState = component.get("v.pageReference").state;
		component.set('v.interactType',importState.c__interactionType);
		}
        var action = component.get('c.motionAddIndividualPickListValues');
        action.setCallback(this, function(response){
        var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.stateOptions',result.lstStatusValues);
                console.log('inside picklist method'+ component.get('v.interactType'));
            }
        });
        $A.enqueueAction(action);
    },
})