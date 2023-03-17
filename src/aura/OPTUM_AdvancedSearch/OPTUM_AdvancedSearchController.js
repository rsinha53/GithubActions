({
    handleComponentEvent : function(component, event, helper) {
         helper.clearResultHelper(component,event,helper);
    },
    keyCheck : function(component, event, helper){
        if (event.which == 13){
        event.preventDefault();
        var action = component.get('c.searchResult');
        $A.enqueueAction(action);
    }},  
 	searchResult : function(component, event, helper) {
        var memId = component.get("v.memberId");
        var togg = document.getElementById("toggleSearch");
        var isfNameValid;
        var islNameValid;
        var isemailValid;
        var isssnValid;
        var isaccnumValid;
        var isdobValid;
        var returnError = false;
        //Gets all form values
        var fName = component.get("v.firstName");
		if(fName != null && fName !="undefined"){
           fName = fName.trim();
         component.set("v.firstName" ,fName); 
        }
        var lName = component.get("v.lastName");
		if(lName != null && lName !="undefined"){
           lName = lName.trim();
         component.set("v.lastName" ,lName); 
        }
        var dob = component.get("v.birthDate");
		if(dob != null && dob !="undefined"){
           dob = dob.trim();
         component.set("v.birthDate" ,dob); 
        }
        var email = component.get("v.emailAddress");
		if(email != null && email !="undefined"){
           email = email.trim();
         component.set("v.emailAddress" ,email); 
        }
        var accountNumber = component.get("v.accountNumber");
		if(accountNumber != null && accountNumber !="undefined"){
           accountNumber = accountNumber.trim();
         component.set("v.accountNumber" ,accountNumber); 
        }
        var ssn = component.get("v.ssn");
		if(ssn != null && ssn !="undefined"){
           ssn = ssn.trim();
         component.set("v.ssn" ,ssn); 
        }
        //Gets all comp values
        var fncmp = component.find("firstName");
        var lncmp = component.find("lastName");
        var dobcmp = component.find("birthDate");
        var acccmp = component.find("accountNumber");
        var emailcmp = component.find("memEmail");
        var ssncmp = component.find("ssn");
        var accountRegexFormat = /^\d{9,10}$/;
        var ssnRegexFormat = /^\d{4}$/;
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      
          if ($A.util.isEmpty(memId)){ 
              //for email 
              if(!$A.util.isEmpty(email)){
                  if(email.match(regExpEmailformat)){
                      helper.callAdvancedApi(component, event, helper);
                      
                  }else{
                      $A.util.addClass(emailcmp, "slds-has-error"); 
                      helper.fireToast("Error: Invalid Data", "Please Provide Email Address in the Correct Format", component, event, helper);
                       returnError = true;
                     
                  }
                  
              }
              //for account number
             else if(!$A.util.isEmpty(accountNumber)){
              if(accountNumber.match(accountRegexFormat)){
                 helper.callAdvancedApi(component, event, helper);
                  
              }else{
                  $A.util.addClass(acccmp, "slds-has-error"); 
                  helper.fireToast("Error: Invalid Data", "Please Enter a Valid  Account Number", component, event, helper);
                  returnError = true;
                  
              }
                  
              }
              
              // for SSN
             else if(!$A.util.isEmpty(ssn) ){
                 if(ssn.match(ssnRegexFormat))
                 {
                     if(! $A.util.isEmpty(lName))
                     { 
                  		 helper.callAdvancedApi(component, event, helper);
                   		 $A.util.removeClass(lncmp, "slds-has-error");
                         $A.util.removeClass(fncmp, "slds-has-error");
                         $A.util.removeClass(dobcmp, "slds-has-error");
                         $A.util.removeClass(ssncmp, "slds-has-error");
                         $A.util.removeClass(acccmp, "slds-has-error");
                         $A.util.removeClass(emailcmp, "slds-has-error");
                         
                     }
                     else
                     {
                            $A.util.addClass(lncmp, "slds-has-error");
                			helper.fireToast("Error: Invalid Data", "Please enter Last Name", component, event, helper);
                  			returnError = true;
                     }
                 }
                 else
                 {
                    	 $A.util.addClass(ssncmp, "slds-has-error");
                			helper.fireToast("Error: Invalid Data", "Please Provide Last 4 Digits of SSN", component, event, helper);
                  			returnError = true;
                 }
                  
                  
              }
              //for last name
               else if(!$A.util.isEmpty(lName) ){
                   if(! $A.util.isEmpty(ssn) )
                   {
                        if(ssn.match(ssnRegexFormat))
                           {
                               helper.callAdvancedApi(component, event, helper);
                               $A.util.removeClass(lncmp, "slds-has-error");
                               $A.util.removeClass(fncmp, "slds-has-error");
                               $A.util.removeClass(dobcmp, "slds-has-error");
                               $A.util.removeClass(ssncmp, "slds-has-error");
                               $A.util.removeClass(acccmp, "slds-has-error");
                               $A.util.removeClass(emailcmp, "slds-has-error");
                               
                           }
                            else
                            {
                                $A.util.addClass(ssncmp, "slds-has-error");
                                helper.fireToast("Error: Invalid Data", "Please Provide Last 4 Digits of SSN", component, event, helper);
                                returnError = true;
                             }
                   }
                   else if(!$A.util.isEmpty(fName) || !$A.util.isEmpty(dob))
                    {
                           
                         if(!$A.util.isEmpty(fName) && !$A.util.isEmpty(dob))
                         {
                             //for past date-->
								if(component.get("v.validDate") == true)  
                                {
                                    helper.callAdvancedApi(component, event, helper);
                                     $A.util.removeClass(lncmp, "slds-has-error");
                                     $A.util.removeClass(fncmp, "slds-has-error");
                                     $A.util.removeClass(dobcmp, "slds-has-error");
                                     $A.util.removeClass(ssncmp, "slds-has-error");
                                     $A.util.removeClass(acccmp, "slds-has-error");
                                     $A.util.removeClass(emailcmp, "slds-has-error"); 
                                }
                             else
                             {
                                  $A.util.addClass(dobcmp, "slds-has-error");
                                helper.fireToast("Error: Invalid Data", "Enter a Past Date for DOB", component, event, helper);
                                 returnError = true;
                             }
                                
                         }
                         else if(!$A.util.isEmpty(fName) &&  $A.util.isEmpty(dob))
                         {
                            $A.util.addClass(dobcmp, "slds-has-error");
                             helper.fireToast("Error: Invalid Data", "Enter DOB", component, event, helper);
                             returnError = true;
                             
                         }
                          else if($A.util.isEmpty(fName) &&  !$A.util.isEmpty(dob))
                         {
                               $A.util.addClass(fncmp, "slds-has-error");
                                helper.fireToast("Error: Invalid Data", "Enter First Name", component, event, helper);
                                 returnError = true;
                         }  
                    }
                   
                     else
                     {
                         $A.util.addClass(fncmp, "slds-has-error");
                         $A.util.addClass(ssncmp, "slds-has-error");
                          $A.util.addClass(dobcmp, "slds-has-error");
                			helper.fireToast("Error: Invalid Data", "Please Provide Last 4 Digits of SSN/First Name and DOB", component, event, helper);
                  			returnError = true;
                     }
              }
              // for first name
               else if(!$A.util.isEmpty(fName)){
                  
                     if(!$A.util.isEmpty(lName) && !$A.util.isEmpty(dob))
                         {
                            
                             helper.callAdvancedApi(component, event, helper);
                             $A.util.removeClass(lncmp, "slds-has-error");
                             $A.util.removeClass(fncmp, "slds-has-error");
                             $A.util.removeClass(dobcmp, "slds-has-error");
                             $A.util.removeClass(ssncmp, "slds-has-error");
                             $A.util.removeClass(acccmp, "slds-has-error");
                             $A.util.removeClass(emailcmp, "slds-has-error");
                         }
                         else if(!$A.util.isEmpty(lName) &&  $A.util.isEmpty(dob))
                         {
                              $A.util.addClass(dobcmp, "slds-has-error");
                                helper.fireToast("Error: Invalid Data", "Enter DOB", component, event, helper);
                                 returnError = true;
                         }
                          else if($A.util.isEmpty(lName) &&  !$A.util.isEmpty(dob))
                         {
                               $A.util.addClass(lncmp, "slds-has-error");
                               helper.fireToast("Error: Invalid Data", "Enter Last Name", component, event, helper);
                                 returnError = true;
                         }
                   //addddddddd
                          else 
                         {
                              
                             $A.util.addClass(lncmp, "slds-has-error");
                             $A.util.addClass(dobcmp, "slds-has-error");
                             helper.fireToast("Error: Invalid Data", "Enter Last Name and DOB", component, event, helper);
                             returnError = true;
                         }
                       
                   }
              // for dateofbirth
              	  else if(!$A.util.isEmpty(dob)){
                   
                     if(!$A.util.isEmpty(lName) && !$A.util.isEmpty(fName))
                         {
                              
                             if(component.get("v.validDate") == true){ 
                                 helper.callAdvancedApi(component, event, helper);
                                 $A.util.removeClass(lncmp, "slds-has-error");
                                 $A.util.removeClass(fncmp, "slds-has-error");
                                 $A.util.removeClass(dobcmp, "slds-has-error");
                                 $A.util.removeClass(ssncmp, "slds-has-error");
                                 $A.util.removeClass(acccmp, "slds-has-error");
                                 $A.util.removeClass(emailcmp, "slds-has-error");
                             }
                              else
                             {
                                 $A.util.addClass(dobcmp, "slds-has-error");
                                 helper.fireToast("Error: Invalid Data", "Enter a Past Date for DOB", component, event, helper);
                                 returnError = true;
                             }
                         }
                         else if(!$A.util.isEmpty(lName) &&  $A.util.isEmpty(fName))
                         {
                               $A.util.addClass(fncmp, "slds-has-error");
                                helper.fireToast("Error: Invalid Data", "Enter First Name", component, event, helper);
                                 returnError = true;
                         }
                          else if($A.util.isEmpty(lName) &&  !$A.util.isEmpty(fName))
                         {
                               $A.util.addClass(lncmp, "slds-has-error");
                                helper.fireToast("Error: Invalid Data", "Enter Last Name", component, event, helper);
                                 returnError = true;
                         }
                          else
                          {
                               $A.util.addClass(lncmp, "slds-has-error");
                              $A.util.addClass(fncmp, "slds-has-error");
                                helper.fireToast("Error: Invalid Data", "Enter Last Name and First name", component, event, helper);
                                 returnError = true;
                          }
                       
                   }
              else
              {
                   $A.util.addClass(fncmp, "slds-has-error");
                   $A.util.addClass(lncmp, "slds-has-error");
                   $A.util.addClass(dobcmp, "slds-has-error");
                   $A.util.addClass(acccmp, "slds-has-error");
                   $A.util.addClass(emailcmp, "slds-has-error");
                   $A.util.addClass(ssncmp, "slds-has-error");
                   
                  //add all comps
                  
                                helper.fireToast("Error: Invalid Data", "Please provide the mandatory details to search the member", component, event, helper);
                                 returnError = true;
              }
          
           // helper.callAdvancedApi(component, event, helper);
        
      }
   
	},
    
    clearResults : function(component, event, helper){
         helper.clearResultHelper(component,event,helper);
    },
    dateFormatValidation : function(component,event,helper){
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        var dobcmp = component.find("birthDate");
     // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
    // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
     var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        if(component.get("v.birthDate") != '' && component.get("v.birthDate") >= todayFormattedDate){
            component.set("v.dateValidationError" , true);
            component.set("v.validDate",false);
        }else{
            component.set("v.dateValidationError" , false);
            component.set("v.validDate",true);
            $A.util.removeClass(dobcmp, "slds-has-error");
        }
        
    }
})