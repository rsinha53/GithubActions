({
    doInit: function(component, event, helper) {
        setTimeout(function(){ 
        var urlRef = window.location.href;
        console.log('-----URL----'+urlRef);
        var getParams = function (url) {
            var params = {};
            var parser = document.createElement('a');
            parser.href = url;
            var query = parser.search.substring(1);
            var vars = query.split('&');
            for (var i = 0; i < vars.length; i++) {
                var pair = vars[i].split('=');
                params[pair[0]] = decodeURIComponent(pair[1]);
            }
            return params;
        };
        
        var urlParams = getParams(urlRef);
        
        if(urlRef != undefined){
            var noAutoSearch = urlParams.c__noAutoSearch;
            console.log('-------NO AutoSearch------'+noAutoSearch);
           
        }
        
        }, 2000);
        
        //US1935707: Research User : Member User
        var action = component.get("c.getUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var storeResponse = response.getReturnValue();
                //console.log('storeResponse::: '+storeResponse);
                component.set("v.userInfo", storeResponse);
                helper.loadIntTypes(component, event, helper);
            }
        });
        $A.enqueueAction(action);

    },
    showErrors : function(component, event, helper) {
        var el = component.find("dob");
        //$A.util.removeClass(el, "slds-has-error-date"); 
        $A.util.addClass(el, "slds-has-error-date"); 
    },
    toggleSearch : function(component,event, helper) {
        
        var togg = document.getElementById("toggleSearch");
        if(togg.innerHTML == 'Advanced Search'){
            var elem = document.getElementById("advsearch");
            elem.setAttribute("style", "display: Block;");
            togg.innerHTML = 'Basic Search';
        }
        else {
            var elem = document.getElementById("advsearch");
            elem.setAttribute("style", "display: none;");
            togg.innerHTML = 'Advanced Search';
        }
    },
    onClickOfEnter : function(component,event, helper) {
        if (event.keyCode === 13) {
        	component.find("memid").focus();
            var a = component.get('c.showResults');
            $A.enqueueAction(a);
            
        }
    },
    showResults : function(component,event, helper) {
        
        var memId = component.get("v.memberId");  
       
       console.log('user Ida:::'+component.get("v.userInfo").Profile_Name__c);
        console.log('Member DOB :: '+component.get("v.dob"));
        
        var togg = document.getElementById("toggleSearch");
        console.log('togg.innerHTML 123:::'+togg.innerHTML);
        console.log('$A.util.isEmpty(state):::'+component.get("v.zip"));
        console.log('component.find:::'+component.find('selOption').find('selstate').get("v.value"));
        var isfNameValid;
        var islNameValid;
        var iszipValid;   
        var returnError = false;
        
        //Gets all form values
        var fName = component.get("v.firstName");
        var lName = component.get("v.lastName");
        var dob = component.get("v.dob");
        var state = component.find('selOption').find('selstate').get("v.value");
        var zipCode = component.get("v.zip");               
        
        //Gets all comp values
        var fncmp = component.find("firstName");
        var lncmp = component.find("lastName");
        var dobcmp = component.find("dob");
        var zipcmp = component.find("zip");
        var statecmp = component.find('selOption').find('selstate');
        //US1685067
        if (togg.innerHTML == 'Advanced Search' && $A.util.isEmpty(memId)){             
            helper.fireToast("Error: Invalid Data", "ID or Name Search is Required.", component, event, helper);
            return;
        }
        
        if (togg.innerHTML == 'Basic Search'){
            console.log('dob::'+$A.util.isEmpty(memId)+'---memId::'+$A.util.isEmpty(dob));
            if ($A.util.isEmpty(memId)){
                
                if (!$A.util.isEmpty(dob)){
                    if (!helper.isValidDate(component,event,helper,dob)){                       
                        
                        returnError = true;
                        //return;
                    }
                    
                }
                //Basic validation without FirstName, LastName
                if ($A.util.isEmpty(lName) && $A.util.isEmpty(fName)){                           

                    //Check other value availabilities
                    helper.checkOtherAvailabilities(component, event, helper, 'MAIN');
                    var otherValueAdded = component.get("v.otherValueAdded"); 

                    console.log('otherValueAdded :: '+otherValueAdded);
                    if (otherValueAdded == 'true'){
                        $A.util.addClass(fncmp, "slds-has-error");    
                        $A.util.addClass(lncmp, "slds-has-error");
                        helper.fireToast("Error: Invalid Data", "Member Search requires Last Name, First Name and at least one additional field.", component, event, helper);
                        returnError = true;
                    }else{
                        $A.util.removeClass(fncmp, "slds-has-error");    
                        $A.util.removeClass(lncmp, "slds-has-error");
                        helper.fireToast("Error: Invalid Data", "ID or Name Search is Required.", component, event, helper);                        
                        return;
                    }    
                    
                } 

                //Validation with FirstName only
                if (!$A.util.isEmpty(fName) && $A.util.isEmpty(lName)){
                    //Check other value availabilities
                    helper.checkOtherAvailabilities(component, event, helper, 'MAIN');
                    var otherValueAdded = component.get("v.otherValueAdded"); 
                    $A.util.addClass(lncmp, "slds-has-error");
                    if (otherValueAdded == 'false'){
                        $A.util.addClass(dobcmp, "slds-has-error-date");
                        $A.util.addClass(zipcmp, "slds-has-error");
                        $A.util.addClass(statecmp, "slds-has-error");
                    }

                    
                    helper.fireToast("Error: Invalid Data", "Member Search requires Last Name, First Name and at least one additional field.", component, event, helper);
                    returnError = true;                    
                }

                //Validation with LastName only
                if ($A.util.isEmpty(fName) && !$A.util.isEmpty(lName)){
                    //Check other value availabilities
                    helper.checkOtherAvailabilities(component, event, helper, 'MAIN');
                    var otherValueAdded = component.get("v.otherValueAdded"); 
                                              
                    $A.util.addClass(fncmp, "slds-has-error");
                    if (otherValueAdded == 'false'){
                        $A.util.addClass(dobcmp, "slds-has-error-date");
                        $A.util.addClass(zipcmp, "slds-has-error");
                        $A.util.addClass(statecmp, "slds-has-error");
                    }
                    helper.fireToast("Error: Invalid Data", "Member Search requires Last Name, First Name and at least one additional field.", component, event, helper);
                    returnError = true;
                    
                }
                
                
                
                //Validation without rest of the fields
                if ((!$A.util.isEmpty(fName) && !$A.util.isEmpty(lName)) && ($A.util.isEmpty(dob) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(state))){ 
                    
                    helper.checkOtherAvailabilities(component, event, helper, 'OTHER');

                    helper.fireToast("Error: Invalid Data", "Member Search requires Last Name, First Name and at least one additional field.", component, event, helper);                
                                        
                    component.set("v.advancedValidation", true);
                    /*
                    $A.util.addClass(dobcmp, "slds-has-error-date");
                    $A.util.addClass(zipcmp, "slds-has-error");
                    $A.util.addClass(statecmp, "slds-has-error");
                    */
                    
                    //Do wildcard search
                    isfNameValid = helper.validateNamesWildCard(component,event,helper,true,fncmp,4);
                    islNameValid = helper.validateNamesWildCard(component,event,helper,false,lncmp,4);
                    
                    returnError = true;
                    //return;
                }

                //Validation for LastName and FirstName and other non empty fields                    
                //DOB validation
                if (!$A.util.isEmpty(dob)){
                    if (!helper.isValidDate(component,event,helper,dob)){                       
                        
                        returnError = true;
                        //return;
                    }
                    
                }

				//ZIP validation
                if (!$A.util.isEmpty(zipCode)){
                    iszipValid = helper.validateZipCode(component,event,helper,zipCode);
                    if (!iszipValid){
                        returnError = true;
                        //return;
                    }    
                }
                
                //Sate validation
                if (!$A.util.isEmpty(state)){
                     $A.util.removeClass(statecmp, "slds-has-error");
                }
                    
                

                
                //Do wildcard search
                isfNameValid = helper.validateNamesWildCard(component,event,helper,true,fncmp,4);
                islNameValid = helper.validateNamesWildCard(component,event,helper,false,lncmp,4);
                //Check zip code length
                //Commented out
                //iszipValid = helper.validateZipCode(component,event,helper,zipCode);
                
                console.log('isfNameValid:::'+isfNameValid);
                console.log('islNameValid:::'+islNameValid);
                console.log('iszipValid:::'+iszipValid);
                
                if (!isfNameValid || !islNameValid){                    
                    //return;
                    returnError = true;
                }
            
        	}else{
                //Advanced Search with Member Id
                var memIdFnameValid = true;
                var memIdLnameValid = true;
                                
                if (!$A.util.isEmpty(dob)){                    
                    if (!helper.isValidDate(component,event,helper,dob)){                        
                        returnError = true;
                        
                    }                    
                }				
				               
                if (!$A.util.isEmpty(fName)){
                	memIdFnameValid = helper.validateNamesWildCard(component,event,helper,true,fncmp,4);
                }else{
                    component.set("v.hasFirstNameError",false);
                    component.set("v.FirstNameErrorMessage","");  
                    $A.util.addClass(component.find("msgTxtFname"), "slds-hide")
                    $A.util.removeClass(component.find("msgTxtFname"), "slds-show");  
                    $A.util.removeClass(fncmp, "slds-has-error");
                }    
                if (!$A.util.isEmpty(lName)){
                	memIdLnameValid = helper.validateNamesWildCard(component,event,helper,false,lncmp,4);
                }else{
                    component.set("v.hasLastNameError",false);
                    component.set("v.LastNameErrorMessage","");  
                    $A.util.addClass(component.find("msgTxtLname"), "slds-hide")
                    $A.util.removeClass(component.find("msgTxtLname"), "slds-show");
                    $A.util.removeClass(lncmp, "slds-has-error");
                    
                }    
                
                                
                
                if (!memIdFnameValid || !memIdLnameValid){                   

                    returnError = true;
                }
                
                
            
        }
            
            if (returnError)
                return;
            
        }
        
        var element = document.getElementById("results");
        element.setAttribute("style", "display: Block;margin: 1px -1% 0% -1%;");
        var element = document.getElementById("buttons");
       //US1935707: reasearch user 
       	if (!component.get("v.isResearchUser"))       
        	element.setAttribute("style", "display: Block;");
       
        //element.setAttribute("style", "display: none;");
        helper.showFinalResults(component,event, helper);
        helper.clearValidationContent(component, event, helper);
    },
    handleMisdirectEvent: function(component,event, helper) {
    	console.log('Inside misdirect handler');
        var element = document.getElementById("results");
        element.setAttribute("style", "display: none;");
        component.set("v.memberId", "");
        component.set("v.firstName", "");
        component.set("v.lastName", "");
        component.set("v.dob", "");
        component.find('selOption').find('selstate').set("v.value", ""); 
        component.set("v.zip", "");
        component.set("v.InteractionType", "Phone Call");
        var togg = document.getElementById("toggleSearch");
        if(togg.innerHTML == 'Basic Search'){
            var elem = document.getElementById("advsearch");
            elem.setAttribute("style", "display: none;");
            togg.innerHTML = 'Advanced Search';
        }
        var element = document.getElementById("buttons");
        element.setAttribute("style", "display: None;");
        
    },
    
    clearResults : function(component,event, helper) {
        var element = document.getElementById("results");
        element.setAttribute("style", "display: none;");
        component.set("v.memberId", "");
        component.set("v.firstName", "");
        component.set("v.lastName", "");
        component.set("v.dob", "");
        component.find('selOption').find('selstate').set("v.value", ""); 
        component.set("v.zip", "");
        component.set("v.InteractionType", "Phone Call");
        component.set("v.searchclicked",false);
        var togg = document.getElementById("toggleSearch");
        if(togg.innerHTML == 'Basic Search'){
            var elem = document.getElementById("advsearch");
            elem.setAttribute("style", "display: none;");
            togg.innerHTML = 'Advanced Search';
        }
        var element = document.getElementById("buttons");
        element.setAttribute("style", "display: None;");
        
        //US1685067
        helper.clearValidationContent(component,event, helper);
    },
    
    //US1685067
    restrictExtraCharacters: function (component, event, helper) {    	
    	
        var regex = new RegExp("^[a-zA-Z0-9]+$");
        var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        if (regex.test(str)){             
            return true;
        }else{            
            event.preventDefault();
            return false;
        }
        

	},
    
    //US1685067
    restrictCharacters: function (component, event, helper) {
    	
        var regex = new RegExp("^[0-9]+$");
        var str = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        
        //Check more than 5 characters
        var zip = component.get("v.zip");
        if (zip.length > 4){
            event.preventDefault();
            return false;
        }
        
        if (regex.test(str)){
            return true;
        }else{ 
            event.preventDefault();
            return false;
        }
        

	},
    hideDatePicker: function (component, event, helper) {
    	
        var mandatoryFieldCmp = event.getSource();
        console.log('---1---'+ JSON.stringify(mandatoryFieldCmp));
        

	},
    openMembNotFoundTab: function(component, event, helper) {
		var membId = component.get("v.memberId");
        var fstname = component.get("v.firstName");
		var lstname = component.get("v.lastName");
		var dob = component.get("v.dob");
		var state = component.find('selOption').find('selstate').get("v.value");
		var zipcode = component.get("v.zip");
        var workspaceAPI = component.find("workspace");
        var interactionType = component.get("v.InteractionType");
        console.log('------state------'+state);
        console.log('------dob------'+dob);
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ACETLGT_MemberNotFound"
                },
                "state": {
                    "c__fstname":fstname,
					"c__lstname":lstname,
					"c__dob":dob,
					"c__state":state,
					"c__zipcode":zipcode,
					"c__Id":membId,
                    "c__intractType":interactionType
				}
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
        }).then(function(tabInfo) {
            workspaceAPI.setTabLabel({
                tabId: tabInfo.tabId,
                label: "Enter Member Information"
            });
            workspaceAPI.setTabIcon({
                tabId: tabInfo.tabId,
                icon: "standard:people",
                iconAlt: "Member"
            });
        });
        }).catch(function(error) {
            console.log(error);
        });
    },
    handleVCCDBridgeSuppEvent: function(component, event, helper) {
            var VCCDResponceObj = event.getParam("VCCDResponceObj");
                 if(!$A.util.isUndefinedOrNull(VCCDResponceObj)){
                component.set("v.vccdParams",JSON.stringify(VCCDResponceObj));
                    component.set("v.memberId",VCCDResponceObj.memberId);
                    if(!$A.util.isUndefinedOrNull(VCCDResponceObj.MemberDOB)){ 
                       component.set("v.dob",VCCDResponceObj.MemberDOB );                 
                    }                    
                    if(!$A.util.isUndefinedOrNull(VCCDResponceObj.memberId) || (!$A.util.isUndefinedOrNull(VCCDResponceObj.memberId)&& !$A.util.isUndefinedOrNull(VCCDResponceObj.MemberDOB)) )
                    {    
                    if(!$A.util.isUndefinedOrNull(VCCDResponceObj.MemberDOB)){ 
                            setTimeout(function(){
                            var a = component.get('c.toggleSearch');
                            $A.enqueueAction(a);
                            }, 1);
                        }
                        setTimeout(function(){
                            var a = component.get('c.showResults');
                            $A.enqueueAction(a);
              
                        }, 1000);
                        
                    }
                
            }

    }
})