({
	showFinalResults : function (component, event, helper) {         
        
        console.log('Inside Search');
        helper.showSpinner2(component, event, helper);
        var result = true;
        var interactionType = component.get("v.InteractionType");  
        var memId = component.get("v.memberId");
        var firstName = component.get("v.firstName");
        var lastName = component.get("v.lastName");
        var dob = component.get("v.dob");	
        var zip = component.get("v.zip");
        var state = component.find('selOption').find('selstate').get("v.value");
        var action = component.get("c.getSearchResults");
        component.set("v.searchclicked",true); 
        memId= (!$A.util.isEmpty(memId) && !$A.util.isUndefined(memId))?memId:'';
        dob = (!$A.util.isEmpty(dob) && !$A.util.isUndefined(dob))?dob:'';
        //action.setStorable();
        
        console.log('-MemId-->'+memId+'-firstName-->'+firstName+'-lastName-->'+lastName+'-dob-->'+dob+'-zip-->'+zip+'-intType-->'+interactionType+'-state-->'+state);
        if (result){
		component.set("v.lstmembers");
         
            // Setting the apex parameters
            action.setParams({
                memberId : memId,
                firstName : firstName,
                lastName : lastName,
                dob : dob,  
                state : state,
                zip : zip,
                intType: interactionType
            });
        
 			//Setting the Callback
            action.setCallback(this,function(a){
                //get the response state
                var state = a.getState();
                console.log('----state---'+state);
                //check if result is successfull
                if(state == "SUCCESS"){
                    var result = a.getReturnValue();
                    console.log('------result--------'+result);
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    	if (!$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)){
                        console.log('......>>> ' + result.resultWrapper);     
                        component.set("v.lstmembers",result.resultWrapper);
                             setTimeout(function(){
                                 
                                if(component.get("v.lstmembers") != undefined && component.get("v.lstmembers").length == 1 && !$A.util.isUndefinedOrNull(component.get("v.vccdParams"))){
                                    var link = document.getElementById(component.get("v.memberId"));
                                    if(!$A.util.isUndefinedOrNull(link)){
                                      link.click();
                                    }
                                   
                                }
                            }, 700);
                        }
                        
                    }
                } else if(state == "ERROR"){
                   	component.set("v.lstmembers");
        		}
                helper.hideSpinner2(component, event, helper);
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(action);
        }
      	console.log('-result-->'+ result);
        
	    return result;
	},
    hideSpinner2 : function(component, event, helper) {	
        console.log('Hiding Spinner2');
		component.set("v.Spinner", false);
	},
	// this function automatic call by aura:waiting event  
    showSpinner2: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   	},
    
    fireToast: function(title, messages, component, event, helper){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": messages,
            "type": "error",
            "mode": "dismissible",
            "duration": "10000"
        });
        toastEvent.fire();
        helper.hideSpinner2(component, event, helper);
        return;
        
    },
    
	validateNamesWildCard:function(component,event,helper,isFirstName,inputComp,charlengthNum){

        var charString = inputComp.get("v.value");
        //var charString = inputComp;
        console.log('charString::'+charString);
        console.log('inputComp::'+inputComp);
        var lastchar = charString[charString.length - 1];
        console.log('lastchar::'+lastchar);
        console.log('charlengthNum::'+charlengthNum);
        console.log('charString.length::'+charString.length);
        
        //if (charString.length < 2){
        if (charString.length == 1){    
            if (isFirstName){
                component.set("v.hasFirstNameError",true);
                component.set("v.FirstNameErrorMessage",$A.get("$Label.c.ACETNameSearchAtleast2Char"));  
                $A.util.removeClass(component.find("msgTxtFname"), "slds-hide")
                $A.util.addClass(component.find("msgTxtFname"), "slds-show");     
            }else{
                //alert('118')
                component.set("v.hasLastNameError",true);
                component.set("v.LastNameErrorMessage",$A.get("$Label.c.ACETNameSearchAtleast2Char"));  
                $A.util.removeClass(component.find("msgTxtLname"), "slds-hide")
                $A.util.addClass(component.find("msgTxtLname"), "slds-show");
            }
            $A.util.addClass(inputComp, "slds-has-error");
            return false;
        }
        
        //if (lastchar == "*" && charString.length < charlengthNum){
        if (charString.includes("*") && charString.length < charlengthNum){
            if(isFirstName){
                component.set("v.hasFirstNameError",true);
                component.set("v.FirstNameErrorMessage",$A.get("$Label.c.ACETNameWildSearchAtleast3Char"));  
                $A.util.removeClass(component.find("msgTxtFname"), "slds-hide")
                $A.util.addClass(component.find("msgTxtFname"), "slds-show");              

            }else{
                component.set("v.hasLastNameError",true);
                component.set("v.LastNameErrorMessage",$A.get("$Label.c.ACETNameWildSearchAtleast3Char"));  
                $A.util.removeClass(component.find("msgTxtLname"), "slds-hide")
                $A.util.addClass(component.find("msgTxtLname"), "slds-show");
            }
            $A.util.addClass(inputComp, "slds-has-error");
            return false;
            
        }

        else{
            
            if (isFirstName) {
                component.set("v.hasFirstNameError",false);
                component.set("v.FirstNameErrorMessage","");  
                $A.util.removeClass(component.find("msgTxtFname"), "slds-show")
                $A.util.addClass(component.find("msgTxtFname"), "slds-hide");
			
            }else{
				component.set("v.hasLastNameError",false);
                component.set("v.LastNameErrorMessage","");  
                $A.util.removeClass(component.find("msgTxtLname"), "slds-show")
                $A.util.addClass(component.find("msgTxtLname"), "slds-hide");                
            }
            
            return true;
        }
        
    },
    
    
    
    validateZipCode:function(component,event,helper,zip){
        
        if (zip.length != 5){
        
            $A.util.addClass(component.find("zip"), "slds-has-error");
            component.set("v.ZipCodeErrorMessage",$A.get("$Label.c.ACETZipcodeLimitError"));   
            $A.util.removeClass(component.find("msgTxtZip"), "slds-hide")
            $A.util.addClass(component.find("msgTxtZip"), "slds-show");
            return false;
        }else{
            $A.util.removeClass(component.find("zip"), "slds-has-error");
            component.set("v.ZipCodeErrorMessage","");  
            $A.util.addClass(component.find("msgTxtZip"), "slds-hide")
            $A.util.removeClass(component.find("msgTxtZip"), "slds-show");
            return true;
        }
    },
    
    //US1685067
	isValidDate: function(component,event,helper,dateString) {
      var dobcomp = component.find("dob");  
      var regEx = /^\d{4}-\d{2}-\d{2}$/;
      var isValidDate = dateString.match(regEx) != null;
      console.log('======VALIDATE====='+isValidDate);
      if (isValidDate){  
          $A.util.removeClass(dobcomp, "slds-has-error-date");
          component.set("v.DOBErrorMessage","");  
          $A.util.addClass(component.find("msgTxtDOB"), "slds-hide")
          $A.util.removeClass(component.find("msgTxtDOB"), "slds-show");
          return true;
            
      }else{
          
          $A.util.addClass(dobcomp, "slds-has-error-date");
          component.set("v.DOBErrorMessage","Error: Invalid Date");  
          $A.util.removeClass(component.find("msgTxtDOB"), "slds-hide")
          $A.util.addClass(component.find("msgTxtDOB"), "slds-show");
      	  return false;
      }    
    },
    
    //US1685067
    clearValidationContent: function(component, event, helper){        
		
        component.set("v.FirstNameErrorMessage","");
        component.set("v.LastNameErrorMessage","");
        component.set("v.ZipCodeErrorMessage","");
        component.set("v.DOBErrorMessage","");
        
        component.set("v.advancedValidation",false);
        component.set("v.hasFirstNameError",false);
        component.set("v.hasLastNameError",false);        
	
        $A.util.removeClass(component.find("msgTxtFname"), "slds-show");
        $A.util.addClass(component.find("msgTxtFname"), "slds-hide");

        $A.util.removeClass(component.find("msgTxtLname"), "slds-show");
        $A.util.addClass(component.find("msgTxtLname"), "slds-hide");
        
        $A.util.removeClass(component.find("msgTxtDOB"), "slds-show");
        $A.util.addClass(component.find("msgTxtDOB"), "slds-hide");
        
        $A.util.removeClass(component.find("msgTxtZip"), "slds-show");
        $A.util.addClass(component.find("msgTxtZip"), "slds-hide");  
        
        $A.util.removeClass(component.find("firstName"), "slds-has-error") ;
        $A.util.removeClass(component.find("lastName"), "slds-has-error") ;
        
        $A.util.removeClass(component.find("dob"), "slds-has-error-date");
		        
        $A.util.removeClass(component.find("zip"), "slds-has-error")   ;     
        $A.util.removeClass(component.find('selOption').find('selstate'), "slds-has-error")   ;    
        
    },
    
    //US1935707: Research User
    loadIntTypes : function(component, event, helper){ 
    	var userProfileName = component.get("v.userInfo").Profile_Name__c;
        if (userProfileName == $A.get("$Label.c.ACETResearchUserProfile")){           
            component.set("v.options", $A.get("$Label.c.ACETMemSearchIntTypesResearchUser")); 
            component.set("v.isResearchUser", "true");
        }else
            component.set("v.options", $A.get("$Label.c.ACETMemberSearchInteractionTypes").split(','));
        
        var dtPlchldr=component.find('dob');
        dtPlchldr.set('v.placeholder','MM/DD/YYYY');
    
    },

    checkOtherAvailabilities : function(component, event, helper, vType){

        //DEF:270334 - Start 
        var otherValueAdded = false;    
        
        //Gets all form values
        //var fName = component.get("v.firstName");
        //var lName = component.get("v.lastName");
        var dob = component.get("v.dob");
        var state = component.find('selOption').find('selstate').get("v.value");
        var zipCode = component.get("v.zip");               
        
        //Gets all comp values
        //var fncmp = component.find("firstName");
        //var lncmp = component.find("lastName");
        var dobcmp = component.find("dob");
        var zipcmp = component.find("zip");
        var statecmp = component.find('selOption').find('selstate');

        //Check other value availabilities 
        console.log('vType:: '+vType);
		console.log('dob:: '+dob);
        console.log('dob:: '+component.find("dob").value);
        //For DOB
        if ($A.util.isEmpty(dob)){
            if (vType == 'OTHER'){
                $A.util.addClass(dobcmp, "slds-has-error-date");
            }else{
                $A.util.removeClass(dobcmp, "slds-has-error-date");
            }                

            component.set("v.DOBErrorMessage",""); 
        
        }else{
            console.log('IN:: 1');
            $A.util.removeClass(dobcmp, "slds-has-error-date"); 
            otherValueAdded = true;
        }
        //End DOB

        //For ZIP
        if ($A.util.isEmpty(zipCode)){     
            if (vType == 'OTHER'){                   
                $A.util.addClass(zipcmp, "slds-has-error");
            }else{
                $A.util.removeClass(zipcmp, "slds-has-error");
            }    
            component.set("v.ZipCodeErrorMessage","");
        }else{
            console.log('IN:: 2');
            $A.util.removeClass(zipcmp, "slds-has-error");
            otherValueAdded = true; 
        }
        //End ZIP

        //For State
        if ($A.util.isEmpty(state)){
            if (vType == 'OTHER'){
                $A.util.addClass(statecmp, "slds-has-error");
            }else{
                $A.util.removeClass(statecmp, "slds-has-error");
            }    
        }else{
            console.log('IN:: 3');
            $A.util.removeClass(statecmp, "slds-has-error");
            otherValueAdded = true;  
        }
        //End State

        if (otherValueAdded)
            component.set("v.otherValueAdded", "true");
        else
            component.set("v.otherValueAdded", "false");    
    }
    
    
    

})